import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:cine_shelf/config/theme.dart';
import 'package:cine_shelf/core/constants.dart';
import 'package:cine_shelf/models/movie_item.dart';
import 'package:cine_shelf/router/app_router.dart';

/// Widget que muestra una sección horizontal de películas con título y botón de navegación
///
/// Presenta un carrusel horizontal de posters de películas con:
/// - Título de la sección
/// - Botón de navegación para ver la lista completa
/// - Lista horizontal scrolleable de posters
class MovieListSection extends StatelessWidget {
  const MovieListSection({required this.title, required this.items, super.key});

  final String title;
  final List<MovieItem> items;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: CineSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header con título y botón de navegación
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: CineTypography.headline2),
              IconButton(
                icon: const Icon(
                  Icons.arrow_forward_ios,
                  color: CineColors.amber,
                ),
                onPressed: () => context.push(
                  '/movies',
                  extra: MovieListArgs(title: title, items: items),
                ),
              ),
            ],
          ),

          // Lista horizontal de películas
          LayoutBuilder(
            builder: (context, constraints) {
              final availableW = constraints.maxWidth;
              final totalSpacing =
                  AppConstants.itemSpacing * (AppConstants.postersVisible - 1);
              final posterW =
                  (availableW - totalSpacing) / AppConstants.postersVisible;
              final posterH = posterW / AppConstants.posterAspectRatio;

              return SizedBox(
                height: posterH,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: items.length,
                  separatorBuilder: (_, index) =>
                      const SizedBox(width: AppConstants.itemSpacing),
                  itemBuilder: (context, index) {
                    return SizedBox(
                      width: posterW,
                      child: GestureDetector(
                        onTap: () => context.push(
                          '/movies/details',
                          extra: MovieDetailsArgs(movieId: items[index].id),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(CineRadius.md),
                          child: Image.network(
                            items[index].imageUrl,
                            fit: BoxFit.cover,
                            filterQuality: FilterQuality.low,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
