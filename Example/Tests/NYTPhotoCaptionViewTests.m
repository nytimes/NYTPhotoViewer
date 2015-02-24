//
//  NYTPhotoCaptionViewTests.m
//  NYTPhotoViewer
//
//  Created by Brian Capps on 2/24/15.
//  Copyright (c) 2015 Brian Capps. All rights reserved.
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

- (void)testDesignatedInitializerSetsProperties {
    NSAttributedString *title = [[NSAttributedString alloc] init];
    NSAttributedString *summary = [[NSAttributedString alloc] init];
    NSAttributedString *credit = [[NSAttributedString alloc] init];

    NYTPhotoCaptionView *captionView = [[NYTPhotoCaptionView alloc] initWithAttributedTitle:title attributedSummary:summary attributedCredit:credit];
    
    XCTAssertEqualObjects(title, captionView.attributedTitle);
    XCTAssertEqualObjects(summary, captionView.attributedSummary);
    XCTAssertEqualObjects(credit, captionView.attributedCredit);
}

@end
