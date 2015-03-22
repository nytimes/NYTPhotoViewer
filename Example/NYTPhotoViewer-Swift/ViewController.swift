//
//  ViewController.swift
//  NYTPhotoViewer-Swift
//
//  Created by Mark Keefe on 3/20/15.
//  Copyright (c) 2015 The New York Times. All rights reserved.
//

import UIKit

class ViewController: UIViewController, NYTPhotosViewControllerDelegate {

    @IBOutlet weak var imageButton : UIButton!
    private let photos = PhotosProvider.photos
    
    @IBAction func buttonTapped(sender: UIButton) {
        
        let photosViewController = NYTPhotosViewController(photos: photos as [AnyObject]!)
        photosViewController.delegate = self
        presentViewController(photosViewController, animated: true, completion: nil)
        
        updateImagesOnPhotosViewController(photosViewController, afterDelayWithPhotos: photos)
    }
    
    func updateImagesOnPhotosViewController(photosViewController: NYTPhotosViewController, afterDelayWithPhotos: [ExamplePhoto]) {
        let updateImageDelay: Int64 = 5
        let imageName = "testImage"

        let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(1 * Double(NSEC_PER_SEC)))
        
        dispatch_after(delayTime, dispatch_get_main_queue()) {
            for photo in self.photos {
                if photo.image == nil {
                    photo.image = UIImage(named: imageName)
                    photosViewController.updateImageForPhoto(photo)
                }
            }
        }
    }
    
    // MARK: - NYTPhotosViewControllerDelegate
    
    func photosViewController(photosViewController: NYTPhotosViewController!, referenceViewForPhoto photo: NYTPhoto!) -> UIView! {
        if photo as! ExamplePhoto == photos[PhotosProvider.NoReferenceViewPhotoIndex] {
            return nil
        }
        return imageButton
    }
    
    func photosViewController(photosViewController: NYTPhotosViewController!, loadingViewForPhoto photo: NYTPhoto!) -> UIView! {
        if photo as! ExamplePhoto == photos[PhotosProvider.CustomEverythingPhotoIndex] {
            var label = UILabel()
            label.text = "Custom Loading..."
            label.textColor = UIColor.greenColor()
            return label
        }
        return nil
    }
    
    func photosViewController(photosViewController: NYTPhotosViewController!, captionViewForPhoto photo: NYTPhoto!) -> UIView! {
        if photo as! ExamplePhoto == photos[PhotosProvider.CustomEverythingPhotoIndex] {
            var label = UILabel()
            label.text = "Custom Caption View"
            label.textColor = UIColor.whiteColor()
            label.backgroundColor = UIColor.redColor()
            return label
        }
        return nil
    }
    
    func photosViewController(photosViewController: NYTPhotosViewController!, didDisplayPhoto photo: NYTPhoto!, atIndex photoIndex: UInt) {
        println("Did Display Photo: \(photo) identifier: \(photoIndex)")
    }
    
    func photosViewController(photosViewController: NYTPhotosViewController!, actionCompletedWithActivityType activityType: String!) {
        println("Action Completed With Activity Type: \(activityType)")
    }

    func photosViewControllerDidDismiss(photosViewController: NYTPhotosViewController!) {
        println("Did dismiss Photo Viewer: \(photosViewController)")
    }
}
