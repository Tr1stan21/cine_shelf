import 'package:cine_shelf/shared/config/theme.dart';
import 'package:cine_shelf/shared/widgets/dialogs/dialog_tokens.dart';
import 'package:flutter/material.dart';

enum CineShelfDialogButtonVariant { primary, secondary, danger }

class CineShelfDialogButton extends StatelessWidget {
  const CineShelfDialogButton({
    required this.label,
    required this.onPressed,
    this.variant = CineShelfDialogButtonVariant.primary,
    this.icon,
    this.isLoading = false,
    this.enabled = true,
    super.key,
  });

  final String label;
  final VoidCallback? onPressed;
  final CineShelfDialogButtonVariant variant;
  final IconData? icon;
  final bool isLoading;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final isPrimary = variant == CineShelfDialogButtonVariant.primary;
    final color = _textColor;

    return TextButton(
      onPressed: enabled && !isLoading ? onPressed : null,
      style: TextButton.styleFrom(
        minimumSize: const Size(0, CineShelfDialogTokens.minButtonHeight),
        padding: CineShelfDialogTokens.buttonPadding,
        foregroundColor: color,
        disabledForegroundColor: CineShelfDialogTokens.dialogDisabledText,
        backgroundColor: isPrimary
            ? CineShelfDialogTokens.primaryGold
            : Colors.transparent,
        shape: const StadiumBorder(),
        textStyle: CineShelfDialogTokens.buttonStyle(context),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (isLoading)
            SizedBox(
              width: CineSizes.iconSizeSmall,
              height: CineSizes.iconSizeSmall,
              child: CircularProgressIndicator(strokeWidth: 2, color: color),
            )
          else if (icon != null)
            Icon(icon, size: CineSizes.iconSizeSmall + 2),
          if (isLoading || icon != null) const SizedBox(width: CineSpacing.md),
          Text(label),
        ],
      ),
    );
  }

  Color get _textColor {
    switch (variant) {
      case CineShelfDialogButtonVariant.primary:
        return CineShelfDialogTokens.dialogButtonText;
      case CineShelfDialogButtonVariant.secondary:
        return CineShelfDialogTokens.primaryGold;
      case CineShelfDialogButtonVariant.danger:
        return CineShelfDialogTokens.danger;
    }
  }
}
