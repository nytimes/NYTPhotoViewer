# Migration Guide: Objective-C to Swift 6

This document provides a comprehensive guide for migrating from NYTPhotoViewer 5.x (Objective-C) to 6.0 (Swift 6).

## Overview

NYTPhotoViewer 6.0 is a complete rewrite in Swift 6, offering:
- Full Swift 6 language support with strict concurrency
- Modern Swift idioms and patterns
- Better type safety and performance
- Simplified API surface

## Requirements

### Minimum Requirements
- **iOS**: 13.0+ (previously 9.0+)
- **Swift**: 6.0+
- **Xcode**: 16.0+

### Installation
CocoaPods support has been removed. Use Swift Package Manager:

```swift
dependencies: [
    .package(url: "https://github.com/NYTimes/NYTPhotoViewer.git", from: "6.0.0")
]
```

## API Changes

### Initialization

**Before (Objective-C):**
```objc
NYTPhotoViewerArrayDataSource *dataSource = [NYTPhotoViewerArrayDataSource dataSourceWithPhotos:photos];
NYTPhotosViewController *viewer = [[NYTPhotosViewController alloc] initWithDataSource:dataSource];
[self presentViewController:viewer animated:YES completion:nil];
```

**After (Swift 6):**
```swift
let dataSource = NYTPhotoViewerArrayDataSource(photos: photos)
let viewer = NYTPhotosViewController(dataSource: dataSource)
present(viewer, animated: true)
```

### Protocol Conformance

**Before (Objective-C):**
```objc
@interface MyPhoto : NSObject <NYTPhoto>
@property (nonatomic) UIImage *image;
@property (nonatomic) NSData *imageData;
@property (nonatomic) UIImage *placeholderImage;
@property (nonatomic) NSAttributedString *attributedCaptionTitle;
// ...
@end
```

**After (Swift 6):**
```swift
struct MyPhoto: NYTPhoto, Sendable {
    let image: UIImage?
    let imageData: Data?
    let placeholderImage: UIImage?
    let attributedCaptionTitle: NSAttributedString?
    // ...
}
```

### Delegate Methods

**Before (Objective-C):**
```objc
- (void)photosViewController:(NYTPhotosViewController *)photosViewController 
          didNavigateToPhoto:(id<NYTPhoto>)photo 
                     atIndex:(NSUInteger)photoIndex {
    // Handle navigation
}
```

**After (Swift 6):**
```swift
func photosViewController(_ photosViewController: NYTPhotosViewController, 
                         didNavigateTo photo: any NYTPhoto, 
                         at photoIndex: Int) {
    // Handle navigation
}
```

### Data Source Methods

**Before (Objective-C):**
```objc
- (id<NYTPhoto>)photoAtIndex:(NSInteger)photoIndex {
    return photos[photoIndex];
}

- (NSInteger)indexOfPhoto:(id<NYTPhoto>)photo {
    return [photos indexOfObject:photo];
}
```

**After (Swift 6):**
```swift
func photo(at index: Int) -> (any NYTPhoto)? {
    photos[index]
}

func index(of photo: any NYTPhoto) -> Int? {
    // Implementation using Equatable conformance
}
```

## Key Differences

### 1. Concurrency
All main API methods are now marked with `@MainActor`, ensuring UI operations happen on the main thread:

```swift
@MainActor
public class NYTPhotosViewController: UIViewController {
    // All methods automatically @MainActor
}
```

### 2. Sendable Protocol
Photo objects should conform to `Sendable` for safe concurrent access:

```swift
struct MyPhoto: NYTPhoto, Sendable {
    // Properties must be sendable
}
```

### 3. Notifications
Notification names are now Swift types:

**Before:**
```objc
extern NSString * const NYTPhotosViewControllerDidDismissNotification;
```

**After:**
```swift
public let NYTPhotosViewControllerDidDismissNotification = Notification.Name("NYTPhotosViewControllerDidDismissNotification")
```

