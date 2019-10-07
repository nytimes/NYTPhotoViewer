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
#import "NYTPhotoViewerArrayDataSource.h"


@interface NYTPhotosViewControllerTests : XCTestCase
@end

@interface NYTPhotosViewController (Testing)

- (void)dismissViewControllerAnimated:(BOOL)animated userInitiated:(BOOL)isUserInitiated completion:(void (^)(void))completion;
- (void)didPanWithGestureRecognizer:(UIPanGestureRecognizer *)panGestureRecognizer;
- (void)doneButtonTapped:(id)sender;

@end

@implementation NYTPhotosViewControllerTests

- (void)testPanGestureRecognizerExistsAfterInitialization {
    NYTPhotosViewController *photosViewController = [[NYTPhotosViewController alloc] initWithDataSource:[self newTestPhotosDataSource]];
    XCTAssertNotNil(photosViewController.panGestureRecognizer);
}

- (void)testPanGestureRecognizerHasAssociatedViewAfterViewDidLoad {
    NYTPhotosViewController *photosViewController = [[NYTPhotosViewController alloc] initWithDataSource:[self newTestPhotosDataSource]];
    __unused id view = photosViewController.view;
    XCTAssertNotNil(photosViewController.panGestureRecognizer.view);
}

- (void)testSingleTapGestureRecognizerExistsAfterInitialization {
    NYTPhotosViewController *photosViewController = [[NYTPhotosViewController alloc] initWithDataSource:[self newTestPhotosDataSource]];
    XCTAssertNotNil(photosViewController.singleTapGestureRecognizer);
}

- (void)testSingleTapGestureRecognizerHasAssociatedViewAfterViewDidLoad {
    NYTPhotosViewController *photosViewController = [[NYTPhotosViewController alloc] initWithDataSource:[self newTestPhotosDataSource]];
    __unused id view = photosViewController.view;
    XCTAssertNotNil(photosViewController.singleTapGestureRecognizer.view);
}

- (void)testPageViewControllerExistsAfterInitialization {
    NYTPhotosViewController *photosViewController = [[NYTPhotosViewController alloc] initWithDataSource:[self newTestPhotosDataSource]];
    [photosViewController viewDidLoad];

    XCTAssertNotNil(photosViewController.pageViewController);
}

- (void)testPageViewControllerDoesNotHaveAssociatedSuperviewBeforeViewLoads {
    NYTPhotosViewController *photosViewController = [[NYTPhotosViewController alloc] initWithDataSource:[self newTestPhotosDataSource]];
    XCTAssertNil(photosViewController.pageViewController.view.superview);
}

- (void)testPageViewControllerHasAssociatedSuperviewAfterViewLoads {
    NYTPhotosViewController *photosViewController = [[NYTPhotosViewController alloc] initWithDataSource:[self newTestPhotosDataSource]];
    photosViewController.view = photosViewController.view; // Referencing the view loads it.
    XCTAssertNotNil(photosViewController.pageViewController.view.superview);
}

- (void)testCurrentlyDisplayedPhotoIsFirstAfterConvenienceInitialization {
    NSArray *photos = [self newTestPhotos];

     NYTPhotoViewerArrayDataSource *dataSource = [[NYTPhotoViewerArrayDataSource alloc] initWithPhotos:photos];

    NYTPhotosViewController *photosViewController = [[NYTPhotosViewController alloc] initWithDataSource:dataSource];
    [photosViewController viewDidLoad];

    XCTAssertEqualObjects(photos.firstObject, photosViewController.currentlyDisplayedPhoto);
}


- (void)testCurrentlyDisplayedPhotoIsAccurateAfterSettingInitialPhoto {
    NSArray *photos = [self newTestPhotos];
    NYTPhotoViewerArrayDataSource *dataSource = [[NYTPhotoViewerArrayDataSource alloc] initWithPhotos:photos];

    NYTPhotosViewController *photosViewController = [[NYTPhotosViewController alloc] initWithDataSource:dataSource initialPhoto:photos.lastObject delegate:nil];
    [photosViewController viewDidLoad];

    XCTAssertEqualObjects(photos.lastObject, photosViewController.currentlyDisplayedPhoto);
}

