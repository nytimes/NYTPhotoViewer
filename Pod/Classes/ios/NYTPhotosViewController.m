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
#import "NYTPhotosOverlayView.h"
#import "NYTPhotoCaptionView.h"

NSString * const NYTPhotosViewControllerDidDisplayPhotoNotification = @"NYTPhotosViewControllerDidDisplayPhotoNotification";
NSString * const NYTPhotosViewControllerWillDismissNotification = @"NYTPhotosViewControllerWillDismissNotification";
NSString * const NYTPhotosViewControllerDidDismissNotification = @"NYTPhotosViewControllerDidDismissNotification";

static const CGFloat NYTPhotosViewControllerOverlayAnimationDuration = 0.2;
static const CGFloat NYTPhotosViewControllerInterPhotoSpacing = 16.0;

@interface NYTPhotosViewController () <UIPageViewControllerDataSource, UIPageViewControllerDelegate, NYTPhotoViewControllerDelegate>

@property (nonatomic) id <NYTPhotosViewControllerDataSource> dataSource;
@property (nonatomic) UIPageViewController *pageViewController;
@property (nonatomic) NYTPhotoTransitionController *transitionController;

@property (nonatomic) UIPanGestureRecognizer *panGestureRecognizer;
@property (nonatomic) UITapGestureRecognizer *singleTapGestureRecognizer;

@property (nonatomic) NYTPhotosOverlayView *overlayView;

/// A custom notification center to scope internal notifications to this `NYTPhotosViewController` instance.
@property (nonatomic) NSNotificationCenter *notificationCenter;

@property (nonatomic) BOOL shouldHandleLongPress;
@property (nonatomic) BOOL overlayWasHiddenBeforeTransition;

@property (nonatomic, readonly) NYTPhotoViewController *currentPhotoViewController;
@property (nonatomic, readonly) UIView *referenceViewForCurrentPhoto;
@property (nonatomic, readonly) CGPoint boundsCenterPoint;

@end

@implementation NYTPhotosViewController

#pragma mark - NSObject

- (void)dealloc {
    _pageViewController.dataSource = nil;
    _pageViewController.delegate = nil;
}

#pragma mark - NSObject(UIResponderStandardEditActions)

- (void)copy:(id)sender {
    [[UIPasteboard generalPasteboard] setImage:self.currentlyDisplayedPhoto.image];
}

#pragma mark - UIResponder

- (BOOL)canBecomeFirstResponder {
    return YES;
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    if (self.shouldHandleLongPress && action == @selector(copy:) && self.currentlyDisplayedPhoto.image) {
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
    
    self.view.tintColor = [UIColor whiteColor];
    self.view.backgroundColor = [UIColor blackColor];
    self.pageViewController.view.backgroundColor = [UIColor clearColor];
    
    [self addChildViewController:self.pageViewController];
    [self.view addSubview:self.pageViewController.view];
    [self.pageViewController didMoveToParentViewController:self];
    
    [self addOverlayView];
    
    self.transitionController.startingView = self.referenceViewForCurrentPhoto;
    
    UIView *endingView;
    if (self.currentlyDisplayedPhoto.image || self.currentlyDisplayedPhoto.placeholderImage) {
        endingView = self.currentPhotoViewController.scalingImageView.imageView;
    }
    
    self.transitionController.endingView = endingView;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (!self.overlayWasHiddenBeforeTransition) {
        [self setOverlayViewHidden:NO animated:YES];
    }
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    self.pageViewController.view.frame = self.view.bounds;
    self.overlayView.frame = self.view.bounds;
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation {
    return UIStatusBarAnimationFade;
}

#pragma mark - NYTPhotosViewController

- (instancetype)initWithPhotos:(NSArray *)photos {
    return [self initWithPhotos:photos initialPhoto:photos.firstObject];
}

- (instancetype)initWithPhotos:(NSArray *)photos initialPhoto:(id <NYTPhoto>)initialPhoto {
    self = [super initWithNibName:nil bundle:nil];
    
    if (self) {
        _dataSource = [[NYTPhotosDataSource alloc] initWithPhotos:photos];
        _panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(didPanWithGestureRecognizer:)];
        _singleTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didSingleTapWithGestureRecognizer:)];
        
        _transitionController = [[NYTPhotoTransitionController alloc] init];
        self.modalPresentationStyle = UIModalPresentationCustom;
        self.transitioningDelegate = _transitionController;
        self.modalPresentationCapturesStatusBarAppearance = YES;
        
        // iOS 7 has an issue with constraints that could evaluate to be negative, so we set the width to the margins' size.
        _overlayView = [[NYTPhotosOverlayView alloc] initWithFrame:CGRectMake(0, 0, NYTPhotoCaptionViewHorizontalMargin * 2.0, 0)];
        _overlayView.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneButtonTapped:)];
        _overlayView.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(actionButtonTapped:)];
        
        _notificationCenter = [[NSNotificationCenter alloc] init];
        
        [self setupPageViewControllerWithInitialPhoto:initialPhoto];
    }
    
    return self;
}

