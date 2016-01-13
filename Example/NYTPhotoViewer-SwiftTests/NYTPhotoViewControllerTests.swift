//
//  NYTPhotoViewControllerTests.swift
//  NYTPhotoViewer
//
//  Created by Mark Keefe on 3/21/15.
//  Copyright (c) 2015 The New York Times. All rights reserved.
//

import XCTest

class NYTPhotoViewControllerTests: XCTestCase {
    
    var testPhoto: ExamplePhoto?

    override func setUp() {
        super.setUp()
        testPhoto = ExamplePhoto(attributedCaptionTitle: NSAttributedString())
    }
    
    override func tearDown() {
        testPhoto = nil
        super.tearDown()
    }

    func testScalingImageViewExistsAferInitialization() {
        let photoViewController = NYTPhotoViewController(photo: testPhoto, loadingView: nil, notificationCenter: nil)
        XCTAssertNotNil(photoViewController.scalingImageView)
    }
    
    func testDoubleTapGestureRecognizerExistsAferInitialization() {
        let photoViewController = NYTPhotoViewController(photo: testPhoto, loadingView: nil, notificationCenter: nil)
        XCTAssertNotNil(photoViewController.doubleTapGestureRecognizer)
    }
    
    func testLoadingViewExistsAferNilInitialization() {
        let photoViewController = NYTPhotoViewController(photo: testPhoto, loadingView: nil, notificationCenter: nil)
        XCTAssertNotNil(photoViewController.loadingView)
    }
    
    func testDesignatedInitializerAcceptsNilForPhotoArgument() {
        let photoViewController = NYTPhotoViewController(photo: nil, loadingView: UIView(), notificationCenter: NSNotificationCenter.defaultCenter())

        XCTAssertNotNil(photoViewController)
    }
    
    func testDesignatedInitializerAcceptsNilForLoadingViewArgument() {
        let photoViewController = NYTPhotoViewController(photo: testPhoto, loadingView: nil, notificationCenter: NSNotificationCenter.defaultCenter())
        
        XCTAssertNotNil(photoViewController)
    }
    
    func testDesignatedInitializerAcceptsNilForNotificationCenterArgument() {
        let photoViewController = NYTPhotoViewController(photo: testPhoto, loadingView: UIView(), notificationCenter: nil)
        
        XCTAssertNotNil(photoViewController)
    }
    
    func testDesignatedInitializerAcceptsNilForAllArguments() {
        let photoViewController = NYTPhotoViewController(photo: nil, loadingView: nil, notificationCenter: nil)
        
        XCTAssertNotNil(photoViewController)
    }
}
