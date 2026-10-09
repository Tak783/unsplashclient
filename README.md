# Unsplash Client
Endless Unsplash feed, which opens a photo full screen, and searches with the same grid and paging.

- This project demostrates the *same* unsplash client app but in 3 architectures
- Each architecture demonstrates increased levels of abstraction and separation of concerns.
- Order of package abstraction is 1,2,3 with Acrchitecture 3 as the most abstract
- The apps of differ only in how the code is organised,
    so the same brief can be read at three levels of structure.  

## What each architecture has

Architecture 1 is the plainest reading of the brief. Architecture 2 adds the seams and the tests.
Architecture 3 takes those same seams and makes them physical, so the compiler enforces them.

| Feature                                       | Architecture 1 | Architecture 2 | Architecture 3 |
|-----------------------------------------------|:--------------:|:--------------:|:--------------:|
| MVVM                                          |       🟢       |       🟢       |       🟢       |
| Protocol Orientated Programming & S.O.L.I.D   |       🟢       |       🟢       |       🟢       |
| Service protocol seam                         |       🟢       |       🟢       |       🟢       |
| Separate remote and local models              |       🔴       |       🟢       |       🟢       |
| View factories                                |       🔴       |       🟢       |       🟢       |
| Unit tests                                    |       🔴       |       🟢       |       🟢       |
| Split into Swift packages by layers           |       🔴       |       🔴       |       🟢       |
| Platform agnostic layers below the app        |       🔴       |       🔴       |       🟢       |
| Xcode workspace                               |       🔴       |       🔴       |       🟢       |
| Shared design system package                  |       🔴       |       🔴       |       🟢       |
| Unit Test spec protocols                      |       🔴       |       🔴       |       🟢       |
| Memory leak tracking in tests                 |       🔴       |       🔴       |       🟢       |
| Deprecated API kept to show the decision      |       🔴       |       🔴       |       🟢       |

## Overview

### Architecture

* Architecture 3 is built on top of multiple platform agnostic packages that live in their own
  projects, split into layers. The reasoning is discussed below.
* Each package can be built and tested on its own, including the presentation layer app target.
  `CoreSearch` builds and tests in a few seconds without compiling the app at all.
* There are seven layers: `Foundation Layer`, `Core Design System Layer`,
  `Core Shared Components Layer`, `Feature Layer`, `Feature UI`, `Testing Layer` and the
  `Presentation Layer`.
* Layer dependencies run vertically. A package may import only from the layers below it.

The diagram lives at `Architecture 3/architecture-diagram.html`. Open it in a browser.

### Design and development

* Built applying SOLID principles, with unit tests across every layer.
* Tests were written after the code rather than driving it, so this is not a TDD codebase. The
  suites that exist are real rather than decorative: the debouncer tests cover the two character
  minimum, whitespace trimming, one search per burst of typing, repeated queries and cancellation.
* Architecture 3 tracks memory leaks in tests. That paid for itself immediately by catching a
  retain cycle in the search debouncer, where the object held its own pending task and the task
  captured the object back.
* Each test suite in Architecture 3 conforms to a spec protocol, so the list of behaviours a type
  promises can be read in one short file without wading through assertions.
* More UI and integration tests could be added, as discussed under Improvements.


## Architectural decisions

### Layers

* Each package lives in its own project with as few dependencies as possible and carries its own
  tests, so that a feature can be:
  * built in isolation, without building the whole app;
  * reused, open sourced, or dropped into a demo app;
  * platform agnostic, usable from any presentation target.
* Vertical dependencies. Each layer holds packages used by higher level packages, and a package
  may import only from the layers below it.
* In Architecture 1 and Architecture 2 this layering is folders and convention inside a single
  target, so nothing stops a view reaching into a service. In Architecture 3 the layers are
  packages, so an import pointing the wrong way does not compile.


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

## Image loading

