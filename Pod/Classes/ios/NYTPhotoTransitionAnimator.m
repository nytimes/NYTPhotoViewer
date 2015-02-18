//
//  NYTPhotoTransitionAnimator.m
//  Pods
//
//  Created by Brian Capps on 2/17/15.
//
//

#import "NYTPhotoTransitionAnimator.h"

const CGFloat NYTPhotoTransitionAnimatorBackgroundFadeDurationRatio = 4.0/9.0;

@implementation NYTPhotoTransitionAnimator


- (UIView *)fromViewForTransitionContext:(id <UIViewControllerContextTransitioning>)transitionContext {
    UIView *fromView;
    
    if ([transitionContext respondsToSelector:@selector(viewForKey:)]) {
        fromView = [transitionContext viewForKey:UITransitionContextFromViewKey];
    }
    else {
        fromView = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey].view;
    }
    return fromView;
}

- (UIView *)toViewForTransitionContext:(id <UIViewControllerContextTransitioning>)transitionContext {
    UIView *toView;
    
    if ([transitionContext respondsToSelector:@selector(viewForKey:)]) {
        toView = [transitionContext viewForKey:UITransitionContextToViewKey];
    }
    else {
        toView = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey].view;
    }
    return toView;
}

- (void)setupTransitionContainerHierarchyWithTransitionContext:(id <UIViewControllerContextTransitioning>)transitionContext {
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    UIView *fromView = [self fromViewForTransitionContext:transitionContext];
    UIView *toView = [self toViewForTransitionContext:transitionContext];
    
    toView.frame = [transitionContext finalFrameForViewController:toViewController];
    
    if (![toView isDescendantOfView:transitionContext.containerView]) {
        [transitionContext.containerView addSubview:toView];
    }
    
    if (self.isDismissing) {
        [transitionContext.containerView bringSubviewToFront:fromView];
    }
}

#pragma mark - Fading

- (void)performFadeAnimationWithTransitionContext:(id <UIViewControllerContextTransitioning>)transitionContext {
    UIView *fromView = [self fromViewForTransitionContext:transitionContext];
    UIView *toView = [self toViewForTransitionContext:transitionContext];
    
    UIView *viewToFade = toView;
    CGFloat beginningAlpha = 0.0;
    CGFloat endingAlpha = 1.0;
    
    if (self.isDismissing) {
        viewToFade = fromView;
        beginningAlpha = 1.0;
        endingAlpha = 0.0;
    }
    
    viewToFade.alpha = beginningAlpha;
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext] * NYTPhotoTransitionAnimatorBackgroundFadeDurationRatio animations:^{
        viewToFade.alpha = endingAlpha;
    } completion:nil];
}

#pragma mark - Convenience

+ (CGPoint)centerPointForView:(UIView *)view translatedToContainerView:(UIView *)containerView {
    CGPoint centerPoint = view.center;
    
    // Special case for zoomed scroll views.
    if ([view.superview isKindOfClass:[UIScrollView class]]) {
        UIScrollView *scrollView = (UIScrollView *)view.superview;
        
        centerPoint.x += (CGRectGetWidth(scrollView.bounds) - scrollView.contentSize.width) / 2.0 + scrollView.contentOffset.x;
        centerPoint.y += (CGRectGetHeight(scrollView.bounds) - scrollView.contentSize.height) / 2.0 + scrollView.contentOffset.y;
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
    return 0.5;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext {
    UIView *containerView = transitionContext.containerView;
    
    [self setupTransitionContainerHierarchyWithTransitionContext:transitionContext];
    
    // Background fade animation.
    [self performFadeAnimationWithTransitionContext:transitionContext];
    
    // Create a brand new view with the same contents for the purposes of animating this new view and leaving the old one alone.
    UIView *startingViewForAnimation = [[self class] newAnimationViewFromView:self.startingView];
    UIView *endingViewForAnimation = [[self class] newAnimationViewFromView:self.endingView];
    
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
    [UIView animateWithDuration:[self transitionDuration:transitionContext] * 0.1 delay:0 options:UIViewAnimationOptionAllowAnimatedContent | UIViewAnimationOptionBeginFromCurrentState animations:^{
        endingViewForAnimation.alpha = 1.0;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:[self transitionDuration:transitionContext] * 0.05 delay:0 options:UIViewAnimationOptionAllowAnimatedContent | UIViewAnimationOptionBeginFromCurrentState animations:^{
            startingViewForAnimation.alpha = 0.0;
        } completion:^(BOOL finished) {
            [startingViewForAnimation removeFromSuperview];
        }];
    }];
    
    CGFloat startingViewFinalTransform = 1.0 / endingViewInitialTransform;
    CGPoint translatedEndingViewFinalCenter = [[self class] centerPointForView:self.endingView translatedToContainerView:containerView];
    
    // Zoom animation
    [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0 usingSpringWithDamping:0.85 initialSpringVelocity:0.0 options:UIViewAnimationOptionAllowAnimatedContent | UIViewAnimationOptionBeginFromCurrentState animations:^{
        endingViewForAnimation.transform = self.endingView.transform;
        endingViewForAnimation.center = translatedEndingViewFinalCenter;
        
        startingViewForAnimation.transform = CGAffineTransformScale(startingViewForAnimation.transform, startingViewFinalTransform, startingViewFinalTransform);
        startingViewForAnimation.center = translatedEndingViewFinalCenter;
    } completion:^(BOOL finished) {
        [endingViewForAnimation removeFromSuperview];
        self.endingView.hidden = NO;
        self.startingView.hidden = NO;
        
        if (transitionContext.isInteractive) {
            if (transitionContext.transitionWasCancelled) {
                [transitionContext cancelInteractiveTransition];
            }
            else {
                [transitionContext finishInteractiveTransition];
            }
        }
        
        [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
    }];
}

@end