- (void)testCurrentlyDisplayedPhotoIsAccurateAfterDisplayPhotoCall {
    NSArray *photos = [self newTestPhotos];
    NYTPhotoViewerArrayDataSource *dataSource = [[NYTPhotoViewerArrayDataSource alloc] initWithPhotos:photos];

    NYTPhotosViewController *photosViewController = [[NYTPhotosViewController alloc] initWithDataSource:dataSource initialPhoto:photos.lastObject delegate:nil];
    [photosViewController viewDidLoad];
    [photosViewController displayPhoto:photos.firstObject animated:NO];

    XCTAssertEqualObjects(photos.firstObject, photosViewController.currentlyDisplayedPhoto);
}

- (void)testLeftBarButtonItemIsPopulatedAfterInitialization {
    NYTPhotosViewController *photosViewController = [[NYTPhotosViewController alloc] initWithDataSource:[self newTestPhotosDataSource]];
    XCTAssertNotNil(photosViewController.leftBarButtonItem);
}

- (void)testLeftBarButtonItemIsNilAfterSettingToNil {
    NYTPhotosViewController *photosViewController = [[NYTPhotosViewController alloc] initWithDataSource:[self newTestPhotosDataSource]];
    photosViewController.leftBarButtonItem = nil;
    XCTAssertNil(photosViewController.leftBarButtonItem);
}

- (void)testLeftBarButtonItemsArePopulatedAfterInitialization {
    NYTPhotosViewController *photosViewController = [[NYTPhotosViewController alloc] initWithDataSource:[self newTestPhotosDataSource]];
    XCTAssertNotNil(photosViewController.leftBarButtonItems);
}

- (void)testLeftBarButtonItemsAreNilAfterSettingToNil {
    NYTPhotosViewController *photosViewController = [[NYTPhotosViewController alloc] initWithDataSource:[self newTestPhotosDataSource]];
    photosViewController.leftBarButtonItems = nil;
    XCTAssertNil(photosViewController.leftBarButtonItems);
}

- (void)testRightBarButtonItemIsPopulatedAfterInitialization {
    NYTPhotosViewController *photosViewController = [[NYTPhotosViewController alloc] initWithDataSource:[self newTestPhotosDataSource]];
    XCTAssertNotNil(photosViewController.rightBarButtonItem);
}

- (void)testRightBarButtonItemIsNilAfterSettingToNil {
    NYTPhotosViewController *photosViewController = [[NYTPhotosViewController alloc] initWithDataSource:[self newTestPhotosDataSource]];
    photosViewController.rightBarButtonItem = nil;
    XCTAssertNil(photosViewController.rightBarButtonItem);
}

- (void)testRightBarButtonItemsArePopulatedAfterInitialization {
    NYTPhotosViewController *photosViewController = [[NYTPhotosViewController alloc] initWithDataSource:[self newTestPhotosDataSource]];
    XCTAssertNotNil(photosViewController.rightBarButtonItems);
}

- (void)testRightBarButtonItemsAreNilAfterSettingToNil {
    NYTPhotosViewController *photosViewController = [[NYTPhotosViewController alloc] initWithDataSource:[self newTestPhotosDataSource]];
    photosViewController.rightBarButtonItems = nil;
    XCTAssertNil(photosViewController.rightBarButtonItems);
}

- (void)testOneArgConvenienceInitializerAcceptsNil {
    XCTAssertNoThrow([[NYTPhotosViewController alloc] initWithDataSource:nil]);
}

- (void)testTwoArgConvenienceInitializerAcceptsNilForPhotosParameter {
    XCTAssertNoThrow([[NYTPhotosViewController alloc] initWithDataSource:nil initialPhoto:[[NYTExamplePhoto alloc] init] delegate:nil]);
}

