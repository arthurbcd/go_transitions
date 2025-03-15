import 'package:flutter/material.dart';

import 'go_transition.dart';
import 'go_transition_settings.dart';
import 'modifiers.dart';
import 'transitions.dart';

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

  /// Syntax-sugar for building [theme] with [fullscreenDialog] set to `true`.
  static final fullscreenDialog = GoTransitions.theme.build(
    settings: const GoTransitionSettings(fullscreenDialog: true),
  );

  /// Syntax-sugar for building [RawDialogRoute] like transitions.
  static final dialog = GoTransitions.fade.buildPopup();

  /// Syntax-sugar for building [ModalBottomSheetRoute] like transitions.
  static final bottomSheet = GoTransitions.slide.toTop.buildPopup();
}

Widget _invisible(
  PageRoute route,
  BuildContext context,
  Animation<double> a1,
  Animation<double> a2,
  Widget child,
) {
  return Visibility(visible: a1.value == 1.0, child: child);
}
