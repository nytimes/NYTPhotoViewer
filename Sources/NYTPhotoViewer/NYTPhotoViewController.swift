//
//  NYTPhotoViewController.swift
//  NYTPhotoViewer
//
//  Created by Brian Capps on 2/11/15.
//  Copyright (c) 2015 NYTimes. All rights reserved.
//

import UIKit

/// Notification name issued when a photo's image has been updated.
public let NYTPhotoViewControllerPhotoImageUpdatedNotification = Notification.Name("NYTPhotoViewControllerPhotoImageUpdatedNotification")

/// Delegate protocol for NYTPhotoViewController
@MainActor
public protocol NYTPhotoViewControllerDelegate: AnyObject {
    /// Called when a long press is recognized.
    ///
    /// - Parameters:
    ///   - photoViewController: The `NYTPhotoViewController` instance that sent the delegate message.
    ///   - longPressGestureRecognizer: The long press gesture recognizer that recognized the long press.
    func photoViewController(_ photoViewController: NYTPhotoViewController, didLongPressWithGestureRecognizer longPressGestureRecognizer: UILongPressGestureRecognizer)
}

/// The view controller controlling the display of a single photo object.
@MainActor
public final class NYTPhotoViewController: UIViewController, NYTPhotoViewerContainer, UIScrollViewDelegate {
    
    // MARK: - NYTPhotoViewerContainer
    
    public let photo: (any NYTPhoto)?
    public let interstitialView: UIView? = nil
    public let photoViewItemIndex: Int
    
    // MARK: - Properties
    
    /// The internal scaling image view used to display the photo.
    public let scalingImageView: NYTScalingImageView
    
    /// The internal activity view shown while the image is loading. Set from the initializer.
    public private(set) var loadingView: UIView?
    
    /// The gesture recognizer used to detect the double tap gesture used for zooming on photos.
    public let doubleTapGestureRecognizer: UITapGestureRecognizer
    
    private let longPressGestureRecognizer: UILongPressGestureRecognizer
    private let notificationCenter: NotificationCenter?
    
    /// The object that acts as the photo view controller's delegate.
    public weak var delegate: NYTPhotoViewControllerDelegate?
    
    // MARK: - Initialization
    
