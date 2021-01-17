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
            targets: ["NYTPhotoViewer"]),
    ],
    dependencies: [
        .package(url: "https://github.com/pinterest/PINRemoteImage.git", from: "3.0.1")
    ],
    targets: [
        .target(
            name: "NYTPhotoViewer",
            dependencies: ["PINRemoteImage"],
            path: "NYTPhotoViewer"),
    ]
)
