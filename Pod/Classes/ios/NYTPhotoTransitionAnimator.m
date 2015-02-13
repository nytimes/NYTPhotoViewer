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
    
    UIView *endingViewOriginalSuperview = self.endingView.superview;
    CGPoint endingViewOriginalCenterInAnimationSuperview = self.endingView.center;
    
    
    CGPoint endingViewCenter = self.endingViewCenter;
    
    if (CGPointEqualToPoint(self.endingViewCenter, CGPointZero)) {
        endingViewCenter = self.endingView.center;
    }
    
    
    CGPoint endingViewOriginalCenterInAnimationContainer = [self.endingView.superview convertPoint:endingViewCenter toView:containerView];
    CGAffineTransform endingViewOriginalTransform = self.endingView.transform;
    
    if (self.startingView && self.endingView) {
        CGPoint translatedInitialEndingCenter = [self.startingView.superview convertPoint:self.startingView.center toView:containerView];
        CGFloat endingViewInitialTransform = CGRectGetHeight(self.startingView.frame) / CGRectGetHeight(self.endingView.frame);
        
        self.endingView.transform = CGAffineTransformScale(self.endingView.transform, endingViewInitialTransform, endingViewInitialTransform);
        self.endingView.center = translatedInitialEndingCenter;

        [transitionContext.containerView addSubview:self.endingView];
    }
    
    
    
    
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
    [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0 usingSpringWithDamping:0.75 initialSpringVelocity:0.0 options:0 animations:^{
        self.endingView.transform = endingViewOriginalTransform;
        self.endingView.center = endingViewOriginalCenterInAnimationContainer;
    } completion:^(BOOL finished) {
        [endingViewOriginalSuperview addSubview:self.endingView];
        self.endingView.center = endingViewOriginalCenterInAnimationSuperview;
        [transitionContext completeTransition:!transitionContext.transitionWasCancelled];

    }];
}

@end
