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
    let placeholderImage = UIImage(named: "testImagePlaceholder")
    let attributedCaptionSummary = NSAttributedString(string: "summary string", attributes: [NSForegroundColorAttributeName: UIColor.grayColor()])
    let attributedCaptionCredit = NSAttributedString(string: "credit", attributes: [NSForegroundColorAttributeName: UIColor.darkGrayColor()])
    
    init(image: UIImage?, attributedCaptionTitle: NSAttributedString) {

        self.image = image
        self.attributedCaptionTitle = attributedCaptionTitle

        super.init()
    }
}
