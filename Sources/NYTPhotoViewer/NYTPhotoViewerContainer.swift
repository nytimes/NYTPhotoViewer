//
//  NYTPhotoViewerContainer.swift
//  NYTPhotoViewer
//
//  Created by Brian Capps on 2/11/15.
//  Copyright (c) 2015 NYTimes. All rights reserved.
//

import UIKit

/// A protocol that defines that an object contains a photo or interstitial view property
/// and the index of the item in the collection.
@MainActor
public protocol NYTPhotoViewerContainer: AnyObject {
    
    /// An object conforming to the `NYTPhoto` protocol.
    /// Will be nil if the container has a view.
    var photo: (any NYTPhoto)? { get }
    
    /// A view to be displayed instead of a photo.
    /// Will be nil if the container has a photo.
    var interstitialView: UIView? { get }
    
    /// The index of this item in the collection.
    var photoViewItemIndex: Int { get }
}

