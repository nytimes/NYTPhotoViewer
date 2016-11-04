//
//  ViewController.swift
//  NYTPhotoViewer-Swift
//
//  Created by Mark Keefe on 3/20/15.
//  Copyright (c) 2015 The New York Times. All rights reserved.
//

import UIKit
import NYTPhotoViewer


class ViewController: UIViewController, NYTPhotosViewControllerDelegate {

    @IBOutlet weak var imageButton : UIButton?
    private let photos = PhotosProvider().photos
    
    @IBAction func buttonTapped(sender: UIButton) {
        let photosViewController = NYTPhotosViewController(photos: self.photos)
        photosViewController.delegate = self
        presentViewController(photosViewController, animated: true, completion: nil)
        
        updateImagesOnPhotosViewController(photosViewController, afterDelayWithPhotos: photos)
    }
    
    func updateImagesOnPhotosViewController(photosViewController: NYTPhotosViewController, afterDelayWithPhotos: [ExamplePhoto]) {
        
        let delayTime = dispatch_time(DISPATCH_TIME_NOW, 5 * Int64(NSEC_PER_SEC))
        
        dispatch_after(delayTime, dispatch_get_main_queue()) {
            for photo in self.photos {
                if photo.image == nil {
                    photo.image = UIImage(named: PrimaryImageName)
                    photosViewController.updateImageForPhoto(photo)
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let buttonImage = UIImage(named: PrimaryImageName)
        imageButton?.setBackgroundImage(buttonImage, forState: .Normal)
    }
    
    // MARK: - NYTPhotosViewControllerDelegate
    
    func photosViewController(photosViewController: NYTPhotosViewController, handleActionButtonTappedForPhoto photo: NYTPhoto) -> Bool {

        if UIDevice.currentDevice().userInterfaceIdiom == .Pad {
            
            guard let photoImage = photo.image else { return false }
            
            let shareActivityViewController = UIActivityViewController(activityItems: [photoImage], applicationActivities: nil)
            
            shareActivityViewController.completionWithItemsHandler = {(activityType: String?, completed: Bool, items: [AnyObject]?, error: NSError?) in
                if completed {
                    photosViewController.delegate?.photosViewController!(photosViewController, actionCompletedWithActivityType: activityType!)
                }
            }

            shareActivityViewController.popoverPresentationController?.barButtonItem = photosViewController.rightBarButtonItem
            photosViewController.presentViewController(shareActivityViewController, animated: true, completion: nil)

            return true
        }
        
        return false
    }
    
    func photosViewController(photosViewController: NYTPhotosViewController, referenceViewForPhoto photo: NYTPhoto) -> UIView? {
        if photo as? ExamplePhoto == photos[NoReferenceViewPhotoIndex] {
            return nil
        }
        return imageButton
    }
    
    func photosViewController(photosViewController: NYTPhotosViewController, loadingViewForPhoto photo: NYTPhoto) -> UIView? {
        if photo as! ExamplePhoto == photos[CustomEverythingPhotoIndex] {
            let label = UILabel()
            label.text = "Custom Loading..."
            label.textColor = UIColor.greenColor()
            return label
        }
        return nil
    }
    
    func photosViewController(photosViewController: NYTPhotosViewController, captionViewForPhoto photo: NYTPhoto) -> UIView? {
        if photo as! ExamplePhoto == photos[CustomEverythingPhotoIndex] {
            let label = UILabel()
            label.text = "Custom Caption View"
            label.textColor = UIColor.whiteColor()
            label.backgroundColor = UIColor.redColor()
            return label
        }
        return nil
    }
    
    func photosViewController(photosViewController: NYTPhotosViewController, didNavigateToPhoto photo: NYTPhoto, atIndex photoIndex: UInt) {
        print("Did Navigate To Photo: \(photo) identifier: \(photoIndex)")
    }
    
    func photosViewController(photosViewController: NYTPhotosViewController, actionCompletedWithActivityType activityType: String?) {
        print("Action Completed With Activity Type: \(activityType)")
    }

    func photosViewControllerDidDismiss(photosViewController: NYTPhotosViewController) {
        print("Did dismiss Photo Viewer: \(photosViewController)")
    }
}
