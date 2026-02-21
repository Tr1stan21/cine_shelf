import 'package:dio/dio.dart';
import '../models/tmdb/popular_movies_dto.dart';

class TmdbRemoteDataSource {
  final Dio _dio;

  TmdbRemoteDataSource(this._dio);

  Future<PopularMoviesDto> getPopularMovies({int page = 1}) async {
    final response = await _dio.get(
      '/movie/popular',
      queryParameters: {'page': page},
    );

    return PopularMoviesDto.fromJson(response.data as Map<String, dynamic>);
  }
}
