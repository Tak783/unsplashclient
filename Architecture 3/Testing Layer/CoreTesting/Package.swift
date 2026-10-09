// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "CoreTesting",
    platforms: [
        .iOS(.v17)
    ],
    products: [
        .library(
            name: "CoreTesting",
            targets: ["CoreTesting"]
        )
    ],
    targets: [
        .target(name: "CoreTesting"),
        .testTarget(
            name: "CoreTestingTests",
            dependencies: ["CoreTesting"]
        )
    ]
)
