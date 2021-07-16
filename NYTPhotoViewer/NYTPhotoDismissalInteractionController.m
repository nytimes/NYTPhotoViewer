//
//  NYTPhotoDismissalInteractionController.m
//  NYTPhotoViewer
//
//  Created by Brian Capps on 2/17/15.
//
//

#import "NYTPhotoDismissalInteractionController.h"

static const CGFloat NYTPhotoDismissalInteractionControllerPanDismissDistanceRatio = 50.0 / 667.0; // distance over iPhone 6 height.
static const CGFloat NYTPhotoDismissalInteractionControllerPanDismissMaximumDuration = 0.45;
static const CGFloat NYTPhotoDismissalInteractionControllerReturnToCenterVelocityAnimationRatio = 0.00007; // Arbitrary value that looked decent.

@interface NYTPhotoDismissalInteractionController ()

@property (nonatomic) id <UIViewControllerContextTransitioning> transitionContext;

@end

@implementation NYTPhotoDismissalInteractionController

#pragma mark - NYTPhotoDismissalInteractionController

- (void)didPanWithPanGestureRecognizer:(UIPanGestureRecognizer *)panGestureRecognizer viewToPan:(UIView *)viewToPan anchorPoint:(CGPoint)anchorPoint {
    UIView *fromView = [self.transitionContext viewForKey:UITransitionContextFromViewKey];
    CGPoint translatedPanGesturePoint = [panGestureRecognizer translationInView:fromView];
    CGPoint newCenterPoint = CGPointMake(anchorPoint.x, anchorPoint.y + translatedPanGesturePoint.y);

    // If we are presenting fullscreen, the presenting view controller's view will have been removed from the view
    // hierarchy when the presentation animation finished. We need to put it back in the view hierarchy in order for
    // it to appear behind the interactive dismissal animation.
    UIView *toView = [self.transitionContext viewForKey:UITransitionContextToViewKey];
    if (!toView.superview) {
        UIViewController *toViewController = [self.transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
        toView.frame = [self.transitionContext finalFrameForViewController:toViewController];
        if (![toView isDescendantOfView:self.transitionContext.containerView]) {
            [self.transitionContext.containerView addSubview:toView];
        }
        [self.transitionContext.containerView bringSubviewToFront:fromView];
    }

    // Pan the view on pace with the pan gesture.
    viewToPan.center = newCenterPoint;
    
    CGFloat verticalDelta = newCenterPoint.y - anchorPoint.y;
    
    CGFloat backgroundAlpha = [self backgroundAlphaForPanningWithVerticalDelta:verticalDelta];
    fromView.backgroundColor = [fromView.backgroundColor colorWithAlphaComponent:backgroundAlpha];
    
    if (panGestureRecognizer.state == UIGestureRecognizerStateEnded || panGestureRecognizer.state == UIGestureRecognizerStateCancelled) {
        [self finishPanWithPanGestureRecognizer:panGestureRecognizer verticalDelta:verticalDelta viewToPan:viewToPan anchorPoint:anchorPoint];
    }
}

- (void)finishPanWithPanGestureRecognizer:(UIPanGestureRecognizer *)panGestureRecognizer verticalDelta:(CGFloat)verticalDelta viewToPan:(UIView *)viewToPan anchorPoint:(CGPoint)anchorPoint {
    UIView *fromView = [self.transitionContext viewForKey:UITransitionContextFromViewKey];
    
    // Return to center case.
    CGFloat velocityY = [panGestureRecognizer velocityInView:panGestureRecognizer.view].y;
    
    CGFloat animationDuration = (ABS(velocityY) * NYTPhotoDismissalInteractionControllerReturnToCenterVelocityAnimationRatio) + 0.2;
    CGFloat animationCurve = UIViewAnimationOptionCurveEaseOut;
    CGPoint finalPageViewCenterPoint = anchorPoint;
    CGFloat finalBackgroundAlpha = 1.0;
    
    CGFloat dismissDistance = NYTPhotoDismissalInteractionControllerPanDismissDistanceRatio * CGRectGetHeight(fromView.bounds);
    BOOL isDismissing = ABS(verticalDelta) > dismissDistance;
    
    BOOL didAnimateUsingAnimator = NO;
    
    if (isDismissing) {
        if (self.shouldAnimateUsingAnimator) {
            [self.animator animateTransition:self.transitionContext];
            didAnimateUsingAnimator = YES;
        }
        else {
            BOOL isPositiveDelta = verticalDelta >= 0;
            
            CGFloat modifier = isPositiveDelta ? 1 : -1;
            CGFloat finalCenterY = CGRectGetMidY(fromView.bounds) + modifier * CGRectGetHeight(fromView.bounds);
            finalPageViewCenterPoint = CGPointMake(fromView.center.x, finalCenterY);
            
            // Maintain the velocity of the pan, while easing out.
            animationDuration = ABS(finalPageViewCenterPoint.y - viewToPan.center.y) / ABS(velocityY);
            animationDuration = MIN(animationDuration, NYTPhotoDismissalInteractionControllerPanDismissMaximumDuration);
            
            animationCurve = UIViewAnimationOptionCurveEaseOut;
            finalBackgroundAlpha = 0.0;
        }
    }
    else {
        // Interactive transition was canceled (i.e. the user changed their mind and decided not to finish the
        // dismissal), so if we are presenting fullscreen, remove the presenting view controller's view.
        if (self.transitionContext.presentationStyle == UIModalPresentationFullScreen) {
            UIView *toView = [self.transitionContext viewForKey:UITransitionContextToViewKey];
            [toView removeFromSuperview];
        }
    }
    
    if (!didAnimateUsingAnimator) {
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

            self.viewToHideWhenBeginningTransition.alpha = 1.0;
            
            [self.transitionContext completeTransition:isDismissing && !self.transitionContext.transitionWasCancelled];
            
            self.transitionContext = nil;
        }];
    }
    else {
        self.transitionContext = nil;
    }
}

- (CGFloat)backgroundAlphaForPanningWithVerticalDelta:(CGFloat)verticalDelta {
    CGFloat startingAlpha = 1.0;
    CGFloat finalAlpha = 0.1;
    CGFloat totalAvailableAlpha = startingAlpha - finalAlpha;
    
    CGFloat maximumDelta = CGRectGetHeight([self.transitionContext viewForKey:UITransitionContextFromViewKey].bounds) / 2.0; // Arbitrary value.
    CGFloat deltaAsPercentageOfMaximum = MIN(ABS(verticalDelta) / maximumDelta, 1.0);
    
    return startingAlpha - (deltaAsPercentageOfMaximum * totalAvailableAlpha);
}

#pragma mark - UIViewControllerInteractiveTransitioning

- (void)startInteractiveTransition:(id <UIViewControllerContextTransitioning>)transitionContext {
    self.viewToHideWhenBeginningTransition.alpha = 0.0;
    
    self.transitionContext = transitionContext;
}

@end
