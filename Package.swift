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
            targets: ["NYTPhotoViewerGIF"]),
    ],
    dependencies: [
        .package(url: "https://github.com/pinterest/PINRemoteImage.git", from: "3.0.1")
    ],
    targets: [
        .target(
            name: "NYTPhotoViewerGIF",
            dependencies: ["PINRemoteImage"],
            cSettings: [ "-DANIMATED_GIF_SUPPORT"],
            path: "NYTPhotoViewer"),
        .target(
            name: "NYTPhotoViewer",
            path: "NYTPhotoViewer"),
        )
    ]
)
