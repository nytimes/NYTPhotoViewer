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

+ (UIImage *)imageNamed:(NSString *)imageName {
    NSURL *bundleURL = [[NSBundle mainBundle] URLForResource:@"NYTPhotoViewer" withExtension:@"bundle"];
    NSBundle *bundle = [NSBundle bundleWithURL:bundleURL];
    if ([UIImage respondsToSelector:@selector(imageNamed:inBundle:compatibleWithTraitCollection:)]) {
        return [UIImage imageNamed:imageName inBundle:bundle compatibleWithTraitCollection:nil];
    }
    else {
        NSURL *imageURL = [bundle URLForResource:imageName withExtension:@"png"];
        return [UIImage imageWithContentsOfFile:imageURL.path];
    }
}

+ (BOOL)isiOS8OrGreater {
    static BOOL isiOS8OrGreater;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSString *systemVersionString = [UIDevice currentDevice].systemVersion;
        isiOS8OrGreater = systemVersionString.floatValue >= 8.0;
    });
    
    return isiOS8OrGreater;
}

@end