- (void)setupPageViewControllerWithInitialPhoto:(id <NYTPhoto>)initialPhoto {
    self.pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:@{UIPageViewControllerOptionInterPageSpacingKey: @(NYTPhotosViewControllerInterPhotoSpacing)}];
    
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
    [self.pageViewController.view addGestureRecognizer:self.singleTapGestureRecognizer];
}

- (void)addOverlayView {
    [self updateOverlayInformation];
    [self.view addSubview:self.overlayView];
    
    [self setOverlayViewHidden:YES animated:NO];
}

- (void)updateOverlayInformation {
    NSUInteger displayIndex = 1;
    
    NSUInteger photoIndex = [self.dataSource indexOfPhoto:self.currentlyDisplayedPhoto];
    if (photoIndex < self.dataSource.numberOfPhotos) {
        displayIndex = photoIndex + 1;
    }
    
    NSString *overlayTitle;
    if (self.dataSource.numberOfPhotos > 1) {
        overlayTitle = [NSString localizedStringWithFormat:NSLocalizedString(@"%lu of %lu", nil), (unsigned long)displayIndex, (unsigned long)self.dataSource.numberOfPhotos];
    }
    
    self.overlayView.title = overlayTitle;
    
    UIColor *textColor = self.view.tintColor ?: [UIColor whiteColor];
    NSDictionary *titleTextAttributes = @{NSForegroundColorAttributeName: textColor};
    if ([self.delegate respondsToSelector:@selector(photosViewController:overlayTitleTextAttributesForPhoto:)]) {
        NSDictionary *delegateTitleTextAttributes = [self.delegate photosViewController:self overlayTitleTextAttributesForPhoto:self.currentlyDisplayedPhoto];
        titleTextAttributes = delegateTitleTextAttributes ?: titleTextAttributes;
    }
    
    self.overlayView.titleTextAttributes = titleTextAttributes;
    
    UIView *captionView;
    if ([self.delegate respondsToSelector:@selector(photosViewController:captionViewForPhoto:)]) {
        captionView = [self.delegate photosViewController:self captionViewForPhoto:self.currentlyDisplayedPhoto];
    }
    
    if (!captionView) {
        captionView = [[NYTPhotoCaptionView alloc] initWithAttributedTitle:self.currentlyDisplayedPhoto.attributedCaptionTitle attributedSummary:self.currentlyDisplayedPhoto.attributedCaptionSummary attributedCredit:self.currentlyDisplayedPhoto.attributedCaptionCredit];
    }
    
    self.overlayView.captionView = captionView;
}

- (void)doneButtonTapped:(id)sender {
    self.transitionController.forcesNonInteractiveDismissal = YES;
    [self setOverlayViewHidden:YES animated:NO];
    [self dismissAnimated:YES];
}

