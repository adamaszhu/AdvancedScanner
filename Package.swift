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
        .package(url: "https://github.com/Quick/Quick",
            .upToNextMajor(from: "5.0.0")),
        .package(url: "https://github.com/Quick/Nimble",
            .upToNextMajor(from: "10.0.0")),
        .package(url: "https://github.com/adamaszhu/AdvancedFoundation",
                 .upToNextMajor(from: "1.9.7")),
        .package(url: "https://github.com/adamaszhu/AdvancedUIKit",
            .revisionItem("5f79dcb36c75e888ae8db0e82d0f4f27fc9d8589"))
    ],
    targets: [
        .target(name: "AdvancedScanner",
                dependencies: ["AdvancedFoundation",
                               .product(name: "AdvancedUIKit", package: "AdvancedUIKit"),
                               .product(name: "AdvancedUIKitPhoto", package: "AdvancedUIKit")],
                path: "AdvancedScanner"),
        .testTarget(
            name: "AdvancedScannerTests",
            dependencies: ["AdvancedScanner",
                           "AdvancedFoundation",
                           .product(name: "AdvancedUIKit", package: "AdvancedUIKit"),
                           .product(name: "AdvancedUIKitPhoto", package: "AdvancedUIKit"),
                           "Nimble",
                           "Quick"],
            path: "AdvancedScannerTests"),
    ]
)
