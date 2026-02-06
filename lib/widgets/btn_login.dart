import 'package:flutter/material.dart';

class CinePrimaryGoldButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;

  const CinePrimaryGoldButton({
    super.key,
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final enabled = onPressed != null;

    return SizedBox(
      height: 56,
      width: double.infinity,
      child: TweenAnimationBuilder<double>(
        tween: Tween(begin: 0, end: enabled ? 1 : 0),
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOut,
        builder: (context, t, child) {
          return DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              gradient: enabled
                  ? const LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Color(0xFFD4AF6A), // gold highlight
                        Color(0xFFB8893D), // gold base
                      ],
                    )
                  : const LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Color(0xFF3A332B), Color(0xFF2A241F)],
                    ),
              boxShadow: enabled
                  ? [
                      // Soft golden glow (subtle)
                      BoxShadow(
                        color: const Color(
                          0xFFC89A4A,
                        ).withValues(alpha: 0.22 * t),
                        blurRadius: 28,
                        spreadRadius: 0,
                        offset: const Offset(0, 10),
                      ),
                      // Depth shadow
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.35 * t),
                        blurRadius: 18,
                        offset: const Offset(0, 10),
                      ),
                    ]
                  : [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.25),
                        blurRadius: 14,
                        offset: const Offset(0, 10),
                      ),
                    ],
            ),
            child: Material(
              type: MaterialType.transparency,
              child: InkWell(
                borderRadius: BorderRadius.circular(18),
                splashColor: Colors.white.withValues(alpha: 0.06),
                highlightColor: Colors.white.withValues(alpha: 0.03),
                onTap: onPressed,
                child: Center(
                  child: Text(
                    text,
                    style: TextStyle(
                      color: enabled
                          ? const Color(0xFF1A120A)
                          : const Color(0xFFBFB7AE),
                      fontSize: 16.5,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.3,
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
