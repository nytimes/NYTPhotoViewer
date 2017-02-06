//
//  Photo.swift
//  NYTPhotoViewer
//
//  Created by Chris Dzombak on 2/2/17.
//  Copyright © 2017 NYTimes. All rights reserved.
//

import UIKit

/// A photo may often be represented in a Swift application as a value type.
struct Photo {
    // This would usually be a URL, but for this demo we load images from the bundle.
    let name: String
    let summary: String
    let credit: String

    let identifier: Int
}
