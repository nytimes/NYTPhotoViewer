//
//  PhotosProvider.swift
//  NYTPhotoViewer
//
//  Created by Mark Keefe on 3/20/15.
//  Copyright (c) 2015 The New York Times. All rights reserved.
//

import UIKit
import NYTPhotoViewer

/**
 *   Struct for constants
 */
struct Constants {
    static let PrimaryImageName = "NYTimesBuilding"
    static let PlaceholderImageName = "NYTimesBuildingPlaceholder"
}

/**
 * Photo Index types for different pictures in our data source.
 */
enum ViewControllerPhotoIndex : Int {
    case CustomEverything = 1
    case LongCaption = 2
    case DefaultLoadingSpinner = 3
    case NoReferenceView = 4
    case CustomMaxZoomScale = 5
    case PhotoIndexGif = 6
}

class PhotosProvider: NSObject {

    let photos: [ExamplePhoto] = {
        
        var mutablePhotos: [ExamplePhoto] = []
        var image = UIImage(named: Constants.PrimaryImageName)
        let NumberOfPhotos = 7

        for photoIndex in 0 ..< NumberOfPhotos {
            
            let photo = ExamplePhoto()
            var caption = "Summary"
            switch(photoIndex)
            {
                
            case ViewControllerPhotoIndex.CustomEverything.rawValue:
                photo.image = nil
                photo.placeholderImage = UIImage(named: "NYTimesBuilding")
                caption = "photo with custom everything";
                
                
            case ViewControllerPhotoIndex.LongCaption.rawValue:
                caption = "photo with long caption. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vestibulum maximus laoreet vehicula. Maecenas elit quam, pellentesque at tempor vel, tempus non sem. Vestibulum ut aliquam elit. Vivamus rhoncus sapien turpis, at feugiat augue luctus id. Nulla mi urna, viverra sed augue malesuada, bibendum bibendum massa. Cras urna nibh, lacinia vitae feugiat eu, consectetur a tellus. Morbi venenatis nunc sit amet varius pretium. Duis eget sem nec nulla lobortis finibus. Nullam pulvinar gravida est eget tristique. Curabitur faucibus nisl eu diam ullamcorper, at pharetra eros dictum. Suspendisse nibh urna, ultrices a augue a, euismod mattis felis. Ut varius tortor ac efficitur pellentesque. Mauris sit amet rhoncus dolor. Proin vel porttitor mi. Pellentesque lobortis interdum turpis, vitae tincidunt purus vestibulum vel. Phasellus tincidunt vel mi sit amet congue.";
                
            case ViewControllerPhotoIndex.DefaultLoadingSpinner.rawValue:
                photo.image = nil
                caption = "photo with loading spinner";
                
            case ViewControllerPhotoIndex.NoReferenceView.rawValue:
                photo.image = nil
                caption = "photo without reference view";
                
            case ViewControllerPhotoIndex.CustomMaxZoomScale.rawValue:
                photo.image = nil
                caption = "photo with custom maximum zoom scale";
                
            case ViewControllerPhotoIndex.PhotoIndexGif.rawValue:
                photo.imageData = NSData(contentsOfFile: NSBundle.mainBundle().pathForResource("giphy", ofType: "gif")!)
                caption = "animated GIF";
                
            default:
                break
            }
            
            photo.attributedCaptionTitle = NSAttributedString(string: "\(photoIndex + 1)", attributes: [NSForegroundColorAttributeName: UIColor.whiteColor()])
            photo.attributedCaptionSummary = NSAttributedString(string: caption, attributes: [NSForegroundColorAttributeName: UIColor.lightGrayColor(),NSFontAttributeName:UIFont.preferredFontForTextStyle(UIFontTextStyleBody)])
            photo.attributedCaptionCredit = NSAttributedString(string: "NYT Building Photo Credit: Nic Lehoux", attributes: [NSForegroundColorAttributeName: UIColor.grayColor(),NSFontAttributeName:UIFont.preferredFontForTextStyle(UIFontTextStyleCaption1)])
            
            mutablePhotos.append(photo)
        }
        
        return mutablePhotos
    }()
}


