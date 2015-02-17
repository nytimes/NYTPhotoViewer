//
//  NYTPhotoTransitionAnimator.m
//  Pods
//
//  Created by Brian Capps on 2/13/15.
//
//

#import "NYTPhotoTransitionAnimator.h"

const CGFloat NYTPhotoTransitionAnimatorBackgroundFadeDurationRatio = 4.0/9.0;

const CGFloat NYTPhotoTransitionAnimatorPanDismissDistanceRatio = 100.0/667.0; // distance over iPhone 6 height.
const CGFloat NYTPhotoTransitionAnimatorPanDismissMaximumDuration = 0.45;


@interface NYTPhotoTransitionAnimator ()

@property (nonatomic, getter=isDismissing) BOOL dismissing;
@property (nonatomic) id <UIViewControllerContextTransitioning> interactiveTransitionContext;

@end

@implementation NYTPhotoTransitionAnimator

#pragma mark - NYTPhotoTransitionAnimator

- (void)didPanWithPanGestureRecognizer:(UIPanGestureRecognizer *)panGestureRecognizer viewToPan:(UIView *)viewToPan anchorPoint:(CGPoint)anchorPoint {
    UIView *fromView = [self fromViewForTransitionContext:self.interactiveTransitionContext];
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
    UIView *fromView = [self fromViewForTransitionContext:self.interactiveTransitionContext];
    
    // Return to center case.
    CGFloat velocityY = [panGestureRecognizer velocityInView:panGestureRecognizer.view].y;
    
    CGFloat animationDuration = (ABS(velocityY) * 0.00007) + 0.2;
    CGFloat animationCurve = UIViewAnimationOptionCurveEaseOut;
    CGPoint finalPageViewCenterPoint = anchorPoint;
    CGFloat finalBackgroundAlpha = 1.0;
    
    // Dismissal case.
    UIView *referenceView;
    
    CGFloat dismissDistance = NYTPhotoTransitionAnimatorPanDismissDistanceRatio * CGRectGetHeight(fromView.bounds);
    BOOL isDismissing = ABS(verticalDelta) > dismissDistance;
    
    if (isDismissing) {
        referenceView = self.endingView;
        
        if (referenceView) {
            [self animateTransition:self.interactiveTransitionContext];
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
    
    if (!referenceView) {
        [UIView animateWithDuration:animationDuration delay:0 options:animationCurve animations:^{
            viewToPan.center = finalPageViewCenterPoint;

            fromView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:finalBackgroundAlpha];
        } completion:^(BOOL finished) {
            if (isDismissing) {
                [self.interactiveTransitionContext finishInteractiveTransition];
            }
            else {
                [self.interactiveTransitionContext cancelInteractiveTransition];
            }
            
            [self.interactiveTransitionContext completeTransition:isDismissing && !self.interactiveTransitionContext.transitionWasCancelled];
        }];
    }
}

- (CGFloat)backgroundAlphaForPanningWithVerticalDelta:(CGFloat)verticalDelta {
    CGFloat startingAlpha = 1.0;
    CGFloat finalAlpha = 0.1;
    CGFloat totalAvailableAlpha = startingAlpha - finalAlpha;
    
    CGFloat maximumDelta = CGRectGetHeight([self fromViewForTransitionContext:self.interactiveTransitionContext].bounds) / 2.0; // Arbitrary value.
    CGFloat deltaAsPercentageOfMaximum = MIN(ABS(verticalDelta)/maximumDelta, 1.0);
    
    return startingAlpha - (deltaAsPercentageOfMaximum * totalAvailableAlpha);
}


#pragma mark - Fading

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

#pragma mark - UIViewControllerInteractiveTransitioning

- (void)startInteractiveTransition:(id <UIViewControllerContextTransitioning>)transitionContext {
    self.interactiveTransitionContext = transitionContext;
}

#pragma mark - UIViewControllerTransitioningDelegate

- (id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    self.dismissing = NO;
    return self;
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    return self;
}

- (id<UIViewControllerInteractiveTransitioning>)interactionControllerForDismissal:(id<UIViewControllerAnimatedTransitioning>)animator {
    self.dismissing = YES;
    
    return self;
}

@end
