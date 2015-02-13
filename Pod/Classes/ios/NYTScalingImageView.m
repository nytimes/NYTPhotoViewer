//
//  NYTScalingImageView.m
//  Pods
//
//  Created by Harrison, Andrew on 7/23/13.
//  Copyright (c) 2015 The New York Times Company. All rights reserved.
//

#import "NYTScalingImageView.h"

#import "tgmath.h"

@implementation NYTScalingImageView

#pragma mark - UIView

- (instancetype)initWithFrame:(CGRect)frame {
    return [self initWithImage:nil frame:frame];
}

- (void)didAddSubview:(UIView *)subview {
    [super didAddSubview:subview];
    [self centerScrollViewContents];
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    [self centerScrollViewContents];
    [self updateZoomScale];
}

#pragma mark - NYTScalingImageView

- (id)initWithImage:(UIImage *)image frame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        [self setupInternalImageView:image];
        [self setupImageScrollView];
        [self updateZoomScale];
    }
    
    return self;
}

#pragma mark - Setup

- (void)setupInternalImageView:(UIImage *)image {
    self.internalImageView = [[UIImageView alloc] initWithImage:image];
    self.internalImageView.frame = CGRectMake(0, 0, image.size.width, image.size.height);
    
    [self addSubview:self.internalImageView];
    
    self.contentSize = image.size;
}

- (void)setupImageScrollView {
    self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.showsVerticalScrollIndicator = NO;
    self.showsHorizontalScrollIndicator = NO;
    self.bouncesZoom = YES;
    self.decelerationRate = UIScrollViewDecelerationRateFast;
}

- (void)updateZoomScale {
    if (self.internalImageView.image) {
        CGRect scrollViewFrame = self.bounds;
        
        CGFloat scaleWidth = scrollViewFrame.size.width / self.internalImageView.image.size.width;
        CGFloat scaleHeight = scrollViewFrame.size.height / self.internalImageView.image.size.height;
        CGFloat minScale = MIN(scaleWidth, scaleHeight);
        
        self.minimumZoomScale = minScale;
    
#warning Figure out if 1.0 is always desired.
        self.maximumZoomScale = 1.0;
        
        self.zoomScale = self.minimumZoomScale;
    }
}

- (void)scrollViewDidZoom:(__unused UIScrollView *)scrollView {
    [self centerScrollViewContents];
}

#pragma mark - Centering

#define floor __tg_floor //This is to address the Clang bug discussed here http://stackoverflow.com/questions/23333287/tgmath-h-doesnt-work-if-modules-are-enabled

- (void)centerScrollViewContents {
    CGFloat horizontalInset = 0;
    CGFloat verticalInset = 0;

    if (self.contentSize.width < CGRectGetWidth(self.bounds)) {
        horizontalInset = (CGRectGetWidth(self.bounds) - self.contentSize.width) * 0.5;
    }
    
    if (self.contentSize.height < CGRectGetHeight(self.bounds)) {
        verticalInset = (CGRectGetHeight(self.bounds) - self.contentSize.height) * 0.5;
    }
    
    if (self.window.screen.scale < 2.0) {
        horizontalInset = floor(horizontalInset);
        verticalInset = floor(verticalInset);
    }
    
    // Use contentInset to center the contents in the scrollview. Reasoning explained here: http://petersteinberger.com/blog/2013/how-to-center-uiscrollview/
    self.contentInset = UIEdgeInsetsMake(verticalInset, horizontalInset, verticalInset, horizontalInset);
}

#undef floor

@end
