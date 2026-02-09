import 'package:flutter/material.dart';

import 'package:cine_shelf/shared/config/theme.dart';

class GlowSeparator extends StatelessWidget {
  const GlowSeparator({
    super.key,
    this.width = double.infinity,
    this.height = 3.0,
  });

  final double width;
  final double height;

  // Paleta (naranja-rojizo, mínimo oro)
  static const Color _redOrange = Color(0xFFE54A12);
  static const Color _hotOrange = Color(0xFFF26A0A);
  static const Color _orange = Color(0xFFFF8A12);
  static const Color _amber = Color(0xFFFFB33A);

  // Nuevos pasos suaves hacia blanco
  static const Color _amberLight1 = Color(0xFFFFD07A);
  static const Color _amberLight2 = Color(0xFFFFE2B0);

  static const Color _coreWarm = Color(0xFFFFF7EA);
  static const Color _coreWhite = Color(0xFFFFFFFF);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [
              _redOrange.withOpacity(0.00),
              _redOrange.withOpacity(0.18),

              _hotOrange.withOpacity(0.35),
              _hotOrange.withOpacity(0.55),
              _orange.withOpacity(0.75),
              _orange.withOpacity(0.90),

              _amber.withOpacity(0.92),

              // Transición más suave al blanco
              _amberLight1,
              _amberLight2,
              _coreWarm,
              _coreWhite,
              _coreWarm,
              _amberLight2,
              _amberLight1,

              _amber.withOpacity(0.92),

              _orange.withOpacity(0.90),
              _orange.withOpacity(0.75),
              _hotOrange.withOpacity(0.55),
              _hotOrange.withOpacity(0.35),

              _redOrange.withOpacity(0.18),
              _redOrange.withOpacity(0.00),
            ],
            stops: const [
              0.00,
              0.16,

              0.26,
              0.34,
              0.41,
              0.46,

              0.480,

              // rampa hacia el núcleo (más larga y con pasos)
              0.487,
              0.492,
              0.496,
              0.500,
              0.504,
              0.508,
              0.513,

              0.520,

              0.54,
              0.59,
              0.66,
              0.74,

              0.84,
              1.00,
            ],
          ),
        ),
      ),
    );
  }
}

class ThinDivider extends StatelessWidget {
  const ThinDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(height: 1, color: CineColors.white.withOpacity(0.08));
  }
}
