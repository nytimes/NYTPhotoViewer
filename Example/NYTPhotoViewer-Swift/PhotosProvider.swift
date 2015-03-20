//
//  PhotosProvider.swift
//  NYTPhotoViewer
//
//  Created by Mark Keefe on 3/20/15.
//  Copyright (c) 2015 Brian Capps. All rights reserved.
//

import UIKit

class PhotosProvider: NSObject {
    
    static let photos: [ExamplePhoto] = {
        
        let NumberOfPhotos = 5
        let SummaryString = "summary", CreditString = "credit"
        let image = UIImage(named: "testImage"), placeholderImage = UIImage(named: "testImagePlaceholder")

        let attributedCaptionSummary = NSAttributedString(string: SummaryString, attributes: [NSForegroundColorAttributeName: UIColor.grayColor()])
        let attributedCaptionCredit = NSAttributedString(string: CreditString, attributes: [NSForegroundColorAttributeName: UIColor.darkGrayColor()])
        
        func shouldSetImageOnIndex(photoIndex: Int) -> Bool {
            let customEverythingPhotoIndex = 1, defaultLoadingSpinnerPhotoIndex = 3
            return photoIndex == customEverythingPhotoIndex || photoIndex == defaultLoadingSpinnerPhotoIndex
        }

        var mutablePhotos: [ExamplePhoto] = []

        for var photoIndex = 0; photoIndex < NumberOfPhotos; photoIndex++ {

            let image = shouldSetImageOnIndex(photoIndex) ? image : nil
            let attributedCaptionTitle = NSAttributedString(string: "\(photoIndex + 1)", attributes: [NSForegroundColorAttributeName: UIColor.whiteColor()])

            let photo = ExamplePhoto(image: image, placeholderImage: placeholderImage, attributedCaptionTitle: attributedCaptionTitle, attributedCaptionSummary: attributedCaptionSummary, attributedCaptionCredit: attributedCaptionCredit)
        
            mutablePhotos.append(photo)
        }
        
        return mutablePhotos
    }()
}
