import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../movies/data/movies_providers.dart';
import '../../movies/models/movie_discovery_query.dart';
import '../../movies/models/tmdb/movie_genres_catalog.dart';
import '../../region/application/region_providers.dart';

/// Returns 3 random genres selected for Home sections.
///
/// Selection is stable for the active app session and tries to prioritize
/// genres that have at least one movie on page 1 for the current region.
final homeRandomGenreSectionsProvider =
    FutureProvider.autoDispose<List<MovieGenre>>((ref) async {
      // Keep the selection alive for the whole app session so that navigating
      // between tabs does not re-roll the genres.
      ref.keepAlive();

      const targetCount = 3;
      const maxAttempts = 9;
      const minUsefulMovies = 1;

      final genres = List<MovieGenre>.from(MovieGenresCatalog.all);
      genres.shuffle(Random());

      if (genres.length <= targetCount) {
        return genres;
      }

      final repository = ref.watch(moviesRepositoryProvider);
      final region = ref.watch(selectedRegionCodeProvider);

      final selected = <MovieGenre>[];
      final usedIds = <int>{};

      final attempts = maxAttempts.clamp(0, genres.length);
      for (var i = 0; i < attempts; i++) {
        final genre = genres[i];
        try {
          final page = await repository.getMoviesPageByQuery(
            MovieDiscoveryQuery.genre(genre.id),
            page: 1,
            region: region,
          );
          final usefulCount = page.movies
              .where((m) => m.posterPath != null)
              .length;
          if (usefulCount >= minUsefulMovies) {
            selected.add(genre);
            usedIds.add(genre.id);
            if (selected.length == targetCount) {
              return selected;
            }
          }
        } catch (_) {
          // Keep sampling other genres when one probe fails.
          continue;
        }
      }

      // Fallback: fill the remaining slots from the shuffled catalog, even if
      // they have low availability, so Home always renders 3 genre sections.
      for (final genre in genres) {
        if (usedIds.contains(genre.id)) {
          continue;
        }
        selected.add(genre);
        usedIds.add(genre.id);
        if (selected.length == targetCount) {
          break;
        }
      }

      return selected;
    });
