import 'package:flutter/material.dart';
import 'package:cine_shelf/shared/config/theme.dart';

/// Statistics display widget showing user's movie collection counts.
///
/// Presents three key metrics in a single pill-shaped container:
/// - Watched movies count
/// - Watchlist count
/// - Favorites count
///
/// Each stat includes an icon, numeric value, and label.
/// Metrics are separated by vertical dividers.
class StatsPill extends StatelessWidget {
  const StatsPill({
    required this.watchedValue,
    required this.watchlistValue,
    required this.favoriteValue,
    super.key,
  });

  final int watchedValue;
  final int watchlistValue;
  final int favoriteValue;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: CineSpacing.lg,
        vertical: CineSpacing.md,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(CineRadius.xl),
        border: Border.all(color: CineColors.amber.withValues(alpha: 0.55)),
        color: CineColors.black.withValues(alpha: 0.14),
      ),
      child: Row(
        children: [
          Expanded(
            child: Center(
              child: StatItem(
                icon: Icons.remove_red_eye_outlined,
                value: watchedValue,
                label: 'Watched',
              ),
            ),
          ),
          const _Divider(),
          Expanded(
            child: Center(
              child: StatItem(
                icon: Icons.bookmark_outline,
                value: watchlistValue,
                label: 'Watchlist',
              ),
            ),
          ),
          const _Divider(),
          Expanded(
            child: Center(
              child: StatItem(
                icon: Icons.favorite_border,
                value: favoriteValue,
                label: 'Favorites',
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Internal vertical divider between stat items.
class _Divider extends StatelessWidget {
  const _Divider();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      margin: const EdgeInsets.symmetric(horizontal: CineSpacing.md),
      height: 40,
      color: CineColors.amber.withValues(alpha: 0.22),
    );
  }
}

/// Individual statistic item within the stats pill.
///
/// Displays an icon, numeric value, and label in a compact column layout.
class StatItem extends StatelessWidget {
  const StatItem({
    required this.icon,
    required this.value,
    required this.label,
    super.key,
  });

  final IconData icon;
  final int value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(width: CineSpacing.sm),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 24,
              color: CineColors.amber.withValues(alpha: 0.9),
            ),
            const SizedBox(width: 4),
            Text(
              value.toString(),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: CineColors.textLight,
                height: 1.1,
              ),
            ),
          ],
        ),
        const SizedBox(height: 5),
        Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontSize: 15,
            color: CineColors.textSecondary,
            height: 1.1,
          ),
        ),
      ],
    );
  }
}
