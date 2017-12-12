//
//  NYTPhotosDataSourceTests.m
//  NYTPhotoViewer
//
//  Created by Brian Capps on 2/26/15.
//  Copyright (c) 2015 NYTimes. All rights reserved.
//

@import UIKit;
@import XCTest;

#import "NYTExamplePhoto.h"
#import "NYTPhotoViewerArrayDataSource.h"

@interface NYTPhotoViewerArrayDataSourceTests : XCTestCase

@end

@implementation NYTPhotoViewerArrayDataSourceTests

- (void)testInitializerAcceptsNil {
    XCTAssertNoThrow([[NYTPhotoViewerArrayDataSource alloc] initWithPhotos:nil]);
}

- (void)testOutOfBoundsDoesNotCrash {
    NYTPhotoViewerArrayDataSource *dataSource = [[NYTPhotoViewerArrayDataSource alloc] initWithPhotos:nil];
    XCTAssertNoThrow(dataSource[1]);
}

- (void)testOutOfBoundsReturnsNil {
    NYTPhotoViewerArrayDataSource *dataSource = [[NYTPhotoViewerArrayDataSource alloc] initWithPhotos:nil];
    XCTAssertNil(dataSource[1]);
}

- (void)testValidIndexReturnsPhoto {
    NYTPhotoViewerArrayDataSource *dataSource = [[NYTPhotoViewerArrayDataSource alloc] initWithPhotos:[self newTestPhotos]];
    XCTAssertNotNil(dataSource[1]);
}

- (void)testValidIndexReturnsCorrectPhoto {
    NSArray *photos = [self newTestPhotos];
    NYTPhotoViewerArrayDataSource *dataSource = [[NYTPhotoViewerArrayDataSource alloc] initWithPhotos:photos];
    XCTAssertEqualObjects(photos.firstObject, dataSource[0]);
}

- (NSArray *)newTestPhotos {
    NSMutableArray *photos = [NSMutableArray array];
    
    for (int i = 0; i < 5; i++) {
        NYTExamplePhoto *photo = [[NYTExamplePhoto alloc] init];
        [photos addObject:photo];
    }
    
    return photos;
}

@end
