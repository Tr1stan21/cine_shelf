import 'dart:convert';

import 'package:cine_shelf/core/database/drift_database.dart';
import 'package:cine_shelf/shared/models/movie_poster.dart';

/// Extension providing mapping from cached movie data to app models.
///
/// Converts [CachedMoviesData] (Drift representation) to lightweight
/// [MoviePoster] for use in list displays.
///
/// **Usage:**
/// ```dart
/// final cachedMovies = await movieDataSource.getMoviesByList(uid, listId);
/// final posters = cachedMovies.map((m) => m.toMoviePoster()).toList();
/// ```
extension CachedMovieMapper on CachedMoviesData {
  /// Converts [CachedMoviesData] to [MoviePoster].
  ///
  /// **Mapping:**
  /// - movieId → id
  /// - posterPath → posterPath
  ///
  /// **Returns:** [MoviePoster] with cached poster data
  MoviePoster toMoviePoster() {
    return MoviePoster(id: movieId, posterPath: posterPath);
  }

  /// Parses genresJson (if present) into a list of genre maps.
  ///
  /// **Returns:**
  /// - List of `Map<String, dynamic>` with 'id' and 'name' fields
  /// - Empty list if genresJson is null or invalid JSON
  ///
  /// **Usage:**
  /// For reconstructing full movie details from cache.
  List<Map<String, dynamic>> getGenres() {
    if (genresJson == null || genresJson!.isEmpty) {
      return [];
    }

    try {
      final parsed = jsonDecode(genresJson!) as List;
      return parsed.cast<Map<String, dynamic>>();
    } catch (e) {
      return [];
    }
  }
}
