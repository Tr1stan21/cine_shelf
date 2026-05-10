import 'package:flutter/material.dart';

import 'package:cine_shelf/shared/config/theme.dart';

const Color _bgTransparent = Color(0xA60F0E0E);

Widget _movieActionButton({
  required String label,
  required IconData icon,
  required Color foregroundColor,
  Color? backgroundColor,
  bool outlined = false,
  IconData? trailingIcon,
  VoidCallback? onTap,
}) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      height: 44,
      decoration: BoxDecoration(
        color: outlined ? _bgTransparent : backgroundColor,
        borderRadius: BorderRadius.circular(CineRadius.xl),
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
          Icon(icon, size: CineSizes.iconSizeSmall, color: foregroundColor),
          const SizedBox(width: CineSpacing.sm),
          Text(
            label,
            style: const TextStyle(
              fontSize: 13.5,
              fontWeight: FontWeight.w600,
            ).copyWith(color: foregroundColor),
          ),
          if (trailingIcon != null) ...[
            const SizedBox(width: CineSpacing.sm),
            Icon(
              trailingIcon,
              size: trailingIcon == Icons.chevron_right_rounded
                  ? 20
                  : CineSizes.iconSizeSmall,
              color: foregroundColor,
            ),
          ],
        ],
      ),
    ),
  );
}

class FavoriteMovieButton extends StatelessWidget {
  const FavoriteMovieButton({required this.isFavorite, this.onTap, super.key});

  final bool isFavorite;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return _movieActionButton(
      label: 'Favorite',
      icon: Icons.favorite,
      backgroundColor: isFavorite ? const Color(0xFFB56610) : null,
      foregroundColor: isFavorite ? CineColors.white : CineColors.amber,
      outlined: !isFavorite,
      onTap: onTap,
    );
  }
}

class WatchlistMovieButton extends StatelessWidget {
  const WatchlistMovieButton({
    required this.isWatchlist,
    this.onTap,
    super.key,
  });

  final bool isWatchlist;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return _movieActionButton(
      label: 'Watchlist',
      icon: Icons.access_time_rounded,
      backgroundColor: isWatchlist ? const Color(0xFF5C4B2A) : null,
      foregroundColor: CineColors.amber,
      outlined: !isWatchlist,
      onTap: onTap,
    );
  }
}

class WatchedMovieButton extends StatelessWidget {
  const WatchedMovieButton({required this.isWatched, this.onTap, super.key});

  final bool isWatched;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return _movieActionButton(
      label: 'Watched',
      icon: Icons.visibility_outlined,
      backgroundColor: isWatched ? const Color(0xFF7A3E07) : null,
      foregroundColor: CineColors.amber,
      outlined: !isWatched,
      onTap: onTap,
    );
  }
}

class MovieListButton extends StatelessWidget {
  const MovieListButton({super.key});

  @override
  Widget build(BuildContext context) {
    return _movieActionButton(
      label: 'List...',
      icon: Icons.add,
      foregroundColor: CineColors.amber,
      outlined: true,
      trailingIcon: Icons.chevron_right_rounded,
    );
  }
}
