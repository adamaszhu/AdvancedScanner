// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "AdvancedScanner",
    defaultLocalization: "en",
    platforms: [
        .iOS(.v13)
    ],
    products: [
        .library(name: "AdvancedScanner", targets: ["AdvancedScanner"])
    ],
    dependencies: [
        .package(url: "https://github.com/Quick/Quick", .upToNextMajor(from: "5.0.0")),
        .package(url: "https://github.com/Quick/Nimble", .upToNextMajor(from: "10.0.0")),
        .package(url: "https://github.com/adamaszhu/AdvancedFoundation", .upToNextMajor(from: "1.9.7")),
        .package(url: "https://github.com/adamaszhu/AdvancedUIKit", .upToNextMajor(from: "1.9.12"))
    ],
    targets: [
        .target(name: "AdvancedScanner",
                dependencies: ["AdvancedFoundation", "AdvancedUIKit", "AdvancedUIKitPhoto"],
                path: "AdvancedScanner"),
        .testTarget(
            name: "AdvancedScannerTests",
            dependencies: ["AdvancedFoundation",
                           "AdvancedUIKit",
                           "AdvancedUIKitPhoto",
                           "Nimble",
                           "Quick"],
            path: "AdvancedScannerTests"),
    ]
)