### 4. Optionals
Swift's type safety means more explicit optionals:

```swift
public weak var delegate: (any NYTPhotosViewControllerDelegate)?
public var currentlyDisplayedPhoto: (any NYTPhoto)?
```

### 5. Existential Types
Protocols now use `any` keyword for existential types:

```swift
let photo: any NYTPhoto
let dataSource: any NYTPhotoViewerDataSource
```

## Common Migration Patterns

### Custom Photo Implementation

**Before:**
```objc
@implementation CustomPhoto
- (UIImage *)image { return self.photoImage; }
- (NSAttributedString *)attributedCaptionTitle { 
    return [[NSAttributedString alloc] initWithString:self.title]; 
}
@end
```

**After:**
```swift
struct CustomPhoto: NYTPhoto, Sendable {
    let photoImage: UIImage?
    let title: String
    
    var image: UIImage? { photoImage }
    var imageData: Data? { nil }
    var placeholderImage: UIImage? { nil }
    var attributedCaptionTitle: NSAttributedString? {
        title.map { NSAttributedString(string: $0) }
    }
    var attributedCaptionSummary: NSAttributedString? { nil }
    var attributedCaptionCredit: NSAttributedString? { nil }
}
```

### Custom Data Source

**Before:**
```objc
@interface CustomDataSource : NSObject <NYTPhotoViewerDataSource>
@property (nonatomic, strong) NSArray<id<NYTPhoto>> *photos;
@end
```

**After:**
```swift
@MainActor
final class CustomDataSource: NYTPhotoViewerDataSource {
    let photos: [any NYTPhoto]
    
    var numberOfPhotos: Int? { photos.count }
    
    func photo(at index: Int) -> (any NYTPhoto)? {
        guard index >= 0 && index < photos.count else { return nil }
        return photos[index]
    }
    
    func index(of photo: any NYTPhoto) -> Int? {
        // Implement using Equatable conformance
    }
}
```

## Breaking Changes Summary

1. **Minimum iOS version**: 9.0 → 13.0
2. **Language**: Objective-C → Swift 6
3. **Installation**: CocoaPods removed, SPM only
4. **Animated GIF support**: Removed (no PINRemoteImage dependency)
5. **Method names**: Converted to Swift naming conventions
6. **Nullability**: Explicit optionals throughout
7. **Concurrency**: `@MainActor` annotations required
8. **Type erasure**: Protocols use `any` keyword

## Removed Features

- **Animated GIF support**: Previously supported via PINRemoteImage, now removed to simplify dependencies
- **CocoaPods**: Only Swift Package Manager is supported
- **Carthage**: Focus on SPM for modern Swift development

## Benefits of Swift 6 Version

1. **Type Safety**: Better compile-time checking
2. **Concurrency**: Built-in thread safety with Swift 6 concurrency
3. **Performance**: Swift's performance optimizations
4. **Modern Swift**: Uses latest Swift 6 features
5. **Maintainability**: Easier to maintain Swift codebase
6. **Interoperability**: Better integration with Swift projects

## Troubleshooting

### Error: Type does not conform to 'Sendable'
**Solution**: Mark your photo types with `Sendable`:
```swift
struct MyPhoto: NYTPhoto, Sendable { }
```

### Error: Call to main actor-isolated method
**Solution**: Ensure you're calling from main thread or mark your code with `@MainActor`:
```swift
@MainActor
func showPhotoViewer() {
    let viewer = NYTPhotosViewController(dataSource: dataSource)
    present(viewer, animated: true)
}
```

### Error: Cannot convert value of type 'MyPhoto' to expected type 'any NYTPhoto'
**Solution**: Your photo type must conform to `NYTPhoto` protocol.

## Need Help?

- Open an issue on GitHub
- Check the example app in the repo
- Review the inline documentation

## Timeline

- **5.0.8**: Last Objective-C version
- **6.0.0**: First Swift 6 version

