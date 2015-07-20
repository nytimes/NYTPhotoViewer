# NYTPhotoViewer

[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)

NYTPhotoViewer is a slideshow and image viewer that includes double tap to zoom, captions, support for multiple images, interactive flick to dismiss, animated zooming presentation, and more.

## Demo

![Demo GIF](Images/photo_viewer.gif)

## Implementation

NYTPhotoViewer has a very standard implementation using built-in frameworks. The viewer is a `UIViewController` and uses `UIViewController` transitioning APIs for the animated and interactive transitions, a `UIPageViewController` for horizontal swiping between images, and `UIScrollView` for image zooming. It is intended to be used without the need for subclassing, and as such it accepts model objects conforming to a `NYTPhoto` protocol and provides ample opportunity for customization via the `NYTPhotosViewControllerDelegate`. Since standard APIs are used, the client has full control over the transitions and customization of the `NYTPhotosViewController`.

## Usage

Usage is simple, with the option for more complicated customization when needed through a delegate relationship. In the most basic implementation, just initialize the view controller with an array of photo objects and present it as normal:

```objc
NYTPhotosViewController *photosViewController = [[NYTPhotosViewController alloc] initWithPhotos:photos];
[self presentViewController:photosViewController animated:YES completion:nil];
```

## Installation

### CocoaPods

NYTPhotoViewer is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

    pod "NYTPhotoViewer"

### Carthage

NYTPhotoView is also available through [Carthage](http://github.com/carthage/carthage).

You can install Carthage with [Homebrew](http://brew.sh) using the following command
```bash
$ brew update
$ brew install carthage
```

To add NYTPhotoViewer to your Xcode project using Carthage, add the following line to your `Cartfile`:
```
github "NYTimes/NYTPhotoViewer"
```

## Requirements

This library requires a deployment target of iOS 7.0 or greater.

## Inspiration

NYTPhotoViewer draws feature inspiration from Facebook and Tweetbot's image viewers. If this implementation isn't to your liking, you may want to consider [JTSImageViewController](https://github.com/jaredsinclair/JTSImageViewController) or [IDMPhotoBrowser](https://github.com/ideaismobile/IDMPhotoBrowser).

## Swift

NYTPhotoViewer is written in Objective-C but is intended to be fully interoperable with Swift. You’ll need to include an [Objective-C bridging header](https://developer.apple.com/library/ios/documentation/Swift/Conceptual/BuildingCocoaApps/MixandMatch.html) like [this one from the sample Swift project](Example/NYTPhotoViewer-Swift/NYTPhotoViewer-Swift-Bridging-Header.h).

If you experience any interoperability difficulties, please open an issue or pull request and we will work to resolve it quickly.

## TODO

* Animate bounds changes like Tweetbot and Facebook.
* Publicly expose the data source property.
* An additional sample project written in Swift (currently in pull request).

## License

NYTPhotoViewer is available under the Apache 2.0 license. See the LICENSE.md file for more information.
