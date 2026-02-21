import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'tmdb_providers.dart';
import 'movies_repository_impl.dart';
import '../domain/movies_repository.dart';

final moviesRepositoryProvider = Provider<MoviesRepository>((ref) {
  final remote = ref.watch(tmdbRemoteDataSourceProvider);
  return MoviesRepositoryImpl(remote);
});
