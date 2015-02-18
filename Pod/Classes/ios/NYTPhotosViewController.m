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
#import "NYTPhotoTransitionController.h"
#import "NYTScalingImageView.h"
#import "NYTPhoto.h"

const CGFloat NYTPhotosViewControllerPanDismissDistanceRatio = 100.0/667.0; // distance over iPhone 6 height.
const CGFloat NYTPhotosViewControllerPanDismissMaximumDuration = 0.45;

@interface NYTPhotosViewController () <UIPageViewControllerDataSource, UIPageViewControllerDelegate, NYTPhotoViewControllerDelegate>

@property (nonatomic) id <NYTPhotosViewControllerDataSource> dataSource;
@property (nonatomic) UIPageViewController *pageViewController;

@property (nonatomic) NYTPhotoTransitionController *transitionAnimator;

@property (nonatomic) UIPanGestureRecognizer *panGestureRecognizer;

@property (nonatomic) BOOL shouldHandleLongPress;

@property (nonatomic, readonly) NYTPhotoViewController *currentPhotoViewController;
@property (nonatomic, readonly) UIView *referenceViewForCurrentPhoto;
@property (nonatomic, readonly) CGPoint boundsCenterPoint;

@end

@implementation NYTPhotosViewController

#pragma mark - NSObject

- (void)dealloc {
    self.pageViewController.dataSource = nil;
    self.pageViewController.delegate = nil;
}

#pragma mark - NSObject(UIResponderStandardEditActions)

- (void)copy:(id)sender {
    [[UIPasteboard generalPasteboard] setImage:self.currentPhotoViewController.photo.image];
}

#pragma mark - UIResponder

- (BOOL)canBecomeFirstResponder {
    return YES;
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    if (self.shouldHandleLongPress && action == @selector(copy:) && self.currentPhotoViewController.photo.image) {
        return YES;
    }
    
    return NO;
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
    
    self.transitionAnimator.startingView = self.referenceViewForCurrentPhoto;
    
    if (self.currentPhotoViewController.photo.image) {
        self.transitionAnimator.endingView = self.currentPhotoViewController.scalingImageView.imageView;
    }
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    self.pageViewController.view.frame = self.view.bounds;
}

- (BOOL)prefersStatusBarHidden {
    return YES;
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
        
        _transitionAnimator = [[NYTPhotoTransitionController alloc] init];
        self.modalPresentationStyle = UIModalPresentationCustom;
        self.transitioningDelegate = _transitionAnimator;
        self.modalPresentationCapturesStatusBarAppearance = YES;
        
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
    
    [self setCurrentlyDisplayedViewController:initialPhotoViewController animated:NO];
    
    [self.pageViewController.view addGestureRecognizer:self.panGestureRecognizer];
}

- (void)moveToPhoto:(id <NYTPhoto>)photo animated:(BOOL)animated {
    if (![self.dataSource containsPhoto:photo]) {
        return;
    }
    
    NYTPhotoViewController *photoViewController = [self newPhotoViewControllerForPhoto:photo];
    [self setCurrentlyDisplayedViewController:photoViewController animated:animated];
}

