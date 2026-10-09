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
        )
    ],
    dependencies: [
        .package(
            name: "CoreTesting",
            path: "../../Testing Layer/CoreTesting"
        )
    ],
    targets: [
        .target(name: "CoreNetworking"),
        .testTarget(
            name: "CoreNetworkingTests",
            dependencies: [
                "CoreNetworking",
                .product(
                    name: "CoreTesting",
                    package: "CoreTesting"
                )
            ]
        )
    ]
)
