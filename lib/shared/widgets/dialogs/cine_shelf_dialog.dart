import 'package:cine_shelf/shared/config/theme.dart';
import 'package:cine_shelf/shared/widgets/dialogs/cine_shelf_dialog_title.dart';
import 'package:cine_shelf/shared/widgets/dialogs/dialog_tokens.dart';
import 'package:flutter/material.dart';

class CineShelfDialog extends StatelessWidget {
  const CineShelfDialog({
    required this.title,
    required this.content,
    required this.actions,
    this.errorText,
    super.key,
  });

  final String title;
  final Widget content;
  final List<Widget> actions;
  final String? errorText;

  @override
  Widget build(BuildContext context) {
    final viewInsets = MediaQuery.viewInsetsOf(context);

    return AnimatedPadding(
      duration: CineShelfDialogTokens.transitionDuration,
      curve: CineShelfDialogTokens.transitionCurve,
      padding: CineShelfDialogTokens.viewportPadding + viewInsets,
      child: Center(
        child: Material(
          color: Colors.transparent,
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: CineShelfDialogTokens.maxDialogWidth,
            ),
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: CineShelfDialogTokens.dialogBackground,
                borderRadius: BorderRadius.circular(
                  CineShelfDialogTokens.dialogRadius,
                ),
                border: Border.all(color: CineShelfDialogTokens.dialogBorder),
                boxShadow: CineShelfDialogTokens.dialogGlow,
              ),
              child: SingleChildScrollView(
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                padding: CineShelfDialogTokens.dialogPadding,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    CineShelfDialogTitle(text: title),
                    const SizedBox(height: CineSpacing.xxl),
                    content,
                    if (errorText != null) ...[
                      const SizedBox(height: CineSpacing.md),
                      Text(
                        errorText!,
                        style: CineShelfDialogTokens.bodyStyle(
                          context,
                        ).copyWith(color: CineColors.error, fontSize: 13),
                      ),
                    ],
                    if (actions.isNotEmpty) ...[
                      const SizedBox(
                        height: CineShelfDialogTokens.actionsTopSpacing,
                      ),
                      Wrap(
                        alignment: WrapAlignment.end,
                        spacing: CineSpacing.md,
                        runSpacing: CineSpacing.sm,
                        children: actions,
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
