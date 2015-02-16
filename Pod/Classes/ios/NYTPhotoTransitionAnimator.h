//
//  NYTPhotoTransitionAnimator.h
//  Pods
//
//  Created by Brian Capps on 2/13/15.
//
//

@import UIKit;

@interface NYTPhotoTransitionAnimator : NSObject <UIViewControllerTransitioningDelegate, UIViewControllerAnimatedTransitioning>

@property (nonatomic) UIView *startingView;
@property (nonatomic) UIView *endingView;

@end
