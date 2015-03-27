//
//  ExamplePhoto.swift
//  NYTPhotoViewer
//
//  Created by Mark Keefe on 3/20/15.
//  Copyright (c) 2015 The New York Times. All rights reserved.
//

import UIKit

class ExamplePhoto: NSObject, NYTPhoto {

    var image:UIImage?
    var attributedCaptionTitle: NSAttributedString
    let placeholderImage = UIImage(named: "NYTimesBuildingPlaceholder")
    let attributedCaptionSummary = NSAttributedString(string: "summary string", attributes: [NSForegroundColorAttributeName: UIColor.grayColor()])
    let attributedCaptionCredit = NSAttributedString(string: "credit", attributes: [NSForegroundColorAttributeName: UIColor.darkGrayColor()])
    
    init(attributedCaptionTitle: NSAttributedString) {
        self.attributedCaptionTitle = attributedCaptionTitle
        super.init()
    }

    convenience init(image: UIImage?, attributedCaptionTitle: NSAttributedString) {
        self.init(attributedCaptionTitle: attributedCaptionTitle)
        self.image = image
    }
}
