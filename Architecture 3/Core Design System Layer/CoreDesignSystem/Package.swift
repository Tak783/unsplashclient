// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "CoreDesignSystem",
    platforms: [
        .iOS(.v17)
    ],
    products: [
        .library(
            name: "CoreDesignSystem",
            targets: ["CoreDesignSystem"]
        )
    ],
    targets: [
        .target(name: "CoreDesignSystem"),
        .testTarget(
            name: "CoreDesignSystemTests",
            dependencies: ["CoreDesignSystem"]
        )
    ]
)
