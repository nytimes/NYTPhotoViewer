//
//  NYTPhotosViewController.swift
//  NYTPhotoViewer
//
//  Created by Brian Capps on 2/10/15.
//  Copyright (c) 2015 NYTimes. All rights reserved.
//

import UIKit
import LinkPresentation

// MARK: - Notifications

/// Notification name issued when this `NYTPhotosViewController` navigates to a different photo.
public let NYTPhotosViewControllerDidNavigateToPhotoNotification = Notification.Name("NYTPhotosViewControllerDidNavigateToPhotoNotification")

/// Notification name issued when this `NYTPhotosViewController` navigates to an interstitial view.
public let NYTPhotosViewControllerDidNavigateToInterstitialViewNotification = Notification.Name("NYTPhotosViewControllerDidNavigateToInterstitialViewNotification")

/// Notification name issued when this `NYTPhotosViewController` is about to be dismissed.
public let NYTPhotosViewControllerWillDismissNotification = Notification.Name("NYTPhotosViewControllerWillDismissNotification")

/// Notification name issued when this `NYTPhotosViewController` has been dismissed.
public let NYTPhotosViewControllerDidDismissNotification = Notification.Name("NYTPhotosViewControllerDidDismissNotification")

// MARK: - Constants

private let overlayAnimationDuration: CGFloat = 0.2
private let interPhotoSpacing: CGFloat = 16.0
private let closeButtonImageInsets = UIEdgeInsets(top: 3, left: 0, bottom: -3, right: 0)

// MARK: - Delegate Protocol

/// A protocol of entirely optional methods called for view-related configuration and lifecycle events by an `NYTPhotosViewController` instance.
@MainActor
public protocol NYTPhotosViewControllerDelegate: AnyObject {
    /// Called when a new photo is displayed through a swipe gesture.
    func photosViewController(_ photosViewController: NYTPhotosViewController, didNavigateTo photo: any NYTPhoto, at photoIndex: Int)
    
    /// Called when a new interstitial view is displayed through a swipe gesture.
    func photosViewController(_ photosViewController: NYTPhotosViewController, didNavigateToInterstitialView view: UIView, at index: Int)
    
    /// Called immediately before the `NYTPhotosViewController` is about to start a user-initiated dismissal.
    func photosViewControllerWillDismiss(_ photosViewController: NYTPhotosViewController)
    
    /// Called immediately after the photos view controller has been dismissed by the user.
    func photosViewControllerDidDismiss(_ photosViewController: NYTPhotosViewController)
    
    /// Returns a view to display over a photo, full width, locked to the bottom, representing the caption for the photo.
    func photosViewController(_ photosViewController: NYTPhotosViewController, captionViewFor photo: any NYTPhoto) -> UIView?
    
    /// Returns whether the caption view should respect the safe area.
    func photosViewController(_ photosViewController: NYTPhotosViewController, captionViewRespectsSafeAreaFor photo: any NYTPhoto) -> Bool
    
    /// Returns a string to display as the title in the navigation-bar area for a photo.
    func photosViewController(_ photosViewController: NYTPhotosViewController, titleFor photo: any NYTPhoto, at photoIndex: Int, totalPhotoCount: Int?) -> String?
    
    /// Returns a view to display while a photo is loading.
    func photosViewController(_ photosViewController: NYTPhotosViewController, loadingViewFor photo: any NYTPhoto) -> UIView?
    
    /// Returns the view from which to animate for a given object conforming to the `NYTPhoto` protocol.
    func photosViewController(_ photosViewController: NYTPhotosViewController, referenceViewFor photo: any NYTPhoto) -> UIView?
    
    /// Returns the maximum zoom scale for a given photo.
    func photosViewController(_ photosViewController: NYTPhotosViewController, maximumZoomScaleFor photo: any NYTPhoto) -> CGFloat
    
    /// Called when a photo is long pressed.
    func photosViewController(_ photosViewController: NYTPhotosViewController, handleLongPressFor photo: any NYTPhoto, with gestureRecognizer: UILongPressGestureRecognizer) -> Bool
    
    /// Called when the action button is tapped.
    func photosViewController(_ photosViewController: NYTPhotosViewController, handleActionButtonTappedFor photo: any NYTPhoto) -> Bool
    
    /// Called after the default `UIActivityViewController` is presented and successfully completes an action.
    func photosViewController(_ photosViewController: NYTPhotosViewController, actionCompletedWithActivityType activityType: String?)
    
