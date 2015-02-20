//
//  NYTPhotoContaining.h
//  Pods
//
//  Created by Brian Capps on 2/11/15.
//
//

@protocol NYTPhoto;

/**
 *  A protocol that defines that an object contains a photo propeprty.
 */
@protocol NYTPhotoContaining <NSObject>

/**
 *  An object conforming to the NYTPhoto protocol.
 */
@property (nonatomic, readonly) id <NYTPhoto> photo;

@end
