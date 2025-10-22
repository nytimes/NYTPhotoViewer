//
//  NYTPhotosOverlayView.swift
//  NYTPhotoViewer
//
//  Created by Brian Capps on 2/17/15.
//  Copyright (c) 2015 NYTimes. All rights reserved.
//

import UIKit

/// A view that overlays an `NYTPhotosViewController`, and houses the left and right bar button items, a title, and a caption view.
@MainActor
public class NYTPhotosOverlayView: UIView {
    
    // MARK: - Properties
    
    /// The internal navigation bar used to set the bar button items and title of the overlay.
    public let navigationBar: UINavigationBar
    
    private let navigationItem: UINavigationItem
    
    /// The title of the overlay. Centered between the left and right bar button items.
    public var title: String? {
        get { navigationItem.title }
        set { navigationItem.title = newValue }
    }
    
    /// The attributes of the overlay's title.
    public var titleTextAttributes: [NSAttributedString.Key: Any]? {
        get { navigationBar.titleTextAttributes }
        set { navigationBar.titleTextAttributes = newValue }
    }
    
    /// The bar button item appearing at the top left of the overlay.
    public var leftBarButtonItem: UIBarButtonItem? {
        get { navigationItem.leftBarButtonItem }
        set { navigationItem.setLeftBarButton(newValue, animated: false) }
    }
    
    /// The bar button items appearing at the top left of the overlay.
    public var leftBarButtonItems: [UIBarButtonItem]? {
        get { navigationItem.leftBarButtonItems }
        set { navigationItem.setLeftBarButtonItems(newValue, animated: false) }
    }
    
    /// The bar button item appearing at the top right of the overlay.
    public var rightBarButtonItem: UIBarButtonItem? {
        get { navigationItem.rightBarButtonItem }
        set { navigationItem.setRightBarButton(newValue, animated: false) }
    }
    
    /// The bar button items appearing at the top right of the overlay.
    public var rightBarButtonItems: [UIBarButtonItem]? {
        get { navigationItem.rightBarButtonItems }
        set { navigationItem.setRightBarButtonItems(newValue, animated: false) }
    }
    
    /// A view representing the caption for the photo, which will be set to full width and locked to the bottom. Can be any `UIView` object, but is expected to respond to `intrinsicContentSize` appropriately to calculate height.
    public var captionView: UIView? {
        didSet {
            if captionView === oldValue { return }
            
            oldValue?.removeFromSuperview()
            
            guard let captionView = captionView else { return }
            
            captionView.translatesAutoresizingMaskIntoConstraints = false
            addSubview(captionView)
            
            if captionViewRespectsSafeArea {
                NSLayoutConstraint.activate([
                    captionView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
                    captionView.leftAnchor.constraint(equalTo: safeAreaLayoutGuide.leftAnchor),
                    captionView.rightAnchor.constraint(equalTo: safeAreaLayoutGuide.rightAnchor)
                ])
            } else {
                NSLayoutConstraint.activate([
                    captionView.bottomAnchor.constraint(equalTo: bottomAnchor),
                    captionView.widthAnchor.constraint(equalTo: widthAnchor),
                    captionView.centerXAnchor.constraint(equalTo: centerXAnchor)
                ])
            }
        }
    }
    
    /// Whether the `captionView` should respect the safe area or not
    public var captionViewRespectsSafeArea: Bool = true
    
    // MARK: - Initialization
    
    public override init(frame: CGRect) {
        self.navigationBar = UINavigationBar()
        self.navigationItem = UINavigationItem(title: "")
        
        super.init(frame: frame)
        
        setupNavigationBar()
    }
    
    required init?(coder: NSCoder) {
        self.navigationBar = UINavigationBar()
        self.navigationItem = UINavigationItem(title: "")
        
        super.init(coder: coder)
        
        setupNavigationBar()
    }
    
    // MARK: - Setup
    
    private func setupNavigationBar() {
        navigationBar.translatesAutoresizingMaskIntoConstraints = false
        
        // Make navigation bar background fully transparent.
        navigationBar.backgroundColor = .clear
        navigationBar.barTintColor = nil
        navigationBar.isTranslucent = true
        navigationBar.shadowImage = UIImage()
        navigationBar.setBackgroundImage(UIImage(), for: .default)
        
        navigationBar.items = [navigationItem]
        
        addSubview(navigationBar)
        
        NSLayoutConstraint.activate([
            navigationBar.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            navigationBar.leftAnchor.constraint(equalTo: safeAreaLayoutGuide.leftAnchor),
            navigationBar.rightAnchor.constraint(equalTo: safeAreaLayoutGuide.rightAnchor)
        ])
    }
    
    // MARK: - UIView Overrides
    
    // Pass the touches down to other views
    public override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let hitView = super.hitTest(point, with: event)
        
        if hitView == self {
            return nil
        }
        
        return hitView
    }
    
    public override func layoutSubviews() {
        // The navigation bar has a different intrinsic content size upon rotation, so we must update to that new size.
        // Do it without animation to more closely match the behavior in `UINavigationController`
        UIView.performWithoutAnimation {
            navigationBar.invalidateIntrinsicContentSize()
            navigationBar.layoutIfNeeded()
        }
        
        super.layoutSubviews()
        
        if let captionView = captionView as? NYTPhotoCaptionViewLayoutWidthHinting {
            captionView.preferredMaxLayoutWidth = bounds.width
        }
    }
}

