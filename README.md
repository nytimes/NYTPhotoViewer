# NYTPhotoViewer

[![Swift 6](https://img.shields.io/badge/Swift-6.0-orange.svg)](https://swift.org)
[![Platform](https://img.shields.io/badge/platform-iOS-lightgrey.svg)](https://www.apple.com/ios/)

NYTPhotoViewer is a slideshow and image viewer that includes double-tap to zoom, captions, support for multiple images, interactive flick to dismiss, animated zooming presentation, and more.

![Demo GIF](Documentation/photo_viewer.gif)

## Usage

Usage is simple, with the option for more complicated customization when needed through a delegate relationship. In the most basic implementation, just initialize the view controller with a data source and present it as normal:

```swift
let dataSource = NYTPhotoViewerArrayDataSource(photos: photos)
let photosViewController = NYTPhotosViewController(dataSource: dataSource)
present(photosViewController, animated: true)
```

## Running the Example

Clone this locally, then in your local workspace of the `NYTPhotoViewer` repo, run `./scripts/bootstrap`, then open Examples/NYTPhotoViewer.xcworkspace. You'll see a Swift example app demonstrating the library's features.

## Installation

### Swift Package Manager

NYTPhotoViewer may be installed via SPM, by pointing at this repo's URL.

**Note:** NYTPhotoViewer now requires Swift 6 and is Swift-only. CocoaPods support has been removed.

## Requirements

- iOS 13.0 or greater
- Swift 6.0 or greater
- Xcode 16.0 or greater

## Changelog

See [`CHANGELOG.md`](https://github.com/NYTimes/NYTPhotoViewer/blob/develop/CHANGELOG.md).

## Contributing

Please **open pull requests against the `develop` branch**, and add a relevant note to the [`develop` section of the CHANGELOG](https://github.com/NYTimes/NYTPhotoViewer/blob/develop/CHANGELOG.md#develop) as part of your pull request.

## Swift

NYTPhotoViewer is now written in Swift 6 with full support for strict concurrency and modern Swift features.

## Inspiration

NYTPhotoViewer draws feature inspiration from Facebook and Tweetbot’s image viewers. If this implementation isn’t to your liking, you may consider [JTSImageViewController](https://github.com/jaredsinclair/JTSImageViewController) or [IDMPhotoBrowser](https://github.com/ideaismobile/IDMPhotoBrowser).

## Implementation

NYTPhotoViewer has a straightforward implementation using standard UIKit components. The viewer is a `UIViewController` and uses `UIViewController` transitioning APIs for the animated and interactive transitions, a `UIPageViewController` for horizontal swiping between images, and `UIScrollView` for image zooming.

It is intended to be used without the need for subclassing, and as such it accepts model objects conforming to a `NYTPhoto` protocol and provides ample opportunity for customization via the `NYTPhotosViewControllerDelegate`. Since standard APIs are used, the client has full control over the transitions and customization of the `NYTPhotosViewController`.

## License

NYTPhotoViewer is available under the Apache 2.0 license. See [`LICENSE.md`](https://github.com/NYTimes/NYTPhotoViewer/blob/develop/LICENSE.md) for more information.

## Contributors

[A list of contributors is available through GitHub.](https://github.com/NYTimes/NYTPhotoViewer/graphs/contributors)