    /// The designated initializer that takes the photo and activity view.
    ///
    /// - Parameters:
    ///   - photo: The photo object that this view controller manages.
    ///   - itemIndex: The index of this view controller in the photo viewer collection.
    ///   - loadingView: The view to display while the photo's image loads. This view will be hidden when the image loads.
    ///   - notificationCenter: The notification center on which to observe the photo image updated notification.
    public init(photo: (any NYTPhoto)?, itemIndex: Int, loadingView: UIView?, notificationCenter: NotificationCenter?) {
        self.photo = photo
        self.photoViewItemIndex = itemIndex
        self.notificationCenter = notificationCenter
        
        // Setup scaling image view
        if let imageData = photo?.imageData {
            self.scalingImageView = NYTScalingImageView(imageData: imageData, frame: .zero)
        } else {
            let photoImage = photo?.image ?? photo?.placeholderImage
            self.scalingImageView = NYTScalingImageView(image: photoImage, frame: .zero)
            
            if photoImage == nil {
                self.loadingView = loadingView ?? {
                    let activityIndicator = UIActivityIndicatorView(style: .large)
                    activityIndicator.startAnimating()
                    return activityIndicator
                }()
            }
        }
        
        // Setup gesture recognizers
        self.doubleTapGestureRecognizer = UITapGestureRecognizer()
        self.doubleTapGestureRecognizer.numberOfTapsRequired = 2
        
        self.longPressGestureRecognizer = UILongPressGestureRecognizer()
        
        super.init(nibName: nil, bundle: nil)
        
        self.scalingImageView.delegate = self
        
        self.doubleTapGestureRecognizer.addTarget(self, action: #selector(didDoubleTap(_:)))
        self.longPressGestureRecognizer.addTarget(self, action: #selector(didLongPress(_:)))
        
        // Observe photo updates
        notificationCenter?.addObserver(
            self,
            selector: #selector(photoImageUpdated(_:)),
            name: NYTPhotoViewControllerPhotoImageUpdatedNotification,
            object: nil
        )
    }
    
    required init?(coder: NSCoder) {
        self.photo = nil
        self.photoViewItemIndex = 0
        self.notificationCenter = nil
        self.scalingImageView = NYTScalingImageView(image: nil, frame: .zero)
        self.doubleTapGestureRecognizer = UITapGestureRecognizer()
        self.doubleTapGestureRecognizer.numberOfTapsRequired = 2
        self.longPressGestureRecognizer = UILongPressGestureRecognizer()
        
        super.init(coder: coder)
        
        self.scalingImageView.delegate = self
        self.doubleTapGestureRecognizer.addTarget(self, action: #selector(didDoubleTap(_:)))
        self.longPressGestureRecognizer.addTarget(self, action: #selector(didLongPress(_:)))
    }
    
    deinit {
        scalingImageView.delegate = nil
        notificationCenter?.removeObserver(self)
    }
    
    // MARK: - View Lifecycle
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        scalingImageView.frame = view.bounds
        view.addSubview(scalingImageView)
        
        if let loadingView = loadingView {
            view.addSubview(loadingView)
            loadingView.sizeToFit()
        }
        
        view.addGestureRecognizer(doubleTapGestureRecognizer)
        view.addGestureRecognizer(longPressGestureRecognizer)
    }
    
    public override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        scalingImageView.frame = view.bounds
        
        if let loadingView = loadingView {
            loadingView.sizeToFit()
            loadingView.center = CGPoint(x: view.bounds.midX, y: view.bounds.midY)
        }
    }
    
    public override var prefersHomeIndicatorAutoHidden: Bool {
        true
    }
    
    // MARK: - Notification Handlers
    
    @objc private func photoImageUpdated(_ notification: Notification) {
        guard let photo = notification.object as? (any NYTPhoto),
              let myPhoto = self.photo else { return }
        
        // Check if photos are equal (requires Equatable conformance or object identity)
        let photosEqual: Bool
        if let equatablePhoto = photo as? any Equatable,
           let equatableMyPhoto = myPhoto as? any Equatable,
           type(of: equatablePhoto) == type(of: equatableMyPhoto) {
            photosEqual = isEqual(equatablePhoto, equatableMyPhoto)
        } else {
            photosEqual = false
        }
        
        if photosEqual {
            updateImage(photo.image, imageData: photo.imageData)
        }
    }
    
    private func isEqual(_ lhs: any Equatable, _ rhs: any Equatable) -> Bool {
        func compareIfSameType<T: Equatable>(_ lhs: T, _ rhs: any Equatable) -> Bool {
            guard let rhsTyped = rhs as? T else { return false }
            return lhs == rhsTyped
        }
        return compareIfSameType(lhs, rhs)
    }
    
    private func updateImage(_ image: UIImage?, imageData: Data?) {
        if let imageData = imageData {
            scalingImageView.updateImageData(imageData)
        } else if let image = image {
            scalingImageView.updateImage(image)
        }
        
        if imageData != nil || image != nil {
            loadingView?.removeFromSuperview()
        } else if let loadingView = loadingView, loadingView.superview == nil {
            view.addSubview(loadingView)
        }
    }
    
    // MARK: - Gesture Recognizers
    
    @objc private func didDoubleTap(_ recognizer: UITapGestureRecognizer) {
        let pointInView = recognizer.location(in: scalingImageView.imageView)
        
        var newZoomScale = scalingImageView.maximumZoomScale
        
        if scalingImageView.zoomScale >= scalingImageView.maximumZoomScale ||
            abs(scalingImageView.zoomScale - scalingImageView.maximumZoomScale) <= 0.01 {
            newZoomScale = scalingImageView.minimumZoomScale
        }
        
        let scrollViewSize = scalingImageView.bounds.size
        
        let width = scrollViewSize.width / newZoomScale
        let height = scrollViewSize.height / newZoomScale
        let originX = pointInView.x - (width / 2.0)
        let originY = pointInView.y - (height / 2.0)
        
        let rectToZoomTo = CGRect(x: originX, y: originY, width: width, height: height)
        
        scalingImageView.zoom(to: rectToZoomTo, animated: true)
    }
    
    @objc private func didLongPress(_ recognizer: UILongPressGestureRecognizer) {
        if recognizer.state == .began {
            delegate?.photoViewController(self, didLongPressWithGestureRecognizer: recognizer)
        }
    }
    
    // MARK: - UIScrollViewDelegate
    
    public func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        scalingImageView.imageView
    }
    
    public func scrollViewWillBeginZooming(_ scrollView: UIScrollView, with view: UIView?) {
        scrollView.panGestureRecognizer.isEnabled = true
    }
    
    public func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
        // There is a bug, especially prevalent on iPhone 6 Plus, that causes zooming to render all other gesture recognizers ineffective.
        // This bug is fixed by disabling the pan gesture recognizer of the scroll view when it is not needed.
        if scrollView.zoomScale == scrollView.minimumZoomScale {
            scrollView.panGestureRecognizer.isEnabled = false
        }
    }
}

