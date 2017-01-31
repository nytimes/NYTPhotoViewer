//
//  NYTViewController.m
//  ios-photo-viewer
//
//  Created by Brian Capps on 02/11/2015.
//  Copyright (c) 2014 Brian Capps. All rights reserved.
//

#import "NYTViewController.h"
#import <NYTPhotoViewer/NYTPhotosViewController.h>
#import <NYTPhotoViewer/NYTPhotoViewerArrayDataSource.h>
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
@property (nonatomic) NYTPhotoViewerArrayDataSource *dataSource;

@end

@implementation NYTViewController

- (IBAction)imageButtonTapped:(id)sender {
    self.dataSource = [self.class newTimesBuildingDataSource];

    NYTPhotosViewController *photosViewController = [[NYTPhotosViewController alloc] initWithDataSource:self.dataSource initialPhoto:nil delegate:self];

    [self presentViewController:photosViewController animated:YES completion:nil];

    [self updateImagesOnPhotosViewController:photosViewController afterDelayWithDataSource:self.dataSource];
    BOOL demonstrateDataSourceSwitchAfterTenSeconds = NO;
    if (demonstrateDataSourceSwitchAfterTenSeconds) {
        [self switchDataSourceOnPhotosViewController:photosViewController afterDelayWithDataSource:self.dataSource];
    }
}

// This method simulates a previously blank photo loading its images after 5 seconds.
- (void)updateImagesOnPhotosViewController:(NYTPhotosViewController *)photosViewController afterDelayWithDataSource:(NYTPhotoViewerArrayDataSource *)dataSource {
    if (dataSource != self.dataSource) {
        return;
    }

    CGFloat updateImageDelay = 5.0;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(updateImageDelay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        for (NYTExamplePhoto *photo in dataSource.photos) {
            if (!photo.image && !photo.imageData) {
                photo.image = [UIImage imageNamed:@"NYTimesBuilding"];
                photo.attributedCaptionSummary = [[NSAttributedString alloc] initWithString:@"Photo which previously had a loading spinner (to see the spinner, reopen the photo viewer and scroll to this photo)" attributes:@{NSForegroundColorAttributeName: [UIColor whiteColor], NSFontAttributeName: [UIFont preferredFontForTextStyle:UIFontTextStyleBody]}];
                [photosViewController updatePhoto:photo];
            }
        }
    });
}

// This method simulates completely swapping out the data source, after 10 seconds.
- (void)switchDataSourceOnPhotosViewController:(NYTPhotosViewController *)photosViewController afterDelayWithDataSource:(NYTPhotoViewerArrayDataSource *)dataSource {
    if (dataSource != self.dataSource) {
        return;
    }

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NYTExamplePhoto *photoWithLongCaption = (NYTExamplePhoto *)dataSource[NYTViewControllerPhotoIndexLongCaption];
        photosViewController.delegate = nil; // delegate methods in this VC are intended for use with the TimesBuildingDataSource
        self.dataSource = [self.class newVariedDataSourceIncludingPhoto:photoWithLongCaption];
        photosViewController.dataSource = self.dataSource;
        [photosViewController reloadPhotosAnimated:YES];
    });
}

#pragma mark - NYTPhotosViewControllerDelegate

- (UIView *)photosViewController:(NYTPhotosViewController *)photosViewController referenceViewForPhoto:(id <NYTPhoto>)photo {
    if ([photo isEqual:self.dataSource[NYTViewControllerPhotoIndexNoReferenceView]]) {
        return nil;
    }
    
    return self.imageButton;
}

- (UIView *)photosViewController:(NYTPhotosViewController *)photosViewController loadingViewForPhoto:(id <NYTPhoto>)photo {
    if ([photo isEqual:self.dataSource.photos[NYTViewControllerPhotoIndexCustomEverything]]) {
        UILabel *loadingLabel = [[UILabel alloc] init];
        loadingLabel.text = @"Custom Loading...";
        loadingLabel.textColor = [UIColor greenColor];
        return loadingLabel;
    }
    
    return nil;
}

- (UIView *)photosViewController:(NYTPhotosViewController *)photosViewController captionViewForPhoto:(id <NYTPhoto>)photo {
    if ([photo isEqual:self.dataSource.photos[NYTViewControllerPhotoIndexCustomEverything]]) {
        UILabel *label = [[UILabel alloc] init];
        label.text = @"Custom Caption View";
        label.textColor = [UIColor whiteColor];
        label.backgroundColor = [UIColor redColor];
        return label;
    }
    
    return nil;
}

- (CGFloat)photosViewController:(NYTPhotosViewController *)photosViewController maximumZoomScaleForPhoto:(id <NYTPhoto>)photo {
    if ([photo isEqual:self.dataSource.photos[NYTViewControllerPhotoIndexCustomMaxZoomScale]]) {
        return 0.5f;
    }

    return 1.0f;
}

- (NSDictionary *)photosViewController:(NYTPhotosViewController *)photosViewController overlayTitleTextAttributesForPhoto:(id <NYTPhoto>)photo {
    if ([photo isEqual:self.dataSource.photos[NYTViewControllerPhotoIndexCustomEverything]]) {
        return @{NSForegroundColorAttributeName: [UIColor grayColor]};
    }
    
    return nil;
}

