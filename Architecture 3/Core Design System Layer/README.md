# Core Design System Layer

The shared design system for all features. Spacing, sizes, opacities, animation durations and any
other design value that more than one feature should agree on.

Packages: `CoreDesignSystem`.

## What must not be here

No feature logic and no networking. This layer describes how things should look, not what they do.

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
