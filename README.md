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

## How to use

1. APIKey -> search for `place_unsplash_api_key_here` in any of the achitectures (Arch)
1. Arch 1 & 2 -> open their Xcode projects anr run the app
1. Arch 3 -> open the workspace and run the app from there or any of the pacckages

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

The diagram lives at the root folder in `architecture-diagram.html`. Open it in a browser (Chrome)

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


## Layers explained

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

## Perfomancce

The app is image heavy. 3 images per row. Hundreds of rows. Hand writing taht means adding
a download queue, memory cache, disk cache, cache clearance, cancellation, re-ise managenement,
mananing that all off the main thread. Kingfisher was chosen insgtead as it provides so much.
Its well tested and I have used it on most companies I've worked at 

[Kingfisher](https://github.com/onevcat/Kingfisher) 8.13.0

### Why Kingfisher

* **It decodes off the main thread.** 
* **It deduplicates work.** Two cells asking for the same URL share one download.
* **It cancels.** If a cell is scrolled past stops downloading.
* **It has a custom SwiftUI view.** `KFImage` fits the declarative grid, 
with a placeholder closure for the blur hash, rather than wrapping `UIImageView`.
* **It prefetches.** A page of newly loaded URLs can be warmed before the cells reach the screen.

We use Kingfisher it everywhere where there is an image.

## Choices, and what they cost

### Which image size to request

Measured rather than guessed. For the same photo:

| URL                            |   Bytes |
|--------------------------------|--------:|
| `small`                        |  24,526 |
| A square crop built from `raw` |  31,965 |
| `regular`                      | 105,572 |
| `full`                         | 687,297 |

*  The grid asks for `small`. A square crop (see `urlWhenResizedAsASquare`) would have made 
every tile a perfect square without cropping in the view, but it came back a third larger and 
slower, so I droppped it. 
*  I did keep `urlWhenResizedAsASquare`) as a demo maybe to return to and optimise.
But in the end, I turend the grid into rectangles instead of squares so.
* Used Kingfisher also becuase it clears the image cache byitself which is good.
* Used `backgroundDecode` on Kinfisher to increase display speed, did not see meaningful 
difference in additional time and memory usage by it.
* Kingfisher Prefetching warms only the URLs from the page just appended, not the whole list.
* A download is cancelled when its cell leaves the screen `.cancelOnDisappear` 

### Blur

Every Unsplash photo comes with a BlurHash. Used to show a blur whilst an image loads loads. 
However Blur decoding takes compute, so decoded images are held in a cache capped at 600
entries, evicting least recently used first (better UX).

### Keeping the main thread free

* Images are decompressed off the main thread. An undecoded JPEG is otherwise decoded the first
  time it is drawn, mid scroll, which is a dropped frame.
* `LazyVGrid` inside a `ScrollView` builds only the cells on screen.
* Cell width is computed once from the parent width and rounded down, so three cells and two gaps
  always fit and no row is laid out at a fractional width.

### Pagination

* We show thirty photos a page 
* Next page load triggered fifteen from the end.
* From testing fiteen from testing is enough time to load the next set before 
    a user gets to the bottom in normal scroll behavior. This also helps us manage rate limit.

### Search
Core in philosphy was rate limit + memeory managemnt, so it adapts to typical user typing patterns

* Typing is debounced by 400 ms (we only send the request after tha time
* We have a 2 character minimum for making a reqest 
* Request are cancelled when a new one starts - this stops unnessary data fethcing + memor usage

### Memory

The image memory cache is capped at 100 MB `memoryCacheLimitInBytes` rather than Kingfisher's default
of a quarter of physical memory to not annoy users. Downside is, more requests. 
But IRL, this is a business level decision.

### Memory Leaks

Architecture 3 also tracks memory leaks in its tests, which is how the retain cycle in the search
debouncer was found.

## How to navigate

1. `Architecture 3/UnsplashClient.xcworkspace` shows the whole layered structure, with every package
   and its dependencies.
2. `Architecture 2/UnsplashClient/UnsplashClient.xcodeproj` is the same app in one target, with
   tests.
3. `Architecture 1/UnsplashClient/UnsplashClient.xcodeproj` is the same app at its plainest.

Every package in Architecture 3 builds and tests on its own, without building the app.

## Improvements

There are optimisations and improvements to be made across all three architectures, open to
discussion, but these are the core changes I would make next.

*Priority*
* 🚨 the load times on the detail page - the spec did not require load times of detail page to be 
" smooth, without stuttering or noticeable loading times" as the "1. Main Feed" does. So I did not 
add any optimisation. In future, I'd optimise it.
* 🚨 Profiling with Instruments: Time Profiler for the scroll, Allocations and Leaks across 
all feaatures.
* Take the Unsplash access key out of the app. It is a constant today, which is wrong for anything
  real. The call belongs behind a backend that holds the key.

*Others*

* Add SwiftLint, with the rules enforced in CI rather than by review.
* Add UI tests for the feed, the detail screen and search.
* Add snapshot tests for the grid cell and the caption overlay.
* Move reusable SwiftUI components, such as the caption overlay and the blurred placeholder, into
  a `CoreSwiftUIComponents` package.
* Add the usual things: localisation, accessibility and Dynamic Type.
