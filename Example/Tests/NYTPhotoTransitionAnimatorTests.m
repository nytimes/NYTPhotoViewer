//
//  NYTPhotoTransitionAnimatorTests.m
//  NYTPhotoViewer
//
//  Created by Brian Capps on 2/26/15.
//  Copyright (c) 2015 Brian Capps. All rights reserved.
//

@import UIKit;
@import XCTest;

#import <NYTPhotoViewer/NYTPhotoTransitionAnimator.h>

@interface NYTPhotoTransitionAnimatorTests : XCTestCase

@end

@implementation NYTPhotoTransitionAnimatorTests

- (void)testNewAnimationViewCopiesContents {
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    NSString *imagePath = [bundle pathForResource:@"testImage".stringByDeletingPathExtension ofType:@"testImage".pathExtension];
    UIImage *testImage = [UIImage imageWithContentsOfFile:imagePath];
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:testImage];
    UIView *animationView = [NYTPhotoTransitionAnimator newAnimationViewFromView:imageView];
    XCTAssertEqual(imageView.layer.contents, animationView.layer.contents);
}

- (void)testNewAnimationViewReturnsNilWhenPassedNil {
    XCTAssertNil([NYTPhotoTransitionAnimator newAnimationViewFromView:nil]);
}

@end
