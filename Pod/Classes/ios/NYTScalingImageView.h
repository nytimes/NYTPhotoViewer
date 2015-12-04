//
//  NYTScalingImageView.h
//  NYTPhotoViewer
//
//  Created by Harrison, Andrew on 7/23/13.
//  Copyright (c) 2015 The New York Times Company. All rights reserved.
//

@import UIKit;

#ifdef ANIMATED_GIF_SUPPORT
@class FLAnimatedImageView;
#endif

@interface NYTScalingImageView : UIScrollView

/**
 *  The image view used internally as the contents of the scroll view.
 */
#ifdef ANIMATED_GIF_SUPPORT
@property (nonatomic, readonly) FLAnimatedImageView *imageView;
#else
@property (nonatomic, readonly) UIImageView *imageView;
#endif

/**
 *  Initializes a scaling image view with a `UIImage`. This object is a `UIScrollView` that contains a `UIImageView`. This allows for zooming and panning around the image.
 *
 *  @param image A `UIImage` for zooming and panning.
 *  @param frame The frame of the view.
 *
 *  @return A fully initialized object.
 */
- (instancetype)initWithImageData:(NSData *)image frame:(CGRect)frame NS_DESIGNATED_INITIALIZER;

/**
 *  Updates the image in the image view and centers and zooms the new image.
 *
 *  @param image The new image to display in the image view.
 */
- (void)updateImageData:(NSData *)image;

/**
 *  Centers the image inside of the scroll view. Typically used after rotation, or when zooming has finished.
 */
- (void)centerScrollViewContents;

@end