    /// Called when an `NYTInterstitialViewController` is created but before it is displayed.
    func photosViewController(_ photosViewController: NYTPhotosViewController, interstitialViewAt index: Int) -> UIView?
}

// Default implementations for optional methods
public extension NYTPhotosViewControllerDelegate {
    func photosViewController(_ photosViewController: NYTPhotosViewController, didNavigateTo photo: any NYTPhoto, at photoIndex: Int) {}
    func photosViewController(_ photosViewController: NYTPhotosViewController, didNavigateToInterstitialView view: UIView, at index: Int) {}
    func photosViewControllerWillDismiss(_ photosViewController: NYTPhotosViewController) {}
    func photosViewControllerDidDismiss(_ photosViewController: NYTPhotosViewController) {}
    func photosViewController(_ photosViewController: NYTPhotosViewController, captionViewFor photo: any NYTPhoto) -> UIView? { nil }
    func photosViewController(_ photosViewController: NYTPhotosViewController, captionViewRespectsSafeAreaFor photo: any NYTPhoto) -> Bool { true }
    func photosViewController(_ photosViewController: NYTPhotosViewController, titleFor photo: any NYTPhoto, at photoIndex: Int, totalPhotoCount: Int?) -> String? { nil }
    func photosViewController(_ photosViewController: NYTPhotosViewController, loadingViewFor photo: any NYTPhoto) -> UIView? { nil }
    func photosViewController(_ photosViewController: NYTPhotosViewController, referenceViewFor photo: any NYTPhoto) -> UIView? { nil }
    func photosViewController(_ photosViewController: NYTPhotosViewController, maximumZoomScaleFor photo: any NYTPhoto) -> CGFloat { 0 }
    func photosViewController(_ photosViewController: NYTPhotosViewController, handleLongPressFor photo: any NYTPhoto, with gestureRecognizer: UILongPressGestureRecognizer) -> Bool { false }
    func photosViewController(_ photosViewController: NYTPhotosViewController, handleActionButtonTappedFor photo: any NYTPhoto) -> Bool { false }
    func photosViewController(_ photosViewController: NYTPhotosViewController, actionCompletedWithActivityType activityType: String?) {}
    func photosViewController(_ photosViewController: NYTPhotosViewController, interstitialViewAt index: Int) -> UIView? { nil }
}

// MARK: - Main Class

@MainActor
public class NYTPhotosViewController: UIViewController {
    
    // MARK: - Properties
    
    /// The pan gesture recognizer used for panning to dismiss the photo.
    public private(set) var panGestureRecognizer: UIPanGestureRecognizer!
    
    /// The tap gesture recognizer used to hide the overlay.
    public private(set) var singleTapGestureRecognizer: UITapGestureRecognizer!
    
    /// The internal page view controller used for swiping horizontally, photo to photo.
    public private(set) var pageViewController: UIPageViewController?
    
    /// The data source underlying this PhotosViewController.
    public weak var dataSource: (any NYTPhotoViewerDataSource)?
    
    /// The object conforming to `NYTPhoto` that is currently being displayed.
    public var currentlyDisplayedPhoto: (any NYTPhoto)? {
        currentPhotoViewController?.photo
    }
    
    /// The overlay view displayed over photos.
    public private(set) var overlayView: NYTPhotosOverlayView!
    
    /// The left bar button item overlaying the photo.
    public var leftBarButtonItem: UIBarButtonItem? {
        get { overlayView.leftBarButtonItem }
        set { overlayView.leftBarButtonItem = newValue }
    }
    
    /// The left bar button items overlaying the photo.
    public var leftBarButtonItems: [UIBarButtonItem]? {
        get { overlayView.leftBarButtonItems }
        set { overlayView.leftBarButtonItems = newValue }
    }
    
    /// The right bar button item overlaying the photo.
    public var rightBarButtonItem: UIBarButtonItem? {
        get { overlayView.rightBarButtonItem }
        set { overlayView.rightBarButtonItem = newValue }
    }
    
    /// The right bar button items overlaying the photo.
    public var rightBarButtonItems: [UIBarButtonItem]? {
        get { overlayView.rightBarButtonItems }
        set { overlayView.rightBarButtonItems = newValue }
    }
    
