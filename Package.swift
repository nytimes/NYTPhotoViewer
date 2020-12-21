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
            path: "NYTPhotoViewer",
            exclude: [
                "NYTPhotoViewer.bundle",
                "Info.plist"
            ],
            resources: [
                .copy("Resources/NYTPhotoViewerCloseButtonX.png"),
                .copy("Resources/NYTPhotoViewerCloseButtonX@2x.png"),
                .copy("Resources/NYTPhotoViewerCloseButtonX@3x.png"),
                .copy("Resources/NYTPhotoViewerCloseButtonXLandscape.png"),
                .copy("Resources/NYTPhotoViewerCloseButtonXLandscape@2x.png"),
                .copy("Resources/NYTPhotoViewerCloseButtonXLandscape@3x.png"),
            ],
            cSettings: [
                .headerSearchPath("./"),
                .headerSearchPath("./Protocols"),
                .headerSearchPath("./Resource Loading")
            ])
    ]
)
