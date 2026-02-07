import 'package:flutter/material.dart';

import 'package:cine_shelf/config/theme.dart';

/// Botón principal dorado de CineShelf
///
/// Botón elevado con gradiente dorado y efectos de sombra/glow.
/// Se usa en acciones primarias como login.
class CinePrimaryGoldButton extends StatelessWidget {
  const CinePrimaryGoldButton({
    required this.text,
    required this.onPressed,
    super.key,
  });

  final String text;
  final VoidCallback? onPressed;

  // Colores específicos del botón
  static const Color _gold = Color(0xFFD4AF6A);
  static const Color _goldDark = Color(0xFFB8893D);
  static const Color _goldHighlight = Color(0xFFC89A4A);
  static const Color _bgButton = Color(0xFF3A332B);
  static const Color _bgButtonDark = Color(0xFF2A241F);
  static const Color _textDark = Color(0xFF1A120A);
  static const Duration _animationDuration = Duration(milliseconds: 220);

  @override
  Widget build(BuildContext context) {
    final enabled = onPressed != null;

    return SizedBox(
      height: CineSizes.buttonHeight,
      width: double.infinity,
      child: TweenAnimationBuilder<double>(
        tween: Tween(begin: 0, end: enabled ? 1 : 0),
        duration: _animationDuration,
        curve: Curves.easeOut,
        builder: (context, t, child) {
          return DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(CineRadius.lg),
              gradient: enabled
                  ? const LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [_gold, _goldDark],
                    )
                  : const LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [_bgButton, _bgButtonDark],
                    ),
              boxShadow: enabled
                  ? [
                      // Soft golden glow
                      BoxShadow(
                        color: _goldHighlight.withValues(alpha: 0.22 * t),
                        blurRadius: 28,
                        spreadRadius: 0,
                        offset: const Offset(0, 10),
                      ),
                      // Depth shadow
                      BoxShadow(
                        color: CineColors.black.withValues(alpha: 0.35 * t),
                        blurRadius: 18,
                        offset: const Offset(0, 10),
                      ),
                    ]
                  : [
                      BoxShadow(
                        color: CineColors.black.withValues(alpha: 0.25),
                        blurRadius: 14,
                        offset: const Offset(0, 10),
                      ),
                    ],
            ),
            child: Material(
              type: MaterialType.transparency,
              child: InkWell(
                borderRadius: BorderRadius.circular(CineRadius.lg),
                splashColor: CineColors.white.withValues(alpha: 0.06),
                highlightColor: CineColors.white.withValues(alpha: 0.03),
                onTap: onPressed,
                child: Center(
                  child: Text(
                    text,
                    style:
                        const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.3,
                        ).copyWith(
                          color: enabled ? _textDark : CineColors.textSecondary,
                        ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
