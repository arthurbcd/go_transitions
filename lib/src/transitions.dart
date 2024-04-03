import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'go_transition.dart';
import 'with_extensions.dart';

class InvisibleGoTransition extends GoTransition {
  const InvisibleGoTransition();
  @override
  PageRouteTransitionsBuilder get builder => (_, __, animation, ___, child) =>
      Visibility(visible: animation.value == 1.0, child: child);
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

class CupertinoGoTransition extends GoTransition {
  const CupertinoGoTransition();
  @override
  PageRouteTransitionsBuilder get builder =>
      CupertinoRouteTransitionMixin.buildPageTransitions;
}

class MaterialGoTransition extends GoTransition {
  const MaterialGoTransition();
  @override
  PageRouteTransitionsBuilder get builder =>
      (route, context, animation, secondaryAnimation, child) =>
          _MaterialRoute(route: route, child: child)
              .buildTransitions(context, animation, secondaryAnimation, child);
}

class _MaterialRoute extends PageRoute with MaterialRouteTransitionMixin {
  _MaterialRoute({
    required this.route,
    required this.child,
  }) : super(
          fullscreenDialog: route.fullscreenDialog,
          allowSnapshotting: route.allowSnapshotting,
          barrierDismissible: route.barrierDismissible,
        );

  final PageRoute route;
  final Widget child;

  @override
  NavigatorState? get navigator => route.navigator;

  @override
  bool get maintainState => route.maintainState;

  @override
  Widget buildContent(BuildContext context) {
    return child;
  }
}

enum GoTransitions implements GoTransition {
  none(GoTransition()),
  theme(ThemeGoTransition()),
  invisible(InvisibleGoTransition()),
  fade(FadeGoTransition()),
  rotate(RotateGoTransition()),
  scale(ScaleGoTransition()),
  size(SizeGoTransition()),
  slide(SlideGoTransition()),
  fadeUpwards(FadeUpwardsGoTransition()),
  openUpwards(OpenUpwardsGoTransition()),
  zoom(ZoomGoTransition()),
  cupertino(CupertinoGoTransition()),
  material(MaterialGoTransition());

  const GoTransitions(this.goTransition);
  final GoTransition goTransition;

  /// Sintax-sugar for building [GoTransitions.theme] with [fullscreenDialog].
  static GoRouterPageBuilder get fullscreenDialog {
    return GoTransitions.theme.build(fullscreenDialog: true);
  }

  /// Sintax-sugar for building [RawDialogRoute] like transitions.
  static GoRouterPageBuilder get dialog {
    return GoTransitions.fade.buildPopup();
  }

  /// Sintax-sugar for building [ModalBottomSheetRoute] like transitions.
  static GoRouterPageBuilder get bottomSheet {
    return GoTransitions.slide.toTop.buildPopup();
  }

  @override
  PageRouteTransitionsBuilder get builder => goTransition.builder;

  @override
  Alignment? get alignment => goTransition.alignment;

  @override
  Axis? get axis => goTransition.axis;

  @override
  double? get axisAlignment => goTransition.axisAlignment;

  @override
  Curve? get curve => goTransition.curve;

  @override
  Offset? get offset => goTransition.offset;

  @override
  Curve? get reverseCurve => goTransition.reverseCurve;

  @override
  Page call(BuildContext context, GoRouterState state) {
    return goTransition.call(context, state);
  }

  @override
  Widget buildTransitions<T>(
    route,
    context,
    animation,
    secondaryAnimation,
    child,
  ) {
    return goTransition.buildTransitions(
      route,
      context,
      animation,
      secondaryAnimation,
      child,
    );
  }
}
