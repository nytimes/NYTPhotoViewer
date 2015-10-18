//
//  NYTPhotosOverlayViewTests.swift
//  NYTPhotoViewer
//
//  Created by Mark Keefe on 3/21/15.
//  Copyright (c) 2015 The New York Times. All rights reserved.
//

import XCTest
import UIKit

class NYTPhotosOverlayViewTests: XCTestCase {

    func testNavigationBarExistsAfterInitialization() {
        let overlayView = NYTPhotosOverlayView()
        XCTAssertNotNil(overlayView.navigationBar)
    }
    
    func testLeftBarButtonItemSetterAffectsNavigationBar() {
        let overlayView = NYTPhotosOverlayView()
        let leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Done, target: nil, action: nil)
        overlayView.leftBarButtonItem = leftBarButtonItem
        XCTAssert(leftBarButtonItem == overlayView.navigationBar.items?.first?.leftBarButtonItem)
    }
    
    func testRightBarButtonItemSetterAffectsNavigationBar() {
        let overlayView = NYTPhotosOverlayView()
        let rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Done, target: nil, action: nil)
        overlayView.rightBarButtonItem = rightBarButtonItem
        XCTAssert(rightBarButtonItem == overlayView.navigationBar.items?.first?.rightBarButtonItem)
    }
    
    func testTitleSetterAffectsNavigationBar() {
        let overlayView = NYTPhotosOverlayView()
        let title = "title"
        overlayView.title = title
        XCTAssert(title == overlayView.navigationBar.items?.first?.title)
    }
    
    func testTitleTextAttributesSetterAffectsNavigationBar() {
        let overlayView = NYTPhotosOverlayView()
        let titleTextAttributes = [NSForegroundColorAttributeName: UIColor.orangeColor()]
        overlayView.titleTextAttributes = titleTextAttributes
        XCTAssertEqual(titleTextAttributes, overlayView.navigationBar.titleTextAttributes as? [String: UIColor])
    }
}
