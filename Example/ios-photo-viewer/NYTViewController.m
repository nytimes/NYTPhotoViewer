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
        NYTExamplePhoto *photo = [[NYTExamplePhoto alloc] init];
        
        photo.image = [UIImage imageNamed:@"testImage"];
        if (i == 1 || i == 3) {
            photo.image = nil;
        }
        
        photo.identifier = @(i).stringValue;
        [photos addObject:photo];
    }
    
    NYTPhotosViewController *photosViewController = [[NYTPhotosViewController alloc] initWithPhotos:photos];
    photosViewController.delegate = self;

    [self presentViewController:photosViewController animated:YES completion:nil];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        for (NYTExamplePhoto *photo in photos) {
            [photosViewController updateImage:[UIImage imageNamed:@"testImage"] forPhoto:photo];
        }
    });
}

- (UIView *)photosViewController:(NYTPhotosViewController *)photosViewController referenceViewForPhoto:(id<NYTPhoto>)photo {
    return self.imageButton;
}

@end
