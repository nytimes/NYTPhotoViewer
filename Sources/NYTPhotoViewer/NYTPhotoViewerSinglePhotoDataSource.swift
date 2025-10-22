//
//  NYTPhotoViewerSinglePhotoDataSource.swift
//  NYTPhotoViewer
//
//  Created by Chris Dzombak on 1/27/17.
//  Copyright © 2017 The New York Times Company. All rights reserved.
//

import Foundation

/// A simple concrete implementation of `NYTPhotoViewerDataSource`, for use with a single image.
@MainActor
public final class NYTPhotoViewerSinglePhotoDataSource: NYTPhotoViewerDataSource {
    
    // MARK: - Properties
    
    public let photo: any NYTPhoto
    
    // MARK: - Initialization
    
    /// The designated initializer that takes and stores a single photo.
    ///
    /// - Parameter photo: An object conforming to the `NYTPhoto` protocol.
    public init(photo: any NYTPhoto) {
        self.photo = photo
    }
    
    // MARK: - NYTPhotoViewerDataSource
    
    public var numberOfPhotos: Int? {
        1
    }
    
    public func photo(at index: Int) -> (any NYTPhoto)? {
        photo
    }
    
    public func index(of photo: any NYTPhoto) -> Int? {
        0
    }
}

