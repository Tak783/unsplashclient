// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "UnsplashPhotosFeature",
    platforms: [
        .iOS(.v17)
    ],
    products: [
        .library(
            name: "UnsplashPhotosFeature",
            targets: ["UnsplashPhotosFeature"]
        )
    ],
    dependencies: [
        .package(
            name: "CoreSearch",
            path: "../../Core Shared Components Layer/CoreSearch"
        ),
        .package(
            name: "CoreFoundational",
            path: "../../Foundation Layer/CoreFoundational"
        ),
        .package(
            name: "CoreTesting",
            path: "../../Testing Layer/CoreTesting"
        ),
        .package(
            name: "CoreNetworking",
            path: "../../Core Shared Components Layer/CoreNetworking"
        )
    ],
    targets: [
        .target(
            name: "UnsplashPhotosFeature",
            dependencies: [
                .product(
                    name: "CoreSearch",
                    package: "CoreSearch"
                ),
                .product(
                    name: "CoreFoundational",
                    package: "CoreFoundational"
                ),
                .product(
                    name: "CoreNetworking",
                    package: "CoreNetworking"
                )
            ]
        ),
        .testTarget(
            name: "UnsplashPhotosFeatureTests",
            dependencies: [
                "UnsplashPhotosFeature",
                .product(
                    name: "CoreTesting",
                    package: "CoreTesting"
                )
            ]
        )
    ]
)
