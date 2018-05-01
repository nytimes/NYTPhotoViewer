//
//  PhotoItem.swift
//  NYTPhotoViewer
//
//  Created by Chris Dzombak on 2/2/17.
//  Copyright © 2017 NYTimes. All rights reserved.
//

import UIKit

/// A photo item can either be an image or a view
enum PhotoItemType {
    case image
    case view
}

/// A photo may often be represented in a Swift application as a value type.
struct PhotoItem {
    // This would usually be a URL, but for this demo we load images from the bundle.
    let name: String
    let summary: String
    let credit: String
    let itemType: PhotoItemType
    let identifier: Int

    init(name: String = "", summary: String = "", credit: String = "", itemType: PhotoItemType, identifier: Int) {
        self.name = name
        self.summary = summary
        self.credit = credit
        self.itemType = itemType
        self.identifier = identifier
    }

}
