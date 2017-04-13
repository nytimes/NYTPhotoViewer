//
//  NYTScalingImageView.m
//  NYTPhotoViewer
//
//  Created by Harrison, Andrew on 7/23/13.
//  Copyright (c) 2015 The New York Times Company. All rights reserved.
//

#import "NYTScalingImageView.h"

#import "tgmath.h"

#ifdef ANIMATED_GIF_SUPPORT
#import <FLAnimatedImage/FLAnimatedImage.h>
#endif

#define INTERACTIVE_RELOAD

#ifdef INTERACTIVE_RELOAD
#define IsValidZoomScale(zoomScale) (zoomScale != 0 && zoomScale != 1)
#endif

@interface NYTScalingImageView ()

- (instancetype)initWithCoder:(NSCoder *)aDecoder NS_DESIGNATED_INITIALIZER;

#ifdef ANIMATED_GIF_SUPPORT
@property (nonatomic) FLAnimatedImageView *imageView;
#else
@property (nonatomic) UIImageView *imageView;
#endif

@property (nonatomic) CGFloat baseZoomScale;
@property (nonatomic) CGSize baseSize;

@end

@implementation NYTScalingImageView

#pragma mark - UIView

- (instancetype)initWithFrame:(CGRect)frame {
    return [self initWithImage:[UIImage new] frame:frame];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];

    if (self) {
        [self commonInitWithImage:nil imageData:nil];
    }

    return self;
}

- (void)didAddSubview:(UIView *)subview {
    [super didAddSubview:subview];
    [self centerScrollViewContents];
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    [self updateZoomScale];
    [self centerScrollViewContents];
}

#pragma mark - NYTScalingImageView

- (instancetype)initWithImage:(UIImage *)image frame:(CGRect)frame {
    self = [super initWithFrame:frame];

    if (self) {
        [self commonInitWithImage:image imageData:nil];
    }
    
    return self;
}

- (instancetype)initWithImageData:(NSData *)imageData frame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        [self commonInitWithImage:nil imageData:imageData];
    }
    
    return self;
}

- (void)commonInitWithImage:(UIImage *)image imageData:(NSData *)imageData {
    [self setupInternalImageViewWithImage:image imageData:imageData];
    [self setupImageScrollView];
    [self updateZoomScale];
}

#pragma mark - Setup

- (void)setupInternalImageViewWithImage:(UIImage *)image imageData:(NSData *)imageData {
    UIImage *imageToUse = image ?: [UIImage imageWithData:imageData];

#ifdef ANIMATED_GIF_SUPPORT
    self.imageView = [[FLAnimatedImageView alloc] initWithImage:imageToUse];
#else
    self.imageView = [[UIImageView alloc] initWithImage:imageToUse];
#endif
    [self updateImage:imageToUse imageData:imageData];
    
    [self addSubview:self.imageView];
}

- (void)updateImage:(UIImage *)image {
    [self updateImage:image imageData:nil];
}

- (void)updateImageData:(NSData *)imageData {
    [self updateImage:nil imageData:imageData];
}

- (void)updateImage:(UIImage *)image imageData:(NSData *)imageData {
#ifdef DEBUG
#ifndef ANIMATED_GIF_SUPPORT
    if (imageData != nil) {
        NSLog(@"[NYTPhotoViewer] Warning! You're providing imageData for a photo, but NYTPhotoViewer was compiled without animated GIF support. You should use native UIImages for non-animated photos. See the NYTPhoto protocol documentation for discussion.");
    }
#endif // ANIMATED_GIF_SUPPORT
#endif // DEBUG

    UIImage *imageToUse = image ?: [UIImage imageWithData:imageData];

    // Remove any transform currently applied by the scroll view zooming.
#ifndef INTERACTIVE_RELOAD
    self.imageView.transform = CGAffineTransformIdentity;
#endif
    self.imageView.image = imageToUse;
    
#ifdef ANIMATED_GIF_SUPPORT
    // It's necessarry to first assign the UIImage so calulations for layout go right (see above)
    self.imageView.animatedImage = [[FLAnimatedImage alloc] initWithAnimatedGIFData:imageData];
#endif
    
#ifndef INTERACTIVE_RELOAD
    self.imageView.frame = CGRectMake(0, 0, imageToUse.size.width, imageToUse.size.height);
#endif
    
    self.contentSize = imageToUse.size;
    
#ifdef INTERACTIVE_RELOAD
    self.baseZoomScale = self.zoomScale;
    if (CGSizeEqualToSize(self.baseSize, CGSizeZero)) {
        self.baseSize = image.size;
    }
#endif
    [self updateZoomScale];
    
#ifndef INTERACTIVE_RELOAD
    [self centerScrollViewContents];
#endif
}

