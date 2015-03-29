//
//  PhotosProvider.swift
//  NYTPhotoViewer
//
//  Created by Mark Keefe on 3/20/15.
//  Copyright (c) 2015 The New York Times. All rights reserved.
//

import UIKit

/**
*   In Swift 1.2, the following file level constants can be moved inside the class for better encapsulation
*/
let CustomEverythingPhotoIndex = 1, DefaultLoadingSpinnerPhotoIndex = 3, NoReferenceViewPhotoIndex = 4
let PrimaryImageName = "NYTimesBuilding"
let PlaceholderImageName = "NYTimesBuildingPlaceholder"

class PhotosProvider: NSObject {

    let photos: [ExamplePhoto] = {
        
        var mutablePhotos: [ExamplePhoto] = []
        var image = UIImage(named: PrimaryImageName)
        let NumberOfPhotos = 5
        
        func shouldNotSetImageOnIndex(photoIndex: Int) -> Bool {
            return photoIndex == CustomEverythingPhotoIndex || photoIndex == DefaultLoadingSpinnerPhotoIndex
        }
        
        for var photoIndex = 0; photoIndex < NumberOfPhotos; photoIndex++ {
            
            let title = NSAttributedString(string: "\(photoIndex + 1)", attributes: [NSForegroundColorAttributeName: UIColor.whiteColor()])
            let photo = shouldNotSetImageOnIndex(photoIndex) ? ExamplePhoto(attributedCaptionTitle: title) : ExamplePhoto(image: image, attributedCaptionTitle: title)
            
            if photoIndex == CustomEverythingPhotoIndex {
                photo.placeholderImage = UIImage(named: PlaceholderImageName)
            }
            
            mutablePhotos.append(photo)
        }
        
        return mutablePhotos
    }()    
}
