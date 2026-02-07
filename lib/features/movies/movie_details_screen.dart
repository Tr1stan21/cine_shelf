import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:cine_shelf/config/theme.dart';
import 'package:cine_shelf/core/constants.dart';
import 'package:cine_shelf/features/movies/widgets/movie_button.dart';

/// Pantalla de detalles de una pelÃ­cula
///
/// Muestra informaciÃ³n detallada incluyendo poster, tÃ­tulo, aÃ±o,
/// gÃ©neros, sinopsis, calificaciÃ³n y botones de acciÃ³n
/// (favorito, watchlist, visto, listas).
class MovieDetailsScreen extends StatelessWidget {
  const MovieDetailsScreen({super.key, this.movieId});

  final String? movieId;

  static const _topImageUrl = AppConstants.urlPlaceholderPoster;
  static const int _maxStars = 5;
  static const String _favoriteLabel = 'Favorito';
  static const String _watchlistLabel = 'Watchlist';
  static const String _seenLabel = 'Visto';
  static const String _listLabel = 'Lista...';
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);

    const overlap = 26.0;
    final panelHeight = size.height * 0.44;

    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: size.height - panelHeight + overlap,
                  width: double.infinity,
                  child: Image.network(_topImageUrl, fit: BoxFit.cover),
                ),
                SafeArea(
                  top: false,
                  child: Container(
                    padding: const EdgeInsets.all(CineSpacing.xl),
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(AppConstants.background),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 2),
                        const Text(
                          'Blade Runner 2049',
                          style: CineTypography.headline1,
                        ),
                        const SizedBox(height: CineSpacing.sm),
                        const Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: '2017',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: CineColors.amber,
                                ),
                              ),
                              TextSpan(
                                text: '  |  Ciencia ficción, Drama, Misterio',
                                style: TextStyle(
                                  color: CineColors.textSecondary,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: CineSpacing.lg),
                        const Text(
                          'Un nuevo blade runner, el oficial K de la policí­a de\n'
                          'Los Ãngeles, descubre un secreto largamente oculto\n'
                          'que tiene el potencial de sumir lo que queda de la\n'
                          'sociedad en el caos.'
                          'Un nuevo blade runner, el oficial K de la policí­a de\n'
                          'Los Ãngeles, descubre un secreto largamente oculto\n'
                          'que tiene el potencial de sumir lo que queda de la\n'
                          'sociedad en el caos.'
                          'Un nuevo blade runner, el oficial K de la policí­a de\n'
                          'Los Ãngeles, descubre un secreto largamente oculto\n'
                          'que tiene el potencial de sumir lo que queda de la\n'
                          'sociedad en el caos.',
                          style: TextStyle(
                            fontSize: 14,
                            height: 1.35,
                            color: CineColors.textLight,
                          ),
                        ),
                        const SizedBox(height: CineSpacing.lg),
                        Row(
                          children: List.generate(
                            _maxStars,
                            (_) => const Padding(
                              padding: EdgeInsets.only(right: 6),
                              child: Icon(
                                Icons.star,
                                size: 22,
                                color: CineColors.amber,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: CineSpacing.xxxl),
                        const Row(
                          children: [
                            Expanded(
                              child: MovieActionButton(
                                label: _favoriteLabel,
                                icon: Icons.favorite,
                                backgroundColor: Color(0xFFB56610),
                                foregroundColor: CineColors.white,
                              ),
                            ),
                            SizedBox(width: CineSpacing.md),
                            Expanded(
                              child: MovieActionButton(
                                label: _watchlistLabel,
                                icon: Icons.access_time_rounded,
                                outlined: true,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: CineSpacing.md),
                        const Row(
                          children: [
                            Expanded(
                              child: MovieActionButton(
                                label: _seenLabel,
                                icon: Icons.check_rounded,
                                backgroundColor: Color(0xFF7A3E07),
                                foregroundColor: CineColors.amber,
                                trailingIcon: Icons.check_rounded,
                              ),
                            ),
                            SizedBox(width: CineSpacing.md),
                            Expanded(
                              child: MovieActionButton(
                                label: _listLabel,
                                icon: Icons.add,
                                outlined: true,
                                trailingIcon: Icons.chevron_right_rounded,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: GestureDetector(
                onTap: () => context.pop(),
                child: Container(
                  width: 34,
                  height: 34,
                  decoration: const BoxDecoration(
                    color: Color(0xFF101012),
                    shape: BoxShape.circle,
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.arrow_back,
                      size: 18,
                      color: CineColors.amber,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
