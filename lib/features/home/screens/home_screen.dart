import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:cine_shelf/shared/config/constants.dart';
import 'package:cine_shelf/shared/config/theme.dart';
import 'package:cine_shelf/features/home/widgets/movie_list_section.dart';
//import 'package:cine_shelf/features/home/widgets/search_bar.dart';
import 'package:cine_shelf/shared/widgets/separators.dart';
import 'package:cine_shelf/features/movies/models/tmdb/list_category.dart';
import 'package:cine_shelf/features/movies/application/movies_provider.dart';

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
          //CineSearchBar(onChanged: (v) {}, onSubmitted: (v) {}),
          const _MovieSection(category: ListCategory.popular, title: 'Popular'),
          const GlowSeparator(),
          const _MovieSection(
            category: ListCategory.nowPlaying,
            title: 'Now Playing',
          ),
          const GlowSeparator(),
          const _MovieSection(
            category: ListCategory.upcoming,
            title: 'Upcoming',
          ),
          const GlowSeparator(),
          const _MovieSection(
            category: ListCategory.topRated,
            title: 'Top Rated',
          ),
        ],
      ),
    );
  }
}

/// Private widget that encapsulates async loading logic for a single home section.
///
/// Watches [moviesProvider] for the given [category] and renders:
/// - [MovieListSection] on success, forwarding [category] to enable infinite
///   scroll when the user navigates to the full list screen.
/// - A centered [CircularProgressIndicator] while loading.
/// - An empty [SizedBox] on error — errors are silently swallowed here to
///   avoid breaking the rest of the home layout. Individual sections fail
///   independently without taking down the whole screen.
///
/// [category] is forwarded to [MovieListSection] so that [MovieListScreen]
/// can request additional pages when the user scrolls to the bottom.
class _MovieSection extends ConsumerWidget {
  const _MovieSection({required this.category, required this.title});

  /// The TMDB category this section represents (e.g., popular, top_rated).
  final ListCategory category;

  /// Display title shown as the section header.
  final String title;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncMovies = ref.watch(moviesProvider(category));

    return asyncMovies.when(
      data: (page) => MovieListSection(
        title: title,
        items: page.movies,
        totalPages: page.totalPages,
        category: category,
      ),
      loading: () => const Padding(
        padding: EdgeInsets.symmetric(vertical: CineSpacing.xxxl),
        child: Center(child: CircularProgressIndicator()),
      ),
      error: (_, _) => const SizedBox.shrink(),
    );
  }
}
