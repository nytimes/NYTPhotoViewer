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

@protocol NYTPhotosViewControllerDelegate <NSObject>

@optional
- (void)photosViewController:(NYTPhotosViewController *)photosViewController didDisplayPhoto:(id <NYTPhoto>)photo;
- (void)photosViewController:(NYTPhotosViewController *)photosViewController didLongPressPhoto:(id <NYTPhoto>)photo;

- (void)photosViewControllerWillDismiss:(NYTPhotosViewController *)photosViewController;
- (void)photosViewControllerDidDismiss:(NYTPhotosViewController *)photosViewController;

- (UIView *)photosViewController:(NYTPhotosViewController *)photosViewController captionViewForPhoto:(id <NYTPhoto>)photo;
- (UIView *)photosViewController:(NYTPhotosViewController *)photosViewController activityViewForPhoto:(id <NYTPhoto>)photo;
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
