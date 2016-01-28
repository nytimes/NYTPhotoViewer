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

typedef NS_ENUM(NSUInteger, NYTViewControllerPhotoIndex) {
    NYTViewControllerPhotoIndexCustomEverything = 1,
    NYTViewControllerPhotoIndexLongCaption = 2,
    NYTViewControllerPhotoIndexDefaultLoadingSpinner = 3,
    NYTViewControllerPhotoIndexNoReferenceView = 4,
    NYTViewControllerPhotoIndexCustomMaxZoomScale = 5,
    NYTViewControllerPhotoIndexGif = 6,
    NYTViewControllerPhotoCount,
};

@interface NYTViewController () <NYTPhotosViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UIButton *imageButton;
@property (nonatomic) NSArray *photos;

@end

@implementation NYTViewController

- (IBAction)imageButtonTapped:(id)sender {
    self.photos = [[self class] newTestPhotos];
    
    NYTPhotosViewController *photosViewController = [[NYTPhotosViewController alloc] initWithPhotos:self.photos];
    photosViewController.delegate = self;
    [self presentViewController:photosViewController animated:YES completion:nil];
    
    [self updateImagesOnPhotosViewController:photosViewController afterDelayWithPhotos:self.photos];
}

// This method simulates previously blank photos loading their images after some time.
- (void)updateImagesOnPhotosViewController:(NYTPhotosViewController *)photosViewController afterDelayWithPhotos:(NSArray *)photos {
    CGFloat updateImageDelay = 5.0;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(updateImageDelay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        for (NYTExamplePhoto *photo in photos) {
            if (!photo.image && !photo.imageData) {
                photo.image = [UIImage imageNamed:@"NYTimesBuilding"];
                [photosViewController updateImageForPhoto:photo];
            }
        }
    });
}

+ (NSArray *)newTestPhotos {
    NSMutableArray *photos = [NSMutableArray array];
    
    for (NSUInteger i = 0; i < NYTViewControllerPhotoCount; i++) {
        NYTExamplePhoto *photo = [[NYTExamplePhoto alloc] init];
        
        if (i == NYTViewControllerPhotoIndexGif) {
            photo.imageData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"giphy" ofType:@"gif"]];
        } else if (i == NYTViewControllerPhotoIndexCustomEverything || i == NYTViewControllerPhotoIndexDefaultLoadingSpinner) {
            // no-op, left here for clarity:
            photo.image = nil;
        } else {
            photo.image = [UIImage imageNamed:@"NYTimesBuilding"];
        }
        
        if (i == NYTViewControllerPhotoIndexCustomEverything) {
            photo.placeholderImage = [UIImage imageNamed:@"NYTimesBuildingPlaceholder"];
        }

        NSString *caption = @"summary";
        switch ((NYTViewControllerPhotoIndex)i) {
            case NYTViewControllerPhotoIndexCustomEverything:
                caption = @"photo with custom everything";
                break;
            case NYTViewControllerPhotoIndexLongCaption:
                caption = @"photo with long caption. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vestibulum maximus laoreet vehicula. Maecenas elit quam, pellentesque at tempor vel, tempus non sem. Vestibulum ut aliquam elit. Vivamus rhoncus sapien turpis, at feugiat augue luctus id. Nulla mi urna, viverra sed augue malesuada, bibendum bibendum massa. Cras urna nibh, lacinia vitae feugiat eu, consectetur a tellus. Morbi venenatis nunc sit amet varius pretium. Duis eget sem nec nulla lobortis finibus. Nullam pulvinar gravida est eget tristique. Curabitur faucibus nisl eu diam ullamcorper, at pharetra eros dictum. Suspendisse nibh urna, ultrices a augue a, euismod mattis felis. Ut varius tortor ac efficitur pellentesque. Mauris sit amet rhoncus dolor. Proin vel porttitor mi. Pellentesque lobortis interdum turpis, vitae tincidunt purus vestibulum vel. Phasellus tincidunt vel mi sit amet congue.";
                break;
            case NYTViewControllerPhotoIndexDefaultLoadingSpinner:
                caption = @"photo with loading spinner";
                break;
            case NYTViewControllerPhotoIndexNoReferenceView:
                caption = @"photo without reference view";
                break;
            case NYTViewControllerPhotoIndexCustomMaxZoomScale:
                caption = @"photo with custom maximum zoom scale";
                break;
            case NYTViewControllerPhotoIndexGif:
                caption = @"animated GIF";
                break;
            case NYTViewControllerPhotoCount:
                // this case statement intentionally left blank.
                break;
        }
        
        photo.attributedCaptionTitle = [[NSAttributedString alloc] initWithString:@(i + 1).stringValue attributes:@{NSForegroundColorAttributeName: [UIColor whiteColor], NSFontAttributeName: [UIFont preferredFontForTextStyle:UIFontTextStyleBody]}];
        photo.attributedCaptionSummary = [[NSAttributedString alloc] initWithString:caption attributes:@{NSForegroundColorAttributeName: [UIColor lightGrayColor], NSFontAttributeName: [UIFont preferredFontForTextStyle:UIFontTextStyleBody]}];
        photo.attributedCaptionCredit = [[NSAttributedString alloc] initWithString:@"NYT Building Photo Credit: Nic Lehoux" attributes:@{NSForegroundColorAttributeName: [UIColor grayColor], NSFontAttributeName: [UIFont preferredFontForTextStyle:UIFontTextStyleCaption1]}];

        [photos addObject:photo];
    }
    
    return photos;
}