    /// The object that acts as the delegate.
    public weak var delegate: (any NYTPhotosViewControllerDelegate)?
    
    private let transitionController: NYTPhotoTransitionController
    private let notificationCenter: NotificationCenter
    private var shouldHandleLongPress = false
    private var overlayWasHiddenBeforeTransition = false
    private let initialPhoto: (any NYTPhoto)?
    
    private var currentPhotoViewController: NYTPhotoViewController? {
        pageViewController?.viewControllers?.first as? NYTPhotoViewController
    }
    
    private var referenceViewForCurrentPhoto: UIView? {
        guard let photo = currentlyDisplayedPhoto else { return nil }
        return delegate?.photosViewController(self, referenceViewFor: photo)
    }
    
    private var boundsCenterPoint: CGPoint {
        CGPoint(x: view.bounds.midX, y: view.bounds.midY)
    }
    
    // MARK: - Initialization
    
    /// Initializes a `PhotosViewController` with the given data source, initially displaying the first photo in the data source.
    public init(dataSource: any NYTPhotoViewerDataSource) {
        self.dataSource = dataSource
        self.initialPhoto = dataSource.photo(at: 0)
        self.delegate = nil
        self.transitionController = NYTPhotoTransitionController()
        self.notificationCenter = NotificationCenter()
        
        super.init(nibName: nil, bundle: nil)
        
        commonInit()
    }
    
    /// Initializes a `PhotosViewController` with the given data source and delegate.
    public init(dataSource: any NYTPhotoViewerDataSource, initialPhotoIndex: Int, delegate: (any NYTPhotosViewControllerDelegate)?) {
        self.dataSource = dataSource
        self.initialPhoto = dataSource.photo(at: initialPhotoIndex)
        self.delegate = delegate
        self.transitionController = NYTPhotoTransitionController()
        self.notificationCenter = NotificationCenter()
        
        super.init(nibName: nil, bundle: nil)
        
        commonInit()
    }
    
    /// Initializes a `PhotosViewController` with the given data source and delegate.
    public init(dataSource: any NYTPhotoViewerDataSource, initialPhoto: (any NYTPhoto)?, delegate: (any NYTPhotosViewControllerDelegate)?) {
        self.dataSource = dataSource
        self.initialPhoto = initialPhoto
        self.delegate = delegate
        self.transitionController = NYTPhotoTransitionController()
        self.notificationCenter = NotificationCenter()
        
        super.init(nibName: nil, bundle: nil)
        
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        self.dataSource = nil
        self.initialPhoto = nil
        self.delegate = nil
        self.transitionController = NYTPhotoTransitionController()
        self.notificationCenter = NotificationCenter()
        
        super.init(coder: coder)
        
        commonInit()
    }
    
