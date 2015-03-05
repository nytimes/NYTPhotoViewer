//
//  NYTPhotoTransitionAnimatorTests.m
//  NYTPhotoViewer
//
//  Created by Brian Capps on 2/26/15.
//  Copyright (c) 2015 NYTimes. All rights reserved.
//

@import UIKit;
@import XCTest;

#import <NYTPhotoViewer/NYTPhotoTransitionAnimator.h>

@interface NYTPhotoTransitionAnimatorTests : XCTestCase

@end

@implementation NYTPhotoTransitionAnimatorTests

- (void)testNewAnimationViewReturnsNilWhenPassedNil {
    XCTAssertNil([NYTPhotoTransitionAnimator newAnimationViewFromView:nil]);
}

@end
