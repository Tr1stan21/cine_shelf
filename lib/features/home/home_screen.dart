import 'package:flutter/material.dart';

import 'package:cine_shelf/config/theme.dart';
import 'package:cine_shelf/core/constants.dart';
import 'package:cine_shelf/core/widgets/background.dart';
import 'package:cine_shelf/features/home/widgets/movie_list_section.dart';
import 'package:cine_shelf/features/home/widgets/search_bar.dart';
import 'package:cine_shelf/features/home/widgets/separators.dart';
import 'package:cine_shelf/mock/movie_data.dart';

/// Pantalla principal de la aplicación
///
/// Muestra el logo, barra de búsqueda y secciones de películas
/// organizadas por categorías (últimos estrenos, más valoradas, populares).
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static const String _latestReleases = 'Últimos Estrenos';
  static const String _topRated = 'Más Valoradas';
  static const String _popular = 'Populares';

  @override
  Widget build(BuildContext context) {
    return Background(
      padding: const EdgeInsets.symmetric(horizontal: CineSpacing.md),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Image.asset(AppConstants.logoPath, height: 100),
            const SizedBox(height: 20),
            CineSearchBar(onChanged: (v) {}, onSubmitted: (v) {}),
            MovieListSection(title: _latestReleases, items: MovieData.m),
            const GlowSeparator(),
            MovieListSection(title: _topRated, items: MovieData.s),
            const GlowSeparator(),
            MovieListSection(title: _popular, items: MovieData.s),
          ],
        ),
      ),
    );
  }
}
