
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

By default `GoTransition.build` is called through implicit tear-off with default values, but you can call it explicitly:

```dart
GoTransitions.slide.toRight.withFade.build(
  duration: const Duration(milliseconds: 600),
  barrierColor: Colors.black45,
);
```

## Custom Transitions

Easily create and apply custom transitions such as fade, slide, rotate, scale, and more:

```dart
GoRoute(
  path: 'slide',
  builder: (_, __) => const HomePage(),
  pageBuilder: GoTransitions.slide.toRight.withFade,
),
```

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
- toLeft
- toRight
- toTop
- toBottom

Sintax-sugar:

- fullscreenDialog
- dialog (RawDialogRoute)
- bottomSheet (ModalBottomSheetRoute)

## Contribution

Contributions are welcome! Feel free to submit pull requests or open issues on our GitHub repository. Don't forget to star/like the project if you like it.
