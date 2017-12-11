//
//  PhotoBox.swift
//  NYTPhotoViewer
//
//  Created by Chris Dzombak on 2/2/17.
//  Copyright © 2017 NYTimes. All rights reserved.
//

import UIKit
import NYTPhotoViewer

/// A box allowing NYTPhotoViewer to consume Swift value types from our codebase.
final class NYTPhotoBox: NSObject, NYTPhoto {

    let value: Photo

    init(_ photo: Photo) {
        value = photo
    }

    // MARK: NYTPhoto

    var image: UIImage?
    var imageData: Data?
    var placeholderImage: UIImage?

    var attributedCaptionTitle: NSAttributedString?

    var attributedCaptionSummary: NSAttributedString? {
        let attributes = [NSForegroundColorAttributeName: UIColor.white,
                          NSFontAttributeName: UIFont.preferredFont(forTextStyle: .body)]
        return NSAttributedString(string: value.summary, attributes: attributes)
    }

    var attributedCaptionCredit: NSAttributedString? {
        let attributes = [NSForegroundColorAttributeName: UIColor.gray,
                          NSFontAttributeName: UIFont.preferredFont(forTextStyle: .footnote)]
        return NSAttributedString(string: value.credit, attributes: attributes)
    }
}

// MARK: NSObject Equality

extension NYTPhotoBox {
    @objc
    override func isEqual(_ object: Any?) -> Bool {
        guard let otherPhoto = object as? NYTPhotoBox else { return false }
        return value.identifier == otherPhoto.value.identifier
    }
}
