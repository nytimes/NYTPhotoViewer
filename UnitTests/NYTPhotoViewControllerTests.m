//
//  NYTPhotoViewControllerTests.m
//  NYTPhotoViewer
//
//  Created by Brian Capps on 2/24/15.
//  Copyright (c) 2015 NYTimes. All rights reserved.
//

@import UIKit;
@import XCTest;

#import <NYTPhotoViewer/NYTPhotoViewController.h>
#import "NYTExamplePhoto.h"

@interface NYTPhotoViewControllerTests : XCTestCase

@end

@implementation NYTPhotoViewControllerTests

- (void)testScalingImageViewExistsAferInitialization {
    NYTPhotoViewController *photoViewController = [[NYTPhotoViewController alloc] initWithPhoto:[self newTestPhoto] itemIndex:0 loadingView:nil notificationCenter:nil];
    XCTAssertNotNil(photoViewController.scalingImageView);
}

- (void)testDoubleTapGestureRecognizerExistsAferInitialization {
    NYTPhotoViewController *photoViewController = [[NYTPhotoViewController alloc] initWithPhoto:[self newTestPhoto] itemIndex:0 loadingView:nil notificationCenter:nil];
    XCTAssertNotNil(photoViewController.doubleTapGestureRecognizer);
}

- (void)testLoadingViewExistsAferNilInitialization {
    NYTPhotoViewController *photoViewController = [[NYTPhotoViewController alloc] initWithPhoto:[self newTestPhoto] itemIndex:0 loadingView:nil notificationCenter:nil];
    XCTAssertNotNil(photoViewController.loadingView);
}

- (void)testDesignatedInitializerAcceptsNilForPhotoArgument {
    XCTAssertNoThrow([[NYTPhotoViewController alloc] initWithPhoto:nil itemIndex:0 loadingView:[[UIView alloc] init] notificationCenter:[NSNotificationCenter defaultCenter]]);
}

- (void)testDesignatedInitializerAcceptsNilForLoadingViewArgument {
    XCTAssertNoThrow([[NYTPhotoViewController alloc] initWithPhoto:[self newTestPhoto] itemIndex:0 loadingView:nil notificationCenter:[NSNotificationCenter defaultCenter]]);
}

- (void)testDesignatedInitializerAcceptsNilForNotificationCenterArgument {
    XCTAssertNoThrow([[NYTPhotoViewController alloc] initWithPhoto:[self newTestPhoto] itemIndex:0 loadingView:[[UIView alloc] init] notificationCenter:nil]);
}

- (void)testDesignatedInitializerAcceptsNilForAllArguments {
    XCTAssertNoThrow([[NYTPhotoViewController alloc] initWithPhoto:nil itemIndex:0 loadingView:nil notificationCenter:nil]);
}

- (NYTExamplePhoto *)newTestPhoto {
    NYTExamplePhoto *testPhoto = [[NYTExamplePhoto alloc] init];
    return testPhoto;
}

@end
