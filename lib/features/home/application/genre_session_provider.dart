import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:cine_shelf/shared/movies/models/movie_genres_catalog.dart';
import 'package:cine_shelf/shared/movies/models/movie_genre.dart';

/// Shuffled genre order for the current provider session.
///
/// The shuffle happens once when Riverpod creates this provider. Every genre
/// section can then read a stable index from the same randomized list.
final genreSessionProvider = Provider<List<MovieGenre>>((ref) {
  final shuffled = <MovieGenre>[...MovieGenresCatalog.all]..shuffle();
  return shuffled;
});
