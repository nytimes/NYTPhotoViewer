//
//  NYTPhotosOverlayView.h
//  Pods
//
//  Created by Brian Capps on 2/17/15.
//
//

@import UIKit;

@interface NYTPhotosOverlayView : UIView

/**
 *  The internal navigation bar used to set the bar button items and title of the overlay.
 */
@property (nonatomic, readonly) UINavigationBar *navigationBar;

/**
 *  The title of the overlay. Centered between the eft adn right bar button items.
 */
@property (nonatomic) NSString *title;

/**
 *  The bar button item appearing at the top left of the overlay.
 */
@property (nonatomic) UIBarButtonItem *leftBarButtonItem;

/**
 *  The bar button item appearing at the top right of the overlay.
 */
@property (nonatomic) UIBarButtonItem *rightBarButtonItem;

/**
 *  A view representing the caption for the photo, which will be set to full width and locked to the bottom. Can be any UIView object, but is expected to respond to `intrinsicContentSize` appropriately to calculate height.
 */
@property (nonatomic) UIView *captionView;

@end
