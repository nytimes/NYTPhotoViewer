//
//  NYTPhotosViewControllerTests.m
//  NYTPhotoViewer
//
//  Created by Brian Capps on 2/24/15.
//  Copyright (c) 2015 NYTimes. All rights reserved.
//

@import UIKit;
@import XCTest;

#import <OCMock/OCMock.h>

#import <NYTPhotoViewer/NYTPhotosViewController.h>
#import "NYTExamplePhoto.h"

@interface NYTPhotosViewControllerTests : XCTestCase
@end

@interface NYTPhotosViewController (Testing)

- (void)dismissViewControllerAnimated:(BOOL)animated userInitiated:(BOOL)isUserInitiated completion:(void (^)(void))completion;
- (void)didPanWithGestureRecognizer:(UIPanGestureRecognizer *)panGestureRecognizer;
- (void)doneButtonTapped:(id)sender;

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

- (void)testOneArgConvenienceInitializerAcceptsNil {
    XCTAssertNoThrow([[NYTPhotosViewController alloc] initWithPhotos:nil]);
}

- (void)testTwoArgConvenienceInitializerAcceptsNilForPhotosParameter {
    XCTAssertNoThrow([[NYTPhotosViewController alloc] initWithPhotos:nil initialPhoto:[[NYTExamplePhoto alloc] init]]);
}

- (void)testTwoArgConvenienceInitializerAcceptsNilForInitialPhotoParameter {
    XCTAssertNoThrow([[NYTPhotosViewController alloc] initWithPhotos:[self newTestPhotos] initialPhoto:nil]);
}

- (void)testTwoArgConvenienceInitializerAcceptsNilForBothParameters {
    XCTAssertNoThrow([[NYTPhotosViewController alloc] initWithPhotos:nil initialPhoto:nil]);
}

- (void)testDesignatedInitializerAcceptsNilForPhotosParameter {
    id delegateMock = OCMProtocolMock(@protocol(NYTPhotosViewControllerDelegate));
    XCTAssertNoThrow([[NYTPhotosViewController alloc] initWithPhotos:nil initialPhoto:[NYTExamplePhoto new] delegate:delegateMock]);
}

- (void)testDesignatedInitializerAcceptsNilForInitialPhotoParameter {
    id delegateMock = OCMProtocolMock(@protocol(NYTPhotosViewControllerDelegate));
    XCTAssertNoThrow([[NYTPhotosViewController alloc] initWithPhotos:[self newTestPhotos] initialPhoto:nil delegate:delegateMock]);
}

- (void)testDesignatedInitializerAcceptsNilForDelegateParameter {
    XCTAssertNoThrow([[NYTPhotosViewController alloc] initWithPhotos:[self newTestPhotos] initialPhoto:[NYTExamplePhoto new] delegate:nil]);
}

- (void)testDesignatedInitializerAcceptsNilForAllParameters {
    XCTAssertNoThrow([[NYTPhotosViewController alloc] initWithPhotos:nil initialPhoto:nil delegate:nil]);
}

- (void)testDesignatedInitializerSetsDelegate {
    id delegateMock = OCMProtocolMock(@protocol(NYTPhotosViewControllerDelegate));
    NYTPhotosViewController *sut = [[NYTPhotosViewController alloc] initWithPhotos:[self newTestPhotos] initialPhoto:nil delegate:delegateMock];

    XCTAssertEqual(sut.delegate, delegateMock);
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

- (void)testDoneButtonDismissalUserInitiatedFlagIsTrue {
    NSArray *photos = [self newTestPhotos];
    NYTPhotosViewController *photosViewController = [[NYTPhotosViewController alloc] initWithPhotos:photos];

    id photosVCMock = OCMPartialMock(photosViewController);

    [photosViewController doneButtonTapped:nil];

    OCMVerify([photosVCMock dismissViewControllerAnimated:YES userInitiated:YES completion:[OCMArg any]]);
}

- (void)testGestureBasedDismissalUserInitiatedFlagIsTrue {
    NSArray *photos = [self newTestPhotos];
    NYTPhotosViewController *photosViewController = [[NYTPhotosViewController alloc] initWithPhotos:photos];

    id photosVCMock = OCMPartialMock(photosViewController);

    id gestureRecognizerMock = OCMClassMock([UIPanGestureRecognizer class]);
    OCMStub([gestureRecognizerMock state]).andReturn(UIGestureRecognizerStateBegan);

    [photosViewController didPanWithGestureRecognizer:gestureRecognizerMock];

    OCMVerify([photosVCMock dismissViewControllerAnimated:YES userInitiated:YES completion:[OCMArg any]]);
}

- (void)testProgrammaticDismissalUserInitiatedFlagIsFalse {
    NSArray *photos = [self newTestPhotos];
    NYTPhotosViewController *photosViewController = [[NYTPhotosViewController alloc] initWithPhotos:photos];

    id photosVCMock = OCMPartialMock(photosViewController);

    [photosViewController dismissViewControllerAnimated:YES completion:nil];

    OCMVerify([photosVCMock dismissViewControllerAnimated:YES userInitiated:NO completion:[OCMArg any]]);
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
