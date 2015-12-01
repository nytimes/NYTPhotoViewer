//
//  NSBundle+NYTPhotoViewer.m
//  NYTPhotoViewer
//
//  Created by Chris Dzombak on 10/16/15.
//
//

#import "NSBundle+NYTPhotoViewer.h"

@implementation NSBundle (NYTPhotoViewer)

+ (instancetype)nyt_photoViewerResourceBundle {
    static NSBundle *resourceBundle = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSString *resourceBundlePath = [[NSBundle mainBundle] pathForResource:@"NYTPhotoViewer" ofType:@"bundle"];
        resourceBundle = [self bundleWithPath:resourceBundlePath];
    });
    return resourceBundle;
}

@end
