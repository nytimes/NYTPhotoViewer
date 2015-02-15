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

@interface NYTViewController () <NYTPhotosViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UIButton *imageButton;

@end

@implementation NYTViewController

- (IBAction)imageButtonTapped:(id)sender {
    NSMutableArray *photos = [NSMutableArray array];
    
    for (int i = 0; i < 5; i++) {
        [photos addObject:[[NYTExamplePhoto alloc] init]];
    }
    
    NYTPhotosViewController *photosViewController = [[NYTPhotosViewController alloc] initWithPhotos:photos];
    photosViewController.delegate = self;
    [self presentViewController:photosViewController animated:YES completion:nil];
}

- (UIView *)photosViewController:(NYTPhotosViewController *)photosViewController referenceViewForPhoto:(id<NYTPhoto>)photo {
    return self.imageButton;
}

@end
