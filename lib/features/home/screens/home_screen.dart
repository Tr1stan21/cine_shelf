import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:cine_shelf/shared/config/constants.dart';
import 'package:cine_shelf/shared/config/theme.dart';
import 'package:cine_shelf/features/home/widgets/movie_list_section.dart';
import 'package:cine_shelf/features/home/widgets/search_bar.dart';
import 'package:cine_shelf/features/movies/models/tmdb/movie_genres_catalog.dart';
import 'package:cine_shelf/shared/widgets/separators.dart';
import 'package:cine_shelf/features/movies/models/tmdb/list_category.dart';
import 'package:cine_shelf/features/movies/application/movies_provider.dart';
import 'package:cine_shelf/features/region/application/region_providers.dart';

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
          CineSearchBar(onChanged: (v) {}, onSubmitted: (v) {}),
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
          const _GenreMovieSection(genreId: 878, title: 'Science Fiction'),
          const _GenreMovieSection(genreId: 878, title: 'Science Fiction'),
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
/// - An informative placeholder on error with a retry action scoped to this
///   section's category.
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
    final query = ref.watch(movieQueryParamsByCategoryProvider(category));
    final asyncMovies = ref.watch(moviesProvider(query));

    return asyncMovies.when(
      data: (page) => MovieListSection(
        title: title,
        items: page.movies,
        totalPages: page.totalPages,
        query: query,
      ),
      loading: () => const Padding(
        padding: EdgeInsets.symmetric(vertical: CineSpacing.xxxl),
        child: Center(child: CircularProgressIndicator()),
      ),
      error: (_, _) => _SectionErrorPlaceholder(
        sectionTitle: title,
        onRetry: () {
          ref.invalidate(moviesProvider(query));
        },
      ),
    );
  }
}

class _GenreMovieSection extends ConsumerWidget {
  const _GenreMovieSection({required this.genreId, required this.title});

  final int genreId;
  final String title;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final query = ref.watch(movieQueryParamsByGenreProvider(genreId));
    final asyncMovies = ref.watch(moviesProvider(query));

    return asyncMovies.when(
      data: (page) => MovieListSection(
        title: title,
        items: page.movies,
        totalPages: page.totalPages,
        query: query,
      ),
      loading: () => const Padding(
        padding: EdgeInsets.symmetric(vertical: CineSpacing.xxxl),
        child: Center(child: CircularProgressIndicator()),
      ),
      error: (_, _) => _SectionErrorPlaceholder(
        sectionTitle: title,
        onRetry: () => ref.invalidate(moviesProvider(query)),
      ),
    );
  }
}

class _SectionErrorPlaceholder extends StatelessWidget {
  const _SectionErrorPlaceholder({
    required this.sectionTitle,
    required this.onRetry,
  });

  final String sectionTitle;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: CineSpacing.xxl,
        vertical: CineSpacing.xxxl,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 560),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(CineSpacing.xxl),
            decoration: BoxDecoration(
              color: CineColors.black,
              borderRadius: BorderRadius.circular(CineRadius.md),
              border: Border.all(color: CineColors.textHint),
            ),
            child: Column(
              children: [
                const Icon(Icons.error_outline, color: CineColors.amber),
                const SizedBox(height: CineSpacing.md),
                Text(
                  'Could not load $sectionTitle movies.',
                  textAlign: TextAlign.center,
                  style: CineTypography.bodyMedium,
                ),
                const SizedBox(height: CineSpacing.sm),
                Text(
                  'Please try again.',
                  textAlign: TextAlign.center,
                  style: CineTypography.bodyMedium.copyWith(
                    color: CineColors.textSecondary,
                  ),
                ),
                const SizedBox(height: CineSpacing.lg),
                OutlinedButton(
                  onPressed: onRetry,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: CineColors.amber,
                    side: const BorderSide(color: CineColors.amber),
                    padding: const EdgeInsets.symmetric(
                      horizontal: CineSpacing.xxl,
                      vertical: CineSpacing.md,
                    ),
                  ),
                  child: const Text('Retry'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
