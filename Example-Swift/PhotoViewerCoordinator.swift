//
//  PhotoViewerCoordinator.swift
//  NYTPhotoViewer
//
//  Created by Chris Dzombak on 2/2/17.
//  Copyright © 2017 NYTimes. All rights reserved.
//

import NYTPhotoViewer

/// Coordinates interaction between the application's data layer and the photo viewer component.
final class PhotoViewerCoordinator: NYTPhotoViewerDataSource {
    let slideshow: [NYTPhotoBox]
    let provider: PhotosProvider

    lazy var photoViewer: NYTPhotosViewController = {
        return NYTPhotosViewController(dataSource: self)
    }()

    init(provider: PhotosProvider) {
        self.provider = provider
        self.slideshow = provider.fetchDemoSlideshow().map { NYTPhotoBox($0) }
        self.fetchPhotos()
    }

    func fetchPhotos() {
        for box in slideshow {
            provider.fetchPhoto(named: box.value.name, then: { [weak self] (result) in
                box.image = result
                self?.photoViewer.update(box)
            })
        }
    }

    // MARK: NYTPhotoViewerDataSource

    @objc
    var numberOfPhotos: NSNumber? {
        return NSNumber(integerLiteral: slideshow.count)
    }

    @objc
    func index(of photo: NYTPhoto) -> Int {
        guard let box = photo as? NYTPhotoBox else { return NSNotFound }
        return slideshow.index(where: { $0.value.identifier == box.value.identifier }) ?? NSNotFound
    }

    @objc
    func photo(at index: Int) -> NYTPhoto? {
        guard index < slideshow.count else { return nil }
        return slideshow[index]
    }
}
