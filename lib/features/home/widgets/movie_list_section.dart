import 'package:cine_shelf/features/movies/models/movie_list_args.dart';
import 'package:cine_shelf/features/movies/models/movie_details_args.dart';
import 'package:cine_shelf/features/movies/models/tmdb/list_category.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:cine_shelf/shared/config/theme.dart';
import 'package:cine_shelf/shared/config/constants.dart';
import 'package:cine_shelf/features/movies/models/movie_poster.dart';
import 'package:cine_shelf/router/route_paths.dart';

/// Widget displaying a horizontal section of movies with title and navigation button.
///
/// Presents a horizontal carousel of movie posters with:
/// - Section title
/// - Navigation button to view the full list (with infinite scroll)
/// - Horizontal scrollable list of posters
///
/// [category] is forwarded to [MovieListArgs] so [MovieListScreen] can load
/// additional pages when the user scrolls to the bottom of the full list.
class MovieListSection extends StatelessWidget {
  const MovieListSection({
    required this.title,
    required this.items,
    required this.totalPages,
    required this.category,
    super.key,
  });

  final String title;
  final List<MoviePoster> items;
  final int totalPages;

  /// TMDB category — passed through to MovieListScreen to enable infinite scroll.
  final ListCategory category;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: CineSpacing.xxxl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with title and navigation button
          InkWell(
            onTap: () => context.push(
              RoutePaths.movies,
              extra: MovieListArgs(
                title: title,
                items: items,
                totalPages: totalPages,
                category: category,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(title, style: CineTypography.headline2),
                const Icon(Icons.arrow_forward_ios, color: CineColors.amber),
              ],
            ),
          ),
          const SizedBox(height: 5),
          // Horizontal list of movies
          LayoutBuilder(
            builder: (context, constraints) {
              final availableW = constraints.maxWidth;
              final totalSpacing =
                  AppConstants.itemSpacing * (AppConstants.postersVisible - 1);
              final posterW =
                  (availableW - totalSpacing) / AppConstants.postersVisible;
              final posterH = posterW / AppConstants.posterAspectRatio;

              return SizedBox(
                height: posterH,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: items.length,
                  separatorBuilder: (_, index) =>
                      const SizedBox(width: AppConstants.itemSpacing),
                  itemBuilder: (context, index) {
                    final movie = items[index];
                    final imageUrl = AppConstants.tmdbPosterUrl(
                      movie.posterPath,
                    );

                    return SizedBox(
                      width: posterW,
                      child: GestureDetector(
                        onTap: () => context.push(
                          RoutePaths.movieDetails,
                          extra: MovieDetailsArgs(movie: movie),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(CineRadius.md),
                          child: CachedNetworkImage(
                            imageUrl: imageUrl,
                            fit: BoxFit.cover,
                            filterQuality: FilterQuality.low,
                            placeholder: (context, url) => const Center(
                              child: CircularProgressIndicator(),
                            ),
                            errorWidget: (context, url, error) => const Icon(
                              Icons.error_outline,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
