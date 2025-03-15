import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'go_transition_page.dart';
import 'go_transition_settings.dart';
import 'go_transition_style.dart';
import 'modifiers.dart';

@immutable
class GoTransition extends GoTransitionPage {
  /// The default curve to use on any [GoTransition].
  static Curve defaultCurve = Curves.linear;

  /// The default reverse curve to use. Defaults to [defaultCurve].
  static Curve? defaultReverseCurve;

  /// The default duration to use on [build].
  static Duration defaultDuration = const Duration(milliseconds: 300);

  /// The default reverse duration to use on [build]. Defaults to [defaultDuration].
  static Duration? defaultReverseDuration;

  /// The [NavigatorObserver] to set on [GoRouter] and/or [ShellRoute].
  ///
  /// This enables the use of [GoTransition.previousChildOf]. Which is also
  /// used by [GoTransitionModifiers.onPrevious] modifier.
  static NavigatorObserver get observer => _GoTransitionObserver();

  /// The previous [GoTransition] of the current [BuildContext].
  ///
  /// This is the same as `context.previousChild` syntax-sugar.
  static Widget? previousChildOf(BuildContext context) {
    final observer = Navigator.of(context)
        .widget
        .observers
        .whereType<_GoTransitionObserver>();

    assert(observer.isNotEmpty, 'No [GoTransition.observer] found.');
    final page = observer.single._previousRoute?.settings;

    if (page is CustomTransitionPage) return page.child;
    if (page is CupertinoPage) return page.child;
    if (page is MaterialPage) return page.child;
    return null;
  }

  /// Creates a [GoTransition], compatible with [Page], [PageTransitionsBuilder]
  /// and [GoRoute.pageBuilder] signatures.
  ///
  /// - [builder] is applied to both [PageRoute] and [PageTransitionsBuilder].
  /// - [style] is applied to both [PageRoute] and [PageTransitionsBuilder].
  /// - [settings] is applied only to [PageRoute].
  /// - [child] is applied only to [PageRoute].
  ///
  /// You don't need to provide a [child] if you provide a [GoRoute.builder].
  /// It will use the [GoRoute.builder] as the child.
  ///
  /// Additionally, it's also compatible with modifiers:
  /// - [withFade]
  /// - [withRotation]
  /// - [withScale]
  /// - [withSize]
  /// - [withSlide]
  /// - [toLeft]
  /// - [toRight]
  /// - [toTop]
  /// - [toBottom]
  ///
  /// See [GoTransitionModifiers], to see all available modifiers.
  ///
  const GoTransition({
    super.builder,
    super.style,
    super.settings,
    Widget? child,
  }) : super(child: child ?? const _NoChild());

  /// Whether this [GoTransitionPage] has a [child].
  ///
  /// If no [child] is provided, it will use the [GoRoute.builder].
  bool get hasChild => child is! _NoChild;

  /// Returns the [GoTransition] of the current [BuildContext].
  static GoTransitionStyle? styleOf(BuildContext context) {
    final scope = context.getInheritedWidgetOfExactType<GoTransitionScope>();
    return scope?.style;
  }

  /// Tears down this to [GoRouterPageBuilder] signature with default values.
  Page call(BuildContext context, GoRouterState state) {
    return copyWith(
      settings: settings.copyWith(
        key: key ?? state.pageKey,
        name: name ?? state.name,
        arguments: arguments ?? state.extra,
      ),
      child: hasChild ? child : state.build(context),
    );
  }

  /// Creates a copy of this [GoTransition] with the given values.
  GoTransition copyWith({
    PageRouteTransitionsBuilder? builder,
    GoTransitionStyle? style,
    GoTransitionSettings? settings,
    Widget? child,
  }) {
    return GoTransition(
      builder: builder ?? this.builder,
      style: style ?? this.style,
      settings: settings ?? this.settings,
      child: child ?? this.child,
    );
  }
}

class _GoTransitionObserver extends NavigatorObserver {
  Route? _previousRoute;

  @override
  void didPush(Route route, Route? previousRoute) {
    _previousRoute = previousRoute;
  }

  @override
  void didPop(Route route, Route? previousRoute) {
    _previousRoute = previousRoute;
  }

  @override
  void didRemove(Route route, Route? previousRoute) {
    _previousRoute = previousRoute;
  }

  @override
  void didReplace({Route? newRoute, Route? oldRoute}) {
    _previousRoute = oldRoute;
  }

  @override
  void didStartUserGesture(Route route, Route? previousRoute) {
    _previousRoute = previousRoute;
  }
}

extension GoTransitionExtension on GoTransition {
  /// Builds a [GoRouterPageBuilder] of this [GoTransition].
  ///
  /// Use [child] or [builder] to provide a [GoTransition.child].
  /// If null, it will be inferred from [GoRoute.builder] as [child].
  ///
  GoRouterPageBuilder build({
    GoTransitionSettings? settings,
    GoRouterWidgetBuilder? builder,
    Widget? child,
  }) {
    assert(builder == null || child == null, 'You cannot provide both');
    return (context, state) {
      return copyWith(
        settings: settings,
        child: builder != null
            ? Builder(builder: (ctx) => builder(ctx, state))
            : child,
      ).call(context, state);
    };
  }

  /// Builds a [GoRouterPageBuilder] with [PopupRoute] default properties.
  ///
  /// If [child] is null, it will use the current [GoRoute.builder] as child.
  ///
  GoRouterPageBuilder buildPopup({
    GoTransitionSettings settings = const GoTransitionSettings.popup(),
    GoRouterWidgetBuilder? builder,
    Widget? child,
  }) {
    return build(
      settings: settings,
      builder: builder,
      child: child,
    );
  }
}

typedef PageRouteTransitionsBuilder = Widget Function(
  PageRoute route,
  BuildContext context,
  Animation<double> animation,
  Animation<double> secondaryAnimation,
  Widget child,
);

typedef CanTransition = bool Function(TransitionRoute nextRoute);

class _NoChild extends Widget {
  const _NoChild();

  @override
  Element createElement() {
    throw GoError('No child or GoRouter.builder found.');
  }
}

extension on GoRouterState {
  static final _builders = <ValueKey, GoRouterWidgetBuilder?>{};

  Widget build(BuildContext context) {
    final builder = _builders[pageKey] ??= GoRouter.of(context)
        .routerDelegate
        .currentConfiguration
        .routes
        .whereType<GoRoute>()
        .lastOrNull
        ?.builder;

    if (builder == null) {
      throw GoError('The route $fullPath does not have a builder.');
    }

    // we ensure builder is called by the widget tree
    return Builder(builder: (context) => builder(context, this));
  }
}
