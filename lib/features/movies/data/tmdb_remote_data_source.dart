import 'package:dio/dio.dart';
import '../models/tmdb/category_movies_dto.dart';
import '../models/tmdb/list_category.dart';
import '../models/tmdb/movie_detail_dto.dart';

class TmdbRemoteDataSource {
  final Dio _dio;

  TmdbRemoteDataSource(this._dio);

  Future<CategoryMoviesDto> getMovies(
    ListCategory category, {
    int page = 1,
  }) async {
    final response = await _dio.get(
      '/movie/${category.path}',
      queryParameters: {'page': page},
    );
    return CategoryMoviesDto.fromJson(response.data as Map<String, dynamic>);
  }

  /// Obtiene el detalle de una película por su id TMDB.
  ///
  /// Usa el endpoint /movie/{movie_id} que retorna directamente el detalle.
  Future<MovieDetailDto> getMovieDetail(int movieId) async {
    final response = await _dio.get('/movie/$movieId');
    return MovieDetailDto.fromJson(response.data as Map<String, dynamic>);
  }
}
