import 'package:cine_shelf/shared/config/theme.dart';
import 'package:flutter/material.dart';

/// Section header with icon and title.
class SectionHeader extends StatelessWidget {
  const SectionHeader({required this.icon, required this.title, super.key});

  final IconData icon;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 20, color: CineColors.amber),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: CineColors.amber,
          ),
        ),
      ],
    );
  }
}