- (void)setupImageScrollView {
    self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.showsVerticalScrollIndicator = NO;
    self.showsHorizontalScrollIndicator = NO;
    self.bouncesZoom = YES;
    self.decelerationRate = UIScrollViewDecelerationRateFast;
}

- (void)updateZoomScale {
#ifdef ANIMATED_GIF_SUPPORT
    if (self.imageView.animatedImage || self.imageView.image) {
#else
    if (self.imageView.image) {
#endif
        CGRect scrollViewFrame = self.bounds;
        
#ifdef INTERACTIVE_RELOAD
        CGFloat scaleWidth = scrollViewFrame.size.width / self.baseSize.width;
        CGFloat scaleHeight = scrollViewFrame.size.height / self.baseSize.height;
#else
        CGFloat scaleWidth = scrollViewFrame.size.width / self.imageView.image.size.width;
        CGFloat scaleHeight = scrollViewFrame.size.height / self.imageView.image.size.height;
#endif
        CGFloat minScale = MIN(scaleWidth, scaleHeight);
        
        self.minimumZoomScale = minScale;
        self.maximumZoomScale = MAX(minScale, self.maximumZoomScale);
        
#ifdef INTERACTIVE_RELOAD
        if (IsValidZoomScale(self.baseZoomScale)) {
            self.zoomScale = self.baseZoomScale;
        } else {
            self.zoomScale = self.minimumZoomScale;
        }
        self.baseZoomScale = self.zoomScale;
#else
        self.zoomScale = self.minimumZoomScale;
#endif
        // scrollView.panGestureRecognizer.enabled is on by default and enabled by
        // viewWillLayoutSubviews in the container controller so disable it here
        // to prevent an interference with the container controller's pan gesture.
        //
        // This is enabled in scrollViewWillBeginZooming so panning while zoomed-in
        // is unaffected.
#ifndef INTERACTIVE_RELOAD
        self.panGestureRecognizer.enabled = NO;
#endif
    }
}

#pragma mark - Centering

- (void)centerScrollViewContents {
    CGFloat horizontalInset = 0;
    CGFloat verticalInset = 0;
    
    if (self.contentSize.width < CGRectGetWidth(self.bounds)) {
#ifdef INTERACTIVE_RELOAD
        horizontalInset = (CGRectGetWidth(self.bounds) - self.baseSize.width) * 0.5;
#else
        horizontalInset = (CGRectGetWidth(self.bounds) - self.contentSize.width) * 0.5;
#endif
    }
    
    if (self.contentSize.height < CGRectGetHeight(self.bounds)) {
#ifdef INTERACTIVE_RELOAD
        verticalInset = (CGRectGetHeight(self.bounds) - self.baseSize.height) * 0.5;
#else
        verticalInset = (CGRectGetHeight(self.bounds) - self.contentSize.height) * 0.5;
#endif
    }
    
    if (self.window.screen.scale < 2.0) {
        horizontalInset = __tg_floor(horizontalInset);
        verticalInset = __tg_floor(verticalInset);
    }
    
    // Use `contentInset` to center the contents in the scroll view. Reasoning explained here: http://petersteinberger.com/blog/2013/how-to-center-uiscrollview/
    self.contentInset = UIEdgeInsetsMake(verticalInset, horizontalInset, verticalInset, horizontalInset);
    
#ifdef INTERACTIVE_RELOAD
    // Fixes image jumping issue when loading full size image
    if ([self.delegate respondsToSelector:@selector(scrollViewDidScroll:)]) {
        [self.delegate scrollViewDidScroll:self];
    }
#endif
}

@end
