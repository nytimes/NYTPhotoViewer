//
//  NYTPhotosViewControllerTests.m
//  NYTPhotoViewer
//
//  Created by Brian Capps on 2/24/15.
//  Copyright (c) 2015 Brian Capps. All rights reserved.
//

@import UIKit;
@import XCTest;

#import <NYTPhotoViewer/NYTPhotosViewController.h>
#import "NYTExamplePhoto.h"

@interface NYTPhotosViewControllerTests : XCTestCase

@end

@implementation NYTPhotosViewControllerTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}


/*
 @property (nonatomic, readonly) UIPanGestureRecognizer *panGestureRecognizer;
 @property (nonatomic, readonly) UITapGestureRecognizer *singleTapGestureRecognizer;
 @property (nonatomic, readonly) UIPageViewController *pageViewController;
 @property (nonatomic, readonly) id <NYTPhoto> currentlyDisplayedPhoto;
 @property (nonatomic) UIBarButtonItem *leftBarButtonItem;
 @property (nonatomic) UIBarButtonItem *rightBarButtonItem;
 @property (nonatomic, weak) id <NYTPhotosViewControllerDelegate> delegate;

 - (instancetype)initWithPhotos:(NSArray *)photos;
 - (instancetype)initWithPhotos:(NSArray *)photos initialPhoto:(id <NYTPhoto>)initialPhoto NS_DESIGNATED_INITIALIZER;
 - (void)displayPhoto:(id <NYTPhoto>)photo animated:(BOOL)animated;
 - (void)updateImageForPhoto:(id <NYTPhoto>)photo;

 @end

 @protocol NYTPhotosViewControllerDelegate <NSObject>

 @optional
 - (void)photosViewController:(NYTPhotosViewController *)photosViewController didDisplayPhoto:(id <NYTPhoto>)photo;
 - (void)photosViewControllerWillDismiss:(NYTPhotosViewController *)photosViewController;
 - (void)photosViewControllerDidDismiss:(NYTPhotosViewController *)photosViewController;
 - (UIView *)photosViewController:(NYTPhotosViewController *)photosViewController captionViewForPhoto:(id <NYTPhoto>)photo;
 - (UIView *)photosViewController:(NYTPhotosViewController *)photosViewController loadingViewForPhoto:(id <NYTPhoto>)photo;
 - (UIView *)photosViewController:(NYTPhotosViewController *)photosViewController referenceViewForPhoto:(id <NYTPhoto>)photo;
 - (NSDictionary *)photosViewController:(NYTPhotosViewController *)photosViewController overlayTitleTextAttributesForPhoto:(id <NYTPhoto>)photo;
 - (BOOL)photosViewController:(NYTPhotosViewController *)photosViewController handleLongPressForPhoto:(id <NYTPhoto>)photo withGestureRecognizer:(UILongPressGestureRecognizer *)longPressGestureRecognizer;
 - (BOOL)photosViewController:(NYTPhotosViewController *)photosViewController handleActionButtonTappedForPhoto:(id <NYTPhoto>)photo;
 - (void)photosViewController:(NYTPhotosViewController *)photosViewController actionCompletedWithActivityType:(NSString *)activityType;
 */

- (void)testPanGestureRecognizerExistsAferInitialization {
    NYTPhotosViewController *photosViewController = [[NYTPhotosViewController alloc] initWithPhotos:[self newTestPhotos]];
    XCTAssertNotNil(photosViewController.panGestureRecognizer);
}

- (void)testPanGestureRecognizerHasAssociatedView {
    NYTPhotosViewController *photosViewController = [[NYTPhotosViewController alloc] initWithPhotos:[self newTestPhotos]];
    XCTAssertNotNil(photosViewController.panGestureRecognizer.view);
}

- (void)testSingleTapGestureRecognizerExistsAferInitialization {
    NYTPhotosViewController *photosViewController = [[NYTPhotosViewController alloc] initWithPhotos:[self newTestPhotos]];
    XCTAssertNotNil(photosViewController.singleTapGestureRecognizer);
}

- (void)testSingleTapGestureRecognizerHasAssociatedView {
    NYTPhotosViewController *photosViewController = [[NYTPhotosViewController alloc] initWithPhotos:[self newTestPhotos]];
    XCTAssertNotNil(photosViewController.singleTapGestureRecognizer.view);
}

- (void)testPageViewControllerExistsAferInitialization {
    NYTPhotosViewController *photosViewController = [[NYTPhotosViewController alloc] initWithPhotos:[self newTestPhotos]];
    XCTAssertNotNil(photosViewController.pageViewController);
}

- (void)testPageViewControllerDoesNotHaveAssociatedSuperviewBeforeViewLoads {
    NYTPhotosViewController *photosViewController = [[NYTPhotosViewController alloc] initWithPhotos:[self newTestPhotos]];
    XCTAssertNil(photosViewController.pageViewController.view.superview);
}

- (void)testPageViewControllerHasAssociatedViewAfterViewLoads {
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
    invalidPhoto.identifier = @"invalid";
    
    [photosViewController displayPhoto:invalidPhoto animated:NO];
    XCTAssertEqualObjects(photos.firstObject, photosViewController.currentlyDisplayedPhoto);
}

- (void)testDisplayPhotoMovesToCorrectPhoto {
    NSArray *photos = [self newTestPhotos];
    NYTPhotosViewController *photosViewController = [[NYTPhotosViewController alloc] initWithPhotos:photos initialPhoto:photos.firstObject];
    NYTExamplePhoto *photoToDisplay =  photos[2];
    
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
    invalidPhoto.image = [self imageNamed:@"testImage"];
    invalidPhoto.identifier = @"invalid";
    
    [photosViewController updateImageForPhoto:invalidPhoto];
    
    XCTAssertEqualObjects(photosViewController.currentlyDisplayedPhoto.image, [photos.firstObject image]);
}

- (void)testUpdateImageForPhotoUpdatesImage {
    NSArray *photos = [self newTestPhotos];
    NYTPhotosViewController *photosViewController = [[NYTPhotosViewController alloc] initWithPhotos:photos initialPhoto:photos.firstObject];
    NYTExamplePhoto *photoToUpdate = photos.firstObject;
    photoToUpdate.image = [self imageNamed:@"testImage"];
    
    [photosViewController updateImageForPhoto:photoToUpdate];
    
    XCTAssertEqualObjects(photosViewController.currentlyDisplayedPhoto.image, photoToUpdate.image);
}

- (NSArray *)newTestPhotos {
    NSMutableArray *photos = [NSMutableArray array];
    
    for (int i = 0; i < 5; i++) {
        NYTExamplePhoto *photo = [[NYTExamplePhoto alloc] init];
        photo.identifier = @(i).stringValue;
        [photos addObject:photo];
    }
    
    return photos;
}

- (UIImage *)imageNamed:(NSString *)imageName {
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    NSString *imagePath = [bundle pathForResource:imageName.stringByDeletingPathExtension ofType:imageName.pathExtension];
    return [UIImage imageWithContentsOfFile:imagePath];
}

@end
