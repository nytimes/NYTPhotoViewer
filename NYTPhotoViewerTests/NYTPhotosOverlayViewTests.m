//
//  NYTPhotosOverlayViewTests.m
//  NYTPhotoViewer
//
//  Created by Brian Capps on 2/26/15.
//  Copyright (c) 2015 NYTimes. All rights reserved.
//

@import UIKit;
@import XCTest;

#import <NYTPhotoViewer/NYTPhotosOverlayView.h>

@interface NYTPhotosOverlayViewTests : XCTestCase
@end

@implementation NYTPhotosOverlayViewTests

- (void)testNavigationBarExistsAfterInitialization {
    NYTPhotosOverlayView *overlayView = [[NYTPhotosOverlayView alloc] init];
    XCTAssertNotNil(overlayView.navigationBar);
}

- (void)testLeftBarButtonItemSetterAffectsNavigationBar {
    NYTPhotosOverlayView *overlayView = [[NYTPhotosOverlayView alloc] init];
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:nil action:nil];
    overlayView.leftBarButtonItem = leftBarButtonItem;
    XCTAssertEqualObjects(leftBarButtonItem, [overlayView.navigationBar.items.firstObject leftBarButtonItem]);
}

- (void)testRightBarButtonItemSetterAffectsNavigationBar {
    NYTPhotosOverlayView *overlayView = [[NYTPhotosOverlayView alloc] init];
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:nil action:nil];
    overlayView.rightBarButtonItem = rightBarButtonItem;
    XCTAssertEqualObjects(rightBarButtonItem, [overlayView.navigationBar.items.firstObject rightBarButtonItem]);
}

- (void)testTitleSetterAffectsNavigationBar {
    NYTPhotosOverlayView *overlayView = [[NYTPhotosOverlayView alloc] init];
    NSString *title = @"title";
    overlayView.title = title;
    XCTAssertEqualObjects(title, [overlayView.navigationBar.items.firstObject title]);
}

- (void)testTitleTextAttributesSetterAffectsNavigationBar {
    NYTPhotosOverlayView *overlayView = [[NYTPhotosOverlayView alloc] init];
    NSDictionary *titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor orangeColor]};
    overlayView.titleTextAttributes = titleTextAttributes;
    XCTAssertEqualObjects(titleTextAttributes, overlayView.navigationBar.titleTextAttributes);
}

@end
