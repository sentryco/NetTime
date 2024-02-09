// swift-tools-version:5.9
import PackageDescription

let package = Package(
    name: "NetTime",
    platforms: [
        .macOS(.v14), // macOS 14 and later
        .iOS(.v17), // iOS 17 and later
    ],
    products: [
        .library(
            name: "NetTime",
            targets: ["NetTime"]),
    ],
    dependencies: [
        .package(url: "https://github.com/sentryco/Logger.git", branch: "main"),
    ],
    targets: [
        .target(
            name: "NetTime",
            dependencies: ["Logger"]),
        .testTarget(
            name: "NetTimeTests",
            dependencies: ["NetTime", "Logger"]),
    ]
)