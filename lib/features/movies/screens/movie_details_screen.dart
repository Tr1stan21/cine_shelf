import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:cine_shelf/shared/config/theme.dart';
import 'package:cine_shelf/shared/config/constants.dart';
import 'package:cine_shelf/features/movies/widgets/movie_button.dart';

/// Detailed view of a single movie.
///
/// Layout structure:
/// - Full-width hero poster image at top
/// - Scrollable content panel overlapping poster with rounded top corners
/// - Movie metadata: title, year, genres
/// - Synopsis text
/// - Star rating display
/// - Action buttons: Favorite, Watchlist, Watched, Add to List
/// - Back button overlay in top-left corner
///
/// Currently displays static placeholder data.
/// TODO: Integrate with movie API using [movieId] parameter.
class MovieDetailsScreen extends StatelessWidget {
  const MovieDetailsScreen({super.key, this.movieId});

  final String? movieId;

  static const _topImageUrl = AppConstants.urlPlaceholderPoster;
  static const int _maxStars = 5;
  static const String _favoriteLabel = 'Favorite';
  static const String _watchlistLabel = 'Watchlist';
  static const String _seenLabel = 'Watched';
  static const String _listLabel = 'List...';
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
                        image: AssetImage(AppConstants.backgroundPath),
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
                                text: '  |  Science Fiction, Drama, Mystery',
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
                          'A new blade runner, Officer K of the Los Angeles Police Department, '
                          'uncovers a long-hidden secret that has the potential to plunge what remains '
                          'of society into chaos. A new blade runner, Officer K of the Los Angeles Police '
                          'Department, uncovers a long-hidden secret that has the potential to plunge what '
                          'remains of society into chaos. A new blade runner, Officer K of the Los Angeles '
                          'Police Department, uncovers a long-hidden secret that has the potential to plunge '
                          'what remains of society into chaos.',
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
