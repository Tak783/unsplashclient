// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "UnsplashPhotosFeatureUI",
    platforms: [
        .iOS("26.0")
    ],
    products: [
        .library(
            name: "UnsplashPhotosFeatureUI",
            targets: ["UnsplashPhotosFeatureUI"]
        )
    ],
    dependencies: [
        .package(
            name: "CoreDesignSystem",
            path: "../../Core Design System Layer/CoreDesignSystem"
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
        ),
        .package(
            name: "UnsplashPhotosFeature",
            path: "../../Feature Layer/UnsplashPhotosFeature"
        ),
        .package(
            url: "https://github.com/onevcat/Kingfisher.git",
            from: "8.13.0"
        )
    ],
    targets: [
        .target(
            name: "UnsplashPhotosFeatureUI",
            dependencies: [
                .product(
                    name: "CoreDesignSystem",
                    package: "CoreDesignSystem"
                ),
                .product(
                    name: "CoreFoundational",
                    package: "CoreFoundational"
                ),
                .product(
                    name: "CoreNetworking",
                    package: "CoreNetworking"
                ),
                .product(
                    name: "UnsplashPhotosFeature",
                    package: "UnsplashPhotosFeature"
                ),
                .product(
                    name: "Kingfisher",
                    package: "Kingfisher"
                )
            ]
        ),
        .testTarget(
            name: "UnsplashPhotosFeatureUITests",
            dependencies: [
                "UnsplashPhotosFeatureUI",
                .product(
                    name: "CoreTesting",
                    package: "CoreTesting"
                )
            ]
        )
    ]
)
