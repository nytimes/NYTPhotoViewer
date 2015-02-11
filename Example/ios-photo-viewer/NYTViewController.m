//
//  NYTViewController.m
//  ios-photo-viewer
//
//  Created by Brian Capps on 02/11/2015.
//  Copyright (c) 2014 Brian Capps. All rights reserved.
//

#import "NYTViewController.h"
#import <NYTPhotoViewer/NYTPhotosViewController.h>
#import "NYTExamplePhoto.h"

@interface NYTViewController ()

@end

@implementation NYTViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSMutableArray *photos = [NSMutableArray array];
    
    for (int i = 0; i < 5; i++) {
        [photos addObject:[[NYTExamplePhoto alloc] init]];
    }
    
    NYTPhotosViewController *photosViewController = [[NYTPhotosViewController alloc] initWithPhotos:photos];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self presentViewController:photosViewController animated:YES completion:nil];

    });
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
