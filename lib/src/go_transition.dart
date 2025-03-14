import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:go_transitions/src/transitions.dart';
import 'package:go_transitions/src/with_extensions.dart';

@immutable
class GoTransitionStyle {
  const GoTransitionStyle({
    this.applyOnPrevious = false,
    this.curve,
    this.reverseCurve,
    this.alignment,
    this.offset,
    this.axis,
    this.axisAlignment,
  });

  /// Whether to apply the transition on the previous [Route].
  ///
  /// Requires [GoTransition.observer] to work.
  final bool applyOnPrevious;

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

  GoTransitionStyle copyWith({
    bool? applyOnPrevious,
    Curve? curve,
    Curve? reverseCurve,
    Alignment? alignment,
    Offset? offset,
    Axis? axis,
    double? axisAlignment,
  }) {
    return GoTransitionStyle(
      applyOnPrevious: applyOnPrevious ?? this.applyOnPrevious,
      curve: curve ?? this.curve,
      reverseCurve: reverseCurve ?? this.reverseCurve,
      alignment: alignment ?? this.alignment,
      offset: offset ?? this.offset,
      axis: axis ?? this.axis,
      axisAlignment: axisAlignment ?? this.axisAlignment,
    );
  }
}

@immutable
class GoTransitionSettings extends RouteSettings {
  const GoTransitionSettings({
    this.key,
    super.name,
    super.arguments,
    this.restorationId,
    this.duration,
    this.reverseDuration,
    this.allowSnapshotting = true,
    this.maintainState = true,
    this.fullscreenDialog = false,
    this.opaque = true,
    this.barrierDismissible = false,
    this.barrierColor,
    this.barrierLabel,
    this.canTransitionTo,
    this.canTransitionFrom,
  });

  const GoTransitionSettings.popup({
    this.key,
    super.name,
    super.arguments,
    this.restorationId,
    this.duration,
    this.reverseDuration,
    this.allowSnapshotting = false,
    this.maintainState = true,
    this.fullscreenDialog = true,
    this.opaque = false,
    this.barrierDismissible = true,
    this.barrierColor = const Color(0x80000000),
    this.barrierLabel,
    this.canTransitionTo,
    this.canTransitionFrom,
  });

  /// The [Page.key]
  final LocalKey? key;

  /// The [Page.restorationId]
  final String? restorationId;

  /// The [PageRoute.transitionDuration].
  /// Defaults to [GoTransition.defaultDuration].
  final Duration? duration;

  /// The [PageRoute.reverseTransitionDuration].
  /// Defaults to [GoTransition.defaultReverseDuration].
  final Duration? reverseDuration;

  /// The [PageRoute.allowSnapshotting].
  final bool allowSnapshotting;

  /// The [PageRoute.maintainState]
  final bool maintainState;

  /// The [PageRoute.fullscreenDialog]
  final bool fullscreenDialog;

  /// The [PageRoute.opaque]
  final bool opaque;

  /// The [PageRoute.barrierDismissible]
  final bool barrierDismissible;

  /// The [PageRoute.barrierColor]
  final Color? barrierColor;

  /// The [PageRoute.barrierLabel]
  final String? barrierLabel;

  /// The [PageRoute.canTransitionTo].
  final CanTransition? canTransitionTo;

  /// The [PageRoute.canTransitionFrom].
  final CanTransition? canTransitionFrom;

  GoTransitionSettings copyWith({
    LocalKey? key,
    String? name,
    Object? arguments,
    String? restorationId,
    Duration? duration,
    Duration? reverseDuration,
    bool? allowSnapshotting,
    bool? maintainState,
    bool? fullscreenDialog,
    bool? opaque,
    bool? barrierDismissible,
    Color? barrierColor,
    String? barrierLabel,
    CanTransition? canTransitionTo,
    CanTransition? canTransitionFrom,
  }) {
    return GoTransitionSettings(
      key: key ?? this.key,
      name: name ?? this.name,
      arguments: arguments ?? this.arguments,
      restorationId: restorationId ?? this.restorationId,
      duration: duration ?? this.duration,
      reverseDuration: reverseDuration ?? this.reverseDuration,
      allowSnapshotting: allowSnapshotting ?? this.allowSnapshotting,
      maintainState: maintainState ?? this.maintainState,
      fullscreenDialog: fullscreenDialog ?? this.fullscreenDialog,
      opaque: opaque ?? this.opaque,
      barrierDismissible: barrierDismissible ?? this.barrierDismissible,
      barrierColor: barrierColor ?? this.barrierColor,
      barrierLabel: barrierLabel ?? this.barrierLabel,
      canTransitionTo: canTransitionTo ?? this.canTransitionTo,
      canTransitionFrom: canTransitionFrom ?? this.canTransitionFrom,
    );
  }
}

