import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'go_transition.dart';
import 'go_transition_route.dart';
import 'go_transition_settings.dart';
import 'go_transition_style.dart';
import 'modifiers.dart';
import 'transition_mixin.dart';

@immutable
class GoTransitionPage extends PageTransitionsBuilder
    with TransitionMixin
    implements CustomTransitionPage {
  /// Creates a [GoTransitionPage].
  ///
  /// It's compatible with both [Page] and [PageTransitionsBuilder].
  const GoTransitionPage({
    PageRouteTransitionsBuilder? builder,
    this.style = const GoTransitionStyle(),
    this.settings = const GoTransitionSettings(),
    required this.child,
  }) : builder = builder ?? _noPageTransition;

  /// The [buildTransitions] style.
  final GoTransitionStyle style;

  /// The [createRoute] settings.
  final GoTransitionSettings settings;

  /// The [buildTransitions] builder.
  final PageRouteTransitionsBuilder builder;

  @override
  final Widget child;

  @override
  GoTransitionPage get page => this;

  @override
  PopInvokedWithResultCallback get onPopInvoked => settings.onPopInvoked;

  static Widget _noPageTransition(_, __, ___, ____, Widget child) => child;

  @override
  bool canUpdate(Page<dynamic> other) {
    return other.runtimeType == runtimeType && other.key == key;
  }

  @override
  @protected
  Route createRoute(BuildContext context) {
    return GoTransitionRoute(transition: this, builder: (_) => child);
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

extension on GoTransitionStyle {
  GoTransitionStyle get inverted {
    return copyWith(
      offset: offset != null ? -offset! : null,
      alignment: alignment != null ? -alignment! : null,
      axisAlignment: axisAlignment != null ? -axisAlignment! : null,
    );
  }
}
