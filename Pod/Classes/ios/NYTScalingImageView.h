//
//  NYTScalingImageView.h
//  Pods
//
//  Created by Harrison, Andrew on 7/23/13.
//  Copyright (c) 2015 The New York Times Company. All rights reserved.
//

@import UIKit;

@interface NYTScalingImageView : UIScrollView

@property (nonatomic) UIImageView *internalImageView;

/** Initializes a scaling image view with a UIImage. This object is a UIScrollView that contains a UIImageView. This allows for zooming and panning around the image. Additionally it supports double tap to zoom.
 
 @param UIImage A UIImage object.
 @param CGRect  The frame to initialize the NYTScalingImageView in.
 @return Whatever it returns.
 */
- (instancetype)initWithImage:(UIImage *)image frame:(CGRect)frame;

- (void)updateImage:(UIImage *)image;

/** Centers the image inside of the scroll view. Typically used after rotation, or when zooming has finished.
 */
- (void)centerScrollViewContents;

@end
