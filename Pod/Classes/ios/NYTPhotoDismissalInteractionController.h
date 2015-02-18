//
//  NYTPhotoDismissalInteractionController.h
//  Pods
//
//  Created by Brian Capps on 2/17/15.
//
//

@import UIKit;

@interface NYTPhotoDismissalInteractionController : NSObject <UIViewControllerInteractiveTransitioning>

@property (nonatomic) id <UIViewControllerAnimatedTransitioning> animator;
@property (nonatomic) BOOL canAnimateUsingAnimationController;

- (void)didPanWithPanGestureRecognizer:(UIPanGestureRecognizer *)panGestureRecognizer viewToPan:(UIView *)viewToPan anchorPoint:(CGPoint)anchorPoint;

@end
