import 'package:cine_shelf/shared/config/theme.dart';
import 'package:flutter/material.dart';

void showCineSnackBar(BuildContext context, String message) {
  if (!context.mounted) return;

  final theme = Theme.of(context);

  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: theme.textTheme.bodyMedium?.copyWith(color: CineColors.white),
        ),
        duration: const Duration(milliseconds: 1200),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.fromLTRB(
          CineSpacing.md,
          0,
          CineSpacing.md,
          120,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(CineRadius.md),
        ),
        backgroundColor: CineColors.black.withValues(alpha: 0.92),
      ),
    );
}
