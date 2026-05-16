import 'package:cached_network_image/cached_network_image.dart';
import 'package:cine_shelf/features/movies/nav/movie_details_args.dart';
import 'package:cine_shelf/features/movies/models/movie_poster.dart';
import 'package:cine_shelf/router/route_paths.dart';
import 'package:cine_shelf/shared/config/constants.dart';
import 'package:cine_shelf/shared/config/theme.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Isolated widget for an individual movie poster card.
///
/// Extracted from the list builder to reduce unnecessary rebuilds of sibling
/// cards and to allow Flutter to manage its lifecycle independently via
/// element reuse.
class MoviePosterCard extends StatelessWidget {
  const MoviePosterCard({required this.item, super.key});

  final MoviePoster item;

  @override
  Widget build(BuildContext context) {
    final posterPath = item.posterPath;

    return GestureDetector(
      onTap: () => context.push(
        RoutePaths.movieDetails,
        extra: MovieDetailsArgs(movie: item),
      ),
      child: AspectRatio(
        aspectRatio: AppConstants.posterAspectRatio,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(CineRadius.md),
          child: posterPath == null
              ? const ColoredBox(
                  color: CineColors.surfaceRaised,
                  child: Center(
                    child: Icon(Icons.image_not_supported_outlined),
                  ),
                )
              : CachedNetworkImage(
                  imageUrl: AppConstants.tmdbPosterUrl(posterPath),
                  fit: BoxFit.cover,
                  // Low filter quality reduces GPU cost during fast scrolling
                  // while remaining visually acceptable for poster thumbnails.
                  filterQuality: FilterQuality.low,
                  placeholder: (context, url) => const Center(
                    child: SizedBox(
                      width: CineSizes.loaderSmall,
                      height: CineSizes.loaderSmall,
                      child: CircularProgressIndicator(),
                    ),
                  ),
                  errorWidget: (context, url, error) =>
                      const Icon(Icons.error_outline, color: Colors.grey),
                ),
        ),
      ),
    );
  }
}
