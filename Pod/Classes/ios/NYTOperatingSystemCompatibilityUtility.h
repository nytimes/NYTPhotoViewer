//
//  NYTOperatingSystemCompatibilityUtility.h
//  Pods
//
//  Created by Brian Capps on 2/17/15.
//
//

@import UIKit;

@interface NYTOperatingSystemCompatibilityUtility : NSObject

+ (UIView *)fromViewForTransitionContext:(id <UIViewControllerContextTransitioning>)transitionContext;
+ (UIView *)toViewForTransitionContext:(id <UIViewControllerContextTransitioning>)transitionContext;

@end
