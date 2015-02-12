//
//  NYTPhotosViewController.m
//  NYTNewsReader
//
//  Created by Brian Capps on 2/10/15.
//  Copyright (c) 2015 NYTimes. All rights reserved.
//

#import "NYTPhotosViewController.h"
#import "NYTPhotosViewControllerDataSource.h"
#import "NYTPhotosDataSource.h"
#import "NYTPhotoViewController.h"

const CGFloat NYTPhotosViewControllerPanDismissDistance = 50;

@interface NYTPhotosViewController () <UIPageViewControllerDataSource, UIPageViewControllerDelegate>

@property (nonatomic) NYTPhotosDataSource *dataSource;
@property (nonatomic) UIPageViewController *pageViewController;

@property (nonatomic) UIPanGestureRecognizer *panGestureRecognizer;

@end

@implementation NYTPhotosViewController

#pragma mark - NSObject

- (void)dealloc {
    self.pageViewController.dataSource = nil;
    self.pageViewController.delegate = nil;
}

#pragma mark - UIViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    return [self initWithPhotos:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor blackColor];
    self.pageViewController.view.backgroundColor = [UIColor clearColor];
    
    [self addChildViewController:self.pageViewController];
    [self.view addSubview:self.pageViewController.view];
    [self.pageViewController didMoveToParentViewController:self];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    self.pageViewController.view.frame = self.view.bounds;
}

#pragma mark - NYTPhotosViewController

- (instancetype)initWithPhotos:(NSArray *)photos {
    return [self initWithPhotos:photos initialPhoto:photos.firstObject];
}

- (instancetype)initWithPhotos:(NSArray *)photos initialPhoto:(id<NYTPhoto>)initialPhoto {
    self = [super initWithNibName:nil bundle:nil];
    
    if (self) {
        _dataSource = [[NYTPhotosDataSource alloc] initWithPhotos:photos];
        _panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(didPanWithGestureRecognizer:)];
        
        [self setupPageViewControllerWithInitialPhoto:initialPhoto];
    }
    
    return self;
}

- (void)setupPageViewControllerWithInitialPhoto:(id <NYTPhoto>)initialPhoto {
    self.pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:@{UIPageViewControllerOptionInterPageSpacingKey: @(16)}];

    self.pageViewController.delegate = self;
    self.pageViewController.dataSource = self;
    
    NYTPhotoViewController *initialPhotoViewController;
    
    if ([self.dataSource containsPhoto:initialPhoto]) {
        initialPhotoViewController = [self newPhotoViewControllerForPhoto:initialPhoto];
    }
    else {
        initialPhotoViewController = [self newPhotoViewControllerForPhoto:self.dataSource[0]];
    }
    
    [self.pageViewController setViewControllers:@[initialPhotoViewController] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:NULL];
    
    [self.pageViewController.view addGestureRecognizer:self.panGestureRecognizer];
}

- (void)moveToPhoto:(id <NYTPhoto>)photo {
    if (![self.dataSource containsPhoto:photo]) {
        return;
    }
    
    NYTPhotoViewController *photoViewController = [self newPhotoViewControllerForPhoto:photo];
    [self.pageViewController setViewControllers:@[photoViewController] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:NULL];
}

- (NYTPhotoViewController *)newPhotoViewControllerForPhoto:(id <NYTPhoto>)photo {
    if (photo) {
        return [[NYTPhotoViewController alloc] initWithPhoto:photo];
    }
    
    return nil;
}

#pragma mark - Gesture Recognizers

- (void)didPanWithGestureRecognizer:(UIPanGestureRecognizer *)panGestureRecognizer {
    CGPoint centerPoint = CGPointMake(CGRectGetMidX(self.view.bounds), CGRectGetMidY(self.view.bounds));
    
    CGPoint translatedPanGesturePoint = [panGestureRecognizer translationInView:self.view];
    CGPoint translatedCenterPoint = CGPointMake(centerPoint.x, centerPoint.y + translatedPanGesturePoint.y);
    
    // Pan the view on pace with the pan gesture.
    self.pageViewController.view.center = translatedCenterPoint;
    
    CGFloat verticalDelta = self.pageViewController.view.center.y - centerPoint.y;
    
    CGFloat backgroundAlpha = [self backgroundAlphaForPanningWithVerticalDelta:verticalDelta];
    self.view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:backgroundAlpha];
    
    if (panGestureRecognizer.state == UIGestureRecognizerStateEnded) {
        // Return to center case.
        CGFloat velocityY = [panGestureRecognizer velocityInView:self.view].y;
        CGFloat animationDuration = (ABS(velocityY) * 0.00007) + 0.2;
        CGFloat animationCurve = UIViewAnimationOptionCurveEaseOut;
        CGPoint finalPageViewCenterPoint = centerPoint;

        // Dismissal case.
        BOOL isDismissing = ABS(verticalDelta) > NYTPhotosViewControllerPanDismissDistance;
        if (isDismissing) {
            if ([self.delegate respondsToSelector:@selector(photosViewController:referenceViewForPhoto:)]) {
                //TODO: check for reference view and do animated transition to that view.
            }
            else {
                BOOL isPositiveDelta = verticalDelta >= 0;

                CGFloat modifier = isPositiveDelta ? 1 : -1;
                CGFloat finalCenterY = CGRectGetMidY(self.view.bounds) + modifier * CGRectGetHeight(self.view.bounds);
                finalPageViewCenterPoint = CGPointMake(centerPoint.x, finalCenterY);
                
                animationDuration = 0.35;
                animationCurve = UIViewAnimationOptionCurveEaseIn;
            }
        }
        
        [UIView animateWithDuration:animationDuration delay:0 options:animationCurve animations:^{
            self.pageViewController.view.center = finalPageViewCenterPoint;
        } completion:^(BOOL finished) {
            if (isDismissing) {
                [self dismissViewControllerAnimated:NO completion:nil];
            }
        }];
    }
}

- (CGFloat)backgroundAlphaForPanningWithVerticalDelta:(CGFloat)verticalDelta {
    CGFloat finalAlpha = 0.1;
    CGFloat startingAlpha = 1.0;
    CGFloat totalAvailableAlpha = startingAlpha - finalAlpha;
    
    CGFloat maximumDelta = CGRectGetHeight(self.view.bounds) / 2.0;
    CGFloat deltaAsPercentageOfMaximum = MIN(ABS(verticalDelta)/maximumDelta, 1.0);
    
    return startingAlpha - (deltaAsPercentageOfMaximum * totalAvailableAlpha);
}

#pragma mark - UIPageViewControllerDataSource

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController <NYTPhotoContaining> *)viewController {
    NSUInteger photoIndex = [self.dataSource indexOfPhoto:viewController.photo];
    return [self newPhotoViewControllerForPhoto:self.dataSource[photoIndex - 1]];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController <NYTPhotoContaining> *)viewController {
    NSUInteger photoIndex = [self.dataSource indexOfPhoto:viewController.photo];
    return [self newPhotoViewControllerForPhoto:self.dataSource[photoIndex + 1]];
}

#pragma mark - UIPageViewControllerDelegate

@end
