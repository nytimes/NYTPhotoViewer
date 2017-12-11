//
//  PhotosProvider.swift
//  NYTPhotoViewer
//
//  Created by Mark Keefe on 3/20/15.
//  Copyright (c) 2015 The New York Times. All rights reserved.
//

import UIKit

/// A component of your data layer, which might load photos from the cache or network.
final class PhotosProvider {
    typealias Slideshow = [Photo]

    /// Simulate a synchronous fetch of a slideshow, perhaps from a local database.
    func fetchDemoSlideshow() -> Slideshow {
        return (0...4).map { demoPhoto(identifier: $0) }
    }

    /// Simulate fetching a photo from the network.
    /// For simplicity in this demo, errors are not simulated, and the callback is invoked on the main queue.
    func fetchPhoto(named name: String, then completionHandler: @escaping (UIImage) -> Void) {
        let delay = Double(arc4random_uniform(3) + 2)
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            guard let result = UIImage(named: name) else { fatalError("Image '\(name)' could not be loaded from the bundle.") }
            completionHandler(result)
        }
    }
}

extension PhotosProvider {
    fileprivate func demoPhoto(identifier: Int) -> Photo {
        let photoName: String
        let photoSummary: String
        let photoCredit: String

        if (arc4random_uniform(2) == 0 && identifier != 0) {
            photoName = "Chess"
            photoSummary = "Children gather around a game of chess during the Ann Arbor Summer Festival. (Photo ID \(identifier))"
            photoCredit = "Photo: Chris Dzombak"
        } else {
            photoName = "NYTimesBuilding"
            photoSummary = "The New York Times office in Manhattan. (Photo ID \(identifier))"
            photoCredit = "Photo: Nic Lehoux"
        }

        return Photo(name: photoName, summary: photoSummary, credit: photoCredit, identifier: identifier)
    }
}
