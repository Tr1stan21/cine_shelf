import 'package:flutter/material.dart';
import 'package:cine_shelf/shared/config/constants.dart';

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
