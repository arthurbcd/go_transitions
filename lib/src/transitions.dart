import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'go_transition.dart';
import 'go_transition_settings.dart';
import 'go_transition_style.dart';
import 'go_transitions.dart';
import 'modifiers.dart';
import 'transition_mixin.dart';

class ThemeGoTransition extends GoTransition {
  const ThemeGoTransition();

  @override
  PageRouteTransitionsBuilder get builder {
    return (route, context, animation, secondaryAnimation, child) {
      final pageTransitionsTheme = Theme.of(context).pageTransitionsTheme;

      assert(
        !pageTransitionsTheme.builders.containsValue(GoTransitions.theme),
        '\n\nYou should not set GoTransitions.theme in pageTransitionsTheme, '
        'as it will cause an infinite loop.',
      );

      return pageTransitionsTheme.buildTransitions(
        route,
        context,
        animation,
        secondaryAnimation,
        child,
      );
    };
  }

  @override
  Route createRoute(BuildContext context) {
    final platform = Theme.of(context).platform;
    final pageTransitionsTheme = Theme.of(context).pageTransitionsTheme;
    final builder = pageTransitionsTheme.builders[platform];

    if (builder is GoTransition) {
      return builder.createRoute(context);
    }

    return super.createRoute(context);
  }
}

extension on GoTransition {
  GoTransition get none => const GoTransition();
}

class FadeGoTransition extends GoTransition {
  const FadeGoTransition();
  @override
  PageRouteTransitionsBuilder get builder => none.withFade.builder;
}

class RotateGoTransition extends GoTransition {
  const RotateGoTransition();
  @override
  PageRouteTransitionsBuilder get builder => none.withRotation.builder;
}

class ScaleGoTransition extends GoTransition {
  const ScaleGoTransition();
  @override
  PageRouteTransitionsBuilder get builder => none.withScale.builder;
}

class SizeGoTransition extends GoTransition {
  const SizeGoTransition();
  @override
  PageRouteTransitionsBuilder get builder => none.withSize.builder;
}

class SlideGoTransition extends GoTransition {
  const SlideGoTransition();
  @override
  PageRouteTransitionsBuilder get builder => none.withSlide.builder;
}

class FadeUpwardsGoTransition extends GoTransition {
  const FadeUpwardsGoTransition();
  @override
  PageRouteTransitionsBuilder get builder =>
      const FadeUpwardsPageTransitionsBuilder().buildTransitions;
}

class OpenUpwardsGoTransition extends GoTransition {
  const OpenUpwardsGoTransition();
  @override
  PageRouteTransitionsBuilder get builder =>
      const OpenUpwardsPageTransitionsBuilder().buildTransitions;
}

class ZoomGoTransition extends GoTransition {
  const ZoomGoTransition();
  @override
  PageRouteTransitionsBuilder get builder =>
      const ZoomPageTransitionsBuilder().buildTransitions;
}

@immutable
class GoCupertinoPage extends GoTransition implements CupertinoPage {
  const GoCupertinoPage({
    this.title,
    super.builder = CupertinoRouteTransitionMixin.buildPageTransitions<dynamic>,
    super.style,
    super.settings,
    super.child,
  });

  @override
  final String? title;

  @override
  GoCupertinoPage copyWith({
    String? title,
    PageRouteTransitionsBuilder? builder,
    GoTransitionStyle? style,
    GoTransitionSettings? settings,
    Widget? child,
  }) {
    return GoCupertinoPage(
      title: title ?? this.title,
      builder: builder ?? this.builder,
      style: style ?? this.style,
      settings: settings ?? this.settings,
      child: child ?? this.child,
    );
  }

  @override
  Route createRoute(BuildContext context) {
    return GoCupertinoPageRoute(this);
  }
}

class GoCupertinoPageRoute extends CupertinoPageRoute
    with GoPageRoute, TransitionMixin {
  GoCupertinoPageRoute(GoCupertinoPage page)
      : super(settings: page, builder: (_) => page.child);
}

class GoMaterialPage extends GoTransition implements MaterialPage {
  const GoMaterialPage({
    super.builder = _builder,
    super.style,
    super.settings,
    super.child,
  });

  /// [MaterialPageRoute.buildTransitions] builder.
  static Widget _builder(
    PageRoute route,
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return Theme.of(context)
        .pageTransitionsTheme
        .buildTransitions(route, context, animation, secondaryAnimation, child);
  }

  @override
  GoMaterialPage copyWith({
    PageRouteTransitionsBuilder? builder,
    GoTransitionStyle? style,
    GoTransitionSettings? settings,
    Widget? child,
  }) {
    return GoMaterialPage(
      builder: builder ?? this.builder,
      style: style ?? this.style,
      settings: settings ?? this.settings,
      child: child ?? this.child,
    );
  }

  @override
  Route createRoute(BuildContext context) {
    return GoMaterialPageRoute(this);
  }
}

class GoMaterialPageRoute extends MaterialPageRoute
    with GoPageRoute, TransitionMixin {
  GoMaterialPageRoute(GoMaterialPage page)
      : super(settings: page, builder: (_) => page.child);
}
