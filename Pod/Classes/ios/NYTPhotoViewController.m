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
@property (nonatomic) UITapGestureRecognizer *doubleTapGestureRecognizer;

@end

@implementation NYTPhotoViewController

#pragma mark - NSObject

- (void)dealloc {
    _scalingImageView.delegate = nil;
}

#pragma mark - UIViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    return [self initWithPhoto:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
        
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
        
        [self setupGestureRecognizer];
    }
    
    return self;
}

#pragma mark - Gesture Recognizer

- (void)setupGestureRecognizer {
    UITapGestureRecognizer *doubleTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scrollViewDoubleTapped:)];
    doubleTapGestureRecognizer.numberOfTapsRequired = 2;
    [self.scalingImageView addGestureRecognizer:doubleTapGestureRecognizer];
}

- (void)scrollViewDoubleTapped:(UITapGestureRecognizer*)recognizer {
    CGPoint pointInView = [recognizer locationInView:self.scalingImageView.internalImageView];
    
    CGFloat newZoomScale = self.scalingImageView.zoomScale * 1.5;
    newZoomScale = MIN(newZoomScale, self.scalingImageView.maximumZoomScale);
    
    //If we've reached the maximum zoom scale, through double tapping, zoom back out.
    if (newZoomScale == self.scalingImageView.maximumZoomScale) {
        newZoomScale = self.scalingImageView.minimumZoomScale;
    }
    
    CGSize scrollViewSize = self.scalingImageView.bounds.size;
    
    CGFloat width = scrollViewSize.width / newZoomScale;
    CGFloat height = scrollViewSize.height / newZoomScale;
    CGFloat originX = pointInView.x - (width / 2.0);
    CGFloat originY = pointInView.y - (height / 2.0);
    
    CGRect rectToZoomTo = CGRectMake(originX, originY, width, height);
    
    [self.scalingImageView zoomToRect:rectToZoomTo animated:YES];
}

#pragma mark - UIScrollViewDelegate

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.scalingImageView.internalImageView;
}

@end
