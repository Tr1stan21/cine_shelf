import 'dart:convert';

import 'package:cine_shelf/core/database/drift_database.dart';
import 'package:cine_shelf/features/movie_detail/models/movie_detail.dart';
import 'package:cine_shelf/shared/config/constants.dart';

/// Extension providing mapping from cached movie data to app MovieDetail model.
///
/// Converts [CachedMoviesData] (Drift representation) to [MovieDetail]
/// (app-level data model) for use in the movie details screen.
///
/// **Usage:**
/// ```dart
/// final cached = await movieDataSource.getMovieDetail(movieId);
/// if (cached != null) {
///   final detail = cached.toMovieDetail();
/// }
/// ```
extension CachedMovieToDetailMapper on CachedMoviesData {
  /// Converts [CachedMoviesData] to [MovieDetail].
  ///
  /// **Mapping:**
  /// - movieId → id
  /// - title → title
  /// - posterPath → posterUrl (via [AppConstants.tmdbPosterUrl])
  /// - releaseDate → year (extracts from ISO date string)
  /// - genresJson → genres (deserializes JSON array)
  /// - overview → overview
  ///
  /// **Returns:** [MovieDetail] with cached data
  ///
  /// **Fallback handling:**
  /// - If releaseDate is null or unparseable, year defaults to "Unknown"
  /// - If genresJson is null or invalid, genres defaults to empty list
  /// - If posterPath is null, uses default placeholder
  MovieDetail toMovieDetail() {
    // Extract year from ISO date (e.g., "2023-12-15" → "2023")
    final year = _extractYear(releaseDate);

    // Deserialize genres from JSON
    final genres = _deserializeGenres(genresJson);

    // Construct full poster URL
    final posterUrl = AppConstants.tmdbPosterUrl(posterPath);

    return MovieDetail(
      id: movieId,
      title: title.isNotEmpty ? title : 'Unknown title',
      posterUrl: posterUrl,
      year: year,
      genres: genres,
      overview: overview ?? '',
    );
  }

  /// Extracts year from ISO date string.
  ///
  /// **Input format:** "2023-12-15" or null
  /// **Output:** "2023" or "Unknown" if parsing fails
  static String _extractYear(String? dateString) {
    if (dateString == null || dateString.isEmpty) {
      return 'Unknown';
    }

    try {
      final year = dateString.split('-').first;
      return year.isNotEmpty ? year : 'Unknown';
    } catch (e) {
      return 'Unknown';
    }
  }

  /// Deserializes genre list from JSON.
  ///
  /// **Input format:** '[{"name": "Action"}, {"name": "Drama"}]' or null
  /// **Output:** ['Action', 'Drama'] or [] if parsing fails
  static List<String> _deserializeGenres(String? genresJson) {
    if (genresJson == null || genresJson.isEmpty) {
      return [];
    }

    try {
      final parsed = jsonDecode(genresJson) as List;
      return parsed
          .cast<Map<String, dynamic>>()
          .map((g) => (g['name'] as String?) ?? '')
          .where((name) => name.isNotEmpty)
          .toList();
    } catch (e) {
      return [];
    }
  }
}
