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

+ (CGRect)finalFrameForToViewControllerWithTransitionContext:(id <UIViewControllerContextTransitioning>)transitionContext {
    if ([self isiOS8OrGreater]) {
        UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
        return [transitionContext finalFrameForViewController:toViewController];
    }
    
    // On iOS 7.x, it is necessary to return the container view bounds as the final frame.
    return transitionContext.containerView.bounds;
}

+ (BOOL)isiOS8OrGreater {
    NSString *systemVersionString = [UIDevice currentDevice].systemVersion;
    return systemVersionString.floatValue >= 8.0;
}

@end
