import 'package:cine_shelf/features/search/data/repositories/movie_search_repository.dart';
import 'package:cine_shelf/features/search/data/sources/tmdb_search_source.dart';
import 'package:cine_shelf/features/search/mappers/movie_search_mapper.dart';
import 'package:cine_shelf/features/search/models/paginated_movie_search_results.dart';

class TmdbMovieSearchRepositoryImpl implements MovieSearchRepository {
  final TmdbSearchSource _remote;

  TmdbMovieSearchRepositoryImpl(this._remote);

  @override
  Future<PaginatedMovieSearchResults> searchMovies({
    required String query,
    int page = 1,
    String region = 'US',
  }) async {
    final dto = await _remote.searchMovies(
      query: query,
      page: page,
      region: region,
    );
    return dto.toAppModel();
  }
}