    private func commonInit() {
        panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(didPan(_:)))
        singleTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didSingleTap(_:)))
        
        modalPresentationStyle = .fullScreen
        transitioningDelegate = transitionController
        modalPresentationCapturesStatusBarAppearance = true
        
        // Setup overlay view
        overlayView = NYTPhotosOverlayView(frame: .zero)
        
        let closeImage = UIImage(named: "NYTPhotoViewerCloseButtonX", in: .nytPhotoViewerResourceBundle, compatibleWith: nil)
        let closeLandscapeImage = UIImage(named: "NYTPhotoViewerCloseButtonXLandscape", in: .nytPhotoViewerResourceBundle, compatibleWith: nil)
        
        let leftItem = UIBarButtonItem(image: closeImage, landscapeImagePhone: closeLandscapeImage, style: .plain, target: self, action: #selector(doneButtonTapped(_:)))
        leftItem.imageInsets = closeButtonImageInsets
        leftItem.tintColor = .white
        overlayView.leftBarButtonItem = leftItem
        
        let rightItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(actionButtonTapped(_:)))
        rightItem.tintColor = .white
        overlayView.rightBarButtonItem = rightItem
        
        // Setup page view controller
        pageViewController = UIPageViewController(
            transitionStyle: .scroll,
            navigationOrientation: .horizontal,
            options: [UIPageViewController.OptionsKey.interPageSpacing: interPhotoSpacing]
        )
        pageViewController?.delegate = self
        pageViewController?.dataSource = self
    }
    
    deinit {
        pageViewController?.dataSource = nil
        pageViewController?.delegate = nil
    }
    
    // MARK: - View Lifecycle
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        configurePageViewController(withInitialPhoto: initialPhoto)
        
        view.tintColor = .white
        view.backgroundColor = .black
        pageViewController?.view.backgroundColor = .clear
        
        if let pageViewController = pageViewController {
            pageViewController.view.addGestureRecognizer(panGestureRecognizer)
            pageViewController.view.addGestureRecognizer(singleTapGestureRecognizer)
            
            addChild(pageViewController)
            view.addSubview(pageViewController.view)
            pageViewController.didMove(toParent: self)
        }
        
        addOverlayView()
        
        transitionController.startingView = referenceViewForCurrentPhoto
        
        if let photo = currentlyDisplayedPhoto, (photo.image != nil || photo.placeholderImage != nil) {
            transitionController.endingView = currentPhotoViewController?.scalingImageView.imageView
        }
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if !overlayWasHiddenBeforeTransition {
            setOverlayViewHidden(false, animated: true)
        }
    }
    
    public override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        pageViewController?.view.frame = view.bounds
        overlayView.frame = view.bounds
    }
    
    public override var prefersStatusBarHidden: Bool {
        true
    }
    
    public override var prefersHomeIndicatorAutoHidden: Bool {
        true
    }
    
    public override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        .fade
    }
    
    // MARK: - Public Methods
    
    /// Displays the specified photo.
    public func display(photo: (any NYTPhoto)?, animated: Bool) {
        guard let photo = photo,
              let dataSource = dataSource,
              let index = dataSource.index(of: photo) else { return }
        
        let photoViewController = newPhotoViewController(for: photo, at: index)
        setCurrentlyDisplayedViewController(photoViewController, animated: animated)
        updateOverlayInformation()
    }
    
    /// Informs the photo viewer that the photo in the data source at this index has changed.
    public func updatePhoto(at photoIndex: Int) {
        guard let photo = dataSource?.photo(at: photoIndex) else { return }
        updatePhoto(photo)
    }
    
    /// Informs the photo viewer that the given photo in the data source has changed.
    public func updatePhoto(_ photo: any NYTPhoto) {
        guard let dataSource = dataSource,
              dataSource.index(of: photo) != nil else { return }
        
        notificationCenter.post(name: NYTPhotoViewControllerPhotoImageUpdatedNotification, object: photo)
        
        if photosAreEqual(currentlyDisplayedPhoto, photo) {
            updateOverlayInformation()
        }
    }
    
    /// Tells the photo viewer to reload all data from its data source.
    public func reloadPhotos(animated: Bool) {
        var newCurrentPhoto: (any NYTPhoto)?
        
        if let currentPhoto = currentlyDisplayedPhoto,
           let dataSource = dataSource,
           dataSource.index(of: currentPhoto) != nil {
            newCurrentPhoto = currentPhoto
        } else {
            newCurrentPhoto = dataSource?.photo(at: 0)
        }
        
        display(photo: newCurrentPhoto, animated: animated)
        
        if overlayView.isHidden {
            setOverlayViewHidden(false, animated: animated)
        }
    }
    
    // MARK: - Private Methods - Configuration
    
    private func configurePageViewController(withInitialPhoto photo: (any NYTPhoto)?) {
        guard let dataSource = dataSource else { return }
        
        let initialPhotoViewController: NYTPhotoViewController
        
        if let photo = photo, let index = dataSource.index(of: photo) {
            initialPhotoViewController = newPhotoViewController(for: photo, at: index)
        } else {
            if let firstPhoto = dataSource.photo(at: 0) {
                initialPhotoViewController = newPhotoViewController(for: firstPhoto, at: 0)
            } else {
                return
            }
        }
        
        setCurrentlyDisplayedViewController(initialPhotoViewController, animated: false)
    }
    
    private func addOverlayView() {
        let textColor = view.tintColor ?? .white
        overlayView.titleTextAttributes = [.foregroundColor: textColor]
        
        updateOverlayInformation()
        view.addSubview(overlayView)
        
        setOverlayViewHidden(true, animated: false)
    }
    
    private func updateOverlayInformation() {
        guard let photoViewController = currentPhotoViewController,
              let photo = currentlyDisplayedPhoto else { return }
        
        let photoIndex = photoViewController.photoViewItemIndex
        let displayIndex = photoIndex + 1
        
        var overlayTitle: String?
        
        if let customTitle = delegate?.photosViewController(self, titleFor: photo, at: photoIndex, totalPhotoCount: dataSource?.numberOfPhotos) {
            overlayTitle = customTitle
        } else if dataSource?.numberOfPhotos == nil {
            overlayTitle = "\(displayIndex)"
        } else if let totalItems = totalItemCount(), totalItems > 1 {
            overlayTitle = "\(displayIndex) of \(totalItems)"
        }
        
        overlayView.title = overlayTitle
        
        var captionView = delegate?.photosViewController(self, captionViewFor: photo)
        
        if captionView == nil {
            captionView = NYTPhotoCaptionView(
                attributedTitle: photo.attributedCaptionTitle,
                attributedSummary: photo.attributedCaptionSummary,
                attributedCredit: photo.attributedCaptionCredit
            )
        }
        
        let captionViewRespectsSafeArea = delegate?.photosViewController(self, captionViewRespectsSafeAreaFor: photo) ?? true
        
        overlayView.captionViewRespectsSafeArea = captionViewRespectsSafeArea
        overlayView.captionView = captionView
    }
    
    private func totalItemCount() -> Int? {
        guard let dataSource = dataSource else { return nil }
        let numberOfPhotos = dataSource.numberOfPhotos ?? 0
        let numberOfInterstitialViews = dataSource.numberOfInterstitialViews ?? 0
        return numberOfPhotos + numberOfInterstitialViews
    }
    
    // MARK: - Actions
    
    @objc private func doneButtonTapped(_ sender: Any) {
        dismiss(animated: true, userInitiated: true, completion: nil)
    }
    
    @objc private func actionButtonTapped(_ sender: UIBarButtonItem) {
        guard let photo = currentlyDisplayedPhoto else { return }
        
        let clientDidHandle = delegate?.photosViewController(self, handleActionButtonTappedFor: photo) ?? false
        
        if !clientDidHandle, let image = photo.image ?? photo.imageData.flatMap({ UIImage(data: $0) }) {
            let activityViewController = UIActivityViewController(activityItems: [self, image], applicationActivities: nil)
            activityViewController.popoverPresentationController?.barButtonItem = sender
            activityViewController.completionWithItemsHandler = { [weak self] activityType, completed, _, _ in
                guard let self = self, completed else { return }
                self.delegate?.photosViewController(self, actionCompletedWithActivityType: activityType)
            }
            
            displayActivityViewController(activityViewController, animated: true)
        }
    }
    
    private func displayActivityViewController(_ controller: UIActivityViewController, animated: Bool) {
        if UIDevice.current.userInterfaceIdiom == .phone {
            present(controller, animated: animated)
        } else {
            controller.popoverPresentationController?.barButtonItem = rightBarButtonItem
            present(controller, animated: animated)
        }
    }
    
    // MARK: - Gesture Recognizers
    
    @objc private func didSingleTap(_ recognizer: UITapGestureRecognizer) {
        setOverlayViewHidden(!overlayView.isHidden, animated: true)
    }
    
    @objc private func didPan(_ recognizer: UIPanGestureRecognizer) {
        if recognizer.state == .began {
            transitionController.forcesNonInteractiveDismissal = false
            dismiss(animated: true, userInitiated: true, completion: nil)
        } else {
            transitionController.forcesNonInteractiveDismissal = true
            if let pageView = pageViewController?.view {
                transitionController.didPan(with: recognizer, viewToPan: pageView, anchorPoint: boundsCenterPoint)
            }
        }
    }
    
    // MARK: - View Controller Dismissal
    
    public override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        dismiss(animated: flag, userInitiated: false, completion: completion)
    }
    
    private func dismiss(animated flag: Bool, userInitiated isUserInitiated: Bool, completion: (() -> Void)?) {
        if presentedViewController != nil {
            super.dismiss(animated: flag, completion: completion)
            return
        }
        
        var startingView: UIView?
        if let photo = currentlyDisplayedPhoto, (photo.image != nil || photo.placeholderImage != nil || photo.imageData != nil) {
            startingView = currentPhotoViewController?.scalingImageView.imageView
        }
        
        transitionController.startingView = startingView
        transitionController.endingView = referenceViewForCurrentPhoto
        
        overlayWasHiddenBeforeTransition = overlayView.isHidden
        setOverlayViewHidden(true, animated: flag)
        
        let shouldSendDelegateMessages = isUserInitiated
        
        if shouldSendDelegateMessages {
            delegate?.photosViewControllerWillDismiss(self)
        }
        
        NotificationCenter.default.post(name: NYTPhotosViewControllerWillDismissNotification, object: self)
        
        super.dismiss(animated: flag) { [weak self] in
            guard let self = self else { return }
            
            let isStillOnscreen = self.view.window != nil
            
            if isStillOnscreen && !self.overlayWasHiddenBeforeTransition {
                self.setOverlayViewHidden(false, animated: true)
            }
            
            if !isStillOnscreen {
                if shouldSendDelegateMessages {
                    self.delegate?.photosViewControllerDidDismiss(self)
                }
                
                NotificationCenter.default.post(name: NYTPhotosViewControllerDidDismissNotification, object: self)
            }
            
            completion?()
        }
    }
    
    // MARK: - Convenience
    
    private func setCurrentlyDisplayedViewController(_ viewController: UIViewController?, animated: Bool) {
        guard let viewController = viewController else { return }
        
        var animated = animated
        if let container = viewController as? any NYTPhotoViewerContainer,
           photosAreEqual(container.photo, currentlyDisplayedPhoto) {
            animated = false
        }
        
        let direction: UIPageViewController.NavigationDirection
        if let currentVC = currentPhotoViewController,
           let newVC = viewController as? any NYTPhotoViewerContainer {
            direction = newVC.photoViewItemIndex < currentVC.photoViewItemIndex ? .reverse : .forward
        } else {
            direction = .forward
        }
        
        pageViewController?.setViewControllers([viewController], direction: direction, animated: animated)
    }
    
    private func setOverlayViewHidden(_ hidden: Bool, animated: Bool) {
        if hidden == overlayView.isHidden { return }
        
        if animated {
            overlayView.isHidden = false
            overlayView.alpha = hidden ? 1.0 : 0.0
            
            UIView.animate(withDuration: TimeInterval(overlayAnimationDuration), delay: 0, options: [.curveEaseInOut, .allowAnimatedContent, .allowUserInteraction]) {
                self.overlayView.alpha = hidden ? 0.0 : 1.0
            } completion: { _ in
                self.overlayView.alpha = 1.0
                self.overlayView.isHidden = hidden
            }
        } else {
            overlayView.isHidden = hidden
        }
    }
    
    private func newPhotoViewController(for photo: any NYTPhoto, at index: Int) -> NYTPhotoViewController {
        let loadingView = delegate?.photosViewController(self, loadingViewFor: photo)
        
        let photoViewController = NYTPhotoViewController(
            photo: photo,
            itemIndex: index,
            loadingView: loadingView,
            notificationCenter: notificationCenter
        )
        photoViewController.delegate = self
        singleTapGestureRecognizer.require(toFail: photoViewController.doubleTapGestureRecognizer)
        
        if let maxZoomScale = delegate?.photosViewController(self, maximumZoomScaleFor: photo), maxZoomScale > 0 {
            photoViewController.scalingImageView.maximumZoomScale = maxZoomScale
        }
        
        return photoViewController
    }
    
    private func newViewController(at index: Int) -> UIViewController? {
        guard let view = delegate?.photosViewController(self, interstitialViewAt: index) else { return nil }
        return NYTInterstitialViewController(view: view, itemIndex: index)
    }
    
    private func didNavigateToPhoto(_ photo: any NYTPhoto, at index: Int) {
        delegate?.photosViewController(self, didNavigateTo: photo, at: index)
        NotificationCenter.default.post(name: NYTPhotosViewControllerDidNavigateToPhotoNotification, object: self)
    }
    
    private func didNavigateToInterstitialView(_ view: UIView, at index: Int) {
        delegate?.photosViewController(self, didNavigateToInterstitialView: view, at: index)
        NotificationCenter.default.post(name: NYTPhotosViewControllerDidNavigateToInterstitialViewNotification, object: self)
    }
    
    private func photosAreEqual(_ photo1: (any NYTPhoto)?, _ photo2: (any NYTPhoto)?) -> Bool {
        guard let photo1 = photo1, let photo2 = photo2 else { return false }
        
        if let equatable1 = photo1 as? any Equatable,
           let equatable2 = photo2 as? any Equatable,
           type(of: equatable1) == type(of: equatable2) {
            return isEqual(equatable1, equatable2)
        }
        
        return false
    }
    
    private func isEqual(_ lhs: any Equatable, _ rhs: any Equatable) -> Bool {
        func compareIfSameType<T: Equatable>(_ lhs: T, _ rhs: any Equatable) -> Bool {
            guard let rhsTyped = rhs as? T else { return false }
            return lhs == rhsTyped
        }
        return compareIfSameType(lhs, rhs)
    }
    
    // MARK: - NSObject(UIResponderStandardEditActions)
    
    public override func copy(_ sender: Any?) {
        if let image = currentlyDisplayedPhoto?.image {
            UIPasteboard.general.image = image
        }
    }
    
    public override var canBecomeFirstResponder: Bool {
        true
    }
    
    public override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        if shouldHandleLongPress && action == #selector(copy(_:)) && currentlyDisplayedPhoto?.image != nil {
            return true
        }
        return false
    }
}

