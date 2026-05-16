import 'package:cine_shelf/shared/config/theme.dart';
import 'package:flutter/material.dart';

/// App information card with icon, name, version, and description.
class AppInfoCard extends StatelessWidget {
  const AppInfoCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(CineSpacing.xl),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1715),
        borderRadius: BorderRadius.circular(CineRadius.md),
        border: Border.all(
          color: CineColors.amber.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // App icon placeholder
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: CineColors.amber.withValues(alpha: 0.15),
              border: Border.all(
                color: CineColors.amber.withValues(alpha: 0.3),
                width: 2,
              ),
            ),
            child: Center(
              child: Image.asset(
                'assets/logo/logo.png',
                width: 34,
                height: 34,
                fit: BoxFit.contain,
              ),
            ),
          ),

          const SizedBox(width: CineSpacing.lg),

          // App info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'CineShelf',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: CineColors.amber,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Version 1.0.0',
                  style: TextStyle(fontSize: 13, color: CineColors.textMuted),
                ),
                const SizedBox(height: CineSpacing.md),
                Text(
                  'A modern movie tracking app for discovering, organizing, and managing your personal film collection.',
                  style: TextStyle(
                    fontSize: 14,
                    height: 1.4,
                    color: CineColors.textLight.withValues(alpha: 0.85),
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
