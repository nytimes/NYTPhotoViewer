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
#import "NYTPhotoViewerSinglePhotoDataSource.h"

@interface NYTPhotoViewerSinglePhotoDataSourceTests : XCTestCase

@end

@implementation NYTPhotoViewerSinglePhotoDataSourceTests

- (void)testInitializerAcceptsNil {
    XCTAssertNoThrow([[NYTPhotoViewerSinglePhotoDataSource alloc] initWithPhoto:nil]);
}

- (void)testOutOfBoundsDoesNotCrash {
    NYTPhotoViewerSinglePhotoDataSource *dataSource = [[NYTPhotoViewerSinglePhotoDataSource alloc] initWithPhoto:nil];
    XCTAssertNoThrow([dataSource photoAtIndex:1]);
}

- (void)testOutOfBoundsReturnsNil {
    NYTPhotoViewerSinglePhotoDataSource *dataSource = [[NYTPhotoViewerSinglePhotoDataSource alloc] initWithPhoto:nil];
    XCTAssertNil([dataSource photoAtIndex:1]);
}

- (void)testValidIndexReturnsPhotoAtIndex {
    NYTExamplePhoto *photo = [[NYTExamplePhoto alloc] init];
    NYTPhotoViewerSinglePhotoDataSource *dataSource = [[NYTPhotoViewerSinglePhotoDataSource alloc] initWithPhoto:photo];
    XCTAssertEqual(0, [dataSource indexOfPhoto:photo]);
}

- (void)testValidIndexReturnsPhoto {
    NYTExamplePhoto *photo = [[NYTExamplePhoto alloc] init];
    NYTPhotoViewerSinglePhotoDataSource *dataSource = [[NYTPhotoViewerSinglePhotoDataSource alloc] initWithPhoto:photo];
    XCTAssertNotNil([dataSource photoAtIndex:1]);
}

- (void)testValidIndexReturnsCorrectPhoto {
    NSArray *photos = [self newTestPhotos];
    NYTPhotoViewerSinglePhotoDataSource *dataSource = [[NYTPhotoViewerSinglePhotoDataSource alloc] initWithPhoto:photos.firstObject];
    XCTAssertEqualObjects(photos.firstObject, [dataSource photoAtIndex:0]);
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