class _NoChild extends Widget {
  const _NoChild();

  @override
  Element createElement() {
    throw GoError('No child or GoRouter.builder found.');
  }
}

extension GoTransitionAsBuilderExtension on PageRouteTransitionsBuilder {
  /// Maps this [PageRouteTransitionsBuilder] as [RouteTransitionsBuilder].
  RouteTransitionsBuilder get asTransitions => (context, a1, a2, child) {
        final route = ModalRoute.of(context) as PageRoute;
        return this(route, context, a1, a2, child);
      };

  /// Maps this [PageRouteTransitionsBuilder] as [DelegatedTransitionBuilder].
  DelegatedTransitionBuilder get asDelegated =>
      (context, a1, a2, allowSnapshotting, child) {
        final route = ModalRoute.of(context) as PageRoute;
        return this(route, context, a1, a2, SizedBox(child: child));
      };
}

/// The data to used in [Page] & [PageRoute] transition settings.
mixin TransitionData {
  /// The underlying [GoTransitionPage].
  GoTransitionPage get page;

  bool get allowSnapshotting => page.settings.allowSnapshotting;
  Duration get transitionDuration =>
      page.settings.duration ?? GoTransition.defaultDuration;
  Duration get reverseTransitionDuration =>
      page.settings.reverseDuration ??
      GoTransition.defaultReverseDuration ??
      transitionDuration;
  Color? get barrierColor => page.settings.barrierColor;
  bool get barrierDismissible => page.settings.barrierDismissible;
  String? get barrierLabel => page.settings.barrierLabel;
  bool get fullscreenDialog => page.settings.fullscreenDialog;
  bool get maintainState => page.settings.maintainState;
  bool get opaque => page.settings.opaque;
  Object? get arguments => page.settings.arguments;
  LocalKey? get key => page.settings.key;
  String? get name => page.settings.name;
  String? get restorationId => page.settings.restorationId;

  RouteTransitionsBuilder get transitionsBuilder => page.builder.asTransitions;
  DelegatedTransitionBuilder? get delegatedTransition =>
      page.delegatedBuilder?.asDelegated;
}

@immutable
class GoTransitionPage
    with TransitionData
    implements PageTransitionsBuilder, CustomTransitionPage {
  /// Creates a [GoTransitionPage].
  ///
  /// It's compatible with both [Page] and [PageTransitionsBuilder].
  const GoTransitionPage({
    PageRouteTransitionsBuilder? builder,
    this.style = const GoTransitionStyle(),
    this.settings = const GoTransitionSettings(),
    this.canPop = true,
    this.onPopInvoked = _defaultPopInvokedHandler,
    this.delegatedBuilder,
    required this.child,
  }) : builder = builder ?? _noPageTransition;

  static void _defaultPopInvokedHandler(bool didPop, Object? result) {}

  /// The [buildTransitions] style.
  final GoTransitionStyle style;

  /// The [createRoute] settings.
  final GoTransitionSettings settings;

  /// The [buildTransitions] builder.
  final PageRouteTransitionsBuilder builder;

  /// The [delegatedTransition] builder.
  final PageRouteTransitionsBuilder? delegatedBuilder;

  @override
  final bool canPop;

  @override
  final PopInvokedWithResultCallback onPopInvoked;

  @override
  final Widget child;

  @override
  GoTransitionPage get page => this;

  static Widget _noPageTransition(_, __, ___, ____, Widget child) => child;

  @override
  bool canUpdate(Page<dynamic> other) {
    return other.runtimeType == runtimeType && other.key == key;
  }

  @override
  Route createRoute(BuildContext context) {
    return _GoTransitionRoute(this);
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
    // if (!animation.isAnimating && !secondaryAnimation.isAnimating) return child;
    return GoTransitionScope(
      style: style.applyOnPrevious ? style.inverted : style,
      child: Builder(
        builder: (context) {
          return builder(
            route,
            context,
            CurvedAnimation(
              parent: style.applyOnPrevious ? animation.reversed : animation,
              curve: style.curve ?? GoTransition.defaultCurve,
              reverseCurve:
                  style.reverseCurve ?? GoTransition.defaultReverseCurve,
            ),
            CurvedAnimation(
              parent: secondaryAnimation,
              curve: style.curve ?? GoTransition.defaultCurve,
              reverseCurve:
                  style.reverseCurve ?? GoTransition.defaultReverseCurve,
            ),
            child,
          );
        },
      ),
    );
  }
}

