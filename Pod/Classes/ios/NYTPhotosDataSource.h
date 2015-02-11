//
//  NYTPhotosDataSource.h
//  Pods
//
//  Created by Brian Capps on 2/11/15.
//
//

@import Foundation;

#import "NYTPhotosViewControllerDataSource.h"

@interface NYTPhotosDataSource : NSObject <NYTPhotosViewControllerDataSource>

- (instancetype)initWithPhotos:(NSArray *)photos NS_DESIGNATED_INITIALIZER;

@end
