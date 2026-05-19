import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cine_shelf/core/network/dio_provider.dart';
import 'package:cine_shelf/features/search/data/repositories/movie_search_repository.dart';
import 'package:cine_shelf/features/search/data/repositories/tmdb_movie_search_repository_impl.dart';
import 'package:cine_shelf/features/search/data/sources/tmdb_search_source.dart';

final movieSearchRepositoryProvider = Provider<MovieSearchRepository>((ref) {
  final dio = ref.watch(dioProvider);
  return TmdbMovieSearchRepositoryImpl(TmdbSearchSource(dio));
});
