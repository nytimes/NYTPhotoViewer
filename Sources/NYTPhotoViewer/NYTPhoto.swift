//
//  NYTPhoto.swift
//  NYTPhotoViewer
//
//  Created by Brian Capps on 2/10/15.
//  Copyright (c) 2015 NYTimes. All rights reserved.
//

import UIKit

/// The model for photos displayed in an `NYTPhotosViewController`.
///
/// Your models (or boxes, if working with Swift value types) should conform to `Equatable` to provide a concept of identity for the PhotoViewer to work with.
@MainActor
public protocol NYTPhoto: Sendable {
    
    /// The image to display.
    ///
    /// This property is used if and only if `imageData` returns `nil`. Note, however, that returning `UIImage`s from this property whenever possible will result in better performance. See `imageData`'s documentation for discussion.
    var image: UIImage? { get }
    
    /// The image data to display.
    ///
    /// This property's value, if non-`nil`, is preferred over `image`. This allows clients to provide image data for animated images when supported.
    ///
    /// Note that if you're working with a non-animated image, using a native `UIImage` will provide better performance. Therefore, it is recommended to return `nil` from this property unless this photo is an animated GIF.
    var imageData: Data? { get }
    
    /// A placeholder image for display while the image is loading.
    ///
    /// This property is used if and only if `imageData` and `image` return `nil`.
    var placeholderImage: UIImage? { get }
    
    // MARK: Caption
    
    /// An attributed string for display as the title of the caption.
    var attributedCaptionTitle: NSAttributedString? { get }
    
    /// An attributed string for display as the summary of the caption.
    var attributedCaptionSummary: NSAttributedString? { get }
    
    /// An attributed string for display as the credit of the caption.
    var attributedCaptionCredit: NSAttributedString? { get }
}

