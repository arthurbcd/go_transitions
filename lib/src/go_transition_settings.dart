import 'package:flutter/cupertino.dart';

import 'go_transition.dart';

@immutable
class GoTransitionSettings extends RouteSettings {
  const GoTransitionSettings({
    super.name,
    super.arguments,
    this.key,
    this.restorationId,
    this.canPop = true,
    this.onPopInvoked = _defaultPopInvokedHandler,
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
    super.name,
    super.arguments,
    this.key,
    this.restorationId,
    this.canPop = true,
    this.onPopInvoked = _defaultPopInvokedHandler,
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

  static void _defaultPopInvokedHandler(bool didPop, Object? result) {}

  /// The [Page.key]
  final LocalKey? key;

  /// The [Page.restorationId]
  final String? restorationId;

  /// The [Page.canPop].
  final bool canPop;

  /// The [Page.onPopInvoked].
  final PopInvokedWithResultCallback onPopInvoked;

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
