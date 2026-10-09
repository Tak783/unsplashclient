//
//  UnsplashClientApp.swift
//  UnsplashClient
//
//  Created on 09/10/2026.
//

import SwiftUI
import UnsplashPhotosFeatureUI

@main
struct UnsplashClientApp: App {
    init() {
        PhotoImageCacheConfigurator.configure()
    }

    var body: some Scene {
        WindowGroup {
            PhotosViewFactory.makePhotosRootView()
                .preferredColorScheme(.dark)
        }
    }
}
