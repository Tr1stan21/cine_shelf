import 'package:cine_shelf/shared/config/theme.dart';
import 'package:flutter/material.dart';

/// Interactive row for account screen menu options.
///
/// Displays an icon, label text, and chevron indicator.
/// Used for navigation to sub-screens or triggering actions like sign out.
class AccountRow extends StatelessWidget {
  const AccountRow({
    required this.icon,
    required this.label,
    required this.onTap,
    super.key,
  });

  final IconData icon;
  final String label;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(CineRadius.md),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: CineSpacing.lg),
        child: Row(
          children: [
            Icon(icon, size: 22, color: CineColors.amber),
            const SizedBox(width: CineSpacing.lg),
            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                  fontSize: 18,
                  color: CineColors.textSecondary,
                ),
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: CineColors.amber.withValues(alpha: 0.7),
            ),
          ],
        ),
      ),
    );
  }
}
