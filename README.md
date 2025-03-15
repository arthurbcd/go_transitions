
# GoTransitions

This library aims to super simplify the way you can create page transitions with GoRouter.

```dart
void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {

    /// Set default transition values for all `GoTransition`.
    GoTransition.defaultCurve = Curves.easeInOut;
    GoTransition.defaultDuration = const Duration(milliseconds: 600);

    return MaterialApp.router(
    
      /// Easily set the default page transitions for all routes in theme.
      theme: ThemeData(
        pageTransitionsTheme: const PageTransitionsTheme(
          builders: {
            TargetPlatform.android: GoTransitions.fadeUpwards,
            TargetPlatform.iOS: GoTransitions.cupertino,
            TargetPlatform.macOS: GoTransitions.cupertino,
          },
        ),
      ),
      routerConfig: GoRouter(
        routes: [
          GoRoute(
            path: '/',
            builder: (_, __) => const InitialPage(),
            pageBuilder: GoTransitions.fadeUpwards, // 1 line to set a page transition!
          ),
        ],
      ),
    );
  }
}
```

## Building the Transitions

By default `GoTransition.build` and `builder` are called through implicit tear-off:

```dart
GoRoute(
  path: 'slide',
  builder: (_, __) => const HomePage(),
  pageBuilder: GoTransitions.slide.toRight.withFade,
),
```

But you can call it explicitly if you want to:

```dart
GoRoute(
  path: 'slide',
  pageBuilder: GoTransitions.slide.toRight.withFade.build(
    builder: (_, __) => const HomePage(),
    // child: const HomePage(), // <- or directly pass it
  ),
),
```

## Navigating outside the router

You can use `GoTransitionRoute` to navigate outside the router, for example, when using `Navigator`:

```dart
Navigator.of(context).push(
  GoTransitionRoute(
    transition: GoTransitions.rotate.withBackGesture, // <- my awesome transition
    builder: (context) => const HomePage(),
  ),
);
```

## Custom Transitions

Easily create and apply custom transitions such as fade, slide, rotate, scale, and more:


## Transitions

Customizables:

- none
- theme
- invisible
- fade
- rotate
- scale
- size
- slide
- fadeUpwards (Android O)
- openUpwards (Android P)
- zoom (Android Q)
- cupertino (iOS/macOS)

Modifiers:

- withFade
- withRotation
- withScale
- withSize
- withSlide
- withBackGesture
- toLeft
- toRight
- toTop
- toBottom

Syntax-sugar:

- fullscreenDialog
- dialog (RawDialogRoute)
- bottomSheet (ModalBottomSheetRoute)

## Contribution

Contributions are welcome! Feel free to submit pull requests or open issues on our GitHub repository. Don't forget to star/like the project if you like it.
