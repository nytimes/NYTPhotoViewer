//
//  NYTPhotosViewControllerTests.m
//  NYTPhotoViewer
//
//  Created by Brian Capps on 2/24/15.
//  Copyright (c) 2015 NYTimes. All rights reserved.
//

@import UIKit;
@import XCTest;

#import <NYTPhotoViewer/NYTPhotosViewController.h>
#import "NYTExamplePhoto.h"

@interface NYTPhotosViewControllerTests : XCTestCase

@end

@implementation NYTPhotosViewControllerTests

- (void)testPanGestureRecognizerExistsAfterInitialization {
    NYTPhotosViewController *photosViewController = [[NYTPhotosViewController alloc] initWithPhotos:[self newTestPhotos]];
    XCTAssertNotNil(photosViewController.panGestureRecognizer);
}

- (void)testPanGestureRecognizerHasAssociatedView {
    NYTPhotosViewController *photosViewController = [[NYTPhotosViewController alloc] initWithPhotos:[self newTestPhotos]];
    XCTAssertNotNil(photosViewController.panGestureRecognizer.view);
}

- (void)testSingleTapGestureRecognizerExistsAfterInitialization {
    NYTPhotosViewController *photosViewController = [[NYTPhotosViewController alloc] initWithPhotos:[self newTestPhotos]];
    XCTAssertNotNil(photosViewController.singleTapGestureRecognizer);
}

- (void)testSingleTapGestureRecognizerHasAssociatedView {
    NYTPhotosViewController *photosViewController = [[NYTPhotosViewController alloc] initWithPhotos:[self newTestPhotos]];
    XCTAssertNotNil(photosViewController.singleTapGestureRecognizer.view);
}

- (void)testPageViewControllerExistsAfterInitialization {
    NYTPhotosViewController *photosViewController = [[NYTPhotosViewController alloc] initWithPhotos:[self newTestPhotos]];
    XCTAssertNotNil(photosViewController.pageViewController);
}

- (void)testPageViewControllerDoesNotHaveAssociatedSuperviewBeforeViewLoads {
    NYTPhotosViewController *photosViewController = [[NYTPhotosViewController alloc] initWithPhotos:[self newTestPhotos]];
    XCTAssertNil(photosViewController.pageViewController.view.superview);
}

- (void)testPageViewControllerHasAssociatedSuperviewAfterViewLoads {
    NYTPhotosViewController *photosViewController = [[NYTPhotosViewController alloc] initWithPhotos:[self newTestPhotos]];
    photosViewController.view = photosViewController.view; // Referencing the view loads it.
    XCTAssertNotNil(photosViewController.pageViewController.view.superview);
}

- (void)testCurrentlyDisplayedPhotoIsFirstAfterConvenienceInitialization {
    NSArray *photos = [self newTestPhotos];
    NYTPhotosViewController *photosViewController = [[NYTPhotosViewController alloc] initWithPhotos:photos];
    
    XCTAssertEqualObjects(photos.firstObject, photosViewController.currentlyDisplayedPhoto);
}

- (void)testCurrentlyDisplayedPhotoIsAccurateAfterSettingInitialPhoto {
    NSArray *photos = [self newTestPhotos];
    NYTPhotosViewController *photosViewController = [[NYTPhotosViewController alloc] initWithPhotos:photos initialPhoto:photos.lastObject];
    
    XCTAssertEqualObjects(photos.lastObject, photosViewController.currentlyDisplayedPhoto);
}

- (void)testCurrentlyDisplayedPhotoIsAccurateAfterDisplayPhotoCall {
    NSArray *photos = [self newTestPhotos];
    NYTPhotosViewController *photosViewController = [[NYTPhotosViewController alloc] initWithPhotos:photos initialPhoto:photos.lastObject];
    [photosViewController displayPhoto:photos.firstObject animated:NO];
    
    XCTAssertEqualObjects(photos.firstObject, photosViewController.currentlyDisplayedPhoto);
}

- (void)testLeftBarButtonItemIsPopulatedAfterInitialization {
    NYTPhotosViewController *photosViewController = [[NYTPhotosViewController alloc] initWithPhotos:[self newTestPhotos]];
    XCTAssertNotNil(photosViewController.leftBarButtonItem);
}

- (void)testLeftBarButtonItemIsNilAfterSettingToNil {
    NYTPhotosViewController *photosViewController = [[NYTPhotosViewController alloc] initWithPhotos:[self newTestPhotos]];
    photosViewController.leftBarButtonItem = nil;
    XCTAssertNil(photosViewController.leftBarButtonItem);
}

