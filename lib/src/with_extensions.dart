import 'package:flutter/material.dart';

import 'go_transition.dart';

extension GoTransitionsWithExtension on GoTransition {
  /// Returns a new [GoTransition] with a [FadeTransition].
  GoTransition get withFade {
    return copyWith(
      builder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: animation,
          child: builder(context, animation, secondaryAnimation, child),
        );
      },
    );
  }

  /// Returns a new [GoTransition] with a [ScaleTransition].
  GoTransition get withScale {
    return copyWith(
      builder: (context, animation, secondaryAnimation, child) {
        final alignment = this.alignment ?? GoTransition.of(context)?.alignment;

        return ScaleTransition(
          alignment: alignment ?? Alignment.center,
          scale: animation,
          child: builder(context, animation, secondaryAnimation, child),
        );
      },
    );
  }

  /// Returns a new [GoTransition] with a [SizeTransition].
  GoTransition get withSize {
    return copyWith(
      builder: (context, animation, secondaryAnimation, child) {
        final go = GoTransition.of(context);

        return Align(
          alignment: alignment ?? go?.alignment ?? Alignment.center,
          child: SizeTransition(
            sizeFactor: animation,
            axis: axis ?? go?.axis ?? Axis.vertical,
            axisAlignment: axisAlignment ?? go?.axisAlignment ?? 0.0,
            child: builder(context, animation, secondaryAnimation, child),
          ),
        );
      },
    );
  }

  /// Returns a new [GoTransition] with a [SlideTransition].
  GoTransition get withSlide {
    return copyWith(
      builder: (context, animation, secondaryAnimation, child) {
        final go = GoTransition.of(context);

        return SlideTransition(
          position: Tween<Offset>(
            begin: offset ?? go?.offset ?? Offset.zero,
            end: Offset.zero,
          ).animate(animation),
          child: builder(context, animation, secondaryAnimation, child),
        );
      },
    );
  }

  /// Returns a new [GoTransition] with a [RotationTransition].
  GoTransition get withRotation {
    return copyWith(
      builder: (context, animation, secondaryAnimation, child) {
        final go = GoTransition.of(context);

        return RotationTransition(
          turns: animation,
          alignment: alignment ?? go?.alignment ?? Alignment.center,
          child: builder(context, animation, secondaryAnimation, child),
        );
      },
    );
  }

  /// Returns a [GoTransition] that animates from left to right.
  GoTransition get toLeft {
    return copyWith(
      axis: axis ?? Axis.horizontal,
      axisAlignment: axisAlignment ?? 1.0,
      offset: offset ?? const Offset(1, 0),
      alignment: alignment ?? Alignment.centerRight,
    );
  }

  /// Returns a [GoTransition] that animates from right to left.
  GoTransition get toRight {
    return copyWith(
      axis: axis ?? Axis.horizontal,
      axisAlignment: axisAlignment ?? -1.0,
      offset: offset ?? const Offset(-1, 0),
      alignment: alignment ?? Alignment.centerLeft,
    );
  }

  /// Returns a [GoTransition] that animates from bottom to top.
  GoTransition get toTop {
    return copyWith(
      axis: axis ?? Axis.vertical,
      axisAlignment: axisAlignment ?? 1.0,
      offset: offset ?? const Offset(0, 1),
      alignment: alignment ?? Alignment.bottomCenter,
    );
  }

  /// Returns a [GoTransition] that animates from top to bottom.
  GoTransition get toBottom {
    return copyWith(
      axis: axis ?? Axis.vertical,
      axisAlignment: axisAlignment ?? -1.0,
      offset: offset ?? const Offset(0, -1),
      alignment: alignment ?? Alignment.topCenter,
    );
  }
}
