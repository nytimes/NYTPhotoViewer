//
//  NYTPhotoViewerArrayDataSource.m
//  NYTPhotoViewer
//
//  Created by Brian Capps on 2/11/15.
//
//

#import "NYTPhotoViewerArrayDataSource.h"

@interface NYTPhotoViewerArrayDataSource ()

@property (nonatomic, readonly) NSArray *photos;

@end

@implementation NYTPhotoViewerArrayDataSource

#pragma mark - NSObject

- (instancetype)init {
    return [self initWithPhotos:nil];
}

#pragma mark - NYTPhotosDataSource

- (instancetype)initWithPhotos:(NSArray *)photos {
    self = [super init];
    
    if (self) {
        _photos = [photos copy];
    }
    
    return self;
}

#pragma mark - NSFastEnumeration

- (NSUInteger)countByEnumeratingWithState:(NSFastEnumerationState *)state objects:(__unsafe_unretained id [])buffer count:(NSUInteger)length {
    return [self.photos countByEnumeratingWithState:state objects:buffer count:length];
}

#pragma mark - NYTPhotosViewControllerDataSource

- (NSNumber *)numberOfPhotos {
    return @(self.photos.count);
}

- (id <NYTPhoto>)photoAtIndex:(NSInteger)photoIndex {
    if (photoIndex < self.photos.count) {
        return self.photos[photoIndex];
    }
    
    return nil;
}

- (NSInteger)indexOfPhoto:(id <NYTPhoto>)photo {
    return [self.photos indexOfObject:photo];
}

- (BOOL)containsPhoto:(id <NYTPhoto>)photo {
    return [self.photos containsObject:photo];
}

- (id <NYTPhoto>)objectAtIndexedSubscript:(NSUInteger)photoIndex {
    return [self photoAtIndex:photoIndex];
}

@end
