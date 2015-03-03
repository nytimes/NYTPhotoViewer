//
//  NYTPhotoTransitionAnimator.m
//  Pods
//
//  Created by Brian Capps on 2/17/15.
//
//

#import "NYTPhotoTransitionAnimator.h"
#import "NYTOperatingSystemCompatibilityUtility.h"

static const CGFloat NYTPhotoTransitionAnimatorDurationWithZooming = 0.5;
static const CGFloat NYTPhotoTransitionAnimatorDurationWithoutZooming = 0.3;
static const CGFloat NYTPhotoTransitionAnimatorBackgroundFadeDurationRatio = 4.0 / 9.0;
static const CGFloat NYTPhotoTransitionAnimatorEndingViewFadeInDurationRatio = 0.1;
static const CGFloat NYTPhotoTransitionAnimatorStartingViewFadeOutDurationRatio = 0.05;
static const CGFloat NYTPhotoTransitionAnimatorSpringDamping = 0.85;

@interface NYTPhotoTransitionAnimator ()

@property (nonatomic, readonly) BOOL shouldPerformZoomingAnimation;

@end

@implementation NYTPhotoTransitionAnimator

#pragma mark - NSObject

- (instancetype)init {
    self = [super init];
    
    if (self) {
        _animationDurationWithZooming = NYTPhotoTransitionAnimatorDurationWithZooming;
        _animationDurationWithoutZooming = NYTPhotoTransitionAnimatorDurationWithoutZooming;
        _animationDurationFadeRatio = NYTPhotoTransitionAnimatorBackgroundFadeDurationRatio;
        _animationDurationEndingViewFadeInRatio = NYTPhotoTransitionAnimatorEndingViewFadeInDurationRatio;
        _animationDurationStartingViewFadeOutRatio = NYTPhotoTransitionAnimatorStartingViewFadeOutDurationRatio;
        _zoomingAnimationSpringDamping = NYTPhotoTransitionAnimatorSpringDamping;
    }
    
    return self;
}

#pragma mark - NYTPhotoTransitionAnimator

- (void)setupTransitionContainerHierarchyWithTransitionContext:(id <UIViewControllerContextTransitioning>)transitionContext {
    UIView *fromView = [NYTOperatingSystemCompatibilityUtility fromViewForTransitionContext:transitionContext];
    UIView *toView = [NYTOperatingSystemCompatibilityUtility toViewForTransitionContext:transitionContext];
    
    toView.frame = [NYTOperatingSystemCompatibilityUtility finalFrameForToViewControllerWithTransitionContext:transitionContext];
    
    if (![toView isDescendantOfView:transitionContext.containerView]) {
        [transitionContext.containerView addSubview:toView];
    }
    
    if (self.isDismissing) {
        [transitionContext.containerView bringSubviewToFront:fromView];
    }
}

- (void)setAnimationDurationFadeRatio:(CGFloat)animationDurationFadeRatio {
    _animationDurationFadeRatio = MIN(animationDurationFadeRatio, 1.0);
}

- (void)setAnimationDurationEndingViewFadeInRatio:(CGFloat)animationDurationEndingViewFadeInRatio {
    _animationDurationEndingViewFadeInRatio = MIN(animationDurationEndingViewFadeInRatio, 1.0);
}

- (void)setAnimationDurationStartingViewFadeOutRatio:(CGFloat)animationDurationStartingViewFadeOutRatio {
    _animationDurationStartingViewFadeOutRatio = MIN(animationDurationStartingViewFadeOutRatio, 1.0);
}

#pragma mark - Fading

- (void)performFadeAnimationWithTransitionContext:(id <UIViewControllerContextTransitioning>)transitionContext {
    UIView *fromView = [NYTOperatingSystemCompatibilityUtility fromViewForTransitionContext:transitionContext];
    UIView *toView = [NYTOperatingSystemCompatibilityUtility toViewForTransitionContext:transitionContext];
    
    UIView *viewToFade = toView;
    CGFloat beginningAlpha = 0.0;
    CGFloat endingAlpha = 1.0;
    
    if (self.isDismissing) {
        viewToFade = fromView;
        beginningAlpha = 1.0;
        endingAlpha = 0.0;
    }
    
    viewToFade.alpha = beginningAlpha;
    
    [UIView animateWithDuration:[self fadeDurationForTransitionContext:transitionContext] animations:^{
        viewToFade.alpha = endingAlpha;
    } completion:^(BOOL finished) {
        if (!self.shouldPerformZoomingAnimation) {
            [self completeTransitionWithTransitionContext:transitionContext];
        }
    }];
}

- (CGFloat)fadeDurationForTransitionContext:(id <UIViewControllerContextTransitioning>)transitionContext {
    if (self.shouldPerformZoomingAnimation) {
        return [self transitionDuration:transitionContext] * self.animationDurationFadeRatio;
    }
    
    return [self transitionDuration:transitionContext];
}

#pragma mark - Zooming

