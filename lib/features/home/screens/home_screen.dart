import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:cine_shelf/shared/config/constants.dart';
import 'package:cine_shelf/shared/config/theme.dart';
import 'package:cine_shelf/features/home/widgets/movie_list_section.dart';
import 'package:cine_shelf/features/home/widgets/search_bar.dart';
import 'package:cine_shelf/shared/widgets/separators.dart';
import 'package:cine_shelf/features/movies/models/tmdb/list_category.dart';
import 'package:cine_shelf/features/movies/application/movies_provider.dart';

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
        ],
      ),
    );
  }
}

/// Widget auxiliar que encapsula la lógica async de cada sección.
///
/// Extraerlo evita repetir el mismo bloque `asyncValue.when(…)` 4 veces.
class _MovieSection extends ConsumerWidget {
  const _MovieSection({required this.category, required this.title});

  final ListCategory category;
  final String title;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncMovies = ref.watch(moviesProvider(category));

    return asyncMovies.when(
      data: (items) => MovieListSection(title: title, items: items),
      loading: () => const Padding(
        padding: EdgeInsets.symmetric(vertical: CineSpacing.xxxl),
        child: Center(child: CircularProgressIndicator()),
      ),
      error: (_, __) => const SizedBox.shrink(),
    );
  }
}
