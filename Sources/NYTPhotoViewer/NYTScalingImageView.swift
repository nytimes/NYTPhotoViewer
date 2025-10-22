//
//  NYTScalingImageView.swift
//  NYTPhotoViewer
//
//  Created by Harrison, Andrew on 7/23/13.
//  Copyright (c) 2015 The New York Times Company. All rights reserved.
//

import UIKit

@MainActor
public class NYTScalingImageView: UIScrollView {
    
    // MARK: - Properties
    
    /// The image view used internally as the contents of the scroll view.
    public let imageView: UIImageView
    
    // MARK: - Initialization
    
    /// Initializes a scaling image view with a `UIImage`. This object is a `UIScrollView` that contains a `UIImageView`. This allows for zooming and panning around the image.
    ///
    /// - Parameters:
    ///   - image: A `UIImage` for zooming and panning.
    ///   - frame: The frame of the view.
    public init(image: UIImage?, frame: CGRect) {
        self.imageView = UIImageView(image: image)
        super.init(frame: frame)
        commonInit(image: image, imageData: nil)
    }
    
    /// Initializes a scaling image view with `Data` representing an animated image. This object is a `UIScrollView` that contains a `UIImageView`. This allows for zooming and panning around the image.
    ///
    /// - Parameters:
    ///   - imageData: `Data` representing an animated image for zooming and panning.
    ///   - frame: The frame of the view.
    public init(imageData: Data?, frame: CGRect) {
        let image = imageData.flatMap { UIImage(data: $0) }
        self.imageView = UIImageView(image: image)
        super.init(frame: frame)
        commonInit(image: image, imageData: imageData)
    }
    
    required init?(coder: NSCoder) {
        self.imageView = UIImageView()
        super.init(coder: coder)
        commonInit(image: nil, imageData: nil)
    }
    
    private func commonInit(image: UIImage?, imageData: Data?) {
        setupInternalImageView(image: image, imageData: imageData)
        setupImageScrollView()
        updateZoomScale()
    }
    
    // MARK: - Setup
    
    private func setupInternalImageView(image: UIImage?, imageData: Data?) {
        let imageToUse = image ?? imageData.flatMap { UIImage(data: $0) }
        updateImage(image: imageToUse, imageData: imageData)
        addSubview(imageView)
    }
    
    private func setupImageScrollView() {
        autoresizingMask = [.flexibleWidth, .flexibleHeight]
        showsVerticalScrollIndicator = false
        showsHorizontalScrollIndicator = false
        bouncesZoom = true
        decelerationRate = .fast
    }
    
    // MARK: - Public Methods
    
    /// Updates the image in the image view and centers and zooms the new image.
    ///
    /// - Parameter image: The new image to display in the image view.
    public func updateImage(_ image: UIImage?) {
        updateImage(image: image, imageData: nil)
    }
    
    /// Updates the image in the image view and centers and zooms the new image.
    ///
    /// - Parameter imageData: The data representing an animated image to display in the image view.
    public func updateImageData(_ imageData: Data?) {
        updateImage(image: nil, imageData: imageData)
    }
    
    private func updateImage(image: UIImage?, imageData: Data?) {
        let imageToUse = image ?? imageData.flatMap { UIImage(data: $0) }
        
        // Remove any transform currently applied by the scroll view zooming.
        imageView.transform = .identity
        imageView.image = imageToUse
        
        if let size = imageToUse?.size {
            imageView.frame = CGRect(origin: .zero, size: size)
            contentSize = size
        }
        
        updateZoomScale()
        centerScrollViewContents()
    }
    
    /// Centers the image inside of the scroll view. Typically used after rotation, or when zooming has finished.
    public func centerScrollViewContents() {
        var horizontalInset: CGFloat = 0
        var verticalInset: CGFloat = 0
        
        if contentSize.width < bounds.width {
            horizontalInset = (bounds.width - contentSize.width) * 0.5
        }
        
        if contentSize.height < bounds.height {
            verticalInset = (bounds.height - contentSize.height) * 0.5
        }
        
        if window?.screen.scale ?? 1.0 < 2.0 {
            horizontalInset = floor(horizontalInset)
            verticalInset = floor(verticalInset)
        }
        
        // Use `contentInset` to center the contents in the scroll view.
        contentInset = UIEdgeInsets(top: verticalInset, left: horizontalInset, bottom: verticalInset, right: horizontalInset)
    }
    
    private func updateZoomScale() {
        guard let imageSize = imageView.image?.size else { return }
        
        let scaleWidth = bounds.width / imageSize.width
        let scaleHeight = bounds.height / imageSize.height
        let minScale = min(scaleWidth, scaleHeight)
        
        minimumZoomScale = minScale
        maximumZoomScale = max(minScale, maximumZoomScale)
        zoomScale = minimumZoomScale
        
        // Disable pan gesture recognizer to prevent interference with the container controller's pan gesture.
        // This is enabled in scrollViewWillBeginZooming so panning while zoomed-in is unaffected.
        panGestureRecognizer.isEnabled = false
    }
    
    // MARK: - UIView Overrides
    
    public override func didAddSubview(_ subview: UIView) {
        super.didAddSubview(subview)
        centerScrollViewContents()
    }
    
    public override var frame: CGRect {
        didSet {
            updateZoomScale()
            centerScrollViewContents()
        }
    }
}

