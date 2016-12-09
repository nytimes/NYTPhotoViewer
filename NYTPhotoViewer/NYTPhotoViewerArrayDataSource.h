//
//  NYTPhotoViewerArrayDataSource.h
//  NYTPhotoViewer
//
//  Created by Brian Capps on 2/11/15.
//
//

@import Foundation;

#import "NYTPhotoViewerDataSource.h"

NS_ASSUME_NONNULL_BEGIN

/**
 *  A simple concrete implementation of `NYTPhotoViewerDataSource`, for use with an array of images.
 */
@interface NYTPhotoViewerArrayDataSource : NSObject <NYTPhotoViewerDataSource>

/**
 *  The designated initializer that takes and stores an array of photos.
 *
 *  @param photos An array of objects conforming to the `NYTPhoto` protocol.
 *
 *  @return A fully initialized object.
 */
- (instancetype)initWithPhotos:(nullable NSArray *)photos NS_DESIGNATED_INITIALIZER;

@end

NS_ASSUME_NONNULL_END
