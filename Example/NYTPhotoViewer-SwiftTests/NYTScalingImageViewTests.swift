//
//  NYTScalingImageViewTests.swift
//  NYTPhotoViewer
//
//  Created by Mark Keefe on 3/21/15.
//  Copyright (c) 2015 The New York Times. All rights reserved.
//

import XCTest

class NYTScalingImageViewTests: XCTestCase {

    func testInitializationAcceptsNil() {
        let scalingImageView = NYTScalingImageView(image: nil, frame: CGRectZero)
        XCTAssertNotNil(scalingImageView)
    }
    
    func testImageViewExistsAfterInitialization() {
        let scalingImageView = NYTScalingImageView(image: nil, frame: CGRectZero)
        XCTAssertNotNil(scalingImageView.imageView);
    }
    
    func testInitializationSetsImage() {
        let image = UIImage()
        let scalingImageView = NYTScalingImageView(image: nil, frame: CGRectZero)
        if let scalingImage = scalingImageView.imageView.image {
            XCTAssertEqual(image, scalingImage)
        }
    }
    
    func testUpdateImageUpdatesImage() {
        let image2 = UIImage()
        
        let scalingImageView = NYTScalingImageView(image: nil, frame: CGRectZero)
        scalingImageView.updateImage(image2)
        
        XCTAssertEqual(image2, scalingImageView.imageView.image!)
    }
}
