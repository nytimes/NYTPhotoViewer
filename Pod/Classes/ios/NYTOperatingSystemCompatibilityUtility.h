//
//  NYTOperatingSystemCompatibilityUtility.h
//  NYTPhotoViewer
//
//  Created by Brian Capps on 2/17/15.
//
//

@import UIKit;

/**
 *  A class encompassing a series of stateless methods that require different calls on different operating systems.
 */
@interface NYTOperatingSystemCompatibilityUtility : NSObject

/**
 *  Gets the "from" view from the transition context, using `viewControllerForKey:` on iOS 7 and `viewForKey:` on iOS 8.
 *
 *  @param transitionContext The transition context from which to get the "from" view.
 *
 *  @return The "from" view of the transition context.
 */
+ (UIView *)fromViewForTransitionContext:(id <UIViewControllerContextTransitioning>)transitionContext;

/**
 *  Gets the "to" view from the transition context, using `viewControllerForKey:` on iOS 7 and `viewForKey:` on iOS 8.
 *
 *  @param transitionContext The transition context from which to get the "to" view.
 *
 *  @return The "to" view of the transition context.
 */
+ (UIView *)toViewForTransitionContext:(id <UIViewControllerContextTransitioning>)transitionContext;

/**
 *  Gets the final frame for the "to" view controller. On operating systems below iOS 8, `finalFrameForViewController:` is incorrect, and the final frame is derived from the container view's bounds.
 *
 *  @param transitionContext The transition context from which to get the final frame.
 *
 *  @return The final frame for the "to" view controller.
 */
+ (CGRect)finalFrameForToViewControllerWithTransitionContext:(id <UIViewControllerContextTransitioning>)transitionContext;

/**
 *  Checks for iOS 8.0+. Returns `YES` if the current device is running at least iOS 8.0
 *
 *  @return `YES` if the device is running at least iOS 8.0
 */
+ (BOOL)isiOS8OrGreater;

@end