- (void)actionButtonTapped:(id)sender {
    BOOL clientDidHandle = NO;
    
    if ([self.delegate respondsToSelector:@selector(photosViewController:handleActionButtonTappedForPhoto:)]) {
        clientDidHandle = [self.delegate photosViewController:self handleActionButtonTappedForPhoto:self.currentlyDisplayedPhoto];
    }
    
    if (!clientDidHandle && self.currentlyDisplayedPhoto.image) {
        UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:@[self.currentlyDisplayedPhoto.image] applicationActivities:nil];
        activityViewController.completionHandler = ^(NSString *activityType, BOOL completed) {
            if (completed && [self.delegate respondsToSelector:@selector(photosViewController:actionCompletedWithActivityType:)]) {
                [self.delegate photosViewController:self actionCompletedWithActivityType:activityType];
            }
        };
        
        [self presentViewController:activityViewController animated:YES completion:nil];
    }
}

- (UIBarButtonItem *)leftBarButtonItem {
    return self.overlayView.leftBarButtonItem;
}

- (void)setLeftBarButtonItem:(UIBarButtonItem *)leftBarButtonItem {
    self.overlayView.leftBarButtonItem = leftBarButtonItem;
}

- (UIBarButtonItem *)rightBarButtonItem {
    return self.overlayView.rightBarButtonItem;
}

- (void)setRightBarButtonItem:(UIBarButtonItem *)rightBarButtonItem {
    self.overlayView.rightBarButtonItem = rightBarButtonItem;
}

- (void)displayPhoto:(id <NYTPhoto>)photo animated:(BOOL)animated {
    if (![self.dataSource containsPhoto:photo]) {
        return;
    }
    
    NYTPhotoViewController *photoViewController = [self newPhotoViewControllerForPhoto:photo];
    [self setCurrentlyDisplayedViewController:photoViewController animated:animated];
}

- (void)updateImageForPhoto:(id <NYTPhoto>)photo {
    [self.notificationCenter postNotificationName:NYTPhotoViewControllerPhotoImageUpdatedNotification object:photo];
}

#pragma mark - Gesture Recognizers

- (void)didSingleTapWithGestureRecognizer:(UITapGestureRecognizer *)tapGestureRecognizer {
    [self setOverlayViewHidden:!self.overlayView.hidden animated:YES];
}

- (void)didPanWithGestureRecognizer:(UIPanGestureRecognizer *)panGestureRecognizer {
    if (panGestureRecognizer.state == UIGestureRecognizerStateBegan) {
        self.overlayWasHiddenBeforeTransition = self.overlayView.hidden;
        [self setOverlayViewHidden:YES animated:YES];
        [self dismissAnimated:YES];
    }
    else {
        [self.transitionController didPanWithPanGestureRecognizer:panGestureRecognizer viewToPan:self.pageViewController.view anchorPoint:self.boundsCenterPoint];
    }
}

- (void)dismissAnimated:(BOOL)animated {
    UIView *startingView;
    if (self.currentlyDisplayedPhoto.image || self.currentlyDisplayedPhoto.placeholderImage) {
        startingView = self.currentPhotoViewController.scalingImageView.imageView;
    }
    
    self.transitionController.startingView = startingView;
    self.transitionController.endingView = self.referenceViewForCurrentPhoto;
    
    if ([self.delegate respondsToSelector:@selector(photosViewControllerWillDismiss:)]) {
        [self.delegate photosViewControllerWillDismiss:self];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:NYTPhotosViewControllerWillDismissNotification object:self];
    
    [self dismissViewControllerAnimated:animated completion:^{
        BOOL isStillOnscreen = self.view.window != nil; // Happens when the dismissal is canceled.
        
        if (isStillOnscreen && !self.overlayWasHiddenBeforeTransition) {
            [self setOverlayViewHidden:NO animated:YES];
        }
        
        if (!isStillOnscreen) {
            if ([self.delegate respondsToSelector:@selector(photosViewControllerDidDismiss:)]) {
                [self.delegate photosViewControllerDidDismiss:self];
            }
            
            [[NSNotificationCenter defaultCenter] postNotificationName:NYTPhotosViewControllerDidDismissNotification object:self];
        }
    }];
}

