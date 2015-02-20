//
//  NYTOperatingSystemCompatibilityUtility.h
//  Pods
//
//  Created by Brian Capps on 2/17/15.
//
//

@import UIKit;

/**
 *  A class encompassing a series of stateless methods that require different calls on different oeprating systems.
 */
@interface NYTOperatingSystemCompatibilityUtility : NSObject

/**
 *  Gets the fromView from the transition context, using `viewControllerForKey:` on iOS 7 and `viewForKey:` on iOS 8.
 *
 *  @param transitionContext The transitionContext form which to get the fromView.
 *
 *  @return The fromView of the transition context.
 */
+ (UIView *)fromViewForTransitionContext:(id <UIViewControllerContextTransitioning>)transitionContext;

/**
 *  Gets the toView from the transition context, using `viewControllerForKey:` on iOS 7 and `viewForKey:` on iOS 8.
 *
 *  @param transitionContext The transitionContext form which to get the toView.
 *
 *  @return The toView of the transition context.
 */
+ (UIView *)toViewForTransitionContext:(id <UIViewControllerContextTransitioning>)transitionContext;

@end
