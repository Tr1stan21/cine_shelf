import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/movie_poster.dart';
import '../../data/movies_providers.dart';

final popularMoviesProvider = FutureProvider<List<MoviePoster>>((ref) async {
  final repo = ref.watch(moviesRepositoryProvider);
  return repo.getPopularMovies(page: 1);
});
