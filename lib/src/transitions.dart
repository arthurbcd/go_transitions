// ignore_for_file: type=lint
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'go_transition.dart';
import 'with_extensions.dart';

Widget _invisible(
  PageRoute route,
  BuildContext context,
  Animation<double> a1,
  Animation<double> a2,
  Widget child,
) {
  return Visibility(visible: a1.value == 1.0, child: child);
}

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
    super.delegatedBuilder = _delegatedBuilder,
    super.style,
    super.settings,
    super.canPop,
    super.onPopInvoked,
    super.child,
  });

  static Widget _delegatedBuilder(
    PageRoute route,
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return CupertinoPageTransition.delegatedTransition(
          context,
          animation,
          secondaryAnimation,
          route.allowSnapshotting,
          child,
        ) ??
        child;
  }

  @override
  final String? title;

  @override
  GoCupertinoPage copyWith({
    String? title,
    PageRouteTransitionsBuilder? builder,
    PageRouteTransitionsBuilder? delegatedBuilder,
    GoTransitionStyle? style,
    GoTransitionSettings? settings,
    bool? canPop,
    PopInvokedWithResultCallback? onPopInvoked,
    Widget? child,
  }) {
    return GoCupertinoPage(
      title: title ?? this.title,
      builder: builder ?? this.builder,
      delegatedBuilder: delegatedBuilder ?? this.delegatedBuilder,
      style: style ?? this.style,
      settings: settings ?? this.settings,
      canPop: canPop ?? this.canPop,
      onPopInvoked: onPopInvoked ?? this.onPopInvoked,
      child: child ?? this.child,
    );
  }

  @override
  Route createRoute(BuildContext context) {
    return GoCupertinoPageRoute(this);
  }
}

class GoCupertinoPageRoute extends CupertinoPageRoute
    with GoPageRoute, TransitionData {
  GoCupertinoPageRoute(GoCupertinoPage page)
      : super(settings: page, builder: (_) => page.child);
}

class GoMaterialPage extends GoTransition implements MaterialPage {
  const GoMaterialPage({
    super.builder = _builder,
    super.delegatedBuilder = _delegatedBuilder,
    super.style,
    super.settings,
    super.canPop,
    super.onPopInvoked,
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

  /// [MaterialPageRoute.delegatedTransition] builder.
  static Widget _delegatedBuilder(
    PageRoute route,
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    final theme = Theme.of(context).pageTransitionsTheme;
    final platform = Theme.of(context).platform;
    final themeDelegatedTransition = theme.delegatedTransition(platform);
    return themeDelegatedTransition?.call(context, animation,
            secondaryAnimation, route.allowSnapshotting, child) ??
        child;
  }

  @override
  GoMaterialPage copyWith({
    PageRouteTransitionsBuilder? builder,
    PageRouteTransitionsBuilder? delegatedBuilder,
    GoTransitionStyle? style,
    GoTransitionSettings? settings,
    bool? canPop,
    PopInvokedWithResultCallback? onPopInvoked,
    Widget? child,
  }) {
    return GoMaterialPage(
      builder: builder ?? this.builder,
      delegatedBuilder: delegatedBuilder ?? this.delegatedBuilder,
      style: style ?? this.style,
      settings: settings ?? this.settings,
      canPop: canPop ?? this.canPop,
      onPopInvoked: onPopInvoked ?? this.onPopInvoked,
      child: child ?? this.child,
    );
  }

  @override
  Route createRoute(BuildContext context) {
    return GoMaterialPageRoute(this);
  }
}

class GoMaterialPageRoute extends MaterialPageRoute
    with GoPageRoute, TransitionData {
  GoMaterialPageRoute(GoMaterialPage page)
      : super(settings: page, builder: (_) => page.child);
}

mixin GoTransitions {
  static const none = GoTransition();
  static const theme = ThemeGoTransition();
  static const invisible = GoTransition(builder: _invisible);
  static const fade = FadeGoTransition();
  static const rotate = RotateGoTransition();
  static const scale = ScaleGoTransition();
  static const size = SizeGoTransition();
  static const slide = SlideGoTransition();
  static const fadeUpwards = FadeUpwardsGoTransition();
  static const openUpwards = OpenUpwardsGoTransition();
  static const zoom = ZoomGoTransition();
  static const cupertino = GoCupertinoPage();
  static const material = GoMaterialPage();

  /// Sintax-sugar for building [theme] with [fullscreenDialog] set to `true`.
  static final fullscreenDialog = GoTransitions.theme.build(
    settings: GoTransitionSettings(fullscreenDialog: true),
  );

  /// Sintax-sugar for building [RawDialogRoute] like transitions.
  static final dialog = GoTransitions.fade.buildPopup();

  /// Sintax-sugar for building [ModalBottomSheetRoute] like transitions.
  static final bottomSheet = GoTransitions.slide.toTop.buildPopup();
}

extension GoRouterStateBuildExtension on GoRouterState {
  static final _builders = <ValueKey, GoRouterWidgetBuilder?>{};

  Widget build(BuildContext context) {
    _builders[pageKey] ??= GoRouter.of(context)
        .routerDelegate
        .currentConfiguration
        .routes
        .whereType<GoRoute>()
        .last
        .builder;

    final child = _builders[pageKey]?.call(context, this);

    if (child == null) {
      throw GoError('The route $fullPath does not have a builder.');
    }

    return child;
  }
}
