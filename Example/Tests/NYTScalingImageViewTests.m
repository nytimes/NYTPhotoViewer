//
//  NYTScalingImageViewTests.m
//  NYTPhotoViewer
//
//  Created by Brian Capps on 2/26/15.
//  Copyright (c) 2015 NYTimes. All rights reserved.
//

@import UIKit;
@import XCTest;

#import <NYTPhotoViewer/NYTScalingImageView.h>

@interface NYTScalingImageViewTests : XCTestCase

@end

@implementation NYTScalingImageViewTests

- (void)testInitializationAcceptsNil {
    XCTAssertNoThrow([[NYTScalingImageView alloc] initWithImage:nil frame:CGRectZero]);
}

- (void)testImageViewExistsAfterInitialization {
    NYTScalingImageView *scalingImageView = [[NYTScalingImageView alloc] initWithImage:nil frame:CGRectZero];
    XCTAssertNotNil(scalingImageView.imageView);
}

- (void)testInitializationSetsImage {
    UIImage *image = [[UIImage alloc] init];
    NYTScalingImageView *scalingImageView = [[NYTScalingImageView alloc] initWithImage:image frame:CGRectZero];
    XCTAssertEqualObjects(image, scalingImageView.imageView.image);
}

- (void)testUpdateImageUpdatesImage {
    UIImage *image1 = [[UIImage alloc] init];
    UIImage *image2 = [[UIImage alloc] init];
    
    NYTScalingImageView *scalingImageView = [[NYTScalingImageView alloc] initWithImage:image1 frame:CGRectZero];
    [scalingImageView updateImage:image2];
    
    XCTAssertEqual(image2, scalingImageView.imageView.image);
}

@end
