//
//  NYTInterstitialViewController.h
//  NYTPhotoViewer
//
//  Created by Howarth, Craig on 4/17/18.
//  Copyright © 2018 NYTimes. All rights reserved.
//

@import UIKit;
#import "NYTPhotoViewerContainer.h"

NS_ASSUME_NONNULL_BEGIN

/**
 *  The view controller controlling the display of a interstitial view.
 */
@interface NYTInterstitialViewController : UIViewController <NYTPhotoViewerContainer>

/**
 *  The designated initializer that takes an interstitial view.
 *
 *  @param view      The view object that this view controller manages.
 *  @param itemIndex The index of this view controller in the photo viewer collection.
 *
 *  @return A fully initialized object.
 */
- (instancetype)initWithView:(nullable UIView *)view itemIndex:(NSUInteger)itemIndex NS_DESIGNATED_INITIALIZER;

@end

NS_ASSUME_NONNULL_END
