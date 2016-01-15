//
//  NYTLoadingIndicatorView.m
//  Pods
//
//  Created by Marcus Kida on 15/01/2016.
//
//

#import "NYTLoadingIndicatorView.h"

@interface NYTLoadingIndicatorView ()

@property (nonatomic) UIView *indicatorView;

@end

@implementation NYTLoadingIndicatorView

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup {
    self.backgroundColor = [UIColor clearColor];
    self.indicatorView = [[UIView alloc] init];
    self.indicatorView.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.indicatorView];
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    [self updateIndicatorView];
}

- (void)resetIndicatorHidden:(BOOL)hidden {
    self.indicatorView.frame = (CGRect){0, 0, 0, self.bounds.size.height};
    self.indicatorView.hidden = hidden;
}

- (void)updateIndicatorView {
    if (self.progress == 0.0f) {
        return [self resetIndicatorHidden:NO];
    }
    if (self.progress >= 1.0f) {
        return [self resetIndicatorHidden:YES];
    }
    self.indicatorView.frame = (CGRect){0, 0, [self progressWidth:self.progress], self.bounds.size.height};
}

- (CGFloat)progressWidth:(CGFloat)progress {
    return (self.bounds.size.width / 100) * (progress * 100);
}

- (void)setProgress:(CGFloat)progress {
    _progress = progress;
    [self updateIndicatorView];
}

@end
