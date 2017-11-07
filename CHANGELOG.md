## `develop`

Changes for users of the library currently on `develop`:

- Expose a data-source-oriented API for PhotosViewController ([#226](https://github.com/NYTimes/NYTPhotoViewer/pull/226))
    - A data source no longer has to handle out-of-bounds indexes ([#227](https://github.com/NYTimes/NYTPhotoViewer/pull/227))
    - The data source is not retained ([#227](https://github.com/NYTimes/NYTPhotoViewer/pull/227))
- Respect safe areas for iOS 11 support

## [1.2.0](https://github.com/NYTimes/NYTPhotoViewer/releases/tag/1.2.0)

Changes for users of the library in 1.2.0:

- Add Carthage support ([#164](https://github.com/NYTimes/NYTPhotoViewer/pull/164), [#167](https://github.com/NYTimes/NYTPhotoViewer/pull/167)), ([#171](https://github.com/NYTimes/NYTPhotoViewer/pull/171))
- Fix gradient flickering of caption view on iOS 9 ([#166](https://github.com/NYTimes/NYTPhotoViewer/pull/166))
- Readd loading view when photo source is set back to nil ([#187](https://github.com/NYTimes/NYTPhotoViewer/pull/187))
- Include all files in the bundle, not just PNGs, in Cocoapods resource bundle ([#170](https://github.com/NYTimes/NYTPhotoViewer/pull/170))

## [1.1.0](https://github.com/NYTimes/NYTPhotoViewer/releases/tag/1.1.0)

Changes for users of the library in 1.1.0:

- Add a delegate method to allow customizing navigation bar title text ([#142](https://github.com/NYTimes/NYTPhotoViewer/pull/142), [#151](https://github.com/NYTimes/NYTPhotoViewer/pull/151), [#154](https://github.com/NYTimes/NYTPhotoViewer/pull/154))
- Add documentation clarifying `NYTPhoto.image` vs `.imageData` properties; add a warning if you’re doing something wrong ([#153](https://github.com/NYTimes/NYTPhotoViewer/pull/152))
- Add `delegate` to the designated initializer ([#155](https://github.com/NYTimes/NYTPhotoViewer/pull/155))
- Fix overlay view animating out and back when a view controller presented atop `NYTPhotosViewController` is dismissed ([#156](https://github.com/NYTimes/NYTPhotoViewer/pull/156))

## [1.0.1](https://github.com/NYTimes/NYTPhotoViewer/releases/tag/1.0.1)

Changes for users of the library in 1.0.1:

- Fixes for incorrect logic determining whether to send delegate messages about `PhotosViewController` dismissal ([#130](https://github.com/NYTimes/NYTPhotoViewer/pull/130), [#137](https://github.com/NYTimes/NYTPhotoViewer/pull/137))
- Avoid testing floats for equality in PhotoViewController ([#135](https://github.com/NYTimes/NYTPhotoViewer/pull/135))
- Fix orientation issue with reference view of type UIImageView ([#116](https://github.com/NYTimes/NYTPhotoViewer/pull/116), [#145](https://github.com/NYTimes/NYTPhotoViewer/pull/145))
- Avoid applying a hacky iOS status bar bugfix on iOS 8.3+ (it appears to have been fixed then) ([#131](https://github.com/NYTimes/NYTPhotoViewer/issues/131))
- Removed redundant Swift unit tests ([#128](https://github.com/NYTimes/NYTPhotoViewer/pull/128))

## [1.0.0](https://github.com/NYTimes/NYTPhotoViewer/releases/tag/1.0.0)

Changes for users of the library in 1.0.0:

- **The library now supports iOS 8.0 and newer.** ([#82](https://github.com/NYTimes/NYTPhotoViewer/pull/82), [#84](https://github.com/NYTimes/NYTPhotoViewer/pull/84), [#107](https://github.com/NYTimes/NYTPhotoViewer/pull/107))
- Support programmatic view controller dismissal via `dismissViewControllerAnimated:completion:` ([#121](https://github.com/NYTimes/NYTPhotoViewer/pull/121), [#122](https://github.com/NYTimes/NYTPhotoViewer/pull/122))
- Use scrolling `UITextView` for captions ([#88](https://github.com/NYTimes/NYTPhotoViewer/pull/88))
- Fix a bug when presenting NYTPhotoViewer from a subview of `UIStackView` ([#104](https://github.com/NYTimes/NYTPhotoViewer/pull/104))
- Update overlay information after `displayPhoto:` call ([#100](https://github.com/NYTimes/NYTPhotoViewer/pull/100))
- Implements animated GIF support ([#71](https://github.com/NYTimes/NYTPhotoViewer/pull/71), [#94](https://github.com/NYTimes/NYTPhotoViewer/pull/94), [#106](https://github.com/NYTimes/NYTPhotoViewer/pull/106), [#111](https://github.com/NYTimes/NYTPhotoViewer/pull/111))
- Fix misplacing view position while zoom transition ([#89](https://github.com/NYTimes/NYTPhotoViewer/pull/89))
- Adopt CocoaPods `resource_bundles` and fix resource image loading ([#80](https://github.com/NYTimes/NYTPhotoViewer/pull/80), [#113](https://github.com/NYTimes/NYTPhotoViewer/pull/113), [#123](https://github.com/NYTimes/NYTPhotoViewer/pull/123))
- Use iOS 8 `UIActivityViewController.completionWithItemsHandler` API ([#82](https://github.com/NYTimes/NYTPhotoViewer/pull/82))
- Nullability and lightweight generics annotations on important public API ([#83](https://github.com/NYTimes/NYTPhotoViewer/pull/83), [#98](https://github.com/NYTimes/NYTPhotoViewer/pull/98))
- Fix circular reference of `NYTPhotosViewController` ([#79](https://github.com/NYTimes/NYTPhotoViewer/pull/79))
- Set `barButtonItem` on popover `UIActivityViewController`s ([#65](https://github.com/NYTimes/NYTPhotoViewer/pull/65/))
- Accept Xcode 7 build settings and fix Xcode 7 warnings ([#76](https://github.com/NYTimes/NYTPhotoViewer/pull/76))
- Ensure our nav bar will always be translucent with no tint color ([#57](https://github.com/NYTimes/NYTPhotoViewer/pull/57))
- Fix crash on tapping Share button on iPad ([#52](https://github.com/NYTimes/NYTPhotoViewer/pull/52))
- Allow customizing maximum photo zoom scale([#51](https://github.com/NYTimes/NYTPhotoViewer/pull/51))
- Rename `…didDisplayPhoto…` delegate method to `…didNavigateToPhoto…` ([#47](https://github.com/NYTimes/NYTPhotoViewer/pull/47))
- Adds support for setting `rightBarButtonItems` and `leftBarButtonItems` on `NYTPhotosViewController` ([#49](https://github.com/NYTimes/NYTPhotoViewer/pull/49))

## [0.1.2](https://github.com/NYTimes/NYTPhotoViewer/releases/tag/0.1.2)

Initial open-source release.
