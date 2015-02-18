//
//  NYTOperatingSystemCompatibilityUtility.m
//  Pods
//
//  Created by Brian Capps on 2/17/15.
//
//

#import "NYTOperatingSystemCompatibilityUtility.h"

@implementation NYTOperatingSystemCompatibilityUtility

+ (UIView *)fromViewForTransitionContext:(id <UIViewControllerContextTransitioning>)transitionContext {
    UIView *fromView;
    
    if ([transitionContext respondsToSelector:@selector(viewForKey:)]) {
        fromView = [transitionContext viewForKey:UITransitionContextFromViewKey];
    }
    else {
        fromView = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey].view;
    }
    
    return fromView;
}

+ (UIView *)toViewForTransitionContext:(id <UIViewControllerContextTransitioning>)transitionContext {
    UIView *toView;
    
    if ([transitionContext respondsToSelector:@selector(viewForKey:)]) {
        toView = [transitionContext viewForKey:UITransitionContextToViewKey];
    }
    else {
        toView = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey].view;
    }
    
    return toView;
}

@end
