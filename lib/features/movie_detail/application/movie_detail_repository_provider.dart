import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cine_shelf/core/network/dio_provider.dart';
import 'package:cine_shelf/features/movie_detail/data/repositories/movie_detail_repository.dart';
import 'package:cine_shelf/features/movie_detail/data/repositories/tmdb_movie_detail_repository_impl.dart';
import 'package:cine_shelf/features/movie_detail/data/sources/tmdb_movie_detail_source.dart';

final movieDetailRepositoryProvider = Provider<MovieDetailRepository>((ref) {
  final dio = ref.watch(dioProvider);
  return TmdbMovieDetailRepositoryImpl(TmdbMovieDetailSource(dio));
});
