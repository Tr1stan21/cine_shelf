import 'package:dio/dio.dart';

import '../dto/movie_detail_dto.dart';

class TmdbMovieDetailSource {
  static const String _fixedLanguage = 'en-US';

  final Dio _dio;

  const TmdbMovieDetailSource(this._dio);

  Future<MovieDetailDto> getMovieDetail(int movieId) async {
    final response = await _dio.get(
      '/movie/$movieId',
      queryParameters: {'language': _fixedLanguage},
    );

    return MovieDetailDto.fromJson(response.data as Map<String, dynamic>);
  }
}
