//
//  NYTPhotoCaptionView.m
//  Pods
//
//  Created by Brian Capps on 2/18/15.
//
//

#import "NYTPhotoCaptionView.h"

const CGFloat NYTPhotoCaptionViewHorizontalMargin = 16.0;
const CGFloat NYTPhotoCaptionViewVerticalMargin = 10.0;

@interface NYTPhotoCaptionView ()

@property (nonatomic) UILabel *textLabel;

@end

@implementation NYTPhotoCaptionView

- (instancetype)initWithFrame:(CGRect)frame {
    return [self initWithAttributedTitle:nil attributedSummary:nil attributedCredit:nil];
}

- (CGSize)sizeThatFits:(CGSize)size {
    CGSize fittingSize = [self.textLabel sizeThatFits:size];
    fittingSize.width += NYTPhotoCaptionViewHorizontalMargin * 2.0;
    fittingSize.height += NYTPhotoCaptionViewVerticalMargin * 2.0;
    
    return size;
}

- (instancetype)initWithAttributedTitle:(NSAttributedString *)attributedTitle attributedSummary:(NSAttributedString *)attributedSummary attributedCredit:(NSAttributedString *)attributedCredit {
    self = [super initWithFrame:CGRectZero];
    
    if (self) {
        _attributedTitle = attributedTitle;
        _attributedSummary = attributedSummary;
        _attributedCredit = attributedCredit;
        
        [self setupTextLabel];
        [self updateTextLabelAttributedText];
    }
    
    return self;
}

- (CGSize)intrinsicContentSize {
    return [self sizeThatFits:CGSizeMake(CGRectGetWidth(self.frame), CGFLOAT_MAX)];
}

- (void)setupTextLabel {
    _textLabel = [[UILabel alloc] init];
    [self addSubview:_textLabel];
    
    NSLayoutConstraint *topConstraint = [NSLayoutConstraint constraintWithItem:self.textLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1.0 constant:NYTPhotoCaptionViewVerticalMargin];
    NSLayoutConstraint *widthConstraint = [NSLayoutConstraint constraintWithItem:self.textLabel attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeWidth multiplier:1.0 constant:NYTPhotoCaptionViewHorizontalMargin];
    NSLayoutConstraint *horizontalPositionConstraint = [NSLayoutConstraint constraintWithItem:self.textLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0.0];

    [self addConstraints:@[topConstraint, widthConstraint, horizontalPositionConstraint]];
}

- (void)setAttributedTitle:(NSAttributedString *)attributedTitle {
    _attributedTitle = attributedTitle;
    
    [self updateTextLabelAttributedText];
}

- (void)setAttributedSummary:(NSAttributedString *)attributedSummary {
    _attributedSummary = attributedSummary;
    
    [self updateTextLabelAttributedText];
}

- (void)setAttributedCredit:(NSAttributedString *)attributedCredit {
    _attributedCredit = attributedCredit;
    
    [self updateTextLabelAttributedText];
}

- (void)updateTextLabelAttributedText {
    NSMutableAttributedString *attributedLabelText = [[NSMutableAttributedString alloc] initWithString:@""];
    
    if (self.attributedTitle) {
        [attributedLabelText appendAttributedString:self.attributedTitle];
    }
    
    if (self.attributedSummary) {
        [attributedLabelText appendAttributedString:self.attributedSummary];
    }
    
    if (self.attributedCredit) {
        [attributedLabelText appendAttributedString:self.attributedCredit];
    }
    
    self.textLabel.attributedText = attributedLabelText;
}

@end
