//
//  NYTPhotoTransitionController.m
//  Pods
//
//  Created by Brian Capps on 2/13/15.
//
//

#import "NYTPhotoTransitionController.h"
#import "NYTPhotoTransitionAnimator.h"
#import "NYTPhotoDismissalInteractionController.h"

@interface NYTPhotoTransitionController ()

@property (nonatomic) NYTPhotoTransitionAnimator *animator;
@property (nonatomic) NYTPhotoDismissalInteractionController *interactionController;

@end

@implementation NYTPhotoTransitionController

#pragma mark - NSObject

- (instancetype)init {
    self = [super init];
    
    if (self) {
        _animator = [[NYTPhotoTransitionAnimator alloc] init];
        _interactionController = [[NYTPhotoDismissalInteractionController alloc] init];
    }
    
    return self;
}

#pragma mark - NYTPhotoTransitionAnimator

- (void)didPanWithPanGestureRecognizer:(UIPanGestureRecognizer *)panGestureRecognizer viewToPan:(UIView *)viewToPan anchorPoint:(CGPoint)anchorPoint {
    [self.interactionController didPanWithPanGestureRecognizer:panGestureRecognizer viewToPan:viewToPan anchorPoint:anchorPoint];
}

- (UIView *)startingView {
    return self.animator.startingView;
}

- (void)setStartingView:(UIView *)startingView {
    self.animator.startingView = startingView;
}

- (UIView *)endingView {
    return self.animator.endingView;
}

- (void)setEndingView:(UIView *)endingView {
    self.animator.endingView = endingView;
}

#pragma mark - UIViewControllerTransitioningDelegate

- (id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    self.animator.dismissing = NO;
    
    return self.animator;
}

- (id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    self.animator.dismissing = YES;
    
    return self.animator;
}

- (id <UIViewControllerInteractiveTransitioning>)interactionControllerForDismissal:(id <UIViewControllerAnimatedTransitioning>)animator {
    self.interactionController.animator = animator;
    self.interactionController.canAnimateUsingAnimationController = self.endingView != nil;
    
    return self.interactionController;
}

@end
