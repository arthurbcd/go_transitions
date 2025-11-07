# Changelog

## 0.8.3

- bump `go_router` to '>=13.0.0 <18.0.0'

Thanks to `runoob-coder` !

## 0.8.2

- Fix #8, bump `go_router` to '>=13.0.0 <17.0.0'.

Thanks to `realtec` !

## 0.8.1

- Fix #6, bump `go_router` to '>=13.0.0 <16.0.0'

Thanks to `paulking86` !

## 0.8.0

- Added `GoTransitionRoute` for using transitions outside go_router, ex: `Navigator.push`.
- Added #5 `GoTransition.build(GoRouterWidgetBuilder? builder)` alternative to `child`.

Thanks to `fiet-kyo`!

- Improved inferred `GoRouter.builder` child in `GoTransition.call`.
- Fixed missing `GoTransitionPage.builder` default implementation.
- Updated `README.md` with details about the new features.
- Moved `canPop` & `onPopInvoked` to `GoTransitionSettings`.
- Bump min sdk to 3.5.0 to match flutter >= 3.24.0.

## 0.7.1

- Fixed #4 'noSuchMethod' implementation on flutter 3.27.0. 

Thanks to `Clon1998`!

## 0.7.0

- Bump min version constraints to flutter 3.24.0.
- Added `Page.canPop` and `Page.onPopInvoked` to `GoTransitionPage`, `GoTransition`, `MaterialGoTransition` and `CupertinoGoTransition`.

## 0.6.0

- Added `withBackGesture` modifier.

## 0.5.3

- Fixed #2 `GoTransitions.cupertino` back swipe gestures.

Thanks to `Clon1998`!

## 0.5.2

- Bump `go_router` for `14.0.0`.

## 0.5.1

- Fixed allowSnapshotting recursive call.

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

Thanks to `jtkeyva` for the contribution!

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
