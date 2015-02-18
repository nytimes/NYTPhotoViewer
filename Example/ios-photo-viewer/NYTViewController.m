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
        
        photo.attributedCaptionTitle = [[NSAttributedString alloc] initWithString:@(i + 1).stringValue attributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
        photo.attributedCaptionSummary = [[NSAttributedString alloc] initWithString:@"summary" attributes:@{NSForegroundColorAttributeName: [UIColor grayColor]}];
        photo.attributedCaptionCredit = [[NSAttributedString alloc] initWithString:@"credit" attributes:@{NSForegroundColorAttributeName: [UIColor darkGrayColor]}];

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

#pragma mark - NYTPhotosViewControllerDelegate

- (UIView *)photosViewController:(NYTPhotosViewController *)photosViewController referenceViewForPhoto:(id<NYTPhoto>)photo {
    return self.imageButton;
}

- (UIView *)photosViewController:(NYTPhotosViewController *)photosViewController activityViewForPhoto:(id<NYTPhoto>)photo {
    if ([photo.identifier isEqualToString:@(1).stringValue]) {
        UILabel *loadingLabel = [[UILabel alloc] init];
        loadingLabel.text = @"Loading Image...";
        loadingLabel.textColor = [UIColor whiteColor];
        return loadingLabel;
    }
    
    return nil;
}

- (UIView *)photosViewController:(NYTPhotosViewController *)photosViewController captionViewForPhoto:(id<NYTPhoto>)photo {
    if ([photo.identifier isEqualToString:@(1).stringValue]) {
        UILabel *label = [[UILabel alloc] init];
        label.text = @"Custom Caption View";
        label.textColor = [UIColor whiteColor];
        label.backgroundColor = [UIColor redColor];
        return label;
    }
    
    return nil;
}

- (void)photosViewController:(NYTPhotosViewController *)photosViewController didDisplayPhoto:(id<NYTPhoto>)photo {
    NSLog(@"Did Display Photo: %@", photo);
}

@end
