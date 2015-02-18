//
//  NYTPhotosOverlayView.h
//  Pods
//
//  Created by Brian Capps on 2/17/15.
//
//

@import UIKit;

@interface NYTPhotosOverlayView : UIView

@property (nonatomic, readonly) UINavigationBar *navigationBar;

@property (nonatomic) NSString *title;
@property (nonatomic) UIView *captionView;

@end
