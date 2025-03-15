import 'package:flutter/widgets.dart';

import 'go_transition_page.dart';
import 'transition_mixin.dart';

class GoTransitionRoute extends PageRoute with GoPageRoute, TransitionMixin {
  /// Creates a [GoTransitionRoute] with the given [transition] and [builder].
  /// - The [transition] is used to create the transition animation.
  /// - The [builder] is used to build the page content.
  ///
  /// Example:
  /// ```dart
  /// Navigator.of(context).push(
  ///   GoTransitionRoute(
  ///     transition: GoTransitions.slide.toRight,
  ///     builder: (context) => const MyPage(),
  ///   )
  /// );
  /// ```
  GoTransitionRoute({
    required GoTransitionPage transition,
    required this.builder,
  }) : super(settings: transition);

  @override
  final WidgetBuilder builder;

  @override
  bool canTransitionTo(TransitionRoute nextRoute) {
    if (page.settings.canTransitionTo != null) {
      return page.settings.canTransitionTo!(nextRoute);
    }

    // Don't perform outgoing animation if the next route is a fullscreen dialog.
    return super.canTransitionTo(nextRoute) && !fullscreenDialog;
  }

  @override
  bool canTransitionFrom(TransitionRoute previousRoute) {
    return (page.settings.canTransitionFrom ??
        super.canTransitionFrom)(previousRoute);
  }
}
