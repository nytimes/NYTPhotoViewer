//
//  NYTPhotosViewControllerDataSource.h
//  NYTNewsReader
//
//  Created by Brian Capps on 2/10/15.
//  Copyright (c) 2015 NYTimes. All rights reserved.
//

@import UIKit;

@protocol NYTPhoto;

@protocol NYTPhotosViewControllerDataSource <NSFastEnumeration>

@property (nonatomic, readonly) NSUInteger numberOfPhotos;

- (id <NYTPhoto>)photoAtIndex:(NSUInteger)photoIndex;
- (NSUInteger)indexOfPhoto:(id <NYTPhoto>)photo;

- (BOOL)containsPhoto:(id <NYTPhoto>)photo;

/**
 *  Subscripting support. For example, dataSource[0] will be a valid way to obtain the photo at index 0.
 *
 *  @param idx The index of the photo.
 *
 *  @return The photo at the index, or nil if there is none.
 */
- (id <NYTPhoto>)objectAtIndexedSubscript:(NSUInteger)photoIndex;

@end
