import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

@immutable
class GoTransition implements PageTransitionsBuilder {
  /// The default curve to use on any [GoTransition].
  static Curve defaultCurve = Curves.linear;

  /// The default reverse curve to use. Defaults to [defaultCurve].
  static Curve? defaultReverseCurve;

  /// The default duration to use on [build].
  static Duration defaultDuration = const Duration(milliseconds: 300);

  /// The default reverse duration to use on [build]. Defaults to [defaultDuration].
  static Duration? defaultReverseDuration;

  /// Creates a [GoTransition].
  const GoTransition({
    this.builder = _noTransition,
    this.alignment,
    this.offset,
    this.axis,
    this.axisAlignment,
    this.curve,
    this.reverseCurve,
  });

  /// Default transition with no animation.
  static Widget _noTransition<T>(_, __, ___, ____, Widget child) => child;

  /// The [PageTransitionsBuilder.buildTransitions] builder.
  final PageRouteTransitionsBuilder builder;

  /// The transition [MatrixTransition.alignment].
  final Alignment? alignment;

  /// The transition [SlideTransition.position] begin [Offset].
  final Offset? offset;

  /// The transition [SizeTransition.axis].
  final Axis? axis;

  /// The transition [SizeTransition.axisAlignment].
  final double? axisAlignment;

  /// The transition [Curve] to use.
  final Curve? curve;

  /// The transition reverse [Curve] to use. If null, uses [curve].
  final Curve? reverseCurve;

  /// Returns the [GoTransition] of the current [BuildContext].
  static GoTransition? of(BuildContext context) {
    final scope = context.getInheritedWidgetOfExactType<GoTransitionScope>();
    return scope?.goTransition;
  }

  /// Tears down this to [GoRouterPageBuilder] signature with default values.
  Page call(BuildContext context, GoRouterState state) {
    return build()(context, state);
  }

  @override
  @mustCallSuper
  Widget buildTransitions<T>(
    route,
    context,
    animation,
    secondaryAnimation,
    child,
  ) {
    return GoTransitionScope(
      goTransition: this,
      child: Builder(
        builder: (context) {
          return builder(
            route,
            context,
            CurvedAnimation(
              parent: animation,
              curve: curve ?? GoTransition.defaultCurve,
              reverseCurve: reverseCurve ?? GoTransition.defaultReverseCurve,
            ),
            CurvedAnimation(
              parent: secondaryAnimation,
              curve: curve ?? GoTransition.defaultCurve,
              reverseCurve: reverseCurve ?? GoTransition.defaultReverseCurve,
            ),
            child,
          );
        },
      ),
    );
  }
}

class GoTransitionScope extends InheritedWidget {
  const GoTransitionScope({
    super.key,
    required super.child,
    required this.goTransition,
  });

  final GoTransition goTransition;

  @override
  bool updateShouldNotify(GoTransitionScope oldWidget) => false;
}

extension GoTransitionExtension on GoTransition {
  /// Builds a [GoRouterPageBuilder] of this [GoTransition].
  ///
  /// - [duration] defaults to [GoTransition.defaultDuration].
  /// - [reverseDuration] defaults to [GoTransition.defaultReverseDuration].
  /// - [key] defaults to [GoRouterState.pageKey].
  /// - [name] defaults to [GoRouterState.name].
  /// - [arguments] defaults to [GoRouterState.extra].
  ///
  /// If [child] is null, it will use the current [GoRoute.builder] as child.
  ///
  GoRouterPageBuilder build({
    Duration? duration,
    Duration? reverseDuration,
    bool opaque = true,
    bool maintainState = true,
    bool fullscreenDialog = false,
    bool barrierDismissible = false,
    bool allowSnapshotting = true,
    Color? barrierColor,
    String? barrierLabel,
    LocalKey? key,
    String? name,
    Object? arguments,
    String? restorationId,
    CanTransition? canTransitionTo,
    CanTransition? canTransitionFrom,
    Widget? child,
  }) {
    return (context, state) {
      child ??= GoRouter.of(context)
          .routerDelegate
          .currentConfiguration
          .routes
          .whereType<GoRoute>()
          .last
          .builder
          ?.call(context, state);

      if (child == null) {
        throw GoError('The route ${state.fullPath} does not have a builder.');
      }

      final transitionDuration = duration ?? GoTransition.defaultDuration;
      final reverseTransitionDuration = reverseDuration ??
          GoTransition.defaultReverseDuration ??
          transitionDuration;

      return GoTransitionPage(
        key: key ?? state.pageKey,
        name: name ?? state.name,
        arguments: arguments ?? state.extra,
        restorationId: restorationId,
        pageTransitionsBuilder: buildTransitions,
        canTransitionTo: canTransitionTo,
        canTransitionFrom: canTransitionFrom,
        transitionDuration: transitionDuration,
        reverseTransitionDuration: reverseTransitionDuration,
        opaque: opaque,
        maintainState: maintainState,
        fullscreenDialog: fullscreenDialog,
        barrierDismissible: barrierDismissible,
        allowSnapshotting: allowSnapshotting,
        barrierColor: barrierColor,
        barrierLabel: barrierLabel,
        child: child!,
      );
    };
  }

