//
//  NYTPhotoTransitionAnimator.h
//  Pods
//
//  Created by Brian Capps on 2/17/15.
//
//

@import UIKit;

/**
 *  An object that controls the animated transition of photo presentation and dismissal.
 */
@interface NYTPhotoTransitionAnimator : NSObject <UIViewControllerAnimatedTransitioning>

/**
 *  The view from which to start an image zooming transition. This view may be hidden or show in the transition, but will never be removed or changed in its view hierarchy.
 */
@property (nonatomic) UIView *startingView;

/**
 *  The view from which to end an image zooming transition. This view may be hidden or show in the transition, but will never be removed or changed in its view hierarchy.
 */

@property (nonatomic) UIView *endingView;

/**
 *  The view that is used for animating the starting view. If no view is set, the starting view is screenshotted and relevant properties copied to the new view.
 */
@property (nonatomic) UIView *startingViewForAnimation;

/**
 *  The view that is used for animating the ending view. If no view is set, the ending view is screenshotted and relevant properties copied to the new view.
 */
@property (nonatomic) UIView *endingViewForAnimation;

/**
 *  Whether this transition is a dismissal. If NO, presentation is assumed.
 */
@property (nonatomic, getter=isDismissing) BOOL dismissing;

/**
 *  Convenience method for creating a view for animation from another arbitrary view. Attempts to create an identical view in the most efficient way possible.
 *
 *  @param view The view to create the animation from.
 *
 *  @return A new view identical in apperance to the passed-in view, with relevant properties transferred. Not a member of any view hierarchy.
 */
+ (UIView *)newAnimationViewFromView:(UIView *)view;

@end
