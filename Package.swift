// swift-tools-version:5.3
import PackageDescription

let package = Package(
    name: "NYTPhotoViewer",
    platforms: [
        .iOS(.v9)
    ],
    products: [
        .library(
            name: "NYTPhotoViewer",
            targets: ["NYTPhotoViewer"]
            ),
    ],
    dependencies: [
        .package(url: "https://github.com/Flipboard/FLAnimatedImage.git", .upToNextMajor(from: "1.0.17"))
    ],
    targets: [
        .target(
            name: "NYTPhotoViewer",
            path: "NYTPhotoViewer"
        ),
    ]
)
