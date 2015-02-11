//
//  NYTExamplePhoto.m
//  ios-photo-viewer
//
//  Created by Brian Capps on 2/11/15.
//  Copyright (c) 2015 Brian Capps. All rights reserved.
//

#import "NYTExamplePhoto.h"


@implementation NYTExamplePhoto

@synthesize image = _image;
@synthesize placeholderImage = _placeholderImage;
@synthesize captionTitle = _captionTitle;
@synthesize captionSummary = _captionSummary;
@synthesize captionCredit = _captionCredit;
@synthesize identifier = _identifier;

- (UIImage *)image {
    return [UIImage imageNamed:@"testImage"];
}

@end
