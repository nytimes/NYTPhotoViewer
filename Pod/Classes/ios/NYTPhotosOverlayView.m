//
//  NYTPhotosOverlayView.m
//  Pods
//
//  Created by Brian Capps on 2/17/15.
//
//

#import "NYTPhotosOverlayView.h"

@interface NYTPhotosOverlayView ()

@property (nonatomic) UINavigationItem *titleItem;
@property (nonatomic) UINavigationBar *navigationBar;

@end

@implementation NYTPhotosOverlayView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        self.userInteractionEnabled = NO;
        [self setupNavigationBar];
    }
    
    return self;
}

- (void)setupNavigationBar {
    self.navigationBar = [[UINavigationBar alloc] init];
    self.navigationBar.translatesAutoresizingMaskIntoConstraints = NO;
    
    // Make navigaiton bar background fully transparent.
    self.navigationBar.backgroundColor = [UIColor clearColor];
    self.navigationBar.shadowImage = [[UIImage alloc] init];
    [self.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    
    self.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor]};
    
    self.titleItem = [[UINavigationItem alloc] initWithTitle:nil];
    self.navigationBar.items = @[self.titleItem];
    
    [self addSubview:self.navigationBar];
    
    NSLayoutConstraint *heightConstraint = [NSLayoutConstraint constraintWithItem:self.navigationBar attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeHeight multiplier:1.0 constant:44.0];
    [self.navigationBar addConstraints:@[heightConstraint]];
    
    NSLayoutConstraint *topConstraint = [NSLayoutConstraint constraintWithItem:self.navigationBar attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1.0 constant:0.0];
    NSLayoutConstraint *widthConstraint = [NSLayoutConstraint constraintWithItem:self.navigationBar attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0.0];
    NSLayoutConstraint *horizontalPositionConstraint = [NSLayoutConstraint constraintWithItem:self.navigationBar attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0.0];
    [self addConstraints:@[topConstraint, widthConstraint, horizontalPositionConstraint]];
}

- (NSString *)title {
    return self.titleItem.title;
}

- (void)setTitle:(NSString *)title {
    self.titleItem.title = title;
}

@end
