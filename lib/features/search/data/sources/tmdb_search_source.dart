import 'package:dio/dio.dart';

import '../dto/search_movies_dto.dart';

class TmdbSearchSource {
  static const String _fixedLanguage = 'en-US';

  final Dio _dio;

  const TmdbSearchSource(this._dio);

  Future<SearchMoviesDto> searchMovies({
    required String query,
    int page = 1,
    String region = 'US',
  }) async {
    final response = await _dio.get(
      '/search/movie',
      queryParameters: {
        'query': query,
        'page': page,
        'include_adult': false,
        'region': region.toUpperCase(),
        'language': _fixedLanguage,
      },
    );

    return SearchMoviesDto.fromJson(response.data as Map<String, dynamic>);
  }
}
