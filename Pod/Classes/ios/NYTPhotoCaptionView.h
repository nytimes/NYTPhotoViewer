//
//  NYTPhotoCaptionView.h
//  Pods
//
//  Created by Brian Capps on 2/18/15.
//
//

@import UIKit;

/**
 *  The left and right margin around the content.
 */
extern const CGFloat NYTPhotoCaptionViewHorizontalMargin;

/**
 *  A view used to display the caption for a photo.
 */
@interface NYTPhotoCaptionView : UIView

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
