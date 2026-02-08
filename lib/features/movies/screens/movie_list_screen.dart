import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:cine_shelf/shared/config/theme.dart';
import 'package:cine_shelf/shared/config/constants.dart';
import 'package:cine_shelf/shared/widgets/background.dart';
import 'package:cine_shelf/features/movies/models/movie.dart';
import 'package:cine_shelf/router/app_router.dart';

/// Screen displaying a complete movie list in grid format
///
/// Organizes movies in a 3-column grid and allows
/// navigation to details when tapping any movie.
class MovieListScreen extends StatelessWidget {
  const MovieListScreen({required this.title, required this.items, super.key});

  final String title;
  final List<Movie> items;

  @override
  Widget build(BuildContext context) {
    return Background(
      padding: const EdgeInsets.symmetric(horizontal: CineSpacing.md),
      child: Column(
        children: [
          Text(title, style: CineTypography.headline2),
          const SizedBox(height: CineSpacing.md),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: (items.length / AppConstants.moviesPerRow).ceil(),
              itemBuilder: (context, rowIndex) {
                final start = rowIndex * AppConstants.moviesPerRow;
                final end = (start + AppConstants.moviesPerRow).clamp(
                  0,
                  items.length,
                );
                final rowItems = items.sublist(start, end);

                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    children: List.generate(AppConstants.moviesPerRow, (i) {
                      if (i >= rowItems.length) {
                        return const Expanded(child: SizedBox());
                      }

                      final item = rowItems[i];

                      return Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: GestureDetector(
                            onTap: () => context.push(
                              '/movies/details',
                              extra: MovieDetailsArgs(movieId: item.id),
                            ),
                            child: AspectRatio(
                              aspectRatio: AppConstants.posterAspectRatio,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(
                                  CineRadius.md,
                                ),
                                child: Image.network(
                                  item.imageUrl,
                                  fit: BoxFit.cover,
                                  filterQuality: FilterQuality.low,
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
