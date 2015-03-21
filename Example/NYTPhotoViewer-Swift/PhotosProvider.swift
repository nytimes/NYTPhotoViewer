//
//  PhotosProvider.swift
//  NYTPhotoViewer
//
//  Created by Mark Keefe on 3/20/15.
//  Copyright (c) 2015 The New York Times. All rights reserved.
//

import UIKit

class PhotosProvider: NSObject {
    
    static let CustomEverythingPhotoIndex = 1, DefaultLoadingSpinnerPhotoIndex = 3, NoReferenceViewPhotoIndex = 4

    static let photos: [ExamplePhoto] = {
        
        let NumberOfPhotos = 5
        let image = UIImage(named: "testImage"), placeholderImage = UIImage(named: "testImagePlaceholder")
        
        func shouldSetImageOnIndex(photoIndex: Int) -> Bool {
            return photoIndex == CustomEverythingPhotoIndex || photoIndex == DefaultLoadingSpinnerPhotoIndex
        }

        var mutablePhotos: [ExamplePhoto] = []

        for var photoIndex = 0; photoIndex < NumberOfPhotos; photoIndex++ {

            let image = shouldSetImageOnIndex(photoIndex) ? image : nil
            let attributedCaptionTitle = NSAttributedString(string: "\(photoIndex + 1)", attributes: [NSForegroundColorAttributeName: UIColor.whiteColor()])

            let photo = ExamplePhoto(image: image, placeholderImage: placeholderImage, attributedCaptionTitle: attributedCaptionTitle)
        
            mutablePhotos.append(photo)
        }
        
        return mutablePhotos
    }()
}
