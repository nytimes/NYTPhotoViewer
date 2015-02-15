//
//  NYTPhotoTransitionAnimator.m
//  Pods
//
//  Created by Brian Capps on 2/13/15.
//
//

#import "NYTPhotoTransitionAnimator.h"

const CGFloat NYTPhotoTransitionAnimatorBackgroundFadeDurationRatio = 4.0/9.0;

@interface NYTPhotoTransitionAnimator ()

@property (nonatomic, getter=isDismissing) BOOL dismissing;

@end

@implementation NYTPhotoTransitionAnimator

- (instancetype)init {
    self = [super init];
    
    if (self) {
        _endingViewCenter = CGPointZero;
    }
    
    return self;
}

#pragma mark - UIViewControllerTransitioningDelegate

- (id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    self.dismissing = NO;
    return self;
}

- (id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    self.dismissing = YES;
    return self;
}

#pragma mark - UIViewControllerAnimatedTransitioning

- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext {
    return 0.5;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext {
    UIView *containerView = [transitionContext containerView];
    
    UIView *fromView;
    UIView *toView;
    
    if ([transitionContext respondsToSelector:@selector(viewForKey:)]) {
        fromView = [transitionContext viewForKey:UITransitionContextFromViewKey];
        toView = [transitionContext viewForKey:UITransitionContextToViewKey];
    }
    else {
        fromView = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey].view;
        toView = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey].view;
    }
    
    toView.frame = containerView.bounds;
    
    if (![toView isDescendantOfView:containerView]) {
        [containerView addSubview:toView];
    }
    
    
    CGPoint endingViewCenter = self.endingViewCenter;
    
    if (CGPointEqualToPoint(endingViewCenter, CGPointZero)) {
        endingViewCenter = self.endingView.center;
    }
    
    CGPoint endingViewOriginalCenterInAnimationContainer = [self.endingView.superview convertPoint:endingViewCenter toView:containerView];
    
    // Create a brand new view witht he same contents just for the purposes of animating it,
    UIView *endingViewForAnimation = [[self class] newAnimationViewFromView:self.endingView];
    
    if (self.startingView && self.endingView) {
        CGPoint translatedInitialEndingCenter = [self.startingView.superview convertPoint:self.startingView.center toView:containerView];
        CGFloat endingViewInitialTransform = CGRectGetHeight(self.startingView.frame) / CGRectGetHeight(endingViewForAnimation.frame);
        
        endingViewForAnimation.transform = CGAffineTransformScale(endingViewForAnimation.transform, endingViewInitialTransform, endingViewInitialTransform);
        endingViewForAnimation.center = translatedInitialEndingCenter;

        [transitionContext.containerView addSubview:endingViewForAnimation];
    }
    
    // Hide the original ending view until the completion of the animation.
    self.endingView.hidden = YES;
    
    
    UIView *viewToFade = toView;
    CGFloat beginningAlpha = 0.0;
    CGFloat endingAlpha = 1.0;
    
    if (self.isDismissing) {
        [containerView bringSubviewToFront:fromView];
        
        viewToFade = fromView;
        beginningAlpha = 1.0;
        endingAlpha = 0.0;
    }
    
    viewToFade.alpha = beginningAlpha;
    
    // Fade animation
    [UIView animateWithDuration:[self transitionDuration:transitionContext] * NYTPhotoTransitionAnimatorBackgroundFadeDurationRatio animations:^{
        viewToFade.alpha = endingAlpha;
    } completion:^(BOOL finished) {
    }];
    
    // Zoom animation
    [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:0.0 options:UIViewAnimationOptionAllowAnimatedContent | UIViewAnimationOptionBeginFromCurrentState animations:^{
        endingViewForAnimation.transform = self.endingView.transform;
        endingViewForAnimation.center = endingViewOriginalCenterInAnimationContainer;
    } completion:^(BOOL finished) {
        [endingViewForAnimation removeFromSuperview];
        self.endingView.hidden = NO;

        [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
    }];
}

#pragma mark - Convenience

+ (UIView *)newAnimationViewFromView:(UIView *)view {
    if (!view) {
        return nil;
    }
    
    UIView *animationView = [[UIView alloc] initWithFrame:view.frame];
    animationView.layer.contents = view.layer.contents;
    animationView.layer.bounds = view.layer.bounds;
    animationView.layer.cornerRadius = view.layer.cornerRadius;
    animationView.layer.masksToBounds = view.layer.masksToBounds;
    animationView.contentMode = view.contentMode;
    animationView.transform = view.transform;
    
    return animationView;
}

@end
