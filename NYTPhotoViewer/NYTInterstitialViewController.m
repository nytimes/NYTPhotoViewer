//
//  NYTInterstitialViewController.m
//  NYTPhotoViewer
//
//  Created by Howarth, Craig on 4/17/18.
//  Copyright © 2018 NYTimes. All rights reserved.
//

#import "NYTInterstitialViewController.h"
#import "NYTPhoto.h"

@interface NYTInterstitialViewController ()

@property (nonatomic, nullable) id <NYTPhoto> photo;
@property (nonatomic, nullable) UIView *interstitialView;
@property (nonatomic) NSUInteger photoViewItemIndex;
@property (nonatomic, nullable) NSArray<NSLayoutConstraint *> *constraints;

- (instancetype)initWithCoder:(NSCoder *)aDecoder NS_DESIGNATED_INITIALIZER;

@end

@implementation NYTInterstitialViewController

#pragma mark - UIViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    return [self initWithView:nil itemIndex:0];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];

    if (self) {
        [self commonInitWithView:nil itemIndex:0];
    }

    return self;
}

- (void)prepareLayout {
    if (self.interstitialView.translatesAutoresizingMaskIntoConstraints) {
        self.interstitialView.center = CGPointMake(CGRectGetMidX(self.view.bounds), CGRectGetMidY(self.view.bounds));
    } else if (self.constraints == NULL) {
        self.constraints = @[
          [self.interstitialView.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor],
          [self.interstitialView.centerYAnchor constraintEqualToAnchor:self.view.centerYAnchor],
        ];
        [NSLayoutConstraint activateConstraints:self.constraints];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.view addSubview:self.interstitialView];
    [self prepareLayout];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    [self prepareLayout];
}

- (BOOL)prefersHomeIndicatorAutoHidden {
    return YES;
}

#pragma mark - NYTPhotoViewController

- (instancetype)initWithView:(UIView *)interstitialView itemIndex:(NSUInteger)itemIndex {
    self = [super initWithNibName:nil bundle:nil];

    if (self) {
        [self commonInitWithView:interstitialView itemIndex:itemIndex];
    }

    return self;
}

- (void)commonInitWithView:(UIView *)interstitialView itemIndex:(NSUInteger)itemIndex {
    _photo = nil;
    _photoViewItemIndex = itemIndex;
    _interstitialView = interstitialView;
}

@end