#pragma mark - Convenience

- (void)setCurrentlyDisplayedViewController:(UIViewController <NYTPhotoContainer> *)viewController animated:(BOOL)animated {
    if (!viewController) {
        return;
    }
    
    [self.pageViewController setViewControllers:@[viewController] direction:UIPageViewControllerNavigationDirectionForward animated:animated completion:nil];
}

- (void)setOverlayViewHidden:(BOOL)hidden animated:(BOOL)animated {
    if (hidden == self.overlayView.hidden) {
        return;
    }
    
    if (animated) {
        self.overlayView.hidden = NO;
        
        self.overlayView.alpha = hidden ? 1.0 : 0.0;
        
        [UIView animateWithDuration:NYTPhotosViewControllerOverlayAnimationDuration delay:0.0 options:UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionAllowAnimatedContent | UIViewAnimationOptionAllowUserInteraction animations:^{
            self.overlayView.alpha = hidden ? 0.0 : 1.0;
        } completion:^(BOOL finished) {
            self.overlayView.alpha = 1.0;
            self.overlayView.hidden = hidden;
        }];
    }
    else {
        self.overlayView.hidden = hidden;
    }
}

- (NYTPhotoViewController *)newPhotoViewControllerForPhoto:(id <NYTPhoto>)photo {
    if (photo) {
        UIView *loadingView;
        if ([self.delegate respondsToSelector:@selector(photosViewController:loadingViewForPhoto:)]) {
            loadingView = [self.delegate photosViewController:self loadingViewForPhoto:photo];
        }
        
        NYTPhotoViewController *photoViewController = [[NYTPhotoViewController alloc] initWithPhoto:photo loadingView:loadingView notificationCenter:self.notificationCenter];
        photoViewController.delegate = self;
        [self.singleTapGestureRecognizer requireGestureRecognizerToFail:photoViewController.doubleTapGestureRecognizer];
        
        return photoViewController;
    }
    
    return nil;
}

- (void)didDisplayPhoto:(id <NYTPhoto>)photo {
    if ([self.delegate respondsToSelector:@selector(photosViewController:didDisplayPhoto:)]) {
        [self.delegate photosViewController:self didDisplayPhoto:photo];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:NYTPhotosViewControllerDidDisplayPhotoNotification object:self];
}

- (id <NYTPhoto>)currentlyDisplayedPhoto {
    return self.currentPhotoViewController.photo;
}

- (NYTPhotoViewController *)currentPhotoViewController {
    return self.pageViewController.viewControllers.firstObject;
}

- (UIView *)referenceViewForCurrentPhoto {
    if ([self.delegate respondsToSelector:@selector(photosViewController:referenceViewForPhoto:)]) {
        return [self.delegate photosViewController:self referenceViewForPhoto:self.currentlyDisplayedPhoto];
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

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController <NYTPhotoContainer> *)viewController {
    NSUInteger photoIndex = [self.dataSource indexOfPhoto:viewController.photo];
    return [self newPhotoViewControllerForPhoto:self.dataSource[photoIndex - 1]];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController <NYTPhotoContainer> *)viewController {
    NSUInteger photoIndex = [self.dataSource indexOfPhoto:viewController.photo];
    return [self newPhotoViewControllerForPhoto:self.dataSource[photoIndex + 1]];
}

#pragma mark - UIPageViewControllerDelegate

- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed {
    if (completed) {
        [self updateOverlayInformation];
        
        UIViewController <NYTPhotoContainer> *photoViewController = pageViewController.viewControllers.firstObject;
        [self didDisplayPhoto:photoViewController.photo];
    }
}

@end
