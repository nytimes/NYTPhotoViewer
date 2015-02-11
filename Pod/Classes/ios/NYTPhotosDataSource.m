//
//  NYTPhotosDataSource.m
//  Pods
//
//  Created by Brian Capps on 2/11/15.
//
//

#import "NYTPhotosDataSource.h"

@interface NYTPhotosDataSource ()

@property (nonatomic) NSArray *photos;

@end

@implementation NYTPhotosDataSource

- (instancetype)init {
    return [self initWithPhotos:nil];
}

- (instancetype)initWithPhotos:(NSArray *)photos {
    self = [super init];
    
    if (self) {
        _photos = photos;
    }
    
    return self;
}

#pragma mark - NYTPhotosViewControllerDataSource

- (NSUInteger)numberOfPhotos {
    return self.photos.count;
}

- (id<NYTPhoto>)photoAtIndex:(NSUInteger)photoIndex {
    if (photoIndex < self.photos.count) {
        return self.photos[photoIndex];
    }
    
    return nil;
}

- (id <NYTPhoto>)objectAtIndexedSubscript:(NSUInteger)idx {
    return [self photoAtIndex:idx];
}

@end