- (void)updateImage:(UIImage *)image forPhoto:(id<NYTPhoto>)photo {
    photo.image = image;
    
    NYTPhotoViewController *photoViewController;
    
    for (NYTPhotoViewController *controller in self.pageViewController.viewControllers) {
        if ([controller.photo.identifier isEqualToString:photo.identifier]) {
            photoViewController = controller;
            break;
        }
    }
    
    [photoViewController updateImage:image];
    
    // Reset the cached view controllers in the page view controller.
    if (self.pageViewController.viewControllers.firstObject && photoViewController) {
        [self.pageViewController setViewControllers:@[self.pageViewController.viewControllers.firstObject] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    }
}

- (NYTPhotoViewController *)newPhotoViewControllerForPhoto:(id <NYTPhoto>)photo {
    if (photo) {
        UIView *activityView;
        if ([self.delegate respondsToSelector:@selector(photosViewController:activityViewForPhoto:)]) {
            activityView = [self.delegate photosViewController:self activityViewForPhoto:photo];
        }
        
        NYTPhotoViewController *photoViewController = [[NYTPhotoViewController alloc] initWithPhoto:photo activityView:activityView];
        photoViewController.delegate = self;
        return photoViewController;
    }
    
    return nil;
}

#pragma mark - Gesture Recognizers

- (void)didPanWithGestureRecognizer:(UIPanGestureRecognizer *)panGestureRecognizer {
    if (panGestureRecognizer.state == UIGestureRecognizerStateBegan) {
        [self dismissAnimated:YES];
    }
    else {
        [self.transitionAnimator didPanWithPanGestureRecognizer:panGestureRecognizer viewToPan:self.pageViewController.view anchorPoint:self.boundsCenterPoint];
    }
}

- (void)dismissAnimated:(BOOL)animated {
    self.transitionAnimator.startingView = self.currentPhotoViewController.scalingImageView.imageView;
    self.transitionAnimator.endingView = self.referenceViewForCurrentPhoto;
    
    if ([self.delegate respondsToSelector:@selector(photosViewControllerWillDismiss:)]) {
        [self.delegate photosViewControllerWillDismiss:self];
    }
    
    [self dismissViewControllerAnimated:animated completion:^{
        if ([self.delegate respondsToSelector:@selector(photosViewControllerDidDismiss:)]) {
            [self.delegate photosViewControllerDidDismiss:self];
        }
    }];
}

#pragma mark - Convenience

- (void)setCurrentlyDisplayedViewController:(UIViewController <NYTPhotoContaining> *)viewController animated:(BOOL)animated {
    if (!viewController) {
        return;
    }
    
    typeof(self) __weak weakSelf = self;
    
    void(^animationCompletion)(BOOL finished) = ^(BOOL finished) {
        [weakSelf didDisplayPhoto:viewController.photo];
    };
    
    [self.pageViewController setViewControllers:@[viewController] direction:UIPageViewControllerNavigationDirectionForward animated:animated completion:animationCompletion];
    
    // The completion block isn't called unless animated is YES, so call it ourselves if animated is NO.
    if (!animated) {
        animationCompletion(YES);
    }
}

- (void)didDisplayPhoto:(id <NYTPhoto>)photo {
    if ([self.delegate respondsToSelector:@selector(photosViewController:didDisplayPhoto:)]) {
        [self.delegate photosViewController:self didDisplayPhoto:photo];
    }
}

- (id <NYTPhoto>)currentlyDisplayedPhoto {
    return self.currentPhotoViewController.photo;
}

- (NYTPhotoViewController *)currentPhotoViewController {
    return self.pageViewController.viewControllers.firstObject;
}

- (UIView *)referenceViewForCurrentPhoto {
    if ([self.delegate respondsToSelector:@selector(photosViewController:referenceViewForPhoto:)]) {
        return [self.delegate photosViewController:self referenceViewForPhoto:self.currentPhotoViewController.photo];
    }
    
    return nil;
}

- (CGPoint)boundsCenterPoint {
    return CGPointMake(CGRectGetMidX(self.view.bounds), CGRectGetMidY(self.view.bounds));
}

#pragma mark - NYTPhotoViewControllerDelegate

- (void)photoViewController:(NYTPhotoViewController *)photoViewController didLongPressWithGestureRecognizer:(UILongPressGestureRecognizer *)longPressGestureRecognizer {
    self.shouldHandleLongPress = NO;
    
    BOOL clientDidHandle = NO;
    if ([self.delegate respondsToSelector:@selector(photosViewController:handleLongPressForPhoto:withGestureRecognizer:)]) {
        clientDidHandle = [self.delegate photosViewController:self handleLongPressForPhoto:photoViewController.photo withGestureRecognizer:longPressGestureRecognizer];
    }
    
    self.shouldHandleLongPress = !clientDidHandle;
    
    if (self.shouldHandleLongPress) {
        UIMenuController *menuController = [UIMenuController sharedMenuController];
        CGRect targetRect = CGRectZero;
        targetRect.origin = [longPressGestureRecognizer locationInView:longPressGestureRecognizer.view];
        [menuController setTargetRect:targetRect inView:longPressGestureRecognizer.view];
        [menuController setMenuVisible:YES animated:YES];
    }
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

- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed {
    if (completed) {
        UIViewController <NYTPhotoContaining> *photoViewController = pageViewController.viewControllers.firstObject;
        [self didDisplayPhoto:photoViewController.photo];
    }
}

@end
