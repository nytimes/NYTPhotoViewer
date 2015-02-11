//
//  NYTPhotoViewController.m
//  Pods
//
//  Created by Brian Capps on 2/11/15.
//
//

#import "NYTPhotoViewController.h"

@interface NYTPhotoViewController ()

@property (nonatomic) id <NYTPhoto> photo;

@end

@implementation NYTPhotoViewController

#pragma mark - UIViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    return [self initWithPhoto:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSInteger possibilities = 255;
    NSInteger randomInt = arc4random() % possibilities;
    CGFloat randomFloat = (CGFloat)randomInt / (CGFloat)possibilities;

    self.view.backgroundColor = [UIColor colorWithRed:randomFloat green:1.0 blue:1.0 alpha:randomFloat];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - NYTPhotoViewController

- (instancetype)initWithPhoto:(id <NYTPhoto>)photo {
    self = [super initWithNibName:nil bundle:nil];
    
    if (self) {
        _photo = photo;
    }
    
    return self;
}


@end