extension on GoTransitionStyle {
  GoTransitionStyle get inverted {
    return copyWith(
      offset: offset != null ? -offset! : null,
      alignment: alignment != null ? -alignment! : null,
      axisAlignment: axisAlignment != null ? -axisAlignment! : null,
    );
  }
}

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
  /// This is the same as `context.previousChild` sintax-sugar.
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
    super.delegatedBuilder,
    super.style,
    super.settings,
    super.canPop,
    super.onPopInvoked,
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
    PageRouteTransitionsBuilder? delegatedBuilder,
    GoTransitionStyle? style,
    GoTransitionSettings? settings,
    bool? canPop,
    PopInvokedWithResultCallback? onPopInvoked,
    Widget? child,
  }) {
    return GoTransition(
      builder: builder ?? this.builder,
      delegatedBuilder: delegatedBuilder ?? this.delegatedBuilder,
      style: style ?? this.style,
      settings: settings ?? this.settings,
      canPop: canPop ?? this.canPop,
      onPopInvoked: onPopInvoked ?? this.onPopInvoked,
      child: child ?? this.child,
    );
  }
}

class GoTransitionScope extends InheritedWidget {
  const GoTransitionScope({
    super.key,
    required this.style,
    required super.child,
  });

  final GoTransitionStyle style;

  @override
  bool updateShouldNotify(GoTransitionScope oldWidget) => false;
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

// extension on Animation {
// bool get isAnimating =>
//     status == AnimationStatus.forward || status == AnimationStatus.reverse;
// }

extension GoTransitionExtension on GoTransition {
  /// Builds a [GoRouterPageBuilder] of this [GoTransition].
  ///
  /// If [child] is null, it will use the current [GoRoute.builder] as child.
  ///
  GoRouterPageBuilder build({
    GoTransitionSettings? settings,
    Widget? child,
  }) {
    return copyWith(
      settings: settings,
      child: child,
    );
  }

  /// Builds a [GoRouterPageBuilder] with [PopupRoute] default properties.
  ///
  /// If [child] is null, it will use the current [GoRoute.builder] as child.
  ///
  GoRouterPageBuilder buildPopup({
    GoTransitionSettings settings = const GoTransitionSettings.popup(),
    Widget? child,
  }) {
    return build(
      settings: settings,
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

mixin GoPageRoute<T> on PageRoute<T> implements TransitionData {
  @override
  GoTransitionPage get page => settings as GoTransitionPage;

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) =>
      Semantics(
        scopesRoute: true,
        explicitChildNodes: true,
        child: page.child,
      );

  @override
  Widget buildTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return page.buildTransitions(
      this,
      context,
      animation,
      secondaryAnimation,
      child,
    );
  }
}

class _GoTransitionRoute extends PageRoute with GoPageRoute, TransitionData {
  _GoTransitionRoute(GoTransitionPage page) : super(settings: page);

  // @override
  // DelegatedTransitionBuilder? get delegatedTransition {
  //   print("delegatedTransition $delegatedTransition");
  //   return page.delegatedBuilder?.asDelegated;
  // }

  @override
  bool canTransitionTo(TransitionRoute<dynamic> nextRoute) {
    if (page.settings.canTransitionTo != null) {
      return page.settings.canTransitionTo!(nextRoute);
    }

    // Don't perform outgoing animation if the next route is a fullscreen dialog.
    return super.canTransitionTo(nextRoute) && !fullscreenDialog;
  }

  @override
  bool canTransitionFrom(TransitionRoute nextRoute) {
    return (page.settings.canTransitionFrom ??
        super.canTransitionFrom)(nextRoute);
  }
}
