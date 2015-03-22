//
//  NYTPhotoCaptionViewTests.swift
//  NYTPhotoViewer
//
//  Created by Mark Keefe on 3/21/15.
//  Copyright (c) 2015 The New York Times. All rights reserved.
//

import XCTest

class NYTPhotoCaptionViewTests: XCTestCase {

    func testDesignatedInitializerAcceptsNilForTitle() {
        let photoCaptionView = NYTPhotoCaptionView(attributedTitle: nil, attributedSummary: NSAttributedString(), attributedCredit: NSAttributedString())
        XCTAssertNotNil(photoCaptionView)
    }
    
    func testDesignatedInitializerAcceptsNilForSummary() {
        let photoCaptionView = NYTPhotoCaptionView(attributedTitle: NSAttributedString(), attributedSummary: nil, attributedCredit: NSAttributedString())
        XCTAssertNotNil(photoCaptionView)
    }
    
    func testDesignatedInitializerAcceptsNilForCredit() {
        let photoCaptionView = NYTPhotoCaptionView(attributedTitle: NSAttributedString(), attributedSummary: NSAttributedString(), attributedCredit: nil)
        XCTAssertNotNil(photoCaptionView)
    }
}
