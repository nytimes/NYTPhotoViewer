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

@interface NYTPhotoViewController : UIViewController <NYTPhotoContaining>

- (instancetype)initWithPhoto:(id <NYTPhoto>)photo NS_DESIGNATED_INITIALIZER;

@end
