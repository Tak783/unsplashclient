// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "CoreSearch",
    platforms: [
        .iOS(.v17)
    ],
    products: [
        .library(
            name: "CoreSearch",
            targets: ["CoreSearch"]
        )
    ],
    targets: [
        .target(name: "CoreSearch"),
        .testTarget(
            name: "CoreSearchTests",
            dependencies: ["CoreSearch"]
        )
    ]
)