- (void)testTwoArgConvenienceInitializerAcceptsNilForInitialPhotoParameter {
    XCTAssertNoThrow([[NYTPhotosViewController alloc] initWithDataSource:[self newTestPhotosDataSource] initialPhoto:nil delegate:nil]);
}

- (void)testTwoArgConvenienceInitializerAcceptsNilForBothParameters {
    XCTAssertNoThrow([[NYTPhotosViewController alloc] initWithDataSource:nil initialPhoto:nil delegate:nil]);
}

- (void)testDesignatedInitializerAcceptsNilForPhotosParameter {
    id delegateMock = OCMProtocolMock(@protocol(NYTPhotosViewControllerDelegate));
    XCTAssertNoThrow([[NYTPhotosViewController alloc] initWithDataSource:nil initialPhoto:[NYTExamplePhoto new] delegate:delegateMock]);
}

- (void)testDesignatedInitializerAcceptsNilForInitialPhotoParameter {
    id delegateMock = OCMProtocolMock(@protocol(NYTPhotosViewControllerDelegate));
    XCTAssertNoThrow([[NYTPhotosViewController alloc] initWithDataSource:[self newTestPhotosDataSource] initialPhoto:nil delegate:delegateMock]);
}

- (void)testDesignatedInitializerAcceptsNilForDelegateParameter {
    XCTAssertNoThrow([[NYTPhotosViewController alloc] initWithDataSource:[self newTestPhotosDataSource] initialPhoto:[NYTExamplePhoto new] delegate:nil]);
}

- (void)testDesignatedInitializerAcceptsNilForAllParameters {
    XCTAssertNoThrow([[NYTPhotosViewController alloc] initWithDataSource:nil initialPhoto:nil delegate:nil]);
}

- (void)testDesignatedInitializerSetsDelegate {
    id delegateMock = OCMProtocolMock(@protocol(NYTPhotosViewControllerDelegate));
    NYTPhotosViewController *sut = [[NYTPhotosViewController alloc] initWithDataSource:[self newTestPhotosDataSource] initialPhoto:nil delegate:delegateMock];

    XCTAssertEqual(sut.delegate, delegateMock);
}

- (void)testDisplayPhotoAcceptsNil {
    NYTPhotosViewController *photosViewController = [[NYTPhotosViewController alloc] initWithDataSource:[self newTestPhotosDataSource]];
    XCTAssertNoThrow([photosViewController displayPhoto:nil animated:NO]);
}

- (void)testDisplayPhotoDoesNothingWhenPassedPhotoOutsideDataSource {
    NSArray *photos = [self newTestPhotos];
    NYTPhotoViewerArrayDataSource *dataSource = [[NYTPhotoViewerArrayDataSource alloc] initWithPhotos:photos];

    NYTPhotosViewController *photosViewController = [[NYTPhotosViewController alloc] initWithDataSource:dataSource initialPhoto:photos.firstObject delegate:nil];
    [photosViewController viewDidLoad];

    NYTExamplePhoto *invalidPhoto = [[NYTExamplePhoto alloc] init];

    [photosViewController displayPhoto:invalidPhoto animated:NO];
    XCTAssertEqualObjects(photos.firstObject, photosViewController.currentlyDisplayedPhoto);
}

- (void)testDisplayPhotoMovesToCorrectPhoto {
    NSArray *photos = [self newTestPhotos];
    NYTPhotosViewController *photosViewController = [[NYTPhotosViewController alloc] initWithDataSource:[self newTestPhotosDataSource] initialPhoto:photos.firstObject delegate:nil];
    [photosViewController viewDidLoad];

    NYTExamplePhoto *photoToDisplay = photos[2];

    [photosViewController displayPhoto:photoToDisplay animated:NO];
    XCTAssertEqualObjects(photoToDisplay, photosViewController.currentlyDisplayedPhoto);
}

