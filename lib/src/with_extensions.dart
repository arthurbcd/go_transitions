import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_transitions/go_transitions.dart';

import 'go_transition.dart';

extension GoReverseAnimationExtension on Animation<double> {
  Animation<double> get reversed => drive(Tween<double>(begin: 1, end: 0));
}

extension PreviousChildContextExtension on BuildContext {
  /// Returns the child of the previous route.
  Widget? get previousChild => GoTransition.previousChildOf(this);
}

extension GoTransitionModifiers on GoTransition {
  /// Returns a new [GoTransition] with the given [style] properties.
  GoTransition withStyle({
    Curve? curve,
    Curve? reverseCurve,
    Alignment? alignment,
    Offset? offset,
    Axis? axis,
    double? axisAlignment,
  }) {
    return copyWith(
      style: style.copyWith(
        curve: curve,
        reverseCurve: reverseCurve,
        alignment: alignment,
        offset: offset,
        axis: axis,
        axisAlignment: axisAlignment,
      ),
    );
  }

  /// Returns a new [GoTransition] with the given [settings] properties.
  GoTransition withSettings({
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
    return copyWith(
      settings: settings.copyWith(
        key: key,
        name: name,
        arguments: arguments,
        restorationId: restorationId,
        duration: duration,
        reverseDuration: reverseDuration,
        allowSnapshotting: allowSnapshotting,
        maintainState: maintainState,
        fullscreenDialog: fullscreenDialog,
        opaque: opaque,
        barrierDismissible: barrierDismissible,
        barrierColor: barrierColor,
        barrierLabel: barrierLabel,
        canTransitionTo: canTransitionTo,
        canTransitionFrom: canTransitionFrom,
      ),
    );
  }

  /// Returns a new [GoTransition] with transition applied on the previous page.
  ///
  /// You must set [GoTransition.observer] to use this feature.
  GoTransition get onPrevious {
    return copyWith(
      style: style.copyWith(
        applyOnPrevious: true,
      ),
      builder: (route, context, animation, secondaryAnimation, child) {
        final previousChild = GoTransition.previousChildOf(context);
        if (previousChild == null) return child;

        return Stack(
          alignment: Alignment.center,
          children: [
            child,
            builder(
              route,
              context,
              animation,
              secondaryAnimation,
              previousChild,
            ),
          ],
        );
      },
    );
  }

  /// Returns a new [GoTransition] with a [FadeTransition].
  GoTransition get withFade {
    return copyWith(
      builder: (route, context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: animation,
          child: builder(route, context, animation, secondaryAnimation, child),
        );
      },
    );
  }

  /// Returns a new [GoTransition] with a [ScaleTransition].
  GoTransition get withScale {
    return copyWith(
      builder: (route, context, animation, secondaryAnimation, child) {
        final alignment =
            style.alignment ?? GoTransition.styleOf(context)?.alignment;

        return ScaleTransition(
          alignment: alignment ?? Alignment.center,
          scale: animation,
          child: builder(route, context, animation, secondaryAnimation, child),
        );
      },
    );
  }

  /// Returns a new [GoTransition] with a [SizeTransition].
  GoTransition get withSize {
    return copyWith(
      builder: (route, context, animation, secondaryAnimation, child) {
        final go = GoTransition.styleOf(context);

        return Align(
          alignment: style.alignment ?? go?.alignment ?? Alignment.center,
          child: SizeTransition(
            sizeFactor: animation,
            axis: style.axis ?? go?.axis ?? Axis.vertical,
            axisAlignment: style.axisAlignment ?? go?.axisAlignment ?? 0.0,
            child:
                builder(route, context, animation, secondaryAnimation, child),
          ),
        );
      },
    );
  }

  /// Returns a new [GoTransition] with a [SlideTransition].
  GoTransition get withSlide {
    return copyWith(
      builder: (route, context, animation, secondaryAnimation, child) {
        final go = GoTransition.styleOf(context);

        return SlideTransition(
          position: Tween<Offset>(
            begin: style.offset ?? go?.offset ?? Offset.zero,
            end: Offset.zero,
          ).animate(animation),
          child: builder(route, context, animation, secondaryAnimation, child),
        );
      },
    );
  }

  /// Returns a new [GoTransition] with a [RotationTransition].
  GoTransition get withRotation {
    return copyWith(
      builder: (route, context, animation, secondaryAnimation, child) {
        final go = GoTransition.styleOf(context);

        return RotationTransition(
          turns: animation,
          alignment: style.alignment ?? go?.alignment ?? Alignment.center,
          child: builder(route, context, animation, secondaryAnimation, child),
        );
      },
    );
  }

  /// Returns a [GoTransition] that animates from left to right.
  GoTransition get toLeft {
    return withStyle(
      axis: style.axis ?? Axis.horizontal,
      axisAlignment: style.axisAlignment ?? 1.0,
      offset: style.offset ?? const Offset(1, 0),
      alignment: style.alignment ?? Alignment.centerRight,
    );
  }

  /// Returns a [GoTransition] that animates from right to left.
  GoTransition get toRight {
    return withStyle(
      axis: style.axis ?? Axis.horizontal,
      axisAlignment: style.axisAlignment ?? -1.0,
      offset: style.offset ?? const Offset(-1, 0),
      alignment: style.alignment ?? Alignment.centerLeft,
    );
  }

  /// Returns a [GoTransition] that animates from bottom to top.
  GoTransition get toTop {
    return withStyle(
      axis: style.axis ?? Axis.vertical,
      axisAlignment: style.axisAlignment ?? 1.0,
      offset: style.offset ?? const Offset(0, 1),
      alignment: style.alignment ?? Alignment.bottomCenter,
    );
  }

  /// Returns a [GoTransition] that animates from top to bottom.
  GoTransition get toBottom {
    return withStyle(
      axis: style.axis ?? Axis.vertical,
      axisAlignment: style.axisAlignment ?? -1.0,
      offset: style.offset ?? const Offset(0, -1),
      alignment: style.alignment ?? Alignment.topCenter,
    );
  }
}
