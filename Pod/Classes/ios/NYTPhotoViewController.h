//
//  NYTPhotoViewController.h
//  Pods
//
//  Created by Brian Capps on 2/11/15.
//
//

@import UIKit;
#import "NYTPhotoContaining.h"

@class NYTScalingImageView;

@protocol NYTPhoto;
@protocol NYTPhotoViewControllerDelegate;

/**
 *  NYTPhotoViewController observes this notification. It expects an id <NYTPhoto> object as the object of the notification.
 */
extern NSString * const NYTPhotoViewControllerPhotoImageUpdatedNotification;

/**
 *  The view controller controlling the display of a single photo object.
 */
@interface NYTPhotoViewController : UIViewController <NYTPhotoContaining>

/**
 *  The internal scaling image view used to display the photo.
 */
@property (nonatomic, readonly) NYTScalingImageView *scalingImageView;

/**
 *  The internal activity view shown while the image is loading. Set form the initializer.
 */
@property (nonatomic, readonly) UIView *activityView;

/**
 *  The gesture recognizer used to detect the double tap gesture used for zooming on photos.
 */
@property (nonatomic, readonly) UITapGestureRecognizer *doubleTapGestureRecognizer;

/**
 *  The object that acts as the photo view controller's delegate.
 */
@property (nonatomic, weak) id <NYTPhotoViewControllerDelegate> delegate;

/**
 *  The designated initializer that takes the photo and activity view.
 *
 *  @param photo        The photo object that this view controller manages.
 *  @param activityView The activity view to display while the photo's image loads. Call `updateImage:` with a non-nil image to hide.
 *
 *  @return A fully initialized object.
 */
- (instancetype)initWithPhoto:(id <NYTPhoto>)photo activityView:(UIView *)activityView NS_DESIGNATED_INITIALIZER;

/**
 *  Updates the image displayed for the photo. If previously showing an activity view, that view is hidden and removed.
 *
 *  @param image The new image to display.
 */
- (void)updateImage:(UIImage *)image;

@end

@protocol NYTPhotoViewControllerDelegate <NSObject>

@optional

/**
 *  Called when a long press is recognized.
 *
 *  @param photoViewController        The `NYTPhotoViewController` instance that sent the delegate message.
 *  @param longPressGestureRecognizer The long press gesture recognizer that recognized the long press.
 */
- (void)photoViewController:(NYTPhotoViewController *)photoViewController didLongPressWithGestureRecognizer:(UILongPressGestureRecognizer *)longPressGestureRecognizer;

@end