// MARK: - UIPageViewControllerDataSource

extension NYTPhotosViewController: UIPageViewControllerDataSource {
    
    private func nextViewController(fromIndex startingIndex: Int, delta: Int, stopBeforeIndex: Int) -> UIViewController? {
        var itemIndex = startingIndex
        
        while itemIndex + delta != stopBeforeIndex {
            itemIndex += delta
            
            let isPhotoAvailable = dataSource?.isPhoto(at: itemIndex) ?? true
            
            if isPhotoAvailable {
                if let photo = dataSource?.photo(at: itemIndex) {
                    return newPhotoViewController(for: photo, at: itemIndex)
                }
            }
            
            if let viewController = newViewController(at: itemIndex) {
                return viewController
            }
        }
        
        return nil
    }
    
    public func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let container = viewController as? any NYTPhotoViewerContainer else { return nil }
        return nextViewController(fromIndex: container.photoViewItemIndex, delta: -1, stopBeforeIndex: -1)
    }
    
    public func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let container = viewController as? any NYTPhotoViewerContainer else { return nil }
        let totalCount = totalItemCount() ?? 0
        return nextViewController(fromIndex: container.photoViewItemIndex, delta: 1, stopBeforeIndex: totalCount)
    }
}

// MARK: - UIPageViewControllerDelegate

