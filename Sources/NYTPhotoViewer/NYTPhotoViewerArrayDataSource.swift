//
//  NYTPhotoViewerArrayDataSource.swift
//  NYTPhotoViewer
//
//  Created by Brian Capps on 2/11/15.
//  Copyright (c) 2017 The New York Times Company. All rights reserved.
//

import Foundation

/// A simple concrete implementation of `NYTPhotoViewerDataSource`, for use with an array of images.
/// Does not support interstitial views.
@MainActor
public final class NYTPhotoViewerArrayDataSource: NYTPhotoViewerDataSource, Sequence {
    
    // MARK: - Properties
    
    public let photos: [any NYTPhoto]
    
    // MARK: - Initialization
    
    /// The designated initializer that takes and stores an array of photos.
    ///
    /// - Parameter photos: An array of objects conforming to the `NYTPhoto` protocol.
    public init(photos: [any NYTPhoto]) {
        self.photos = photos
    }
    
    public convenience init() {
        self.init(photos: [])
    }
    
    // MARK: - NYTPhotoViewerDataSource
    
    public var numberOfPhotos: Int? {
        photos.count
    }
    
    public func photo(at index: Int) -> (any NYTPhoto)? {
        guard index >= 0 && index < photos.count else { return nil }
        return photos[index]
    }
    
    public func index(of photo: any NYTPhoto) -> Int? {
        photos.firstIndex { photo1 in
            if let equatable1 = photo1 as? any Equatable,
               let equatable2 = photo as? any Equatable,
               type(of: equatable1) == type(of: equatable2) {
                return isEqual(equatable1, equatable2)
            }
            return false
        }
    }
    
    private func isEqual(_ lhs: any Equatable, _ rhs: any Equatable) -> Bool {
        // Use a generic helper to compare equatable types
        func compareIfSameType<T: Equatable>(_ lhs: T, _ rhs: any Equatable) -> Bool {
            guard let rhsTyped = rhs as? T else { return false }
            return lhs == rhsTyped
        }
        return compareIfSameType(lhs, rhs)
    }
    
    // MARK: - Sequence
    
    public func makeIterator() -> IndexingIterator<[any NYTPhoto]> {
        photos.makeIterator()
    }
    
    // MARK: - Subscripting
    
    public subscript(index: Int) -> (any NYTPhoto)? {
        photo(at: index)
    }
}

