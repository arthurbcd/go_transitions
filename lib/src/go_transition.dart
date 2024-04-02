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

  /// The signature for [buildTransitions] builder.
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
  }) {
    return (context, state) {
      final last =
          GoRouter.of(context).routerDelegate.currentConfiguration.last;
      // ignore: unnecessary_cast
      final child = (last.route as GoRoute).builder?.call(context, state);

      if (child == null) {
        throw GoError('The route ${state.fullPath} does not have a builder.');
      }

      final transitionDuration = duration ?? GoTransition.defaultDuration;
      final reverseTransitionDuration = reverseDuration ??
          GoTransition.defaultReverseDuration ??
          transitionDuration;

      return _PageBuilder(
        key: key ?? state.pageKey,
        name: name ?? state.name,
        arguments: arguments ?? state.extra,
        restorationId: restorationId,
        routeBuilder: (context, settings) {
          return _PageRouteBuilder(
            settings: settings,
            pageTransitionsBuilder: buildTransitions,
            onCanTransitionTo: canTransitionTo,
            onCanTransitionFrom: canTransitionFrom,
            transitionDuration: transitionDuration,
            reverseTransitionDuration: reverseTransitionDuration,
            opaque: opaque,
            maintainState: maintainState,
            fullscreenDialog: fullscreenDialog,
            barrierDismissible: barrierDismissible,
            allowSnapshotting: allowSnapshotting,
            barrierColor: barrierColor,
            barrierLabel: barrierLabel,
            pageBuilder: (_, __, ___) => Semantics(
              scopesRoute: true,
              explicitChildNodes: true,
              child: child,
            ),
          );
        },
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

class _PageBuilder<T> extends Page<T> {
  const _PageBuilder({
    super.key,
    super.name,
    super.arguments,
    super.restorationId,
    required this.routeBuilder,
  });

  final Route<T> Function(BuildContext context, RouteSettings settings)
      routeBuilder;

  @override
  Route<T> createRoute(BuildContext context) => routeBuilder(context, this);
}

typedef PageRouteTransitionsBuilder = Widget Function(
    PageRoute, BuildContext, Animation<double>, Animation<double>, Widget);

typedef CanTransition = bool Function(TransitionRoute nextRoute);

class _PageRouteBuilder<T> extends PageRouteBuilder<T> {
  _PageRouteBuilder({
    required this.pageTransitionsBuilder,
    required super.pageBuilder,
    super.barrierColor,
    super.barrierLabel,
    super.barrierDismissible = false,
    super.fullscreenDialog = false,
    super.maintainState = true,
    super.opaque = true,
    super.transitionDuration = const Duration(milliseconds: 300),
    super.reverseTransitionDuration,
    super.allowSnapshotting = true,
    super.settings,
    this.onCanTransitionTo,
    this.onCanTransitionFrom,
  });

  final PageRouteTransitionsBuilder pageTransitionsBuilder;
  final CanTransition? onCanTransitionTo;
  final CanTransition? onCanTransitionFrom;

  @override
  RouteTransitionsBuilder get transitionsBuilder =>
      (context, animation, secondaryAnimation, child) {
        return pageTransitionsBuilder(
          this,
          context,
          animation,
          secondaryAnimation,
          child,
        );
      };

  @override
  bool canTransitionTo(TransitionRoute<dynamic> nextRoute) {
    if (onCanTransitionTo != null) return onCanTransitionTo!(nextRoute);

    // Don't perform outgoing animation if the next route is a fullscreen dialog.
    return super.canTransitionTo(nextRoute) && !fullscreenDialog;
  }

  @override
  bool canTransitionFrom(TransitionRoute nextRoute) {
    return (onCanTransitionFrom ?? super.canTransitionFrom)(nextRoute);
  }
}
