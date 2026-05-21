import 'package:cine_shelf/shared/widgets/dialogs/dialog_tokens.dart';
import 'package:flutter/material.dart';

Future<T?> showCineShelfDialog<T>({
  required BuildContext context,
  required WidgetBuilder builder,
  bool barrierDismissible = true,
  bool useRootNavigator = true,
  RouteSettings? routeSettings,
}) {
  return showGeneralDialog<T>(
    context: context,
    barrierDismissible: barrierDismissible,
    barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
    barrierColor: CineShelfDialogTokens.dialogOverlay,
    useRootNavigator: useRootNavigator,
    routeSettings: routeSettings,
    transitionDuration: CineShelfDialogTokens.transitionDuration,
    pageBuilder: (context, animation, secondaryAnimation) {
      return builder(context);
    },
    transitionBuilder: (context, animation, secondaryAnimation, child) {
      final curvedAnimation = CurvedAnimation(
        parent: animation,
        curve: CineShelfDialogTokens.transitionCurve,
      );

      return FadeTransition(
        opacity: curvedAnimation,
        child: ScaleTransition(
          scale: Tween<double>(
            begin: CineShelfDialogTokens.transitionScaleBegin,
            end: 1,
          ).animate(curvedAnimation),
          child: child,
        ),
      );
    },
  );
}