- (void)testUpdateImageForPhotoAcceptsNil {
    NYTPhotosViewController *photosViewController = [[NYTPhotosViewController alloc] initWithDataSource:[self newTestPhotosDataSource]];
    XCTAssertNoThrow([photosViewController updatePhoto:nil]);
}

- (void)testUpdateImageForPhotoDoesNothingWhenPassedPhotoOutsideDataSource {
    NSArray *photos = [self newTestPhotos];
    NYTPhotosViewController *photosViewController = [[NYTPhotosViewController alloc] initWithDataSource:[self newTestPhotosDataSource] initialPhoto:photos.firstObject delegate:nil];
    NYTExamplePhoto *invalidPhoto = [[NYTExamplePhoto alloc] init];
    invalidPhoto.image = [[UIImage alloc] init];

    [photosViewController updatePhoto:invalidPhoto];

    XCTAssertEqualObjects(photosViewController.currentlyDisplayedPhoto.image, [photos.firstObject image]);
}

- (void)testUpdateImageForPhotoUpdatesImage {
    NSArray *photos = [self newTestPhotos];
    NYTPhotosViewController *photosViewController = [[NYTPhotosViewController alloc] initWithDataSource:[self newTestPhotosDataSource] initialPhoto:photos.firstObject delegate:nil];

    NYTExamplePhoto *photoToUpdate = photos.firstObject;
    photoToUpdate.image = [UIImage imageNamed:@"NYTimesBuilding" inBundle:[NSBundle bundleForClass:[self class]] compatibleWithTraitCollection:nil];

    [photosViewController updatePhoto:photoToUpdate];

    XCTAssertEqualObjects(photosViewController.currentlyDisplayedPhoto.image, photoToUpdate.image);
}

- (void)testViewIsntLoadedAfterInit {
    NYTPhotosViewController *photosViewController = [[NYTPhotosViewController alloc] initWithDataSource:[self newTestPhotosDataSource]];

    XCTAssertFalse(photosViewController.isViewLoaded);
}

- (void)testPageViewIsntLoadedAfterInit {
    NYTPhotosViewController *photosViewController = [[NYTPhotosViewController alloc] initWithDataSource:[self newTestPhotosDataSource]];

    XCTAssertFalse(photosViewController.pageViewController.isViewLoaded);
}

- (void)testDoneButtonDismissalUserInitiatedFlagIsTrue {
    NYTPhotosViewController *photosViewController = [[NYTPhotosViewController alloc] initWithDataSource:[self newTestPhotosDataSource]];

    id photosVCMock = OCMPartialMock(photosViewController);

    [photosViewController doneButtonTapped:nil];

    OCMVerify([photosVCMock dismissViewControllerAnimated:YES userInitiated:YES completion:[OCMArg any]]);
}

- (void)testGestureBasedDismissalUserInitiatedFlagIsTrue {
    NYTPhotosViewController *photosViewController = [[NYTPhotosViewController alloc] initWithDataSource:[self newTestPhotosDataSource]];

    id photosVCMock = OCMPartialMock(photosViewController);

    id gestureRecognizerMock = OCMClassMock([UIPanGestureRecognizer class]);
    OCMStub([gestureRecognizerMock state]).andReturn(UIGestureRecognizerStateBegan);

    [photosViewController didPanWithGestureRecognizer:gestureRecognizerMock];

    OCMVerify([photosVCMock dismissViewControllerAnimated:YES userInitiated:YES completion:[OCMArg any]]);
}

- (void)testProgrammaticDismissalUserInitiatedFlagIsFalse {
    NYTPhotosViewController *photosViewController = [[NYTPhotosViewController alloc] initWithDataSource:[self newTestPhotosDataSource]];

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

- (NYTPhotoViewerArrayDataSource *)newTestPhotosDataSource {

    return [NYTPhotoViewerArrayDataSource dataSourceWithPhotos:[self newTestPhotos]];

}

@end
