//
//  NYTPhotosDataSourceTests.swift
//  NYTPhotoViewer
//
//  Created by Mark Keefe on 3/21/15.
//  Copyright (c) 2015 The New York Times. All rights reserved.
//

import XCTest

class NYTPhotosDataSourceTests: XCTestCase {

    let photos: [ExamplePhoto] = PhotosProvider().photos
    
    func testInitializerAcceptsNil() {
        XCTAssertNotNil(NYTPhotosDataSource(photos: nil))
    }
    
    func testOutOfBoundsReturnsNilAndDoesNotCrash() {
        let dataSource = NYTPhotosDataSource(photos: nil)
        let notAnObject: AnyObject? = dataSource[1]
        XCTAssertNil(notAnObject, "NYTDataSource should not crash after it was initialized with nil")
    }
    
    func testValidIndexReturnsPhoto() {
        let dataSource = NYTPhotosDataSource(photos: photos)
        XCTAssertNotNil(dataSource[1])
    }

    func testValidIndexReturnsCorrectPhoto() {
        let dataSource = NYTPhotosDataSource(photos: photos)
        XCTAssertEqual(photos[1], dataSource[1] as? ExamplePhoto)
    }
}
