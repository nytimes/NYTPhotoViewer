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
    fileprivate let photos = PhotosProvider().photos
    
    @IBAction func buttonTapped(_ sender: UIButton) {
        let photosViewController = NYTPhotosViewController(photos: self.photos)
        photosViewController.delegate = self
        present(photosViewController, animated: true, completion: nil)
        
        updateImagesOnPhotosViewController(photosViewController, afterDelayWithPhotos: photos)
    }
    
    func updateImagesOnPhotosViewController(_ photosViewController: NYTPhotosViewController, afterDelayWithPhotos: [ExamplePhoto]) {
        
        let delayTime = DispatchTime.now() + Double(5 * Int64(NSEC_PER_SEC)) / Double(NSEC_PER_SEC)
        
        DispatchQueue.main.asyncAfter(deadline: delayTime) {
            for photo in self.photos {
                if photo.image == nil {
                    photo.image = UIImage(named: PrimaryImageName)
                    photosViewController.updateImage(for: photo)
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let buttonImage = UIImage(named: PrimaryImageName)
        imageButton?.setBackgroundImage(buttonImage, for: UIControlState())
    }
    
    // MARK: - NYTPhotosViewControllerDelegate
    
    func photosViewController(_ photosViewController: NYTPhotosViewController, handleActionButtonTappedFor photo: NYTPhoto) -> Bool {

        if UIDevice.current.userInterfaceIdiom == .pad {
            
            guard let photoImage = photo.image else { return false }
            
            let shareActivityViewController = UIActivityViewController(activityItems: [photoImage], applicationActivities: nil)
            
            shareActivityViewController.completionWithItemsHandler = {(activityType: UIActivityType?, completed: Bool, items: [Any]?, error: Error?) in
                if completed {
                    photosViewController.delegate?.photosViewController!(photosViewController, actionCompletedWithActivityType: activityType?.rawValue)
                }
            }

            shareActivityViewController.popoverPresentationController?.barButtonItem = photosViewController.rightBarButtonItem
            photosViewController.present(shareActivityViewController, animated: true, completion: nil)

            return true
        }
        
        return false
    }
    
    func photosViewController(_ photosViewController: NYTPhotosViewController, referenceViewFor photo: NYTPhoto) -> UIView? {
        if photo as? ExamplePhoto == photos[NoReferenceViewPhotoIndex] {
            return nil
        }
        return imageButton
    }
    
    func photosViewController(_ photosViewController: NYTPhotosViewController, loadingViewFor photo: NYTPhoto) -> UIView? {
        if photo as! ExamplePhoto == photos[CustomEverythingPhotoIndex] {
            let label = UILabel()
            label.text = "Custom Loading..."
            label.textColor = UIColor.green
            return label
        }
        return nil
    }
    
    func photosViewController(_ photosViewController: NYTPhotosViewController, captionViewFor photo: NYTPhoto) -> UIView? {
        if photo as! ExamplePhoto == photos[CustomEverythingPhotoIndex] {
            let label = UILabel()
            label.text = "Custom Caption View"
            label.textColor = UIColor.white
            label.backgroundColor = UIColor.red
            return label
        }
        return nil
    }
    
    func photosViewController(_ photosViewController: NYTPhotosViewController, didNavigateTo photo: NYTPhoto, at photoIndex: UInt) {
        print("Did Navigate To Photo: \(photo) identifier: \(photoIndex)")
    }
    
    func photosViewController(_ photosViewController: NYTPhotosViewController, actionCompletedWithActivityType activityType: String?) {
        print("Action Completed With Activity Type: \(activityType)")
    }

    func photosViewControllerDidDismiss(_ photosViewController: NYTPhotosViewController) {
        print("Did dismiss Photo Viewer: \(photosViewController)")
    }
}
