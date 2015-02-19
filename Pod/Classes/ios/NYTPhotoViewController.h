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

@interface NYTPhotoViewController : UIViewController <NYTPhotoContaining>

@property (nonatomic, weak) id <NYTPhotoViewControllerDelegate> delegate;

@property (nonatomic, readonly) NYTScalingImageView *scalingImageView;
@property (nonatomic, readonly) UIView *activityView;
@property (nonatomic, readonly) UITapGestureRecognizer *doubleTapGestureRecognizer;

- (instancetype)initWithPhoto:(id <NYTPhoto>)photo activityView:(UIView *)activityView NS_DESIGNATED_INITIALIZER;

- (void)updateImage:(UIImage *)image;

@end

@protocol NYTPhotoViewControllerDelegate <NSObject>

@optional
- (void)photoViewController:(NYTPhotoViewController *)photoViewController didLongPressWithGestureRecognizer:(UILongPressGestureRecognizer *)longPressGestureRecognizer;

@end
