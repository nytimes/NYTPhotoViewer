//
//  ExamplePhoto.swift
//  NYTPhotoViewer
//
//  Created by Mark Keefe on 3/20/15.
//  Copyright (c) 2015 The New York Times. All rights reserved.
//

import UIKit

class ExamplePhoto: NSObject, NYTPhoto {

    var image: UIImage?
    let placeholderImage: UIImage?
    let attributedCaptionTitle: NSAttributedString
    let attributedCaptionSummary: NSAttributedString
    let attributedCaptionCredit: NSAttributedString

    init(image: UIImage?, placeholderImage: UIImage?, attributedCaptionTitle: NSAttributedString, attributedCaptionSummary: NSAttributedString, attributedCaptionCredit: NSAttributedString) {
        
        self.image = image
        self.placeholderImage = placeholderImage
        self.attributedCaptionTitle = attributedCaptionTitle
        self.attributedCaptionSummary = attributedCaptionSummary
        self.attributedCaptionCredit = attributedCaptionCredit
    }

    convenience init(image: UIImage?, placeholderImage: UIImage?, attributedCaptionTitle: NSAttributedString) {
        
        let SummaryString = "summary", CreditString = "credit"
        let attributedSummary = NSAttributedString(string: SummaryString, attributes: [NSForegroundColorAttributeName: UIColor.grayColor()])
        let attributedCredit = NSAttributedString(string: CreditString, attributes: [NSForegroundColorAttributeName: UIColor.darkGrayColor()])
        
        self.init(image: image, placeholderImage: placeholderImage, attributedCaptionTitle: attributedCaptionTitle, attributedCaptionSummary: attributedSummary, attributedCaptionCredit: attributedCredit)
    }
}
