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
            name: "CoreNetworking",
            path: "../../Core Layer/CoreNetworking"
        )
    ],
    targets: [
        .target(
            name: "UnsplashPhotosFeature",
            dependencies: [
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
                    name: "CoreTestSupport",
                    package: "CoreNetworking"
                )
            ]
        )
    ]
)
