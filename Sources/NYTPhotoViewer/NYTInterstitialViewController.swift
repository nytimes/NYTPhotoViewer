//
//  NYTInterstitialViewController.swift
//  NYTPhotoViewer
//
//  Created by Howarth, Craig on 4/17/18.
//  Copyright © 2018 NYTimes. All rights reserved.
//

import UIKit

/// The view controller controlling the display of an interstitial view.
@MainActor
final class NYTInterstitialViewController: UIViewController, NYTPhotoViewerContainer {
    
    // MARK: - NYTPhotoViewerContainer
    
    let photo: (any NYTPhoto)? = nil
    let interstitialView: UIView?
    let photoViewItemIndex: Int
    
    private var constraints: [NSLayoutConstraint]?
    
    // MARK: - Initialization
    
    /// The designated initializer that takes an interstitial view.
    ///
    /// - Parameters:
    ///   - view: The view object that this view controller manages.
    ///   - itemIndex: The index of this view controller in the photo viewer collection.
    init(view: UIView?, itemIndex: Int) {
        self.interstitialView = view
        self.photoViewItemIndex = itemIndex
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        self.interstitialView = nil
        self.photoViewItemIndex = 0
        super.init(coder: coder)
    }
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let interstitialView = interstitialView {
            view.addSubview(interstitialView)
        }
        prepareLayout()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        prepareLayout()
    }
    
    override var prefersHomeIndicatorAutoHidden: Bool {
        true
    }
    
    // MARK: - Private Methods
    
    private func prepareLayout() {
        guard let interstitialView = interstitialView else { return }
        
        if interstitialView.translatesAutoresizingMaskIntoConstraints {
            interstitialView.center = CGPoint(x: view.bounds.midX, y: view.bounds.midY)
        } else if constraints == nil {
            let newConstraints = [
                interstitialView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                interstitialView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
            ]
            NSLayoutConstraint.activate(newConstraints)
            self.constraints = newConstraints
        }
    }
}

