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
@property (nonatomic) CAGradientLayer *gradientLayer;

@end

@implementation NYTPhotoCaptionView

- (instancetype)initWithFrame:(CGRect)frame {
    return [self initWithAttributedTitle:nil attributedSummary:nil attributedCredit:nil];
}

- (CGSize)sizeThatFits:(CGSize)size {
    CGSize fittingSize = [self.textLabel sizeThatFits:size];
    fittingSize.width += NYTPhotoCaptionViewHorizontalMargin * 2.0;
    fittingSize.height += NYTPhotoCaptionViewVerticalMargin * 2.0;
    
    return fittingSize;
}

- (instancetype)initWithAttributedTitle:(NSAttributedString *)attributedTitle attributedSummary:(NSAttributedString *)attributedSummary attributedCredit:(NSAttributedString *)attributedCredit {
    self = [super initWithFrame:CGRectZero];
    
    if (self) {
        self.translatesAutoresizingMaskIntoConstraints = NO;
        
        _attributedTitle = attributedTitle;
        _attributedSummary = attributedSummary;
        _attributedCredit = attributedCredit;
        
        [self setupTextLabel];
        [self updateTextLabelAttributedText];
        [self setupGradient];
    }
    
    return self;
}

- (CGSize)intrinsicContentSize {
    return [self sizeThatFits:CGSizeMake(CGRectGetWidth(self.superview.bounds), CGFLOAT_MAX)];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.gradientLayer.frame = self.layer.bounds;
}

- (void)setupTextLabel {
    self.textLabel = [[UILabel alloc] init];
    self.textLabel.numberOfLines = 0;
    self.textLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:self.textLabel];
    
    NSLayoutConstraint *topConstraint = [NSLayoutConstraint constraintWithItem:self.textLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1.0 constant:NYTPhotoCaptionViewVerticalMargin];
    NSLayoutConstraint *bottomConstraint = [NSLayoutConstraint constraintWithItem:self.textLabel attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1.0 constant:-NYTPhotoCaptionViewVerticalMargin];
    NSLayoutConstraint *widthConstraint = [NSLayoutConstraint constraintWithItem:self.textLabel attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeWidth multiplier:1.0 constant:-NYTPhotoCaptionViewHorizontalMargin * 2.0];
    NSLayoutConstraint *horizontalPositionConstraint = [NSLayoutConstraint constraintWithItem:self.textLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0.0];

    [self addConstraints:@[topConstraint, bottomConstraint, widthConstraint, horizontalPositionConstraint]];
}

- (void)setupGradient {
    self.gradientLayer = [CAGradientLayer layer];
    self.gradientLayer.frame = self.layer.bounds;
    self.gradientLayer.colors = [NSArray arrayWithObjects:(id)[UIColor clearColor].CGColor, (id)[[UIColor blackColor] colorWithAlphaComponent:0.85].CGColor, nil];
    [self.layer insertSublayer:self.gradientLayer atIndex:0];
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
        if (self.attributedTitle) {
            [attributedLabelText appendAttributedString:[[NSAttributedString alloc] initWithString:@"\n" attributes:nil]];
        }
        [attributedLabelText appendAttributedString:self.attributedSummary];
    }
    
    if (self.attributedCredit) {
        if (self.attributedTitle || self.attributedSummary) {
            [attributedLabelText appendAttributedString:[[NSAttributedString alloc] initWithString:@"\n" attributes:nil]];
        }
        [attributedLabelText appendAttributedString:self.attributedCredit];
    }
    
    self.textLabel.attributedText = attributedLabelText;
}

@end
