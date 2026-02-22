import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:cine_shelf/shared/config/theme.dart';

/// Circular back button with dark background and amber icon.
///
/// Consistent back navigation button used across fullscreen views
/// like movie details and credits screens.
class CineBackButton extends StatelessWidget {
  const CineBackButton({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.pop(),
      child: Container(
        width: 34,
        height: 34,
        decoration: const BoxDecoration(
          color: Color(0xFF101012),
          shape: BoxShape.circle,
        ),
        child: const Center(
          child: Icon(Icons.arrow_back, size: 18, color: CineColors.amber),
        ),
      ),
    );
  }
}