- (NSString *)photosViewController:(NYTPhotosViewController *)photosViewController titleForPhoto:(id<NYTPhoto>)photo atIndex:(NSInteger)photoIndex totalPhotoCount:(nullable NSNumber *)totalPhotoCount {
    if ([photo isEqual:self.dataSource.photos[NYTViewControllerPhotoIndexCustomEverything]]) {
        return [NSString stringWithFormat:@"%lu/%lu", (unsigned long)photoIndex+1, (unsigned long)totalPhotoCount.integerValue];
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

#pragma mark - Sample Data Sources

+ (NYTPhotoViewerArrayDataSource *)newTimesBuildingDataSource {
    NSMutableArray *photos = [NSMutableArray array];

    for (NSUInteger i = 0; i < NYTViewControllerPhotoCount; i++) {
        NYTExamplePhoto *photo = [NYTExamplePhoto new];

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

        NSString *caption = @"<photo summary>";
        switch ((NYTViewControllerPhotoIndex)i) {
            case NYTViewControllerPhotoIndexCustomEverything:
                caption = @"Photo with custom everything";
                break;
            case NYTViewControllerPhotoIndexLongCaption:
                caption = @"Photo with long caption.\n\nLorem ipsum dolor sit amet, consectetur adipiscing elit. Vestibulum maximus laoreet vehicula. Maecenas elit quam, pellentesque at tempor vel, tempus non sem. Vestibulum ut aliquam elit. Vivamus rhoncus sapien turpis, at feugiat augue luctus id. Nulla mi urna, viverra sed augue malesuada, bibendum bibendum massa. Cras urna nibh, lacinia vitae feugiat eu, consectetur a tellus. Morbi venenatis nunc sit amet varius pretium. Duis eget sem nec nulla lobortis finibus. Nullam pulvinar gravida est eget tristique. Curabitur faucibus nisl eu diam ullamcorper, at pharetra eros dictum. Suspendisse nibh urna, ultrices a augue a, euismod mattis felis. Ut varius tortor ac efficitur pellentesque. Mauris sit amet rhoncus dolor. Proin vel porttitor mi. Pellentesque lobortis interdum turpis, vitae tincidunt purus vestibulum vel. Phasellus tincidunt vel mi sit amet congue.";
                break;
            case NYTViewControllerPhotoIndexDefaultLoadingSpinner:
                caption = @"Photo with loading spinner";
                break;
            case NYTViewControllerPhotoIndexNoReferenceView:
                caption = @"Photo without reference view";
                break;
            case NYTViewControllerPhotoIndexCustomMaxZoomScale:
                caption = @"Photo with custom maximum zoom scale";
                break;
            case NYTViewControllerPhotoIndexGif:
                caption = @"Animated GIF";
                break;
            case NYTViewControllerPhotoCount:
                // this case statement intentionally left blank.
                break;
        }

        photo.attributedCaptionTitle = [self attributedTitleFromString:@(i + 1).stringValue];
        photo.attributedCaptionSummary = [self attributedSummaryFromString:caption];

        if (i != NYTViewControllerPhotoIndexGif) {
            photo.attributedCaptionCredit = [self attributedCreditFromString:@"Photo: Nic Lehoux"];
        }

        [photos addObject:photo];
    }

    return [NYTPhotoViewerArrayDataSource dataSourceWithPhotos:photos];
}

/// A second set of test photos, to demonstrate reloading the entire data source.
+ (NYTPhotoViewerArrayDataSource *)newVariedDataSourceIncludingPhoto:(NYTExamplePhoto *)photo {
    NSMutableArray *photos = [NSMutableArray array];

    [photos addObject:({
        NYTExamplePhoto *p = [NYTExamplePhoto new];
        p.image = [UIImage imageNamed:@"Chess"];
        p.attributedCaptionTitle = [self attributedTitleFromString:@"Chess"];
        p.attributedCaptionCredit = [self attributedCreditFromString:@"Photo: Chris Dzombak"];
        p;
    })];

    [photos addObject:({
        NYTExamplePhoto *p = photo;
        photo.attributedCaptionTitle = nil;
        p.attributedCaptionSummary = [self attributedSummaryFromString:@"This photo’s caption has changed in the data source."];
        p;
    })];
    
    return [NYTPhotoViewerArrayDataSource dataSourceWithPhotos:photos];
}

+ (NSAttributedString *)attributedTitleFromString:(NSString *)caption {
    return [[NSAttributedString alloc] initWithString:caption attributes:@{NSForegroundColorAttributeName: [UIColor whiteColor], NSFontAttributeName: [UIFont preferredFontForTextStyle:UIFontTextStyleBody]}];
}

+ (NSAttributedString *)attributedSummaryFromString:(NSString *)summary {
    return [[NSAttributedString alloc] initWithString:summary attributes:@{NSForegroundColorAttributeName: [UIColor lightGrayColor], NSFontAttributeName: [UIFont preferredFontForTextStyle:UIFontTextStyleBody]}];
}

+ (NSAttributedString *)attributedCreditFromString:(NSString *)credit {
    return [[NSAttributedString alloc] initWithString:credit attributes:@{NSForegroundColorAttributeName: [UIColor grayColor], NSFontAttributeName: [UIFont preferredFontForTextStyle:UIFontTextStyleCaption1]}];
}

@end
