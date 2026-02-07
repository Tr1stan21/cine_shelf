import 'package:flutter/material.dart';

import 'package:cine_shelf/config/theme.dart';

/// Botón de acción para la pantalla de detalles de película
///
/// Soporta dos variantes:
/// - Filled: con color de fondo sólido
/// - Outlined: con borde y fondo semi-transparente
///
/// Puede incluir iconos leading y trailing opcionales.
class MovieActionButton extends StatelessWidget {
  const MovieActionButton({
    required this.label,
    required this.icon,
    this.backgroundColor,
    this.foregroundColor = CineColors.amber,
    this.outlined = false,
    this.trailingIcon,
    super.key,
  });

  final String label;
  final IconData icon;
  final Color? backgroundColor;
  final Color foregroundColor;
  final bool outlined;
  final IconData? trailingIcon;

  static const Color _bgTransparent = Color(0xA60F0E0E);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 44,
      decoration: BoxDecoration(
        color: outlined ? _bgTransparent : backgroundColor,
        borderRadius: BorderRadius.circular(CineRadius.xl),
        border: outlined
            ? Border.all(
                color: foregroundColor.withValues(alpha: 0.7),
                width: 1.2,
              )
            : null,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: CineSizes.iconSizeSmall, color: foregroundColor),
          const SizedBox(width: CineSpacing.sm),
          Text(
            label,
            style: const TextStyle(
              fontSize: 13.5,
              fontWeight: FontWeight.w600,
            ).copyWith(color: foregroundColor),
          ),
          if (trailingIcon != null) ...[
            const SizedBox(width: CineSpacing.sm),
            Icon(
              trailingIcon,
              size: trailingIcon == Icons.chevron_right_rounded
                  ? 20
                  : CineSizes.iconSizeSmall,
              color: foregroundColor,
            ),
          ],
        ],
      ),
    );
  }
}
