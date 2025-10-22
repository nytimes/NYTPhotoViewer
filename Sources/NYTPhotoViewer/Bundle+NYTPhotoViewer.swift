//
//  Bundle+NYTPhotoViewer.swift
//  NYTPhotoViewer
//
//  Created by Chris Dzombak on 10/16/15.
//  Copyright (c) 2015 NYTimes. All rights reserved.
//

import Foundation

extension Bundle {
    /// Returns the resource bundle for NYTPhotoViewer.
    @MainActor
    static var nytPhotoViewerResourceBundle: Bundle {
        #if SWIFT_PACKAGE
        return Bundle.module
        #else
        let resourceBundlePath = Bundle(for: NYTPhotosViewController.self).path(forResource: "NYTPhotoViewer", ofType: "bundle")
        return resourceBundlePath.flatMap { Bundle(path: $0) } ?? Bundle.main
        #endif
    }
}

