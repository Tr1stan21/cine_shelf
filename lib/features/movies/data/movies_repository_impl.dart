import 'movies_repository.dart';
import '../models/movie_poster.dart';
import '../mappers/movie_poster_dto_mapper.dart';
import '../mappers/movie_detail_dto_mapper.dart';
import 'tmdb_remote_data_source.dart';
import '../models/tmdb/list_category.dart';
import '../models/movie_detail.dart';

class MoviesRepositoryImpl implements MoviesRepository {
  final TmdbRemoteDataSource _remote;

  MoviesRepositoryImpl(this._remote);

  @override
  Future<List<MoviePoster>> getMovies(
    ListCategory category, {
    int page = 1,
  }) async {
    final dto = await _remote.getMovies(category, page: page);
    return dto.results.map((e) => e.toAppModel()).toList();
  }

  @override
  Future<MovieDetail> getMovieDetail(int movieId) async {
    // El endpoint /movie/{id} ya incluye los géneros resueltos
    final dto = await _remote.getMovieDetail(movieId);
    return dto.toMovieDetail();
  }
}
