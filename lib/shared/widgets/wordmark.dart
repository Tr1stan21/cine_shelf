import 'package:flutter/material.dart';

/// CineShelf brand wordmark widget.
///
/// Renders the "CineShelf" text with consistent brand styling:
/// - Golden/amber color matching logo
/// - Bold weight for prominence
/// - Tight letter spacing for premium feel
///
/// Used in auth screens and other branding contexts.
class CineShelfWordmark extends StatelessWidget {
  const CineShelfWordmark({
    required this.fontSize,
    super.key,
    this.center = true,
  });

  final double fontSize;
  final bool center;

  static const Color _brandGold = Color(0xFFE2B66A);

  @override
  Widget build(BuildContext context) {
    return Text(
      'CineShelf',
      textAlign: center ? TextAlign.center : TextAlign.left,
      style: TextStyle(
        fontSize: fontSize,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.4,
        color: _brandGold,
      ),
    );
  }
}
