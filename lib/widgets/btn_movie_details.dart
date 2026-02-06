import 'package:flutter/material.dart';

class BtnMovieDetails extends StatelessWidget {
  const BtnMovieDetails({
    required this.label,
    required this.icon,
    this.backgroundColor,
    this.foregroundColor = const Color(0xFFFFB000),
    this.outlined = false,
    this.trailingIcon,
  });

  final String label;
  final IconData icon;
  final Color? backgroundColor;
  final Color foregroundColor;
  final bool outlined;
  final IconData? trailingIcon;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 44,
      decoration: BoxDecoration(
        color: outlined ? const Color(0xA60F0E0E) : backgroundColor,
        borderRadius: BorderRadius.circular(22),
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
          Icon(icon, size: 18, color: foregroundColor),
          const SizedBox(width: 10),
          Text(
            label,
            style: TextStyle(
              color: foregroundColor,
              fontSize: 13.5,
              fontWeight: FontWeight.w600,
            ),
          ),
          if (trailingIcon != null) ...[
            const SizedBox(width: 10),
            Icon(
              trailingIcon,
              size: trailingIcon == Icons.chevron_right_rounded ? 20 : 18,
              color: foregroundColor,
            ),
          ],
        ],
      ),
    );
  }
}
