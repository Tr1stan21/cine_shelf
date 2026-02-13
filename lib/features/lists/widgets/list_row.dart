import 'package:cine_shelf/shared/config/theme.dart';
import 'package:flutter/material.dart';

class ListRow extends StatelessWidget {
  const ListRow({
    required this.icon,
    required this.label,
    required this.numMovies,
    this.onTap,
    super.key,
  });

  final IconData icon;
  final String label;
  final int numMovies;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: CineSpacing.lg,
          vertical: CineSpacing.lg,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: CineColors.amber, width: 1),
        ),
        child: Row(
          children: [
            Icon(icon, color: CineColors.amber),
            const SizedBox(width: CineSpacing.lg),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: const TextStyle(
                      fontSize: 18,
                      color: CineColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '$numMovies movies',
                    style: const TextStyle(
                      fontSize: 14,
                      color: CineColors.textMuted,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: CineColors.textSecondary),
          ],
        ),
      ),
    );
  }
}
