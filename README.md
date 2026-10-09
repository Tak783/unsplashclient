# Unsplash Client

Demonstration of architectures with high levels of separation of concerns.

The same app is built three times. Each one browses an endless Unsplash feed, opens a photo full
screen, and searches with the same grid and paging. They differ only in how the code is organised,
so the same brief can be read at three levels of structure.

## What each architecture has

| Feature                                       | Architecture 1 | Architecture 2 | Architecture 3 |
|-----------------------------------------------|:--------------:|:--------------:|:--------------:|
| MVVM                                          |       🟢       |       🟢       |       🟢       |
| Protocol     |       🟢       |       🟢       |       🟢       |
| Service protocol seam                         |       🟢       |       🟢       |       🟢       |
| Separate remote and local models              |       🔴       |       🟢       |       🟢       |
| View factories                                |       🔴       |       🟢       |       🟢       |
| Unit tests                                    |       🔴       |       🟢       |       🟢       |
| Test spec protocols                           |       🔴       |       🔴       |       🟢       |
| Memory leak tracking in tests                 |       🔴       |       🔴       |       🟢       |
| Deprecated API kept to show the decision      |       🔴       |       🔴       |       🟢       |
| Split into Swift packages by layer            |       🔴       |       🔴       |       🟢       |
| Xcode workspace                               |       🔴       |       🔴       |       🟢       |
| Shared design system package                  |       🔴       |       🔴       |       🟢       |
| Platform agnostic layers below the app        |       🔴       |       🔴       |       🟢       |

Architecture 1 is the plainest reading of the brief. Architecture 2 adds the seams and the tests.
Architecture 3 takes those same seams and makes them physical, so the compiler enforces them.

## Layers

All three architectures generally follow the layering below in principle. In Architecture 1 and
Architecture 2 the layers are folders and conventions inside one target, so nothing stops a view
reaching into a service. In Architecture 3 each layer is a Swift package, so an import that points
the wrong way does not compile.

The diagram lives at `Architecture 3/architecture-diagram.html`. Open it in a browser.

### Foundation Layer

Packages that extend Apple's Foundation framework, plus any fundamental reusable component that
every other layer and every app may need. No UIKit, no SwiftUI, no presentation code.

* `CoreFoundational`: extensions to Foundation, reused by higher level layers.

### Core Design System Layer

The shared design system for all features: spacing, sizes, opacities and animation durations that
more than one feature should agree on.

* `CoreDesignSystem`: the design system for presentation layer packages, reused by every Feature UI
  package and by any app.

### Core Shared Components Layer

Shared components to be reused by higher level packages, such as features and feature UI. No UI
code of any kind, so a component here is usable by a feature that has no screen at all.

* `CoreNetworking`: the networking layer.
* `CoreSearch`: reusable components for search features.

### Feature Layer

Features shared across multiple packages and apps. Models, services and view models. No SwiftUI
and no UIKit, because a feature describes what the app does and never what it looks like.

* `UnsplashPhotosFeature`: the Unsplash photo feature, covering the feed and search.

### Feature UI

Presentation layer UI code for apps. Screens, cells and view components. This is the one layer
permitted a UI framework. It reuses the Feature Layer rather than repeating it.

* `UnsplashPhotosFeatureUI`: the presentation layer for the Unsplash photo feature.

### Testing Layer

Test helpers shared by the test targets of every other layer. A sibling of the other layers rather
than a rung on the ladder, because only test targets depend on it and nothing that ships does.

* `CoreTesting`: reusable helpers and extensions for unit, integration, end to end and UI testing.

### Presentation Layer

The app itself, and the only place that knows which platform it is for and which features it ships.
Its job is assembly.

* `UnsplashClient`: the iOS app.

## Platform agnostic components

Every layer below the presentation layer is platform agnostic. Platform means iOS, macOS, watchOS,
tvOS and visionOS, and code in those layers must be supportable on all of them.

* Reuse across Mac, iOS, iPadOS and watchOS apps, whether they are written in UIKit, WatchKit or
  SwiftUI.
* Components that other features and other apps can take as they are.
* Faster builds and faster test runs, locally and on a pipeline, because a layer builds alone.
* Easier collaboration, because work is not funnelled through one target.
* Room to open source a layer, to hire against it, or to stand up a demo app on top of it, since
  each layer depends on abstractions rather than concrete implementations.

## How to navigate

1. `Architecture 3/UnsplashClient.xcworkspace` shows the whole layered structure, with every package
   and its dependencies.
2. `Architecture 2/UnsplashClient/UnsplashClient.xcodeproj` is the same app in one target, with
   tests.
3. `Architecture 1/UnsplashClient/UnsplashClient.xcodeproj` is the same app at its plainest.

Every package in Architecture 3 builds and tests on its own, without building the app.