  /// Builds a [GoRouterPageBuilder] with [PopupRoute] default properties.
  ///
  /// - [duration] defaults to [GoTransition.defaultDuration].
  /// - [reverseDuration] defaults to [GoTransition.defaultReverseDuration].
  /// - [key] defaults to [GoRouterState.pageKey].
  /// - [name] defaults to [GoRouterState.name].
  /// - [arguments] defaults to [GoRouterState.extra].
  ///
  /// If [child] is null, it will use the current [GoRoute.builder] as child.
  ///
  GoRouterPageBuilder buildPopup({
    Duration? duration,
    Duration? reverseDuration,
    bool opaque = false,
    bool maintainState = true,
    bool fullscreenDialog = true,
    bool barrierDismissible = true,
    bool allowSnapshotting = false,
    Color? barrierColor = const Color(0x80000000),
    String? barrierLabel,
    LocalKey? key,
    String? name,
    Object? arguments,
    String? restorationId,
    CanTransition? canTransitionTo,
    CanTransition? canTransitionFrom,
    Widget? child,
  }) {
    return build(
      duration: duration,
      reverseDuration: reverseDuration,
      opaque: opaque,
      maintainState: maintainState,
      fullscreenDialog: fullscreenDialog,
      barrierDismissible: barrierDismissible,
      allowSnapshotting: allowSnapshotting,
      barrierColor: barrierColor,
      barrierLabel: barrierLabel,
      key: key,
      name: name,
      arguments: arguments,
      restorationId: restorationId,
      canTransitionTo: canTransitionTo,
      canTransitionFrom: canTransitionFrom,
      child: child,
    );
  }

  /// Returns a copy of this [GoTransition] with the given properties.
  GoTransition copyWith({
    PageRouteTransitionsBuilder? builder,
    Alignment? alignment,
    Offset? offset,
    Axis? axis,
    double? axisAlignment,
    Curve? curve,
    Curve? reverseCurve,
  }) {
    return GoTransition(
      builder: builder ?? this.builder,
      alignment: alignment ?? this.alignment,
      offset: offset ?? this.offset,
      axis: axis ?? this.axis,
      axisAlignment: axisAlignment ?? this.axisAlignment,
      curve: curve ?? this.curve,
      reverseCurve: reverseCurve ?? this.reverseCurve,
    );
  }
}

typedef PageRouteTransitionsBuilder = Widget Function(
    PageRoute, BuildContext, Animation<double>, Animation<double>, Widget);

typedef CanTransition = bool Function(TransitionRoute nextRoute);

class GoTransitionPage<T> extends CustomTransitionPage<T> {
  const GoTransitionPage({
    required super.child,
    required this.pageTransitionsBuilder,
    super.barrierColor,
    super.barrierLabel,
    super.barrierDismissible = false,
    super.fullscreenDialog = false,
    super.maintainState = true,
    super.opaque = true,
    super.transitionDuration = const Duration(milliseconds: 300),
    super.reverseTransitionDuration,
    super.arguments,
    super.key,
    super.name,
    super.restorationId,
    this.allowSnapshotting = true,
    this.canTransitionTo,
    this.canTransitionFrom,
  }) : super(transitionsBuilder: _noTransition);

  /// The [PageTransitionsBuilder.buildTransitions] builder.
  final PageRouteTransitionsBuilder pageTransitionsBuilder;

  /// Overrides the default [PageRoute.canTransitionTo] behavior.
  final CanTransition? canTransitionTo;

  /// Overrides the default [PageRoute.canTransitionFrom] behavior.
  final CanTransition? canTransitionFrom;

  /// The [PageRoute.allowSnapshotting] property.
  final bool allowSnapshotting;

  static Widget _noTransition<T>(_, __, ___, Widget child) => child;

  @override
  RouteTransitionsBuilder get transitionsBuilder =>
      (context, animation, secondaryAnimation, child) {
        final route = ModalRoute.of(context);
        if (route is! PageRoute) return child;

        return pageTransitionsBuilder(
          route,
          context,
          animation,
          secondaryAnimation,
          child,
        );
      };

  @override
  Route<T> createRoute(BuildContext context) => _GoTransitionRoute(this);
}

class _GoTransitionRoute<T> extends PageRoute<T> {
  _GoTransitionRoute(GoTransitionPage<T> page) : super(settings: page);

  GoTransitionPage<T> get _page => settings as GoTransitionPage<T>;

  @override
  bool get barrierDismissible => _page.barrierDismissible;

  @override
  Color? get barrierColor => _page.barrierColor;

  @override
  String? get barrierLabel => _page.barrierLabel;

  @override
  Duration get transitionDuration => _page.transitionDuration;

  @override
  Duration get reverseTransitionDuration => _page.reverseTransitionDuration;

  @override
  bool get maintainState => _page.maintainState;

  @override
  bool get fullscreenDialog => _page.fullscreenDialog;

  @override
  bool get opaque => _page.opaque;

  @override
  bool get allowSnapshotting => _page.allowSnapshotting;

  @override
  bool canTransitionTo(TransitionRoute<dynamic> nextRoute) {
    if (_page.canTransitionTo != null) return _page.canTransitionTo!(nextRoute);

    // Don't perform outgoing animation if the next route is a fullscreen dialog.
    return super.canTransitionTo(nextRoute) && !fullscreenDialog;
  }

  @override
  bool canTransitionFrom(TransitionRoute nextRoute) {
    return (_page.canTransitionFrom ?? super.canTransitionFrom)(nextRoute);
  }

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) =>
      Semantics(
        scopesRoute: true,
        explicitChildNodes: true,
        child: _page.child,
      );

  @override
  Widget buildTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) =>
      _page.pageTransitionsBuilder(
        this,
        context,
        animation,
        secondaryAnimation,
        child,
      );
}
