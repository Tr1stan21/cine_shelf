import 'package:flutter/material.dart';
import 'package:cine_shelf/shared/config/theme.dart';

class StatsPill extends StatelessWidget {
  const StatsPill({super.key});

  static const _watched = StatItem(
    icon: Icons.remove_red_eye_outlined,
    value: '152',
    label: 'Watched',
  );
  static const _watchList = StatItem(
    icon: Icons.bookmark_outline,
    value: '40',
    label: 'Watchlist',
  );
  static const _favorites = StatItem(
    icon: Icons.favorite_border,
    value: '23',
    label: 'Favorites',
  );

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
      child: const Row(
        children: [
          Expanded(child: Center(child: _watched)),
          _Divider(),
          Expanded(child: Center(child: _watchList)),
          _Divider(),
          Expanded(child: Center(child: _favorites)),
        ],
      ),
    );
  }
}

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

class StatItem extends StatelessWidget {
  const StatItem({
    required this.icon,
    required this.value,
    required this.label,
    super.key,
  });

  final IconData icon;
  final String value;
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
              value,
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