- (void)performZoomingAnimationWithTransitionContext:(id <UIViewControllerContextTransitioning>)transitionContext {
    UIView *containerView = transitionContext.containerView;
    
    // Create a brand new view with the same contents for the purposes of animating this new view and leaving the old one alone.
    UIView *startingViewForAnimation = self.startingViewForAnimation;
    if (!startingViewForAnimation) {
        startingViewForAnimation = [[self class] newAnimationViewFromView:self.startingView];
    }
    
    UIView *endingViewForAnimation = self.endingViewForAnimation;
    if (!endingViewForAnimation) {
        endingViewForAnimation = [[self class] newAnimationViewFromView:self.endingView];
    }
    
    CGFloat endingViewInitialTransform = CGRectGetHeight(startingViewForAnimation.frame) / CGRectGetHeight(endingViewForAnimation.frame);
    CGPoint translatedStartingViewCenter = [[self class] centerPointForView:self.startingView translatedToContainerView:containerView];
    
    startingViewForAnimation.center = translatedStartingViewCenter;
    
    endingViewForAnimation.transform = CGAffineTransformScale(endingViewForAnimation.transform, endingViewInitialTransform, endingViewInitialTransform);
    endingViewForAnimation.center = translatedStartingViewCenter;
    endingViewForAnimation.alpha = 0.0;
    
    [transitionContext.containerView addSubview:startingViewForAnimation];
    [transitionContext.containerView addSubview:endingViewForAnimation];
    
    // Hide the original ending view and starting view until the completion of the animation.
    self.endingView.hidden = YES;
    self.startingView.hidden = YES;
    
    // Ending view / starting view replacement animation
    [UIView animateWithDuration:[self transitionDuration:transitionContext] * self.animationDurationEndingViewFadeInRatio
                          delay:0
                        options:UIViewAnimationOptionAllowAnimatedContent | UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
        endingViewForAnimation.alpha = 1.0;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:[self transitionDuration:transitionContext] * self.animationDurationStartingViewFadeOutRatio
                              delay:0
                            options:UIViewAnimationOptionAllowAnimatedContent | UIViewAnimationOptionBeginFromCurrentState
                         animations:^{
            startingViewForAnimation.alpha = 0.0;
        } completion:^(BOOL finished) {
            [startingViewForAnimation removeFromSuperview];
        }];
    }];
    
    CGFloat startingViewFinalTransform = 1.0 / endingViewInitialTransform;
    CGPoint translatedEndingViewFinalCenter = [[self class] centerPointForView:self.endingView translatedToContainerView:containerView];
    
    // Zoom animation
    [UIView animateWithDuration:[self transitionDuration:transitionContext]
                          delay:0
         usingSpringWithDamping:self.zoomingAnimationSpringDamping
          initialSpringVelocity:0.0
                        options:UIViewAnimationOptionAllowAnimatedContent | UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
        endingViewForAnimation.transform = self.endingView.transform;
        endingViewForAnimation.center = translatedEndingViewFinalCenter;
        
        startingViewForAnimation.transform = CGAffineTransformScale(startingViewForAnimation.transform, startingViewFinalTransform, startingViewFinalTransform);
        startingViewForAnimation.center = translatedEndingViewFinalCenter;
    } completion:^(BOOL finished) {
        [endingViewForAnimation removeFromSuperview];
        self.endingView.hidden = NO;
        self.startingView.hidden = NO;
        
        [self completeTransitionWithTransitionContext:transitionContext];
    }];
}

#pragma mark - Convenience

- (BOOL)shouldPerformZoomingAnimation {
    return self.startingView && self.endingView;
}

- (void)completeTransitionWithTransitionContext:(id <UIViewControllerContextTransitioning>)transitionContext {
    if (transitionContext.isInteractive) {
        if (transitionContext.transitionWasCancelled) {
            [transitionContext cancelInteractiveTransition];
        }
        else {
            [transitionContext finishInteractiveTransition];
        }
    }
    
    [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
}

+ (CGPoint)centerPointForView:(UIView *)view translatedToContainerView:(UIView *)containerView {
    CGPoint centerPoint = view.center;
    
    // Special case for zoomed scroll views.
    if ([view.superview isKindOfClass:[UIScrollView class]]) {
        UIScrollView *scrollView = (UIScrollView *)view.superview;
        
        if (scrollView.zoomScale != 1.0) {
            centerPoint.x += (CGRectGetWidth(scrollView.bounds) - scrollView.contentSize.width) / 2.0 + scrollView.contentOffset.x;
            centerPoint.y += (CGRectGetHeight(scrollView.bounds) - scrollView.contentSize.height) / 2.0 + scrollView.contentOffset.y;
        }
    }
    
    return [view.superview convertPoint:centerPoint toView:containerView];
}

+ (UIView *)newAnimationViewFromView:(UIView *)view {
    if (!view) {
        return nil;
    }
    
    UIView *animationView = [[UIView alloc] initWithFrame:view.frame];
    
    if (view.layer.contents) {
        animationView.layer.contents = view.layer.contents;
        animationView.layer.bounds = view.layer.bounds;
    }
    else {
        animationView = [view snapshotViewAfterScreenUpdates:NO];
    }
    
    animationView.layer.cornerRadius = view.layer.cornerRadius;
    animationView.layer.masksToBounds = view.layer.masksToBounds;
    animationView.contentMode = view.contentMode;
    animationView.transform = view.transform;
    
    return animationView;
}

#pragma mark - UIViewControllerAnimatedTransitioning

- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext {
    if (self.shouldPerformZoomingAnimation) {
        return self.animationDurationWithZooming;
    }
    
    return self.animationDurationWithoutZooming;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext {
    [self setupTransitionContainerHierarchyWithTransitionContext:transitionContext];
    
    [self performFadeAnimationWithTransitionContext:transitionContext];
    
    if (self.shouldPerformZoomingAnimation) {
        [self performZoomingAnimationWithTransitionContext:transitionContext];
    }
}

@end
