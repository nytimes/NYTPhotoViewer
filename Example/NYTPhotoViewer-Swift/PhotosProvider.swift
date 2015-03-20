//
//  PhotosProvider.swift
//  NYTPhotoViewer
//
//  Created by Mark Keefe on 3/20/15.
//  Copyright (c) 2015 Brian Capps. All rights reserved.
//

import UIKit

class PhotosProvider: NSObject {
    
    static let NumberOfPhotos = 5
    static let CustomEverythingPhotoIndex = 1
    static let DefaultLoadingSpinnerPhotoIndex = 3
    static let NoReferenceViewPhotoIndex = 4
    static let SummaryString = "summary"
    static let CreditString = "credit"

    static let photos: [ExamplePhoto] = {
        
        var mutablePhotos: [ExamplePhoto] = []
        let image = UIImage(named: "testImage"), placeholderImage = UIImage(named: "testImagePlaceholder")
        let attributedCaptionSummary = NSAttributedString(string: SummaryString, attributes: [NSForegroundColorAttributeName: UIColor.grayColor()])
        let attributedCaptionCredit = NSAttributedString(string: CreditString, attributes: [NSForegroundColorAttributeName: UIColor.darkGrayColor()])
        
        func shouldSetImageOnIndex(photoIndex: Int) -> Bool {
            return photoIndex == CustomEverythingPhotoIndex || photoIndex == DefaultLoadingSpinnerPhotoIndex
        }

        for var photoIndex = 0; photoIndex < NumberOfPhotos; photoIndex++ {

            let attributedCaptionTitle = NSAttributedString(string: "\(photoIndex + 1)", attributes: [NSForegroundColorAttributeName: UIColor.whiteColor()])

            let photo = ExamplePhoto(image: shouldSetImageOnIndex(photoIndex) ? image : nil, placeholderImage: placeholderImage, attributedCaptionTitle: attributedCaptionTitle, attributedCaptionSummary: attributedCaptionSummary, attributedCaptionCredit: attributedCaptionCredit)
        
            mutablePhotos.append(photo)
        }
        
        return mutablePhotos
    }()
}
