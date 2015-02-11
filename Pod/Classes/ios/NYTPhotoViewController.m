//
//  NYTPhotoViewController.m
//  Pods
//
//  Created by Brian Capps on 2/11/15.
//
//

#import "NYTPhotoViewController.h"
#import "NYTPhoto.h"
#import "NYTScalingImageView.h"

@interface NYTPhotoViewController () <UIScrollViewDelegate>

@property (nonatomic) id <NYTPhoto> photo;

@property (nonatomic) NYTScalingImageView *scalingImageView;

@end

@implementation NYTPhotoViewController

#pragma mark - UIViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    return [self initWithPhoto:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
#warning Remove random BG color
    NSInteger possibilities = 255;
    NSInteger randomInt = arc4random() % possibilities;
    CGFloat randomFloat = (CGFloat)randomInt / (CGFloat)possibilities;

    self.view.backgroundColor = [UIColor colorWithRed:randomFloat green:1.0 blue:1.0 alpha:randomFloat];
    
    self.scalingImageView.frame = self.view.bounds;
    [self.view addSubview:self.scalingImageView];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    self.scalingImageView.frame = self.view.bounds;
}

#pragma mark - NYTPhotoViewController

- (instancetype)initWithPhoto:(id <NYTPhoto>)photo {
    self = [super initWithNibName:nil bundle:nil];
    
    if (self) {
        _photo = photo;
        _scalingImageView = [[NYTScalingImageView alloc] initWithImage:photo.image frame:CGRectZero];
        _scalingImageView.delegate = self;
    }
    
    return self;
}

#pragma mark - UIScrollViewDelegate

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.scalingImageView.internalImageView;
}

@end
