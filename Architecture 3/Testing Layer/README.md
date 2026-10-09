# Testing Layer

Test helpers shared by the test targets of every other layer. It is a sibling of the other layers
rather than a rung on the ladder, because only test targets depend on it and no shipping code
does.

Packages: `CoreTesting`, which holds the memory leak tracking used by the test suites.

## What must not be here

Nothing that ships. No app code, no feature code. If a production target would ever import it,
it belongs in another layer.

## Platform agnostic

Everything in this layer is platform agnostic. Platform means iOS, macOS, watchOS, tvOS and
visionOS. Code here must be supportable on all of them, so it must not reach for anything that
only exists on one.
