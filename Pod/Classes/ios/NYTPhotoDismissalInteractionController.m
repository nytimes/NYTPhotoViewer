//
//  NYTPhotoDismissalInteractionController.m
//  Pods
//
//  Created by Brian Capps on 2/17/15.
//
//

#import "NYTPhotoDismissalInteractionController.h"

const CGFloat NYTPhotoTransitionAnimatorPanDismissDistanceRatio = 100.0/667.0; // distance over iPhone 6 height.
const CGFloat NYTPhotoTransitionAnimatorPanDismissMaximumDuration = 0.45;

@interface NYTPhotoDismissalInteractionController ()

@property (nonatomic) id <UIViewControllerContextTransitioning> transitionContext;

@end

@implementation NYTPhotoDismissalInteractionController

- (void)didPanWithPanGestureRecognizer:(UIPanGestureRecognizer *)panGestureRecognizer viewToPan:(UIView *)viewToPan anchorPoint:(CGPoint)anchorPoint {
    UIView *fromView = [self fromViewForTransitionContext:self.transitionContext];
    CGPoint translatedPanGesturePoint = [panGestureRecognizer translationInView:fromView];
    CGPoint newCenterPoint = CGPointMake(anchorPoint.x, anchorPoint.y + translatedPanGesturePoint.y);
    
    // Pan the view on pace with the pan gesture.
    viewToPan.center = newCenterPoint;
    
    CGFloat verticalDelta = newCenterPoint.y - anchorPoint.y;
    
    CGFloat backgroundAlpha = [self backgroundAlphaForPanningWithVerticalDelta:verticalDelta];
    fromView.backgroundColor = [fromView.backgroundColor colorWithAlphaComponent:backgroundAlpha];
    
    if (panGestureRecognizer.state == UIGestureRecognizerStateEnded) {
        [self finishPanWithPanGestureRecognizer:panGestureRecognizer verticalDelta:verticalDelta viewToPan:viewToPan anchorPoint:anchorPoint];
    }
}

- (void)finishPanWithPanGestureRecognizer:(UIPanGestureRecognizer *)panGestureRecognizer verticalDelta:(CGFloat)verticalDelta viewToPan:(UIView *)viewToPan anchorPoint:(CGPoint)anchorPoint {
    UIView *fromView = [self fromViewForTransitionContext:self.transitionContext];
    
    // Return to center case.
    CGFloat velocityY = [panGestureRecognizer velocityInView:panGestureRecognizer.view].y;
    
    CGFloat animationDuration = (ABS(velocityY) * 0.00007) + 0.2;
    CGFloat animationCurve = UIViewAnimationOptionCurveEaseOut;
    CGPoint finalPageViewCenterPoint = anchorPoint;
    CGFloat finalBackgroundAlpha = 1.0;
    
    // Offscreen dismissal case.
    CGFloat dismissDistance = NYTPhotoTransitionAnimatorPanDismissDistanceRatio * CGRectGetHeight(fromView.bounds);
    BOOL isDismissing = ABS(verticalDelta) > dismissDistance;
    
    BOOL didAnimateUsingAnimationController = NO;
    
    if (isDismissing) {
        if (self.canAnimateUsingAnimationController) {
            [self.animator animateTransition:self.transitionContext];
            didAnimateUsingAnimationController = YES;
        }
        else {
            BOOL isPositiveDelta = verticalDelta >= 0;
            
            CGFloat modifier = isPositiveDelta ? 1 : -1;
            CGFloat finalCenterY = CGRectGetMidY(fromView.bounds) + modifier * CGRectGetHeight(fromView.bounds);
            finalPageViewCenterPoint = CGPointMake(fromView.center.x, finalCenterY);
            
            // Maintain the velocity of the pan, while easing out.
            animationDuration = ABS(finalPageViewCenterPoint.y - viewToPan.center.y) / ABS(velocityY);
            animationDuration = MIN(animationDuration, NYTPhotoTransitionAnimatorPanDismissMaximumDuration);
            
            animationCurve = UIViewAnimationOptionCurveEaseOut;
            finalBackgroundAlpha = 0.0;
        }
    }
    
    if (!didAnimateUsingAnimationController) {
        [UIView animateWithDuration:animationDuration delay:0 options:animationCurve animations:^{
            viewToPan.center = finalPageViewCenterPoint;
            
            fromView.backgroundColor = [fromView.backgroundColor colorWithAlphaComponent:finalBackgroundAlpha];
        } completion:^(BOOL finished) {
            if (isDismissing) {
                [self.transitionContext finishInteractiveTransition];
            }
            else {
                [self.transitionContext cancelInteractiveTransition];
            }
            
            self.viewToHideWhenBeginningTransition.hidden = NO;
            
            [self.transitionContext completeTransition:isDismissing && !self.transitionContext.transitionWasCancelled];
        }];
    }
}

- (CGFloat)backgroundAlphaForPanningWithVerticalDelta:(CGFloat)verticalDelta {
    CGFloat startingAlpha = 1.0;
    CGFloat finalAlpha = 0.1;
    CGFloat totalAvailableAlpha = startingAlpha - finalAlpha;
    
    CGFloat maximumDelta = CGRectGetHeight([self fromViewForTransitionContext:self.transitionContext].bounds) / 2.0; // Arbitrary value.
    CGFloat deltaAsPercentageOfMaximum = MIN(ABS(verticalDelta)/maximumDelta, 1.0);
    
    return startingAlpha - (deltaAsPercentageOfMaximum * totalAvailableAlpha);
}

- (UIView *)fromViewForTransitionContext:(id <UIViewControllerContextTransitioning>)transitionContext {
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIView *fromView;
    if ([transitionContext respondsToSelector:@selector(viewForKey:)]) {
        fromView = [transitionContext viewForKey:UITransitionContextFromViewKey];
    }
    else {
        fromView = fromViewController.view;
    }
    return fromView;
}

- (UIView *)toViewForTransitionContext:(id <UIViewControllerContextTransitioning>)transitionContext {
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    UIView *toView;
    
    if ([transitionContext respondsToSelector:@selector(viewForKey:)]) {
        toView = [transitionContext viewForKey:UITransitionContextToViewKey];
    }
    else {
        toView = toViewController.view;
    }
    return toView;
}

#pragma mark - UIViewControllerInteractiveTransitioning

- (void)startInteractiveTransition:(id <UIViewControllerContextTransitioning>)transitionContext {
    self.viewToHideWhenBeginningTransition.hidden = YES;
    
    self.transitionContext = transitionContext;
}


@end
