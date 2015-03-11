//
//  NYTPhotoCaptionView.m
//  Pods
//
//  Created by Brian Capps on 2/18/15.
//
//

#import "NYTPhotoCaptionView.h"

const CGFloat NYTPhotoCaptionViewHorizontalMargin = 16.0;
static const CGFloat NYTPhotoCaptionViewVerticalMargin = 12.0;

@interface NYTPhotoCaptionView ()

@property (nonatomic) NSAttributedString *attributedTitle;
@property (nonatomic) NSAttributedString *attributedSummary;
@property (nonatomic) NSAttributedString *attributedCredit;

@property (nonatomic) UILabel *textLabel;
@property (nonatomic) CAGradientLayer *gradientLayer;

@end

@implementation NYTPhotoCaptionView

#pragma mark - UIView

- (instancetype)initWithFrame:(CGRect)frame {
    return [self initWithAttributedTitle:nil attributedSummary:nil attributedCredit:nil];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.gradientLayer.frame = self.layer.bounds;
}

#pragma mark - NYTPhotoCaptionView

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

- (void)updateTextLabelAttributedText {
    NSMutableAttributedString *attributedLabelText = [[NSMutableAttributedString alloc] init];
    
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
