//
//  ExamplePhoto.swift
//  NYTPhotoViewer
//
//  Created by Mark Keefe on 3/20/15.
//  Copyright (c) 2015 Brian Capps. All rights reserved.
//

import UIKit

class ExamplePhoto: NSObject, NYTPhoto {

    @objc var image: UIImage?

    @objc let placeholderImage: UIImage?
    @objc let attributedCaptionTitle: NSAttributedString
    @objc let attributedCaptionSummary: NSAttributedString
    @objc let attributedCaptionCredit: NSAttributedString

    init(image anImage: UIImage?, placeholderImage aPlaceholderImage: UIImage?, attributedCaptionTitle anAttributedCaptionTitle: NSAttributedString, attributedCaptionSummary anAttributedCaptionSummary: NSAttributedString, attributedCaptionCredit anAttributedCaptionCredit: NSAttributedString) {
        
        image = anImage
        placeholderImage = aPlaceholderImage
        attributedCaptionTitle = anAttributedCaptionTitle
        attributedCaptionSummary = anAttributedCaptionSummary
        attributedCaptionCredit = anAttributedCaptionCredit
    }

    convenience init(image anImage: UIImage?, placeholderImage: UIImage?, attributedCaptionTitle: NSAttributedString) {

        let SummaryString = "summary", CreditString = "credit"
        let attributedSummary = NSAttributedString(string: SummaryString, attributes: [NSForegroundColorAttributeName: UIColor.grayColor()])
        let attributedCredit = NSAttributedString(string: CreditString, attributes: [NSForegroundColorAttributeName: UIColor.darkGrayColor()])

        self.init(image: anImage, placeholderImage: placeholderImage, attributedCaptionTitle: attributedCaptionTitle, attributedCaptionSummary: attributedSummary, attributedCaptionCredit: attributedCredit)
    }
}
