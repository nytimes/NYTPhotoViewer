//
//  NYTPhotoCaptionViewRespectsSafeArea.h
//  NYTPhotoViewer
//
//  Created by Anton Popovichenko on 25.04.2018.
//

#import <Foundation/Foundation.h>

/**
 *  Allows a view to opt-in to know about using safe area.
 */
@protocol NYTPhotoCaptionViewRespectsSafeArea <NSObject>

/**
 * Stores value from NYTPhotosOverlayView.captionViewRespectsSafeArea.
 */
@property (nonatomic) BOOL respectsSafeArea;

@end
