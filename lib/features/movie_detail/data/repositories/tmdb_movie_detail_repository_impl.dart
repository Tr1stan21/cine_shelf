import 'dart:async';
import 'package:flutter/foundation.dart';

import 'package:cine_shelf/features/movie_detail/data/local/movie_cache_datasource.dart';
import 'package:cine_shelf/features/movie_detail/data/local/movie_cache_mapper.dart';
import 'package:cine_shelf/features/movie_detail/data/dto/movie_detail_dto.dart';
import 'movie_detail_repository.dart';
import 'package:cine_shelf/features/movie_detail/data/sources/tmdb_movie_detail_source.dart';
import 'package:cine_shelf/features/movie_detail/mappers/movie_detail_mapper.dart';
import 'package:cine_shelf/features/movie_detail/models/movie_detail.dart';

class TmdbMovieDetailRepositoryImpl implements MovieDetailRepository {
  /// Creates a [TmdbMovieDetailRepositoryImpl] with TMDB and cache dependencies.
  ///
  /// **Parameters:**
  /// - [_remote]: TMDB remote data source
  /// - [_movieCacheDataSource]: Local Drift data source for offline caching
  TmdbMovieDetailRepositoryImpl(
    this._remote,
    this._movieCacheDataSource,
  );

  final TmdbMovieDetailSource _remote;
  final MovieCacheLocalDataSource _movieCacheDataSource;

  @override
  Future<MovieDetail> getMovieDetail(int movieId) async {
    try {
      // ATTEMPT REMOTE
      final dto = await _remote.getMovieDetail(movieId);
      final detail = dto.toMovieDetail();

      // CACHE LOCALLY (fire & forget)
      unawaited(_cacheMovieInBackground(detail, dto));

      return detail;
    } catch (e) {
      // REMOTE FAILED: try local cache
      debugPrint('MOVIE DETAIL REMOTE ERROR: $e, attempting cache fallback');

      final cached = await _movieCacheDataSource.getMovieDetail(movieId);
      if (cached != null) {
        debugPrint('MOVIE DETAIL CACHE HIT: returning cached data for movie $movieId');
        return cached.toMovieDetail();
      }

      // Cache miss: rethrow to propagate error to UI
      debugPrint('MOVIE DETAIL CACHE MISS: no cached data for movie $movieId');
      rethrow;
    }
  }

  /// Background task to cache movie detail.
  ///
  /// **Behavior:**
  /// - Extracts genre names and poster path from DTO
  /// - Stores in local cache via datasource
  /// - Silent on error (fire & forget)
  ///
  /// **Parameters:**
  /// - [detail]: [MovieDetail] app model
  /// - [dto]: [MovieDetailDto] with raw TMDB data (genre objects, etc.)
  Future<void> _cacheMovieInBackground(
    MovieDetail detail,
    MovieDetailDto dto,
  ) async {
    try {
      await _movieCacheDataSource.cacheMovieDetail(
        movieDetail: detail,
        genresList: dto.genres.map((g) => g.name).toList(),
        posterPath: dto.posterPath,
        releaseDate: dto.releaseDate,
      );
    } catch (e, st) {
      debugPrint('ERROR caching movie detail in background: $e\n$st');
    }
  }
}