- (void)testRightBarButtonItemIsPopulatedAfterInitialization {
    NYTPhotosViewController *photosViewController = [[NYTPhotosViewController alloc] initWithPhotos:[self newTestPhotos]];
    XCTAssertNotNil(photosViewController.rightBarButtonItem);
}

- (void)testRightBarButtonItemIsNilAfterSettingToNil {
    NYTPhotosViewController *photosViewController = [[NYTPhotosViewController alloc] initWithPhotos:[self newTestPhotos]];
    photosViewController.rightBarButtonItem = nil;
    XCTAssertNil(photosViewController.rightBarButtonItem);
}

- (void)testConvenienceInitializerAcceptsNil {
    XCTAssertNoThrow([[NYTPhotosViewController alloc] initWithPhotos:nil]);
}

- (void)testDesignatedInitializerAcceptsNilForPhotosParameter {
    XCTAssertNoThrow([[NYTPhotosViewController alloc] initWithPhotos:nil initialPhoto:[[NYTExamplePhoto alloc] init]]);
}

- (void)testDesignatedInitializerAcceptsNilForInitialPhotoParameter {
    XCTAssertNoThrow([[NYTPhotosViewController alloc] initWithPhotos:[self newTestPhotos] initialPhoto:nil]);
}

- (void)testDesignatedInitializerAcceptsNilForBothParameters {
    XCTAssertNoThrow([[NYTPhotosViewController alloc] initWithPhotos:nil initialPhoto:nil]);
}

- (void)testDisplayPhotoAcceptsNil {
    NYTPhotosViewController *photosViewController = [[NYTPhotosViewController alloc] initWithPhotos:[self newTestPhotos]];
    XCTAssertNoThrow([photosViewController displayPhoto:nil animated:NO]);
}

- (void)testDisplayPhotoDoesNothingWhenPassedPhotoOutsideDataSource {
    NSArray *photos = [self newTestPhotos];
    NYTPhotosViewController *photosViewController = [[NYTPhotosViewController alloc] initWithPhotos:photos initialPhoto:photos.firstObject];
    NYTExamplePhoto *invalidPhoto = [[NYTExamplePhoto alloc] init];
    
    [photosViewController displayPhoto:invalidPhoto animated:NO];
    XCTAssertEqualObjects(photos.firstObject, photosViewController.currentlyDisplayedPhoto);
}

- (void)testDisplayPhotoMovesToCorrectPhoto {
    NSArray *photos = [self newTestPhotos];
    NYTPhotosViewController *photosViewController = [[NYTPhotosViewController alloc] initWithPhotos:photos initialPhoto:photos.firstObject];
    NYTExamplePhoto *photoToDisplay = photos[2];
    
    [photosViewController displayPhoto:photoToDisplay animated:NO];
    XCTAssertEqualObjects(photoToDisplay, photosViewController.currentlyDisplayedPhoto);
}

- (void)testUpdateImageForPhotoAcceptsNil {
    NYTPhotosViewController *photosViewController = [[NYTPhotosViewController alloc] initWithPhotos:[self newTestPhotos]];
    XCTAssertNoThrow([photosViewController updateImageForPhoto:nil]);
}

- (void)testUpdateImageForPhotoDoesNothingWhenPassedPhotoOutsideDataSource {
    NSArray *photos = [self newTestPhotos];
    NYTPhotosViewController *photosViewController = [[NYTPhotosViewController alloc] initWithPhotos:photos initialPhoto:photos.firstObject];
    NYTExamplePhoto *invalidPhoto = [[NYTExamplePhoto alloc] init];
    invalidPhoto.image = [[UIImage alloc] init];
    
    [photosViewController updateImageForPhoto:invalidPhoto];
    
    XCTAssertEqualObjects(photosViewController.currentlyDisplayedPhoto.image, [photos.firstObject image]);
}

- (void)testUpdateImageForPhotoUpdatesImage {
    NSArray *photos = [self newTestPhotos];
    NYTPhotosViewController *photosViewController = [[NYTPhotosViewController alloc] initWithPhotos:photos initialPhoto:photos.firstObject];
    NYTExamplePhoto *photoToUpdate = photos.firstObject;
    photoToUpdate.image = [[UIImage alloc] init];
    
    [photosViewController updateImageForPhoto:photoToUpdate];
    
    XCTAssertEqualObjects(photosViewController.currentlyDisplayedPhoto.image, photoToUpdate.image);
}

#pragma mark - Helpers

- (NSArray *)newTestPhotos {
    NSMutableArray *photos = [NSMutableArray array];
    
    for (int i = 0; i < 5; i++) {
        NYTExamplePhoto *photo = [[NYTExamplePhoto alloc] init];
        [photos addObject:photo];
    }
    
    return photos;
}

@end
