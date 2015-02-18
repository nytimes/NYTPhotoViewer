//
//  NYTPhotoTransitionController.h
//  Pods
//
//  Created by Brian Capps on 2/13/15.
//
//

@import UIKit;

@interface NYTPhotoTransitionController : NSObject <UIViewControllerTransitioningDelegate, UIViewControllerAnimatedTransitioning>

@property (nonatomic) UIView *startingView;
@property (nonatomic) UIView *endingView;

- (void)didPanWithPanGestureRecognizer:(UIPanGestureRecognizer *)panGestureRecognizer viewToPan:(UIView *)viewToPan anchorPoint:(CGPoint)anchorPoint;

@end
