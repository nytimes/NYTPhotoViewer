//
//  NYTPhotoTransitionController.swift
//  NYTPhotoViewer
//
//  Created by Brian Capps on 2/13/15.
//  Copyright (c) 2015 NYTimes. All rights reserved.
//

import UIKit

/// An object that manages both animated transitions and interactive transitions, acting as the transitioning delegate and internally coordinating multiple objects that do the animating and interactivity work.
@MainActor
public final class NYTPhotoTransitionController: NSObject, UIViewControllerTransitioningDelegate {
    
    // MARK: - Properties
    
    /// The view from which to start an image zooming transition.
    public var startingView: UIView? {
        get { animator.startingView }
        set { animator.startingView = newValue }
    }
    
    /// The view from which to end an image zooming transition.
    public var endingView: UIView? {
        get { animator.endingView }
        set { animator.endingView = newValue }
    }
    
    /// Forces the dismiss to animate, instead of the default behavior of being interactive.
    public var forcesNonInteractiveDismissal: Bool = true
    
    private let animator: NYTPhotoTransitionAnimator
    private let interactionController: NYTPhotoDismissalInteractionController
    
    // MARK: - Initialization
    
    public override init() {
        self.animator = NYTPhotoTransitionAnimator()
        self.interactionController = NYTPhotoDismissalInteractionController()
        super.init()
    }
    
    // MARK: - Public Methods
    
    /// Call when new events are received from a `UIPanGestureRecognizer`.
    public func didPan(with panGestureRecognizer: UIPanGestureRecognizer, viewToPan: UIView, anchorPoint: CGPoint) {
        interactionController.didPan(with: panGestureRecognizer, viewToPan: viewToPan, anchorPoint: anchorPoint)
    }
    
    // MARK: - UIViewControllerTransitioningDelegate
    
    public func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> (any UIViewControllerAnimatedTransitioning)? {
        animator.isDismissing = false
        return animator
    }
    
    public func animationController(forDismissed dismissed: UIViewController) -> (any UIViewControllerAnimatedTransitioning)? {
        animator.isDismissing = true
        return animator
    }
    
    public func interactionControllerForDismissal(using animator: any UIViewControllerAnimatedTransitioning) -> (any UIViewControllerInteractiveTransitioning)? {
        if forcesNonInteractiveDismissal {
            return nil
        }
        
        // The interaction controller will be hiding the ending view, so we should get and set a visible version now.
        self.animator.endingViewForAnimation = NYTPhotoTransitionAnimator.newAnimationView(from: endingView)
        
        interactionController.animator = animator
        interactionController.shouldAnimateUsingAnimator = (endingView != nil)
        interactionController.viewToHideWhenBeginningTransition = (startingView != nil) ? endingView : nil
        
        return interactionController
    }
}

