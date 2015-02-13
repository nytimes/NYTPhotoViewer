//
//  NYTPhotoViewController.h
//  Pods
//
//  Created by Brian Capps on 2/11/15.
//
//

@import UIKit;
#import "NYTPhotoContaining.h"

@protocol NYTPhoto;
@protocol NYTPhotoViewControllerDelegate;

@interface NYTPhotoViewController : UIViewController <NYTPhotoContaining>

@property (nonatomic, weak) id <NYTPhotoViewControllerDelegate> delegate;
@property (nonatomic, readonly) UITapGestureRecognizer *doubleTapGestureRecognizer;

- (instancetype)initWithPhoto:(id <NYTPhoto>)photo NS_DESIGNATED_INITIALIZER;

@end

@protocol NYTPhotoViewControllerDelegate <NSObject>

- (void)photoViewController:(NYTPhotoViewController *)photoViewController didLongPressWithGestureRecognizer:(UILongPressGestureRecognizer *)longPressGestureRecognizer;
- (void)photoViewController:(NYTPhotoViewController *)photoViewController isPanningWithGestureRecognizer:(UIPanGestureRecognizer *)panGestureRecognizer;

@end
