//
//  NYTPhotosDataSourceTests.m
//  NYTPhotoViewer
//
//  Created by Brian Capps on 2/26/15.
//  Copyright (c) 2015 NYTimes. All rights reserved.
//

@import UIKit;
@import XCTest;

#import <NYTPhotoViewer/NYTPhotosDataSource.h>
#import "NYTExamplePhoto.h"

@interface NYTPhotosDataSourceTests : XCTestCase

@end

@implementation NYTPhotosDataSourceTests

- (void)testInitializerAcceptsNil {
    XCTAssertNoThrow([[NYTPhotosDataSource alloc] initWithPhotos:nil]);
}

- (void)testOutOfBoundsDoesNotCrash {
    NYTPhotosDataSource *dataSource = [[NYTPhotosDataSource alloc] initWithPhotos:nil];
    XCTAssertNoThrow(dataSource[1]);
}

- (void)testOutOfBoundsReturnsNil {
    NYTPhotosDataSource *dataSource = [[NYTPhotosDataSource alloc] initWithPhotos:nil];
    XCTAssertNil(dataSource[1]);
}

- (void)testValidIndexReturnsPhoto {
    NYTPhotosDataSource *dataSource = [[NYTPhotosDataSource alloc] initWithPhotos:[self newTestPhotos]];
    XCTAssertNotNil(dataSource[1]);
}

- (void)testValidIndexReturnsCorrectPhoto {
    NSArray *photos = [self newTestPhotos];
    NYTPhotosDataSource *dataSource = [[NYTPhotosDataSource alloc] initWithPhotos:photos];
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
