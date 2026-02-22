import 'package:cine_shelf/features/movies/models/movie_details_args.dart';
import 'package:cine_shelf/features/movies/models/movie_poster.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:cine_shelf/shared/config/theme.dart';
import 'package:cine_shelf/shared/config/constants.dart';
import 'package:cine_shelf/shared/widgets/background.dart';
import 'package:cine_shelf/router/route_paths.dart';

/// Full-screen movie list displaying movies in a responsive grid layout.
///
/// Presents a collection of movies organized in a multi-column grid where:
/// - Column count is determined by [AppConstants.moviesPerRow]
/// - Each movie poster maintains consistent aspect ratio
/// - Tapping any poster navigates to movie details screen
/// - Grid automatically handles varying list lengths with proper spacing
///
/// **Performance Optimizations:**
/// - Uses ListView.builder for lazy loading (only visible rows rendered)
/// - Enables addRepaintBoundaries to prevent unnecessary repaints of off-screen rows
/// - CachedNetworkImage with memory caching for image rendering efficiency
/// - Efficiently calculates row/column indices without allocating full grid in memory
///
/// Typically navigated to from MovieListSection when user taps "see all".
class MovieListScreen extends StatelessWidget {
  const MovieListScreen({required this.title, required this.items, super.key});

  final String title;
  final List<MoviePoster> items;

  @override
  Widget build(BuildContext context) {
    return Background(
      padding: const EdgeInsets.symmetric(horizontal: CineSpacing.md),
      child: Column(
        children: [
          Text(title, style: CineTypography.headline2),
          const SizedBox(height: CineSpacing.md),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(8),
              // Calculate number of rows needed
              itemCount: (items.length / AppConstants.moviesPerRow).ceil(),
              // Enable addRepaintBoundaries to optimize repaints of off-screen rows
              addRepaintBoundaries: true,
              itemBuilder: (context, rowIndex) {
                final start = rowIndex * AppConstants.moviesPerRow;
                final end = (start + AppConstants.moviesPerRow).clamp(
                  0,
                  items.length,
                );
                final rowItems = items.sublist(start, end);

                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    children: List.generate(AppConstants.moviesPerRow, (i) {
                      if (i >= rowItems.length) {
                        return const Expanded(child: SizedBox());
                      }

                      final item = rowItems[i];

                      return Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: _MoviePosterCard(item: item),
                        ),
                      );
                    }),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

/// Extracted widget for individual movie poster card.
///
/// Separating into its own widget improves performance by:
/// - Reducing unnecessary rebuilds of the entire row
/// - Allowing Flutter to optimize widget lifecycle independently
/// - Better memory management in large lists
class _MoviePosterCard extends StatelessWidget {
  const _MoviePosterCard({required this.item});

  final MoviePoster item;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push(
        RoutePaths.movieDetails,
        extra: MovieDetailsArgs(movie: item),
      ),
      child: AspectRatio(
        aspectRatio: AppConstants.posterAspectRatio,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(CineRadius.md),
          child: CachedNetworkImage(
            imageUrl: AppConstants.tmdbPosterUrl(item.posterPath),
            fit: BoxFit.cover,
            filterQuality: FilterQuality.low,
            placeholder: (context, url) =>
                const Center(child: CircularProgressIndicator()),
            errorWidget: (context, url, error) =>
                const Icon(Icons.error_outline, color: Colors.grey),
          ),
        ),
      ),
    );
  }
}
