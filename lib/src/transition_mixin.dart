import 'package:flutter/cupertino.dart';

import 'go_transition.dart';
import 'go_transition_page.dart';

/// The data to use in [Page] & [PageRoute] transition settings.
mixin TransitionMixin {
  /// The underlying [GoTransitionPage].
  GoTransitionPage get page;

  bool get allowSnapshotting => page.settings.allowSnapshotting;
  Duration get transitionDuration =>
      page.settings.duration ?? GoTransition.defaultDuration;
  Duration get reverseTransitionDuration =>
      page.settings.reverseDuration ??
      GoTransition.defaultReverseDuration ??
      transitionDuration;
  RouteTransitionsBuilder get transitionsBuilder =>
      page.builder.transitionsBuilder;
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
  bool get canPop => page.settings.canPop;
}

extension on PageRouteTransitionsBuilder {
  RouteTransitionsBuilder get transitionsBuilder => (context, a1, a2, child) {
        final route = ModalRoute.of(context) as PageRoute;
        return this(route, context, a1, a2, child);
      };
}

mixin GoPageRoute<T> on PageRoute<T> implements TransitionMixin {
  @override
  GoTransitionPage get page => settings as GoTransitionPage;

  WidgetBuilder get builder;

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) =>
      Semantics(
        scopesRoute: true,
        explicitChildNodes: true,
        child: Builder(builder: builder),
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
