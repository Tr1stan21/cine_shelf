import 'package:cine_shelf/features/home/widgets/movies_section.dart';
import 'package:cine_shelf/features/catalog/data/dto/tmdb/list_category.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:cine_shelf/shared/config/constants.dart';
import 'package:cine_shelf/shared/widgets/separators.dart';

/// Main home screen displaying categorized movie carousels.
///
/// Renders four horizontally scrollable sections, one per [ListCategory]:
/// - Popular
/// - Now Playing
/// - Upcoming
/// - Top Rated
///
/// Each section is separated by a [GlowSeparator] and delegates loading
/// and error state to [_MovieSection].
///
/// This widget is stateless; all async data is managed by [moviesProvider].
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Image.asset(AppConstants.logoPath, height: 100),
          const SizedBox(height: 20),
          const MovieSection(category: ListCategory.popular, title: 'Popular'),
          const GlowSeparator(),
          const MovieSection(
            category: ListCategory.nowPlaying,
            title: 'Now Playing',
          ),
          const GlowSeparator(),
          const GenreMovieSection(index: 0),
          const GlowSeparator(),
          const MovieSection(
            category: ListCategory.upcoming,
            title: 'Upcoming',
          ),
          const GlowSeparator(),
          const GenreMovieSection(index: 1),
          const GlowSeparator(),
          const MovieSection(
            category: ListCategory.topRated,
            title: 'Top Rated',
          ),
          const GlowSeparator(),
          const GenreMovieSection(index: 2),
        ],
      ),
    );
  }
}
