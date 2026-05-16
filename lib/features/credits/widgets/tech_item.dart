import 'package:cine_shelf/shared/config/theme.dart';
import 'package:flutter/material.dart';

/// Technology/service list item with name, subtitle, and optional version.
class TechItem extends StatelessWidget {
  const TechItem({
    required this.name,
    required this.subtitle,
    super.key,
    this.version,
  });

  final String name;
  final String subtitle;
  final String? version;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: CineSpacing.md),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 2),
            child: Icon(Icons.circle, size: 6, color: CineColors.amber),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        name,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: CineColors.textLight,
                        ),
                      ),
                    ),
                    if (version != null)
                      Text(
                        'v$version',
                        style: TextStyle(
                          fontSize: 13,
                          color: CineColors.textMuted.withValues(alpha: 0.7),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 13,
                    color: CineColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
