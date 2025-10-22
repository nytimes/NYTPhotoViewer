//
//  NYTPhotoViewerDataSource.swift
//  NYTPhotoViewer
//
//  Created by Brian Capps on 2/10/15.
//  Copyright (c) 2015 NYTimes. All rights reserved.
//

import Foundation

/// The data source for an `NYTPhotosViewController` instance.
///
/// A view controller, view model, or model in your application could conform to this protocol, depending on what makes sense in your architecture.
///
/// Alternatively, `NYTPhotoViewerArrayDataSource` and `NYTPhotoViewerSinglePhotoDataSource` are concrete classes which conveniently handle the most common use cases for NYTPhotoViewer.
@MainActor
public protocol NYTPhotoViewerDataSource: AnyObject, Sendable {
    
    /// The total number of photos in the data source, or `nil` if the number is not known.
    var numberOfPhotos: Int? { get }
    
    /// Returns the index of a given photo, or `nil` if the photo is not in the data source.
    ///
    /// - Parameter photo: The photo against which to look for the index.
    /// - Returns: The index of a given photo, or `nil` if the photo is not in the data source.
    func index(of photo: any NYTPhoto) -> Int?
    
    /// Returns the photo object at a specified index, or `nil` if one does not exist at that index.
    ///
    /// - Parameter photoIndex: The index of the desired photo.
    /// - Returns: The photo object at a specified index, or `nil` if one does not exist at that index.
    func photo(at index: Int) -> (any NYTPhoto)?
    
    // MARK: Optional
    
    /// The total number of interstitial views in the data source.
    ///
    /// - Returns: The number of interstitial views or `nil` if the number is not known.
    var numberOfInterstitialViews: Int? { get }
    
    /// Indicates if the item at the specified index is a photo.
    ///
    /// - Parameter index: The index to check.
    /// - Returns: `true` if the item at the specified index is a photo, `false` otherwise.
    func isPhoto(at index: Int) -> Bool
    
    /// Indicates if the item at the specified index is an interstitial view.
    ///
    /// - Parameter index: The index to check.
    /// - Returns: `true` if the item at the specified index is an interstitial view, `false` otherwise.
    func isInterstitialView(at index: Int) -> Bool
}

// Default implementations for optional methods
public extension NYTPhotoViewerDataSource {
    var numberOfInterstitialViews: Int? { nil }
    func isPhoto(at index: Int) -> Bool { true }
    func isInterstitialView(at index: Int) -> Bool { false }
}

