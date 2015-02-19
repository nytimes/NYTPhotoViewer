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

const NSUInteger NYTViewControllerCustomEverythingPhotoIndex = 1;
const NSUInteger NYTViewControllerDefaultLoadingSpinnerPhotoIndex = 3;

@interface NYTViewController () <NYTPhotosViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UIButton *imageButton;

@end

@implementation NYTViewController

- (IBAction)imageButtonTapped:(id)sender {
    NSArray *photos = [[self class] newTestPhotos];
    
    NYTPhotosViewController *photosViewController = [[NYTPhotosViewController alloc] initWithPhotos:photos];
    photosViewController.delegate = self;
    [self presentViewController:photosViewController animated:YES completion:nil];
    
    [self updateImagesOnPhotosViewController:photosViewController afterDelayWithPhotos:photos];
}

// This method simulates previously blank photos loading their images after some time.
- (void)updateImagesOnPhotosViewController:(NYTPhotosViewController *)photosViewController afterDelayWithPhotos:(NSArray *)photos {
    CGFloat updateImageDelay = 5.0;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(updateImageDelay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        for (NYTExamplePhoto *photo in photos) {
            if (!photo.image) {
                [photosViewController updateImage:[UIImage imageNamed:@"testImage"] forPhoto:photo];
            }
        }
    });
}

+ (NSArray *)newTestPhotos {
    NSMutableArray *photos = [NSMutableArray array];
    
    for (int i = 0; i < 5; i++) {
        NYTExamplePhoto *photo = [[NYTExamplePhoto alloc] init];
        
        photo.image = [UIImage imageNamed:@"testImage"];
        if (i == NYTViewControllerCustomEverythingPhotoIndex || i == NYTViewControllerDefaultLoadingSpinnerPhotoIndex) {
            photo.image = nil;
        }
        
        photo.attributedCaptionTitle = [[NSAttributedString alloc] initWithString:@(i + 1).stringValue attributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
        photo.attributedCaptionSummary = [[NSAttributedString alloc] initWithString:@"summary" attributes:@{NSForegroundColorAttributeName: [UIColor grayColor]}];
        photo.attributedCaptionCredit = [[NSAttributedString alloc] initWithString:@"credit" attributes:@{NSForegroundColorAttributeName: [UIColor darkGrayColor]}];
        
        photo.identifier = @(i).stringValue;
        [photos addObject:photo];
    }
    
    return photos;
}

#pragma mark - NYTPhotosViewControllerDelegate

- (UIView *)photosViewController:(NYTPhotosViewController *)photosViewController referenceViewForPhoto:(id<NYTPhoto>)photo {
    return self.imageButton;
}

- (UIView *)photosViewController:(NYTPhotosViewController *)photosViewController activityViewForPhoto:(id<NYTPhoto>)photo {
    if ([photo.identifier isEqualToString:@(NYTViewControllerCustomEverythingPhotoIndex).stringValue]) {
        UILabel *loadingLabel = [[UILabel alloc] init];
        loadingLabel.text = @"Custom Loading...";
        loadingLabel.textColor = [UIColor whiteColor];
        return loadingLabel;
    }
    
    return nil;
}

- (UIView *)photosViewController:(NYTPhotosViewController *)photosViewController captionViewForPhoto:(id<NYTPhoto>)photo {
    if ([photo.identifier isEqualToString:@(NYTViewControllerCustomEverythingPhotoIndex).stringValue]) {
        UILabel *label = [[UILabel alloc] init];
        label.text = @"Custom Caption View";
        label.textColor = [UIColor whiteColor];
        label.backgroundColor = [UIColor redColor];
        return label;
    }
    
    return nil;
}

- (NSDictionary *)photosViewController:(NYTPhotosViewController *)photosViewController overlayTitleTextAttributesForPhoto:(id<NYTPhoto>)photo {
    if ([photo.identifier isEqualToString:@(NYTViewControllerCustomEverythingPhotoIndex).stringValue]) {
        return @{NSForegroundColorAttributeName: [UIColor grayColor]};
    }
    
    return nil;
}

- (void)photosViewController:(NYTPhotosViewController *)photosViewController didDisplayPhoto:(id<NYTPhoto>)photo {
    NSLog(@"Did Display Photo: %@ identifier: %@", photo, photo.identifier);
}

- (void)photosViewController:(NYTPhotosViewController *)photosViewController actionCompletedWithActivityType:(NSString *)activityType {
    NSLog(@"Action Completed With Activity Type: %@", activityType);
}

- (void)photosViewControllerDidDismiss:(NYTPhotosViewController *)photosViewController {
    NSLog(@"Did Dismiss Photo Viewer: %@", photosViewController);
}

@end
