# Foundation Layer

The lowest layer. It holds packages that extend Apple's Foundation framework, plus any
fundamental reusable component that every other layer and every app may need.

Packages: `CoreFoundational`.

## What must not be here

No UIKit. No SwiftUI. No presentation layer code of any kind. If a type knows how something looks
on screen, it does not belong in this layer.

## Platform agnostic

Everything in this layer is platform agnostic. Platform means iOS, macOS, watchOS, tvOS and
visionOS. Code here must be supportable on all of them, so it must not reach for anything that
only exists on one.

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
