//
//  NYTPhotoCaptionView.h
//  Pods
//
//  Created by Brian Capps on 2/18/15.
//
//

@import UIKit;

@interface NYTPhotoCaptionView : UIView

@property (nonatomic) NSAttributedString *attributedTitle;
@property (nonatomic) NSAttributedString *attributedSummary;
@property (nonatomic) NSAttributedString *attributedCredit;

- (instancetype)initWithAttributedTitle:(NSAttributedString *)attributedTitle attributedSummary:(NSAttributedString *)attributedSummary attributedCredit:(NSAttributedString *)attributedCredit NS_DESIGNATED_INITIALIZER;

@end
