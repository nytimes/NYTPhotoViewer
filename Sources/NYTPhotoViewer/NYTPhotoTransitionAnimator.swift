//
//  NYTPhotoTransitionAnimator.swift
//  NYTPhotoViewer
//
//  Created by Brian Capps on 2/17/15.
//  Copyright (c) 2015 NYTimes. All rights reserved.
//

import UIKit

/// An object that controls the animated transition of photo presentation and dismissal.
@MainActor
public final class NYTPhotoTransitionAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    // MARK: - Properties
    
    /// The view from which to start an image zooming transition.
    public var startingView: UIView?
    
    /// The view from which to end an image zooming transition.
    public var endingView: UIView?
    
    /// The view that is used for animating the starting view.
    public var startingViewForAnimation: UIView?
    
    /// The view that is used for animating the ending view.
    public var endingViewForAnimation: UIView?
    
    /// Whether this transition is a dismissal.
    public var isDismissing: Bool = false
    
    /// The duration of the animation when zooming is performed.
    public var animationDurationWithZooming: CGFloat = 0.5
    
    /// The duration of the animation when only fading and not zooming is performed.
    public var animationDurationWithoutZooming: CGFloat = 0.3
    
    /// The ratio (from 0.0 to 1.0) of the total animation duration that the background fade duration takes.
    public var animationDurationFadeRatio: CGFloat = 4.0 / 9.0 {
        didSet { animationDurationFadeRatio = min(animationDurationFadeRatio, 1.0) }
    }
    
    /// The ratio (from 0.0 to 1.0) of the total animation duration that the ending view fade in duration takes.
    public var animationDurationEndingViewFadeInRatio: CGFloat = 0.1 {
        didSet { animationDurationEndingViewFadeInRatio = min(animationDurationEndingViewFadeInRatio, 1.0) }
    }
    
    /// The ratio (from 0.0 to 1.0) of the total animation duration that the starting view fade out duration takes.
    public var animationDurationStartingViewFadeOutRatio: CGFloat = 0.05 {
        didSet { animationDurationStartingViewFadeOutRatio = min(animationDurationStartingViewFadeOutRatio, 1.0) }
    }
    
    /// The value passed as the spring damping argument for the zooming animation.
    public var zoomingAnimationSpringDamping: CGFloat = 0.9
    
    private weak var toViewController: UIViewController?
    private weak var fromViewController: UIViewController?
    
    private var shouldPerformZoomingAnimation: Bool {
        startingView != nil && endingView != nil
    }
    
    // MARK: - UIViewControllerAnimatedTransitioning
    
    public func transitionDuration(using transitionContext: (any UIViewControllerContextTransitioning)?) -> TimeInterval {
        shouldPerformZoomingAnimation ? TimeInterval(animationDurationWithZooming) : TimeInterval(animationDurationWithoutZooming)
    }
    
    public func animateTransition(using transitionContext: any UIViewControllerContextTransitioning) {
        setupTransitionContainerHierarchy(with: transitionContext)
        performFadeAnimation(with: transitionContext)
        
        if shouldPerformZoomingAnimation {
            performZoomingAnimation(with: transitionContext)
        }
    }
    
    public func animationEnded(_ transitionCompleted: Bool) {
        toViewController?.endAppearanceTransition()
        fromViewController?.endAppearanceTransition()
    }
    
    // MARK: - Private Methods
    
    private func setupTransitionContainerHierarchy(with transitionContext: any UIViewControllerContextTransitioning) {
        guard let fromView = transitionContext.view(forKey: .from),
              let toView = transitionContext.view(forKey: .to) else { return }
        
        toViewController = transitionContext.viewController(forKey: .to)
        fromViewController = transitionContext.viewController(forKey: .from)
        
        if let toVC = toViewController {
            toView.frame = transitionContext.finalFrame(for: toVC)
        }
        
        if toViewController?.parent != nil {
            toViewController?.beginAppearanceTransition(true, animated: true)
        }
        
        if fromViewController?.parent != nil {
            fromViewController?.beginAppearanceTransition(false, animated: true)
        }
        
        if !toView.isDescendant(of: transitionContext.containerView) {
            transitionContext.containerView.addSubview(toView)
        }
        
        if isDismissing {
            transitionContext.containerView.bringSubviewToFront(fromView)
        }
    }
    
    private func performFadeAnimation(with transitionContext: any UIViewControllerContextTransitioning) {
        guard let fromView = transitionContext.view(forKey: .from),
              let toView = transitionContext.view(forKey: .to) else { return }
        
        let viewToFade: UIView
        let beginningAlpha: CGFloat
        let endingAlpha: CGFloat
        
        if isDismissing {
            viewToFade = fromView
            beginningAlpha = 1.0
            endingAlpha = 0.0
        } else {
            viewToFade = toView
            beginningAlpha = 0.0
            endingAlpha = 1.0
        }
        
        viewToFade.alpha = beginningAlpha
        
        UIView.animate(withDuration: fadeDuration(for: transitionContext)) {
            viewToFade.alpha = endingAlpha
        } completion: { _ in
            if !self.shouldPerformZoomingAnimation {
                self.completeTransition(with: transitionContext)
            }
        }
    }
    
    private func fadeDuration(for transitionContext: any UIViewControllerContextTransitioning) -> TimeInterval {
        let duration = transitionDuration(using: transitionContext)
        return shouldPerformZoomingAnimation ? duration * TimeInterval(animationDurationFadeRatio) : duration
    }
    
    private func performZoomingAnimation(with transitionContext: any UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        
        let startingViewForAnim = startingViewForAnimation ?? Self.newAnimationView(from: startingView)
        let endingViewForAnim = endingViewForAnimation ?? Self.newAnimationView(from: endingView)
        
        guard let startingViewForAnim = startingViewForAnim,
              let endingViewForAnim = endingViewForAnim,
              let endingView = endingView else { return }
        
        let finalEndingViewTransform = endingView.transform
        let endingViewInitialTransform = startingViewForAnim.frame.height / endingViewForAnim.frame.height
        let translatedStartingViewCenter = Self.centerPoint(for: startingView, translatedTo: containerView)
        
        startingViewForAnim.center = translatedStartingViewCenter
        
        endingViewForAnim.transform = endingViewForAnim.transform.scaledBy(x: endingViewInitialTransform, y: endingViewInitialTransform)
        endingViewForAnim.center = translatedStartingViewCenter
        endingViewForAnim.alpha = 0.0
        
        containerView.addSubview(startingViewForAnim)
        containerView.addSubview(endingViewForAnim)
        
        // Hide the original ending view and starting view until the completion of the animation.
        endingView.alpha = 0.0
        startingView?.alpha = 0.0
        
        let duration = transitionDuration(using: transitionContext)
        let fadeInDuration = duration * TimeInterval(animationDurationEndingViewFadeInRatio)
        let fadeOutDuration = duration * TimeInterval(animationDurationStartingViewFadeOutRatio)
        
        // Ending view / starting view replacement animation
        UIView.animate(withDuration: fadeInDuration, delay: 0, options: [.allowAnimatedContent, .beginFromCurrentState]) {
            endingViewForAnim.alpha = 1.0
        } completion: { _ in
            UIView.animate(withDuration: fadeOutDuration, delay: 0, options: [.allowAnimatedContent, .beginFromCurrentState]) {
                startingViewForAnim.alpha = 0.0
            } completion: { _ in
                startingViewForAnim.removeFromSuperview()
            }
        }
        
        let startingViewFinalTransform = 1.0 / endingViewInitialTransform
        let translatedEndingViewFinalCenter = Self.centerPoint(for: endingView, translatedTo: containerView)
        
        // Zoom animation
        UIView.animate(withDuration: duration, delay: 0, usingSpringWithDamping: zoomingAnimationSpringDamping, initialSpringVelocity: 0.0, options: [.allowAnimatedContent, .beginFromCurrentState]) {
            endingViewForAnim.transform = finalEndingViewTransform
            endingViewForAnim.center = translatedEndingViewFinalCenter
            startingViewForAnim.transform = startingViewForAnim.transform.scaledBy(x: startingViewFinalTransform, y: startingViewFinalTransform)
            startingViewForAnim.center = translatedEndingViewFinalCenter
        } completion: { _ in
            endingViewForAnim.removeFromSuperview()
            endingView.alpha = 1.0
            self.startingView?.alpha = 1.0
            
            self.completeTransition(with: transitionContext)
        }
    }
    
    private func completeTransition(with transitionContext: any UIViewControllerContextTransitioning) {
        if transitionContext.isInteractive {
            if transitionContext.transitionWasCancelled {
                transitionContext.cancelInteractiveTransition()
            } else {
                transitionContext.finishInteractiveTransition()
            }
        }
        
        transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
    }
    
    // MARK: - Class Methods
    
    public static func centerPoint(for view: UIView?, translatedTo containerView: UIView) -> CGPoint {
        guard let view = view, let superview = view.superview else { return .zero }
        
        var centerPoint = view.center
        
        // Special case for zoomed scroll views.
        if let scrollView = superview as? UIScrollView, scrollView.zoomScale != 1.0 {
            centerPoint.x += (scrollView.bounds.width - scrollView.contentSize.width) / 2.0 + scrollView.contentOffset.x
            centerPoint.y += (scrollView.bounds.height - scrollView.contentSize.height) / 2.0 + scrollView.contentOffset.y
        }
        
        return superview.convert(centerPoint, to: containerView)
    }
    
    /// Convenience method for creating a view for animation from another arbitrary view.
    public static func newAnimationView(from view: UIView?) -> UIView? {
        guard let view = view else { return nil }
        
        let animationView: UIView
        
        if view.layer.contents != nil {
            if let imageView = view as? UIImageView {
                // Handle UIImageView separately to preserve image orientation
                animationView = UIImageView(image: imageView.image)
                animationView.bounds = view.bounds
            } else {
                animationView = UIView(frame: view.frame)
                animationView.layer.contents = view.layer.contents
                animationView.layer.bounds = view.layer.bounds
            }
            
            animationView.layer.cornerRadius = view.layer.cornerRadius
            animationView.layer.masksToBounds = view.layer.masksToBounds
            animationView.contentMode = view.contentMode
            animationView.transform = view.transform
        } else {
            animationView = view.snapshotView(afterScreenUpdates: true) ?? UIView()
        }
        
        return animationView
    }
}

