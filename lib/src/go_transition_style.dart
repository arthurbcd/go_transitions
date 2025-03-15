import 'package:flutter/cupertino.dart';

import 'go_transition.dart';

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
