//
//  NYTPhotoCaptionView.h
//  NYTPhotoViewer
//
//  Created by Brian Capps on 2/18/15.
//
//

@import UIKit;

@protocol NYTPhotoCaptionViewLayoutWidthHinting;

/**
 *  A view used to display the caption for a photo.
 */
@interface NYTPhotoCaptionView : UIView <NYTPhotoCaptionViewLayoutWidthHinting>

/**
 *  Designated initializer that takes all the caption attributed strings as arguments.
 *
 *  @param attributedTitle   The attributed string used as the title. The top string in the caption view.
 *  @param attributedSummary The attributed string used as the summary. The second from the top string in the caption view.
 *  @param attributedCredit  The attributed string used as the credit. The third from the top string in the caption view.
 *
 *  @return A fully initialized object.
 */
- (instancetype)initWithAttributedTitle:(NSAttributedString *)attributedTitle attributedSummary:(NSAttributedString *)attributedSummary attributedCredit:(NSAttributedString *)attributedCredit NS_DESIGNATED_INITIALIZER;

@end

/**
 *  Allows a view to opt-in to receiving a hint of its layout width. This aids in calculating an appropriate intrinsic content size.
 */
@protocol NYTPhotoCaptionViewLayoutWidthHinting <NSObject>

/**
 *  The preferred maximum width, in points, of this caption view.
 *
 *  This property works exactly as it does on `UILabel`.
 *
 *  This property affects the size of the view when layout constraints are applied to it. During layout, if the text extends beyond the width specified by this property, the additional text is flowed to one or more new lines, thereby increasing the height of the view.
 */
@property (nonatomic) CGFloat preferredMaxLayoutWidth;

@end
