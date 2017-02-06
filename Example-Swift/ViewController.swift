//
//  ViewController.swift
//  NYTPhotoViewer-Swift
//
//  Created by Mark Keefe on 3/20/15.
//  Copyright (c) 2015 The New York Times. All rights reserved.
//

import UIKit
import NYTPhotoViewer

// The Swift demo project doesn't aim to exactly replicate the ObjC demo, which comprehensively demonstrates the photo viewer.
// Rather, the Swift demo aims to show how to interact with the photo viewer in Swift, and how an application might coordinate the photo viewer with a more complex data layer.

final class ViewController: UIViewController {

    let ReferencePhotoName = "NYTimesBuilding"

    var photoViewerCoordinator: PhotoViewerCoordinator?

    @IBOutlet weak var imageButton : UIButton?
    
    @IBAction func buttonTapped(_ sender: UIButton) {
        let coordinator = PhotoViewerCoordinator(provider: PhotosProvider())
        photoViewerCoordinator = coordinator

        let photosViewController = coordinator.photoViewer
        photosViewController.delegate = self
        present(photosViewController, animated: true, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let buttonImage = UIImage(named: ReferencePhotoName)
        imageButton?.setBackgroundImage(buttonImage, for: UIControlState())
    }
}

// MARK: NYTPhotosViewControllerDelegate

extension ViewController: NYTPhotosViewControllerDelegate {
    
    func photosViewController(_ photosViewController: NYTPhotosViewController, handleActionButtonTappedFor photo: NYTPhoto) -> Bool {
        guard UIDevice.current.userInterfaceIdiom == .pad, let photoImage = photo.image else {
            return false
        }
        
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
    
    func photosViewController(_ photosViewController: NYTPhotosViewController, referenceViewFor photo: NYTPhoto) -> UIView? {
        guard let box = photo as? NYTPhotoBox else { return nil }

        return box.value.name == ReferencePhotoName ? imageButton : nil
    }

    func photosViewControllerDidDismiss(_ photosViewController: NYTPhotosViewController) {
        photoViewerCoordinator = nil
    }
}
