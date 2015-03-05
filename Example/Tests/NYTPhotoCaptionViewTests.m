//
//  NYTPhotoCaptionViewTests.m
//  NYTPhotoViewer
//
//  Created by Brian Capps on 2/24/15.
//  Copyright (c) 2015 NYTimes. All rights reserved.
//

@import UIKit;
@import XCTest;

#import <NYTPhotoViewer/NYTPhotoCaptionView.h>

@interface NYTPhotoCaptionViewTests : XCTestCase

@end

@implementation NYTPhotoCaptionViewTests

- (void)testDesignatedInitializerAcceptsNilForTitle {
    XCTAssertNoThrow([[NYTPhotoCaptionView alloc] initWithAttributedTitle:nil attributedSummary:[[NSAttributedString alloc] init] attributedCredit:[[NSAttributedString alloc] init]]);
}

- (void)testDesignatedInitializerAcceptsNilForSummary {
    XCTAssertNoThrow([[NYTPhotoCaptionView alloc] initWithAttributedTitle:[[NSAttributedString alloc] init] attributedSummary:nil attributedCredit:[[NSAttributedString alloc] init]]);
}

- (void)testDesignatedInitializerAcceptsNilForCredit {
    XCTAssertNoThrow([[NYTPhotoCaptionView alloc] initWithAttributedTitle:[[NSAttributedString alloc] init] attributedSummary:[[NSAttributedString alloc] init] attributedCredit:nil]);
}

@end
