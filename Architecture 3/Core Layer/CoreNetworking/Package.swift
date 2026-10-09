// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "CoreNetworking",
    platforms: [
        .iOS(.v17)
    ],
    products: [
        .library(
            name: "CoreNetworking",
            targets: ["CoreNetworking"]
        ),
        .library(
            name: "CoreTestSupport",
            targets: ["CoreTestSupport"]
        )
    ],
    targets: [
        .target(name: "CoreNetworking"),
        .target(name: "CoreTestSupport"),
        .testTarget(
            name: "CoreNetworkingTests",
            dependencies: [
                "CoreNetworking",
                "CoreTestSupport"
            ]
        )
    ]
)
