// swift-tools-version:6.0
import PackageDescription

let package = Package(
    name: "NYTPhotoViewer",
    platforms: [
        .iOS(.v13)
    ],
    products: [
        .library(
            name: "NYTPhotoViewer",
            targets: ["NYTPhotoViewer"]
        ),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "NYTPhotoViewer",
            dependencies: [],
            path: "Sources/NYTPhotoViewer",
            resources: [
                .process("../Resources")
            ],
            swiftSettings: [
                .enableUpcomingFeature("StrictConcurrency")
            ]
        )
    ],
    swiftLanguageVersions: [.v6]
)
