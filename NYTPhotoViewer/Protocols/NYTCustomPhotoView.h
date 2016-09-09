//
//  NYTCustomPhotoView.h
//  NYTPhotoViewer
//
//  Created by Vlad Getman on 09.09.16.
//  Copyright © 2016 NYTimes. All rights reserved.
//

@protocol NYTPhoto;

/**
 *  A protocol used for custom view
 */
@protocol NYTCustomPhotoView <NSObject>

/**
 *  Update a photo in custom view.
 */
- (void)updatePhoto:(id <NYTPhoto>)photo;

@end