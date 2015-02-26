//
//  NYTPhotosDataSourceTests.m
//  NYTPhotoViewer
//
//  Created by Brian Capps on 2/26/15.
//  Copyright (c) 2015 Brian Capps. All rights reserved.
//

@import UIKit;
@import XCTest;

#import <NYTPhotoViewer/NYTPhotosDataSource.h>

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

@end