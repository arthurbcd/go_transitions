# Changelog

## 0.3.0

Introduces `GoTransitionPage`, an extended `CustomTransitionPage` with:

- `PageTransitionsBuilder.buildTransitions` as pageTransitionsBuilder.
- `PageRoute.canTransitionTo` as canTransitionTo.
- `PageRoute.canTransitionFrom` as canTransitionFrom.
- `PageRoute.allowSnapshotting` as allowSnapshottting.

## 0.2.0

Flutter works with `Widget Function(PageRoute, BuildContext, Animation<double>, Animation<double>, Widget)` signature. This release changes the signature of `GoTransition.builder` to match this.

- Upgraded `RouteTransitionsBuilder` to `PageRouteTransitionsBuilder` for consistency with `flutter`'s `PageRouteBuilder`.
- Added `canTransitionTo` and `canTransitionFrom` to `GoTransition.build`.
- Added `!fullscreenDialog` guard as default clause to `canTransitionTo`, needed for using `MaterialPage` and `CupertinoPage` transitions, so it won't perform undesired outgoing transition when the next route is a fullscreen dialog.
- Hide protected api.
- Updated `README.md`.

## 0.1.0

- Initial release.
