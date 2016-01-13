//
//  NYTPhotoTransitionAnimatorTests.swift
//  NYTPhotoViewer
//
//  Created by Mark Keefe on 3/21/15.
//  Copyright (c) 2015 The New York Times. All rights reserved.
//

import XCTest

class NYTPhotoTransitionAnimatorTests: XCTestCase {

    func testNewAnimationViewReturnsNilWhenPassedNil() {
        XCTAssertNil(NYTPhotoTransitionAnimator.newAnimationViewFromView(nil))
    }
}
