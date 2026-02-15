import 'package:flutter/material.dart';
import 'package:cine_shelf/shared/config/constants.dart';

/// Full-screen background wrapper with branded image.
///
/// Provides consistent background across all screens using
/// the application's background asset with SafeArea insets.
///
/// Parameters:
/// - [child]: Content to display over the background
/// - [padding]: Optional padding around the child (defaults to no padding)
class Background extends StatelessWidget {
  const Background({
    required this.child,
    this.padding = EdgeInsets.zero,
    super.key,
  });

  final Widget child;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: Image.asset(AppConstants.backgroundPath, fit: BoxFit.cover),
        ),
        SafeArea(
          child: Padding(padding: padding, child: child),
        ),
      ],
    );
  }
}
