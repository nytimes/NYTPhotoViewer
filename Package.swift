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
                "Info.plist"
            ],
            resources: [
              .process("assetsxcassets"),
//                .process("Resources/NYTPhotoViewerCloseButtonX.png"),
//                .process("Resources/NYTPhotoViewerCloseButtonX@2x.png"),
//                .process("Resources/NYTPhotoViewerCloseButtonX@3x.png"),
//                .process("Resources/NYTPhotoViewerCloseButtonXLandscape.png"),
//                .process("Resources/NYTPhotoViewerCloseButtonXLandscape@2x.png"),
//                .process("Resources/NYTPhotoViewerCloseButtonXLandscape@3x.png"),             
            ],
            cSettings: [
                .headerSearchPath("./include"),
            ]),
//        .testTarget(
//            name: "NYTPhotoViewerTests",
//            dependencies: ["NYTPhotoViewer"],
//            path: "NYTPhotoViewerTests",
//            exclude: [
//                "Info.plist"
//            ])
    ]
)
