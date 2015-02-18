//
//  NYTPhotoTransitionAnimator.h
//  Pods
//
//  Created by Brian Capps on 2/17/15.
//
//

@import UIKit;

@interface NYTPhotoTransitionAnimator : NSObject <UIViewControllerAnimatedTransitioning>

@property (nonatomic) UIView *startingView;
@property (nonatomic) UIView *endingView;

@property (nonatomic, getter=isDismissing) BOOL dismissing;

@end
