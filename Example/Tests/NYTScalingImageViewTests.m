//
//  NYTScalingImageViewTests.m
//  NYTPhotoViewer
//
//  Created by Brian Capps on 2/26/15.
//  Copyright (c) 2015 NYTimes. All rights reserved.
//

@import UIKit;
@import XCTest;

#define kGifPath  [[NSBundle bundleForClass:self.class] pathForResource:@"giphy" ofType:@"gif"]

#import <NYTPhotoViewer/NYTScalingImageView.h>

#ifdef ANIMATED_GIF_SUPPORT
#import <FLAnimatedImage/FLAnimatedImage.h>
#endif

@interface NYTScalingImageViewTests : XCTestCase

@end

@implementation NYTScalingImageViewTests

- (void)testInitializationAcceptsNil {
    XCTAssertNoThrow([[NYTScalingImageView alloc] initWithImageData:nil frame:CGRectZero]);
}

- (void)testImageViewExistsAfterInitialization {
    NYTScalingImageView *scalingImageView = [[NYTScalingImageView alloc] initWithImageData:nil frame:CGRectZero];
    XCTAssertNotNil(scalingImageView.imageView);
}

- (void)testInitializationSetsImage {
    NSData *image = [NSData dataWithContentsOfFile:kGifPath];
    NYTScalingImageView *scalingImageView = [[NYTScalingImageView alloc] initWithImageData:image frame:CGRectZero];

#ifdef ANIMATED_GIF_SUPPORT
    XCTAssertEqual(image, scalingImageView.imageView.animatedImage.data);
#else
    XCTAssertNotNil(scalingImageView.imageView.image);
#endif
}

- (void)testUpdateImageUpdatesImage {
    NSData *image1 = [NSData dataWithContentsOfFile:kGifPath];
    NSData *image2 = [NSData dataWithContentsOfFile:kGifPath];
    
    NYTScalingImageView *scalingImageView = [[NYTScalingImageView alloc] initWithImageData:image1 frame:CGRectZero];
    [scalingImageView updateImageData:image2];
    
#ifdef ANIMATED_GIF_SUPPORT
    XCTAssertEqual(image2, scalingImageView.imageView.animatedImage.data);
#else
    XCTAssertNotNil(scalingImageView.imageView.image);
#endif
}

@end
