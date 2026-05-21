import 'package:cine_shelf/shared/config/theme.dart';
import 'package:flutter/material.dart';

class CineShelfDialogTokens {
  const CineShelfDialogTokens._();

  static const Color dialogBackground = Color(0xFF12100E);
  static const Color dialogField = Color(0xFF181512);
  static const Color primaryGold = Color(0xFFFFB338);
  static const Color dialogBorder = Color(0x80FFB338);
  static const Color dialogOverlay = Color(0xB3000000);
  static const Color dialogText = Color(0xFFEDE7DF);
  static const Color dialogMutedText = Color(0xFFB9ABA0);
  static const Color dialogDisabledText = Color(0x66FFFFFF);
  static const Color dialogButtonText = Color(0xFF17100A);
  static const Color danger = Color(0xFFFF6B5F);

  static const double dialogRadius = 28;
  static const double fieldRadius = CineRadius.lg;
  static const double buttonRadius = 999;
  static const double glowBlurRadius = 24;
  static const double maxDialogWidth = 430;
  static const double minButtonHeight = 52;
  static const double actionsTopSpacing = CineSpacing.lg;
  static const double transitionScaleBegin = 0.98;

  static const EdgeInsets viewportPadding = EdgeInsets.symmetric(
    horizontal: CineSpacing.xxl,
    vertical: CineSpacing.xxl,
  );
  static const EdgeInsets dialogPadding = EdgeInsets.fromLTRB(26, 30, 26, 24);
  static const EdgeInsets contentPadding = EdgeInsets.only(top: 24);
  static const EdgeInsets fieldContentPadding = EdgeInsets.symmetric(
    horizontal: 18,
    vertical: 18,
  );
  static const EdgeInsets buttonPadding = EdgeInsets.symmetric(
    horizontal: 26,
    vertical: 15,
  );
  static const Duration transitionDuration = Duration(milliseconds: 180);
  static const Curve transitionCurve = Curves.easeOutCubic;

  static TextStyle titleStyle(BuildContext context) {
    final theme = Theme.of(context);
    return (theme.textTheme.displayLarge ?? CineTypography.headline1).copyWith(
      color: primaryGold,
      fontSize: 24,
      fontWeight: FontWeight.w600,
      height: 1.12,
      letterSpacing: 0,
    );
  }

  static TextStyle bodyStyle(BuildContext context) {
    final theme = Theme.of(context);
    return (theme.textTheme.bodyMedium ?? CineTypography.bodyMedium).copyWith(
      color: dialogText,
      fontSize: 15,
      height: 1.35,
      letterSpacing: 0,
    );
  }

  static TextStyle labelStyle(BuildContext context) {
    return bodyStyle(context).copyWith(
      color: dialogMutedText,
      fontSize: 14,
      fontWeight: FontWeight.w500,
    );
  }

  static TextStyle inputStyle(BuildContext context) {
    return bodyStyle(
      context,
    ).copyWith(color: dialogText, fontSize: 16, height: 1.2);
  }

  static TextStyle buttonStyle(BuildContext context) {
    return bodyStyle(
      context,
    ).copyWith(fontSize: 15, fontWeight: FontWeight.w600, height: 1);
  }

  static List<BoxShadow> dialogGlow = [
    BoxShadow(
      color: primaryGold.withValues(alpha: 0.18),
      blurRadius: glowBlurRadius,
      spreadRadius: -8,
      offset: const Offset(0, 8),
    ),
  ];
}
