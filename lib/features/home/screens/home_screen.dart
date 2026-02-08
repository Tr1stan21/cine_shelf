import 'package:flutter/material.dart';

import 'package:cine_shelf/shared/config/constants.dart';
import 'package:cine_shelf/features/home/widgets/movie_list_section.dart';
import 'package:cine_shelf/features/home/widgets/search_bar.dart';
import 'package:cine_shelf/features/home/widgets/separators.dart';
import 'package:cine_shelf/shared/mock/movie_data.dart';

/// Home screen of the application
///
/// Displays the logo, search bar, and movie sections
/// organized by categories (latest releases, top rated, popular).
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static const String _trendingToday = 'Trending Today';
  static const String _latestReleases = 'Latest Releases';
  static const String _popular = 'Popular';
  static const String _topRated = 'Top Rated';

  static const String _genreSpotlight1 = 'Genre Spotlight';
  static const String _genreSpotlight2 = 'More From This Genre';

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Image.asset(AppConstants.logoPath, height: 100),
          const SizedBox(height: 20),
          CineSearchBar(onChanged: (v) {}, onSubmitted: (v) {}),

          // 1) Impacto + frescura
          MovieListSection(title: _trendingToday, items: MovieData.medium),
          const GlowSeparator(),

          // 2) Novedades “tipo Netflix”
          MovieListSection(title: _latestReleases, items: MovieData.medium),
          const GlowSeparator(),

          // 3) Apuesta segura
          MovieListSection(title: _popular, items: MovieData.small),
          const GlowSeparator(),

          // 4) Autoridad / cinéfilos
          MovieListSection(title: _topRated, items: MovieData.small),
          const GlowSeparator(),

          // 5) Dinámica por género (slot 1)
          MovieListSection(title: _genreSpotlight1, items: MovieData.small),
          const GlowSeparator(),

          // 6) Dinámica por género (slot 2)
          MovieListSection(title: _genreSpotlight2, items: MovieData.small),
        ],
      ),
    );
  }
}