Images come from Unsplash over the network, three to a row, for hundreds of rows. Doing that by
hand means writing a download queue, a memory cache, a disk cache, cancellation on cell reuse and
decode off the main thread. All four matter for scrolling, and all four are easy to get subtly
wrong, so the app uses [Kingfisher](https://github.com/onevcat/Kingfisher) 8.13.0 instead.

### Why Kingfisher

* **It deduplicates work.** Two cells asking for the same URL share one download, and a URL
  already in cache never hits the network again. That is the single biggest win in a grid where
  Unsplash repeats photos across pages.
* **It decodes off the main thread.** An undecoded JPEG is decompressed the first time it is
  drawn, which lands on the main thread during a scroll and shows up as a dropped frame.
* **It cancels.** A cell scrolled past stops downloading, so the queue is never clogged with
  images nobody will see.
* **It has a SwiftUI view.** `KFImage` fits the declarative grid, with a placeholder closure for
  the blur hash, rather than wrapping `UIImageView`.
* **It prefetches.** A page of newly loaded URLs can be warmed before the cells reach the screen.

### How it is used

| Where | What | Why |
|---|---|---|
| Feed cell and detail | `KFImage` | Loads the photo and shows the decoded blur hash underneath while it arrives |
| Both | `.backgroundDecode()` | Decompresses off the main thread, so scrolling does not stall |
| Feed cell | `.cancelOnDisappear(true)` | Drops the download when the cell leaves the screen |
| Both | `.fade(duration:)` | A short cross fade from blur hash to photo, from the design system |
| Grid | `ImagePrefetcher` | Warms only the URLs from the page just appended, not the whole list |

The grid requests the `small` URL and the detail screen requests `full`, so the feed stays cheap
and the full screen view is worth opening. A measurement decided that: the `small` image is about
24 KB, while a custom square crop of the same photo came back at about 32 KB and took longer, so
the custom crop was dropped from the grid. The type that built it is kept in Architecture 3, marked
deprecated with the reason, rather than deleted, so the decision stays visible.

### Cache size and clearing

Kingfisher caches in two places, and the app changes one of them.

| | Default | This app |
|---|---|---|
| Memory cost limit | A quarter of physical memory | 100 MB |
| Memory expiry | 300 seconds | unchanged |
| Disk size limit | Unlimited | unchanged |
| Disk expiry | 7 days | unchanged |

A quarter of physical memory is a lot on a modern phone, and an image cache that large competes
with everything else the app wants to hold. 100 MB is roughly a thousand grid thumbnails, far more
than a scroll session needs, while leaving the rest of the device alone. It is set once at launch,
in `PhotoImageCacheConfigurator`, which is the only place in the app that knows Kingfisher is the
image loader.

Clearing is mostly automatic. Kingfisher observes the system notifications and empties the memory
cache on a memory warning, cleans expired disk entries when the app is backgrounded, and cleans
them again on termination. Nothing in the app needs to do that by hand.

To clear manually, for example behind a settings toggle, the calls are
`ImageCache.default.clearMemoryCache()`, `clearDiskCache()` and `cleanExpiredDiskCache()`. None of
those are wired to anything today, because the app has no settings screen.


## How to navigate

1. `Architecture 3/UnsplashClient.xcworkspace` shows the whole layered structure, with every package
   and its dependencies.
2. `Architecture 2/UnsplashClient/UnsplashClient.xcodeproj` is the same app in one target, with
   tests.
3. `Architecture 1/UnsplashClient/UnsplashClient.xcodeproj` is the same app at its plainest.

Every package in Architecture 3 builds and tests on its own, without building the app.

## How to use

APIKey -> search for `place_unsplash_api_key_here` and replce that string with your key

## Key Decicions
1. 

## Improvements

There are optimisations and improvements to be made across all three architectures, open to
discussion, but these are the core changes I would make next.

* Take the Unsplash access key out of the app. It is a constant today, which is wrong for anything
  real. The call belongs behind a backend that holds the key.
* Add UI tests for the feed, the detail screen and search.
* Add snapshot tests for the grid cell and the caption overlay.
* Move the test doubles out of the feature test target into a `CoreMockData` package, so other
  packages and apps can reuse them.
* Move navigation into a `CoreNavigation` package. The typed routes sit in the feature package
  today, which is fine for one app and not for several.
* Move reusable SwiftUI components, such as the caption overlay and the blurred placeholder, into
  a `CoreSwiftUIComponents` package.
* Cut the unnecessary SwiftUI view updates. Both grid views read the loading flag and the error
  state in the same body that renders the grid, so a spinner appearing re-evaluates the whole
  grid. Splitting those into child views would stop it.
* Inject the URL pool instead of calling `UnsplashURLPool` statically from the service, which is
  the last place a concrete type is reached for rather than passed in.
* Remove the dead `CoreNetworking` imports from the feature UI package, left over from the split.
* Profile with Instruments: Time Profiler for the scroll, Allocations and Leaks across several
  hundred images, and Animation Hitches on a device rather than the simulator.
* Add the usual things: localisation, accessibility and Dynamic Type.
* Add SwiftLint, with the rules enforced in CI rather than by review.
