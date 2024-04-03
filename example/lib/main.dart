import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:go_transitions/go_transitions.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    /// Set default transition values for the entire app.
    GoTransition.defaultCurve = Curves.easeInOut;
    GoTransition.defaultDuration = const Duration(milliseconds: 600);

    return MaterialApp.router(
      /// Easily set the default page transitions for the entire app.
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
          ShellRoute(
            builder: (context, state, child) {
              return Scaffold(
                appBar: AppBar(
                  title: Text(state.fullPath.toString()),
                ),
                body: child,
              );
            },
            routes: [
              GoRoute(
                path: '/',
                builder: (_, __) => const InitialPage(),
                routes: [
                  GoRoute(
                    path: 'theme',
                    builder: (_, __) => const HomePage(),
                    pageBuilder: GoTransitions.theme,
                  ),
                  GoRoute(
                    path: 'slide',
                    builder: (_, __) => const HomePage(),
                    pageBuilder: GoTransitions.slide.toRight.withFade,
                  ),
                  GoRoute(
                    path: 'rotate',
                    builder: (_, __) => const HomePage(),
                    pageBuilder: GoTransitions.rotate.withScale,
                  ),
                  GoRoute(
                    path: 'scale',
                    builder: (_, __) => const HomePage(),
                    pageBuilder: GoTransitions.scale.withFade.toBottom.build(
                      barrierColor: Colors.black54,
                    ),
                  ),
                  GoRoute(
                    path: 'fullscreen-dialog',
                    builder: (_, __) => const FullscreenDialogPage(),
                    pageBuilder: GoTransitions.fullscreenDialog,
                  ),
                  GoRoute(
                    path: 'dialog',
                    builder: (_, __) => const MyDialog(),
                    pageBuilder: GoTransitions.dialog,
                  ),
                  GoRoute(
                    path: 'bottom-sheet',
                    builder: (_, __) => const MyBottomSheet(),
                    pageBuilder: GoTransitions.bottomSheet,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class InitialPage extends StatelessWidget {
  const InitialPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepOrange,
      appBar: AppBar(
        title: const Text('InitialPage'),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton(
              onPressed: () {
                context.go('/theme');
              },
              child: const Text('Go to HomePage with .theme'),
            ),
            ElevatedButton(
              onPressed: () {
                context.go('/slide');
              },
              child: const Text('Go to HomePage with .slide'),
            ),
            ElevatedButton(
              onPressed: () {
                context.go('/rotate');
              },
              child: const Text('Go to HomePage with .rotate'),
            ),
            ElevatedButton(
              onPressed: () {
                context.go('/scale');
              },
              child: const Text('Go to HomePage with .scale'),
            ),
            ElevatedButton(
              onPressed: () {
                context.go('/fullscreen-dialog');
              },
              child: const Text('Go to FullscreenDialogPage'),
            ),
            ElevatedButton(
              onPressed: () {
                context.go('/dialog');
              },
              child: const Text('Go to MyRawDialog'),
            ),
            ElevatedButton(
              onPressed: () {
                context.go('/bottom-sheet');
              },
              child: const Text('Go to MyBottomSheet'),
            ),
          ],
        ),
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple,
      appBar: AppBar(
        title: Text('$runtimeType'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            context.go('/');
          },
          child: const Text('Back to InitialPage'),
        ),
      ),
    );
  }
}


class FullscreenDialogPage extends StatelessWidget {
  const FullscreenDialogPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green,
      appBar: AppBar(
        title: Text('$runtimeType'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            context.push('/fullscreen-dialog');
          },
          child: const Text('to 2'),
        ),
      ),
    );
  }
}

class MyDialog extends StatelessWidget {
  const MyDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            title: Text('$runtimeType'),
          ),
          ElevatedButton(
            onPressed: () {
              context.go('/');
            },
            child: const Text('Back to InitialPage'),
          ),
        ],
      ),
    );
  }
}

class MyBottomSheet extends StatelessWidget {
  const MyBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return BottomSheet(
      onClosing: () {},
      builder: (_) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: Text('$runtimeType'),
            ),
            ElevatedButton(
              onPressed: () {
                context.go('/');
              },
              child: const Text('Back to InitialPage'),
            ),
          ],
        );
      },
    );
  }
}