extension NYTPhotosViewController: UIPageViewControllerDelegate {
    
    public func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        guard completed else { return }
        
        updateOverlayInformation()
        
        if let container = pageViewController.viewControllers?.first as? any NYTPhotoViewerContainer {
            if let photo = container.photo {
                didNavigateToPhoto(photo, at: container.photoViewItemIndex)
            } else if let view = container.interstitialView {
                didNavigateToInterstitialView(view, at: container.photoViewItemIndex)
            }
        }
    }
}

// MARK: - NYTPhotoViewControllerDelegate

extension NYTPhotosViewController: NYTPhotoViewControllerDelegate {
    
    public func photoViewController(_ photoViewController: NYTPhotoViewController, didLongPressWithGestureRecognizer longPressGestureRecognizer: UILongPressGestureRecognizer) {
        shouldHandleLongPress = false
        
        var clientDidHandle = false
        if let photo = photoViewController.photo {
            clientDidHandle = delegate?.photosViewController(self, handleLongPressFor: photo, with: longPressGestureRecognizer) ?? false
        }
        
        shouldHandleLongPress = !clientDidHandle
        
        if shouldHandleLongPress {
            let menuController = UIMenuController.shared
            var targetRect = CGRect.zero
            targetRect.origin = longPressGestureRecognizer.location(in: longPressGestureRecognizer.view)
            menuController.showMenu(from: longPressGestureRecognizer.view!, rect: targetRect)
        }
    }
}

// MARK: - UIActivityItemSource

extension NYTPhotosViewController: UIActivityItemSource {
    
    public func activityViewControllerPlaceholderItem(_ activityViewController: UIActivityViewController) -> Any {
        return NSNull()
    }
    
    public func activityViewController(_ activityViewController: UIActivityViewController, itemForActivityType activityType: UIActivity.ActivityType?) -> Any? {
        return nil
    }
    
    @available(iOS 13.0, *)
    public func activityViewControllerLinkMetadata(_ activityViewController: UIActivityViewController) -> LPLinkMetadata? {
        let metadata = LPLinkMetadata()
        metadata.title = currentlyDisplayedPhoto?.attributedCaptionSummary?.string
        return metadata
    }
}

