//
//  NYTPhotosViewControllerTests.swift
//  NYTPhotoViewer
//
//  Created by Mark Keefe on 3/21/15.
//  Copyright (c) 2015 The New York Times. All rights reserved.
//

import UIKit
import XCTest

class NYTPhotosViewControllerTests: XCTestCase {

    let photos: [ExamplePhoto] = PhotosProvider().photos
    var photosViewController: NYTPhotosViewController?
    
    override func setUp() {
        super.setUp()
        photosViewController = NYTPhotosViewController(photos: photos)
    }
    
    override func tearDown() {
        photosViewController = nil
        super.tearDown()
    }

    func testPanGestureRecognizerExistsAfterInitialization() {
        XCTAssertNotNil(photosViewController?.panGestureRecognizer)
    }
    
    func testPanGestureRecognizerHasAssociatedView() {
        XCTAssertNotNil(photosViewController?.panGestureRecognizer.view)
    }
    
    func testSingleTapGestureRecognizerExistsAfterInitialization() {
        XCTAssertNotNil(photosViewController?.singleTapGestureRecognizer)
    }
    
    func testSingleTapGestureRecognizerHasAssociatedView() {
        XCTAssertNotNil(photosViewController?.singleTapGestureRecognizer.view)
    }
    
    func testPageViewControllerExistsAfterInitialization() {
        XCTAssertNotNil(photosViewController?.pageViewController)
    }
    
    func testPageViewControllerDoesNotHaveAssociatedSuperviewBeforeViewLoads() {
        XCTAssertNil(photosViewController?.pageViewController.view.superview)
    }
    
    func testPageViewControllerHasAssociatedSuperviewAfterViewLoads() {
        photosViewController?.view = photosViewController?.view // Referencing the view loads it.
        XCTAssertNotNil(photosViewController?.pageViewController.view.superview)
    }
    
    func testCurrentlyDisplayedPhotoIsFirstAfterConvenienceInitialization() {
        XCTAssertEqual(photos.first!, photosViewController?.currentlyDisplayedPhoto as? ExamplePhoto)
    }
    
    func testCurrentlyDisplayedPhotoIsAccurateAfterSettingInitialPhoto() {
        photosViewController = NYTPhotosViewController(photos: photos, initialPhoto: photos.last)
        XCTAssertEqual(photos.last!, photosViewController?.currentlyDisplayedPhoto as? ExamplePhoto)
    }
    
    func testCurrentlyDisplayedPhotoIsAccurateAfterDisplayPhotoCall() {
        photosViewController = NYTPhotosViewController(photos: photos, initialPhoto: photos.last)
        photosViewController?.displayPhoto(photos.first, animated: false)
        XCTAssertEqual(photos.first!, photosViewController?.currentlyDisplayedPhoto as? ExamplePhoto)
    }
    
    func testLeftBarButtonItemIsPopulatedAfterInitialization() {
        XCTAssertNotNil(photosViewController?.leftBarButtonItem)
    }
    
    func testLeftBarButtonItemIsNilAfterSettingToNil() {
        photosViewController?.leftBarButtonItem = nil
        XCTAssertNil(photosViewController?.leftBarButtonItem)
    }
    
    func testRightBarButtonItemIsPopulatedAfterInitialization() {
        XCTAssertNotNil(photosViewController?.rightBarButtonItem)
    }
    
    func testRightBarButtonItemIsNilAfterSettingToNil() {
        photosViewController?.rightBarButtonItem = nil
        XCTAssertNil(photosViewController?.rightBarButtonItem)
    }

    func testConvenienceInitializerAcceptsNil() {
        XCTAssertNotNil(photosViewController)
    }

    func testDesignatedInitializerAcceptsNilForPhotosParameter() {
        photosViewController = NYTPhotosViewController(photos: nil, initialPhoto: photos.first)
        XCTAssertNotNil(photosViewController)
    }

    func testDesignatedInitializerAcceptsNilForInitialPhotoParameter() {
        photosViewController = NYTPhotosViewController(photos: photos, initialPhoto: nil)

        XCTAssertNotNil(photosViewController)
    }
    
    func testDesignatedInitializerAcceptsNilForBothParameters() {
        photosViewController = NYTPhotosViewController(photos: nil, initialPhoto: nil)

        XCTAssertNotNil(photosViewController)
    }
    
    func testDisplayPhotoAcceptsNil() {
        photosViewController?.displayPhoto(nil, animated: false)
        XCTAssertNotNil(photosViewController)
    }
    
    func testDisplayPhotoDoesNothingWhenPassedPhotoOutsideDataSource() {
        photosViewController = NYTPhotosViewController(photos: photos, initialPhoto: photos.first)
        
        let invalidPhoto = ExamplePhoto(attributedCaptionTitle: NSAttributedString(string: "title"))
        
        photosViewController?.displayPhoto(invalidPhoto as NYTPhoto, animated: false)
        XCTAssertEqual(photos.first!, photosViewController?.currentlyDisplayedPhoto as? ExamplePhoto)
    }
    
    func testDisplayPhotoMovesToCorrectPhoto() {
        photosViewController = NYTPhotosViewController(photos: photos, initialPhoto: photos.first)
        let photoToDisplay = photos[2]
        
        photosViewController?.displayPhoto(photoToDisplay, animated: false)
        XCTAssertEqual(photoToDisplay, photosViewController?.currentlyDisplayedPhoto as? ExamplePhoto)
    }
    
    func testUpdateImageForPhotoAcceptsNil() {
        photosViewController?.updateImageForPhoto(nil)
        XCTAssertNotNil(photosViewController)
    }
    
    func testUpdateImageForPhotoDoesNothingWhenPassedPhotoOutsideDataSource() {
        photosViewController = NYTPhotosViewController(photos: photos, initialPhoto: photos[CustomEverythingPhotoIndex])
        let invalidPhoto = ExamplePhoto(attributedCaptionTitle: NSAttributedString())
        invalidPhoto.image = UIImage()
        
        photosViewController?.updateImageForPhoto(invalidPhoto)
        
        if photos.count > CustomEverythingPhotoIndex {
            if let testImage = photos[CustomEverythingPhotoIndex].image {
                /** Swift 1.2
                 *  if photos.count > PhotosProvider.CustomEverythingPhotoIndex,
                 *  let testImage = photos[PhotosProvider.CustomEverythingPhotoIndex].image
                 */
                if let currentlyDisplayedPhoto = photosViewController?.currentlyDisplayedPhoto {
                    XCTAssertEqual(currentlyDisplayedPhoto.image, testImage)
                }
            }
        }
    }
    
    func testUpdateImageForPhotoUpdatesImage() {
        photosViewController = NYTPhotosViewController(photos: photos, initialPhoto: photos.first)

        if let photoToUpdate = photos.first {
            photoToUpdate.image = UIImage()
            
            photosViewController?.updateImageForPhoto(photoToUpdate)
            
            if let currentlyDisplayedPhoto = photosViewController?.currentlyDisplayedPhoto {
                XCTAssertEqual(currentlyDisplayedPhoto.image, photoToUpdate.image!)
            }
        }
    }
}