#pragma mark - NYTPhotosViewControllerDelegate

- (UIView *)photosViewController:(NYTPhotosViewController *)photosViewController referenceViewForPhoto:(id <NYTPhoto>)photo {
    if ([photo isEqual:self.photos[NYTViewControllerPhotoIndexNoReferenceView]]) {
        return nil;
    }
    
    return self.imageButton;
}

- (UIView *)photosViewController:(NYTPhotosViewController *)photosViewController loadingViewForPhoto:(id <NYTPhoto>)photo {
    if ([photo isEqual:self.photos[NYTViewControllerPhotoIndexCustomEverything]]) {
        UILabel *loadingLabel = [[UILabel alloc] init];
        loadingLabel.text = @"Custom Loading...";
        loadingLabel.textColor = [UIColor greenColor];
        return loadingLabel;
    }
    
    return nil;
}

- (UIView *)photosViewController:(NYTPhotosViewController *)photosViewController captionViewForPhoto:(id <NYTPhoto>)photo {
    if ([photo isEqual:self.photos[NYTViewControllerPhotoIndexCustomEverything]]) {
        UILabel *label = [[UILabel alloc] init];
        label.text = @"Custom Caption View";
        label.textColor = [UIColor whiteColor];
        label.backgroundColor = [UIColor redColor];
        return label;
    }
    
    return nil;
}

- (CGFloat)photosViewController:(NYTPhotosViewController *)photosViewController maximumZoomScaleForPhoto:(id <NYTPhoto>)photo {
    if ([photo isEqual:self.photos[NYTViewControllerPhotoIndexCustomMaxZoomScale]]) {
        return 10.0f;
    }

    return 1.0f;
}

- (NSDictionary *)photosViewController:(NYTPhotosViewController *)photosViewController overlayTitleTextAttributesForPhoto:(id <NYTPhoto>)photo {
    if ([photo isEqual:self.photos[NYTViewControllerPhotoIndexCustomEverything]]) {
        return @{NSForegroundColorAttributeName: [UIColor grayColor]};
    }
    
    return nil;
}

- (NSString *)photosViewController:(NYTPhotosViewController *)photosViewController titleForPhoto:(id<NYTPhoto>)photo atIndex:(NSUInteger)photoIndex totalPhotoCount:(NSUInteger)totalPhotoCount {
    if ([photo isEqual:self.photos[NYTViewControllerPhotoIndexCustomEverything]]) {
        return [NSString stringWithFormat:@"%lu/%lu", (unsigned long)photoIndex+1, (unsigned long)totalPhotoCount];
    }

    return nil;
}

- (void)photosViewController:(NYTPhotosViewController *)photosViewController didNavigateToPhoto:(id <NYTPhoto>)photo atIndex:(NSUInteger)photoIndex {
    NSLog(@"Did Navigate To Photo: %@ identifier: %lu", photo, (unsigned long)photoIndex);
}

- (void)photosViewController:(NYTPhotosViewController *)photosViewController actionCompletedWithActivityType:(NSString *)activityType {
    NSLog(@"Action Completed With Activity Type: %@", activityType);
}

- (void)photosViewControllerDidDismiss:(NYTPhotosViewController *)photosViewController {
    NSLog(@"Did Dismiss Photo Viewer: %@", photosViewController);
}

@end
