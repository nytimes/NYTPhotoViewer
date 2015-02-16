//
//  NYTPhotosViewController.h
//  NYTNewsReader
//
//  Created by Brian Capps on 2/10/15.
//  Copyright (c) 2015 NYTimes. All rights reserved.
//

@import UIKit;

@protocol NYTPhoto;
@protocol NYTPhotosViewControllerDelegate;

@interface NYTPhotosViewController : UIViewController

@property (nonatomic) UIButton *doneButton;
@property (nonatomic) UIButton *actionButton;

@property (nonatomic, weak) id <NYTPhotosViewControllerDelegate> delegate;

/**
 *  A convenience initializer that calls `initWithPhotos:initialPhoto:`, passing the first photo as the initialPhoto argument.
 *
 *  @param photos An array of objects conforming to the NYTPhoto protocol.
 *
 *  @return A fully initialized object.
 */
- (instancetype)initWithPhotos:(NSArray *)photos;

/**
 *  The designated initializer that stores the array of objects conforming to the NYTPhoto protocol for display, along with specifying an initial photo for display.
 *
 *  @param photos An array of objects conforming to the NYTPhoto protocol.
 *  @param initialPhoto The photo to display initially. Must be contained within the photos array.
 *
 *  @return A fully initialized object.
 */
- (instancetype)initWithPhotos:(NSArray *)photos initialPhoto:(id <NYTPhoto>)initialPhoto NS_DESIGNATED_INITIALIZER;

- (void)moveToPhoto:(id <NYTPhoto>)photo;
- (void)updateImage:(UIImage *)image forPhoto:(id <NYTPhoto>)photo;

@end

/**
 *  A protocol of entirely optional methods called for configuration and lifecycle events by an `NYTPhotosViewController` instance.
 */
@protocol NYTPhotosViewControllerDelegate <NSObject>

@optional
- (void)photosViewController:(NYTPhotosViewController *)photosViewController didDisplayPhoto:(id <NYTPhoto>)photo;

/**
 *  Called when a photo is long pressed.
 *
 *  @param photosViewController       The `NYTPhotosViewController` instance that sent the delegate message.
 *  @param photo                      The photo being displayed that was long pressed.
 *  @param longPressGestureRecognizer The gesture recognizer that detected the long press.
 *
 *  @return YES if the long press was handled by the client, NO if the default UIMenuController is desired.
 */
- (BOOL)photosViewController:(NYTPhotosViewController *)photosViewController handleLongPressForPhoto:(id <NYTPhoto>)photo withGestureRecognizer:(UILongPressGestureRecognizer *)longPressGestureRecognizer;

- (void)photosViewControllerWillDismiss:(NYTPhotosViewController *)photosViewController;
- (void)photosViewControllerDidDismiss:(NYTPhotosViewController *)photosViewController;

- (UIView *)photosViewController:(NYTPhotosViewController *)photosViewController captionViewForPhoto:(id <NYTPhoto>)photo;

/**
 *  Returns a view to display while a photo is loading. Can be any UIView object, but is expected to respond to `sizeToFit` appropriately. This view will be sized and centered in the blank area, and hidden when the photo is loaded.
 *
 *  @param photosViewController The `NYTPhotosViewController` instance that sent the delegate message.
 *  @param photo                The photo object over which to display the activity view.
 *
 *  @return A view to display while the photo is loading. Return `nil` to show a default white UIActivityIndicatorView.
 */
- (UIView *)photosViewController:(NYTPhotosViewController *)photosViewController activityViewForPhoto:(id <NYTPhoto>)photo;

/**
 *  Returns the view from which to animate for a given object conforming to the NYTPhoto protocol.
 *
 *  @param photosViewController The `NYTPhotosViewController` instance that sent the delegate message.
 *  @param photo                The photo for which the animation will occur.
 *
 *  @return The view to animate out of or into for the given photo.
 */
- (UIView *)photosViewController:(NYTPhotosViewController *)photosViewController referenceViewForPhoto:(id <NYTPhoto>)photo;

/**
 *  Called when the action button is tapped.
 *
 *  @param photosViewController The `NYTPhotosViewController` instance that sent the delegate message.
 *  @param photo                The photo being displayed when the action button was tapped.
 *
 *  @return YES if the action button tap was handled by the client, NO if the default UIActivityViewController is desired.
 */
- (BOOL)photosViewController:(NYTPhotosViewController *)photosViewController handleActionButtonTappedForPhoto:(id <NYTPhoto>)photo;
- (void)photosViewController:(NYTPhotosViewController *)photosViewController actionCompletedWithActivityType:(NSString *)activityType;

@end
