# Feature UI

Presentation layer UI code for apps. The screens, cells and view components a feature needs.

Packages: `UnsplashPhotosFeatureUI`.

This layer reuses the Feature Layer rather than repeating it. A screen here binds to a view model
from `UnsplashPhotosFeature` and takes its design values from `CoreDesignSystem`. It does not
fetch, decode or page anything itself.

## What belongs one layer down instead

Anything that would still be true with no screen attached. Models, services, paging, view models.
If you find yourself writing that here, it belongs in the Feature Layer.

## Platform

This is the one layer that is not platform agnostic. UI code is written against a platform's UI
framework, so a package here may import SwiftUI or UIKit and may declare a platform requirement.

## Import direction

A package may only import packages from layers below it. Nothing imports upward. This is what
keeps the concerns separate: a lower layer never knows what is built on top of it, so it can be
reused by anything.

```
UnsplashClient (iOS app)                            high level layer, presentation
        │ imports
        ▼
UnsplashPhotosFeatureUI                             feature UI layer
        │ imports
        ▼
UnsplashPhotosFeature                               feature layer, the middle
        │ imports
        ▼
CoreNetworking · CoreSearch · CoreDesignSystem      core layers
        │ imports
        ▼
CoreFoundational                                    low level layer, foundation
```

Worked example. `UnsplashPhotosFeature` may import `CoreFoundational`, `CoreNetworking` and
`CoreSearch`, because all three sit below it. It may not import `UnsplashPhotosFeatureUI`, because
that sits above it. `CoreFoundational` may import nothing from this repository at all.
