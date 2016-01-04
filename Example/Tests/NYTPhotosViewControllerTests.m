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

- (void)testPanGestureRecognizerHasAssociatedViewAfterViewDidLoad {
    NYTPhotosViewController *photosViewController = [[NYTPhotosViewController alloc] initWithPhotos:[self newTestPhotos]];
    __unused id view = photosViewController.view;
    XCTAssertNotNil(photosViewController.panGestureRecognizer.view);
}

- (void)testSingleTapGestureRecognizerExistsAfterInitialization {
    NYTPhotosViewController *photosViewController = [[NYTPhotosViewController alloc] initWithPhotos:[self newTestPhotos]];
    XCTAssertNotNil(photosViewController.singleTapGestureRecognizer);
}

- (void)testSingleTapGestureRecognizerHasAssociatedViewAfterViewDidLoad {
    NYTPhotosViewController *photosViewController = [[NYTPhotosViewController alloc] initWithPhotos:[self newTestPhotos]];
    __unused id view = photosViewController.view;
    XCTAssertNotNil(photosViewController.singleTapGestureRecognizer.view);
}

- (void)testPageViewControllerExistsAfterInitialization {
    NYTPhotosViewController *photosViewController = [[NYTPhotosViewController alloc] initWithPhotos:[self newTestPhotos]];
    [photosViewController viewDidLoad];
    
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
    [photosViewController viewDidLoad];

    XCTAssertEqualObjects(photos.firstObject, photosViewController.currentlyDisplayedPhoto);
}

- (void)testCurrentlyDisplayedPhotoIsAccurateAfterSettingInitialPhoto {
    NSArray *photos = [self newTestPhotos];
    NYTPhotosViewController *photosViewController = [[NYTPhotosViewController alloc] initWithPhotos:photos initialPhoto:photos.lastObject];
    [photosViewController viewDidLoad];

    XCTAssertEqualObjects(photos.lastObject, photosViewController.currentlyDisplayedPhoto);
}

- (void)testCurrentlyDisplayedPhotoIsAccurateAfterDisplayPhotoCall {
    NSArray *photos = [self newTestPhotos];
    NYTPhotosViewController *photosViewController = [[NYTPhotosViewController alloc] initWithPhotos:photos initialPhoto:photos.lastObject];
    [photosViewController viewDidLoad];
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

- (void)testLeftBarButtonItemsArePopulatedAfterInitialization {
    NYTPhotosViewController *photosViewController = [[NYTPhotosViewController alloc] initWithPhotos:[self newTestPhotos]];
    XCTAssertNotNil(photosViewController.leftBarButtonItems);
}

- (void)testLeftBarButtonItemsAreNilAfterSettingToNil {
    NYTPhotosViewController *photosViewController = [[NYTPhotosViewController alloc] initWithPhotos:[self newTestPhotos]];
    photosViewController.leftBarButtonItems = nil;
    XCTAssertNil(photosViewController.leftBarButtonItems);
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

- (void)testRightBarButtonItemsArePopulatedAfterInitialization {
    NYTPhotosViewController *photosViewController = [[NYTPhotosViewController alloc] initWithPhotos:[self newTestPhotos]];
    XCTAssertNotNil(photosViewController.rightBarButtonItems);
}

- (void)testRightBarButtonItemsAreNilAfterSettingToNil {
    NYTPhotosViewController *photosViewController = [[NYTPhotosViewController alloc] initWithPhotos:[self newTestPhotos]];
    photosViewController.rightBarButtonItems = nil;
    XCTAssertNil(photosViewController.rightBarButtonItems);
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
    [photosViewController viewDidLoad];
    
    NYTExamplePhoto *invalidPhoto = [[NYTExamplePhoto alloc] init];
    
    [photosViewController displayPhoto:invalidPhoto animated:NO];
    XCTAssertEqualObjects(photos.firstObject, photosViewController.currentlyDisplayedPhoto);
}

- (void)testDisplayPhotoMovesToCorrectPhoto {
    NSArray *photos = [self newTestPhotos];
    NYTPhotosViewController *photosViewController = [[NYTPhotosViewController alloc] initWithPhotos:photos initialPhoto:photos.firstObject];
    [photosViewController viewDidLoad];

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
    photoToUpdate.image = [UIImage imageNamed:@"NYTimesBuilding" inBundle:[NSBundle bundleForClass:[self class]] compatibleWithTraitCollection:nil];
    
    [photosViewController updateImageForPhoto:photoToUpdate];
    
    XCTAssertEqualObjects(photosViewController.currentlyDisplayedPhoto.image, photoToUpdate.image);
}

- (void)testViewIsntLoadedAfterInit {
    NSArray *photos = [self newTestPhotos];
    NYTPhotosViewController *photosViewController = [[NYTPhotosViewController alloc] initWithPhotos:photos];

    XCTAssertFalse(photosViewController.isViewLoaded);
}

- (void)testPageViewIsntLoadedAfterInit {
    NSArray *photos = [self newTestPhotos];
    NYTPhotosViewController *photosViewController = [[NYTPhotosViewController alloc] initWithPhotos:photos];

    XCTAssertFalse(photosViewController.pageViewController.isViewLoaded);
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
