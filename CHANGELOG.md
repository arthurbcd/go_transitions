# Changelog

## 0.5.0

The package was internally rewritten to make it completely compatible with native classes such as Page, CupertinoPage, MaterialPage when transitionating between them. Which was not possible before if you were using both them and GoTransitions.

- Removed super enums in favor of static instances.
- Added `GoTransitionStyle` dedicated class for defining transition styles.
- Added `GoTransitionSettings` dedicated class for defining transition settings.
- Added `GoTransitionModifiers.withStyle` for modifing the style of a GoTransition.
- Added `GoTransitionModifiers.withSettings` for modifing the settings of a GoTransition.

Experimental: Now you can apply complex transitions on both previous and current routes at the same time, or simply animate just the previous route for "reveal" transitions:

- Added `GoTransition.observer`.
- Added `GoTransition.previousChildOf` to get the child of any previous route. Requires `GoTransition.observer`.
- Added `GoTransitions.onPrevious` for applying transitions on the previous route. Requires `GoTransition.observer`.

Ex: `GoTransition.slide.toRight.onPrevious`.

Thanks to `jtkeyva` for the contribution.

## 0.4.0

- Added `GoTransitions.material`.
- Changed `fullscreenDialog`, `dialog` and `bottomSheet` instances to factory getters.

## 0.3.2

- Added 'child' property to `GoTransition.build` for those who want to explicitly define the child widget, instead of using the default resolved `child` of the pushed `GoRoute.builder`.

## 0.3.1

- Improved location matcher for `GoTransition.build`.

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
