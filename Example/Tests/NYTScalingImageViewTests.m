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

@property (nonatomic, strong) NSData *imageData;

@end

@implementation NYTScalingImageViewTests

- (NSData *)imageData {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _imageData = [NSData dataWithContentsOfFile:kGifPath];
    });
    return _imageData;
}

- (void)testInitializationAcceptsNil {
    XCTAssertNoThrow([[NYTScalingImageView alloc] initWithImageData:nil frame:CGRectZero]);
}

- (void)testImageViewExistsAfterInitialization {
    NYTScalingImageView *scalingImageView = [[NYTScalingImageView alloc] initWithImageData:nil frame:CGRectZero];
    XCTAssertNotNil(scalingImageView.imageView);
}

- (void)testInitializationSetsImage {
    NYTScalingImageView *scalingImageView = [[NYTScalingImageView alloc] initWithImageData:self.imageData frame:CGRectZero];

#ifdef ANIMATED_GIF_SUPPORT
    XCTAssertEqual(self.imageData, scalingImageView.imageView.animatedImage.data);
#else
    XCTAssertNotNil(scalingImageView.imageView.image);
#endif
}

- (void)testUpdateImageUpdatesImage {
    NSData *image2 = [NSData dataWithContentsOfFile:kGifPath];
    
    NYTScalingImageView *scalingImageView = [[NYTScalingImageView alloc] initWithImageData:self.imageData frame:CGRectZero];
    [scalingImageView updateImageData:image2];
    
#ifdef ANIMATED_GIF_SUPPORT
    XCTAssertEqual(image2, scalingImageView.imageView.animatedImage.data);
#else
    XCTAssertNotNil(scalingImageView.imageView.image);
#endif
}

- (void)testImageViewIsOfCorrectKindAfterInitialization {
    NYTScalingImageView *scalingImageViewer = [[NYTScalingImageView alloc] initWithImageData:self.imageData frame:CGRectZero];
#ifdef ANIMATED_GIF_SUPPORT
    XCTAssertTrue([scalingImageViewer.imageView isKindOfClass:FLAnimatedImageView.class]);
#else
    XCTAssertTrue([scalingImageViewer.imageView isKindOfClass:UIImageView.class]);
#endif
}

@end
