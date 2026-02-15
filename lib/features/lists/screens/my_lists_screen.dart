import 'package:cine_shelf/features/lists/widgets/list_row.dart';
import 'package:flutter/material.dart';

import 'package:cine_shelf/shared/config/theme.dart';
import 'package:cine_shelf/shared/config/constants.dart';
import 'package:cine_shelf/shared/widgets/separators.dart';

/// User's personal movie lists screen.
///
/// Displays two sections:
/// 1. Base Lists - System-provided lists:
///    - Watched: Movies the user has marked as watched
///    - Watchlist: Movies saved to watch later
///    - Favorites: Movies marked as favorites
///
/// 2. My Lists - User-created custom lists (currently placeholder)
///
/// Each list row shows the list name, icon, and current movie count.
/// Tapping a list navigates to the detailed list view.
class MyListsScreen extends StatelessWidget {
  const MyListsScreen({
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
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: CineSpacing.lg),
        child: Column(
          children: [
            Image.asset(AppConstants.logoPath, height: 100),

            const SizedBox(height: CineSpacing.xxxl),
            const Text(
              'Base Lists',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w600,
                color: CineColors.amber,
              ),
            ),
            const SizedBox(height: CineSpacing.lg),
            ListRow(
              icon: Icons.visibility_outlined,
              label: 'Watched',
              numMovies: watchedCount,
              onTap: onWatchedTap,
            ),
            const SizedBox(height: CineSpacing.md),
            ListRow(
              icon: Icons.bookmark_border,
              label: 'Watchlist',
              numMovies: watchlistCount,
              onTap: onWatchlistTap,
            ),
            const SizedBox(height: CineSpacing.md),
            ListRow(
              icon: Icons.favorite_border,
              label: 'Favorites',
              numMovies: favoritesCount,
              onTap: onFavoritesTap,
            ),
            const SizedBox(height: CineSpacing.xl),
            const GlowSeparator(),
            const SizedBox(height: CineSpacing.xl),
            const Text(
              'My Lists',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w600,
                color: CineColors.amber,
              ),
            ),
            const SizedBox(height: CineSpacing.md),
          ],
        ),
      ),
    );
  }
}
