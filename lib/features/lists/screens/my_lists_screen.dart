import 'package:flutter/material.dart';

import 'package:cine_shelf/shared/config/theme.dart';
import 'package:cine_shelf/shared/widgets/separators.dart';

class MyListsContent extends StatelessWidget {
  const MyListsContent({
    super.key,
    this.watchedCount = 0,
    this.watchlistCount = 0,
    this.favoritesCount = 0,
    this.onWatchedTap,
    this.onWatchlistTap,
    this.onFavoritesTap,
  });

  final int watchedCount;
  final int watchlistCount;
  final int favoritesCount;

  final VoidCallback? onWatchedTap;
  final VoidCallback? onWatchlistTap;
  final VoidCallback? onFavoritesTap;

  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: CineSpacing.xxl),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: CineSpacing.xxxl),

            Text(
              'My Lists',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.w600,
                color: CineColors.amber,
              ),
            ),

            const SizedBox(height: CineSpacing.xl),
            const GlowSeparator(),
            const SizedBox(height: CineSpacing.xl),

            Text(
              'Base Lists',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: CineColors.amber,
              ),
            ),
            const SizedBox(height: CineSpacing.lg),

            CineListRow(
              icon: Icons.visibility_outlined,
              label: 'Watched',
              numMovies: watchedCount,
              onTap: onWatchedTap,
            ),
            const SizedBox(height: CineSpacing.md),
            CineListRow(
              icon: Icons.bookmark_border,
              label: 'Watchlist',
              numMovies: watchlistCount,
              onTap: onWatchlistTap,
            ),
            const SizedBox(height: CineSpacing.md),
            CineListRow(
              icon: Icons.favorite_border,
              label: 'Favorites',
              numMovies: favoritesCount,
              onTap: onFavoritesTap,
            ),

            const SizedBox(height: CineSpacing.xl),
            const GlowSeparator(),
            const SizedBox(height: CineSpacing.xl),

            Text(
              'My Lists',
              style: theme.textTheme.titleLarge?.copyWith(
                color: cs.primary,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: CineSpacing.md),

            Text(
              'Your custom lists will appear here.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: cs.onSurface.withOpacity(0.7),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CineListRow extends StatelessWidget {
  const CineListRow({
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
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: CineSpacing.lg,
            vertical: CineSpacing.lg,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: cs.primary.withOpacity(0.45), width: 1),
          ),
          child: Row(
            children: [
              Icon(icon, color: cs.primary),
              const SizedBox(width: CineSpacing.lg),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: cs.onSurface,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '$numMovies movies',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: cs.onSurface.withOpacity(0.6),
                      ),
                    ),
                  ],
                ),
              ),

              Icon(Icons.chevron_right, color: cs.primary.withOpacity(0.9)),
            ],
          ),
        ),
      ),
    );
  }
}
