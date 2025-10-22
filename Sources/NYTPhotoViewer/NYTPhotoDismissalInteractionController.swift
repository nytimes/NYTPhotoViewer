//
//  NYTPhotoDismissalInteractionController.swift
//  NYTPhotoViewer
//
//  Created by Brian Capps on 2/17/15.
//  Copyright (c) 2015 NYTimes. All rights reserved.
//

import UIKit

private let panDismissDistanceRatio: CGFloat = 50.0 / 667.0 // distance over iPhone 6 height
private let panDismissMaximumDuration: CGFloat = 0.45
private let returnToCenterVelocityAnimationRatio: CGFloat = 0.00007 // Arbitrary value that looked decent

/// An object that controls an interactive photo dismissal transition.
@MainActor
final class NYTPhotoDismissalInteractionController: NSObject, UIViewControllerInteractiveTransitioning {
    
    // MARK: - Properties
    
    /// The animator object associated with the interactive transition.
    var animator: (any UIViewControllerAnimatedTransitioning)?
    
    /// If set, this view will be hidden as soon as the interactive transition starts, and shown after it ends.
    var viewToHideWhenBeginningTransition: UIView?
    
    /// A `Bool` determining whether, after reaching a certain panning threshold that constitutes a dismissal, the animator object should be used to finish the transition.
    var shouldAnimateUsingAnimator: Bool = false
    
    private var transitionContext: (any UIViewControllerContextTransitioning)?
    
    // MARK: - Public Methods
    
    /// Call when new events are received from a `UIPanGestureRecognizer`.
    func didPan(with panGestureRecognizer: UIPanGestureRecognizer, viewToPan: UIView, anchorPoint: CGPoint) {
        guard let transitionContext = transitionContext,
              let fromView = transitionContext.view(forKey: .from) else { return }
        
        let translatedPanGesturePoint = panGestureRecognizer.translation(in: fromView)
        let newCenterPoint = CGPoint(x: anchorPoint.x, y: anchorPoint.y + translatedPanGesturePoint.y)
        
        // If we are presenting fullscreen, the presenting view controller's view will have been removed
        if let toView = transitionContext.view(forKey: .to), toView.superview == nil {
            if let toViewController = transitionContext.viewController(forKey: .to) {
                toView.frame = transitionContext.finalFrame(for: toViewController)
                if !toView.isDescendant(of: transitionContext.containerView) {
                    transitionContext.containerView.addSubview(toView)
                }
                transitionContext.containerView.bringSubviewToFront(fromView)
            }
        }
        
        // Pan the view on pace with the pan gesture.
        viewToPan.center = newCenterPoint
        
        let verticalDelta = newCenterPoint.y - anchorPoint.y
        let backgroundAlpha = backgroundAlpha(forPanningWith: verticalDelta)
        fromView.backgroundColor = fromView.backgroundColor?.withAlphaComponent(backgroundAlpha)
        
        if panGestureRecognizer.state == .ended {
            finishPan(with: panGestureRecognizer, verticalDelta: verticalDelta, viewToPan: viewToPan, anchorPoint: anchorPoint)
        }
    }
    
    // MARK: - Private Methods
    
    private func finishPan(with panGestureRecognizer: UIPanGestureRecognizer, verticalDelta: CGFloat, viewToPan: UIView, anchorPoint: CGPoint) {
        guard let transitionContext = transitionContext,
              let fromView = transitionContext.view(forKey: .from) else { return }
        
        let velocityY = panGestureRecognizer.velocity(in: panGestureRecognizer.view).y
        
        var animationDuration = (abs(velocityY) * returnToCenterVelocityAnimationRatio) + 0.2
        var animationCurve: UIView.AnimationOptions = .curveEaseOut
        var finalPageViewCenterPoint = anchorPoint
        var finalBackgroundAlpha: CGFloat = 1.0
        
        let dismissDistance = panDismissDistanceRatio * fromView.bounds.height
        let isDismissing = abs(verticalDelta) > dismissDistance
        
        var didAnimateUsingAnimator = false
        
        if isDismissing {
            if shouldAnimateUsingAnimator, let animator = animator {
                animator.animateTransition(using: transitionContext)
                didAnimateUsingAnimator = true
            } else {
                let isPositiveDelta = verticalDelta >= 0
                let modifier: CGFloat = isPositiveDelta ? 1 : -1
                let finalCenterY = fromView.bounds.midY + modifier * fromView.bounds.height
                finalPageViewCenterPoint = CGPoint(x: fromView.center.x, y: finalCenterY)
                
                // Maintain the velocity of the pan, while easing out.
                animationDuration = abs(finalPageViewCenterPoint.y - viewToPan.center.y) / abs(velocityY)
                animationDuration = min(animationDuration, panDismissMaximumDuration)
                
                animationCurve = .curveEaseOut
                finalBackgroundAlpha = 0.0
            }
        } else {
            // Interactive transition was canceled
            if transitionContext.presentationStyle == .fullScreen {
                transitionContext.view(forKey: .to)?.removeFromSuperview()
            }
        }
        
        if !didAnimateUsingAnimator {
            UIView.animate(withDuration: TimeInterval(animationDuration), delay: 0, options: animationCurve) {
                viewToPan.center = finalPageViewCenterPoint
                fromView.backgroundColor = fromView.backgroundColor?.withAlphaComponent(finalBackgroundAlpha)
            } completion: { _ in
                if isDismissing {
                    transitionContext.finishInteractiveTransition()
                } else {
                    transitionContext.cancelInteractiveTransition()
                }
                
                self.viewToHideWhenBeginningTransition?.alpha = 1.0
                transitionContext.completeTransition(isDismissing && !transitionContext.transitionWasCancelled)
                self.transitionContext = nil
            }
        } else {
            self.transitionContext = nil
        }
    }
    
    private func backgroundAlpha(forPanningWith verticalDelta: CGFloat) -> CGFloat {
        guard let transitionContext = transitionContext,
              let fromView = transitionContext.view(forKey: .from) else { return 1.0 }
        
        let startingAlpha: CGFloat = 1.0
        let finalAlpha: CGFloat = 0.1
        let totalAvailableAlpha = startingAlpha - finalAlpha
        
        let maximumDelta = fromView.bounds.height / 2.0 // Arbitrary value
        let deltaAsPercentageOfMaximum = min(abs(verticalDelta) / maximumDelta, 1.0)
        
        return startingAlpha - (deltaAsPercentageOfMaximum * totalAvailableAlpha)
    }
    
    // MARK: - UIViewControllerInteractiveTransitioning
    
    func startInteractiveTransition(_ transitionContext: any UIViewControllerContextTransitioning) {
        viewToHideWhenBeginningTransition?.alpha = 0.0
        self.transitionContext = transitionContext
    }
}

