import '../domain/movies_repository.dart';
import '../models/movie_poster.dart';
import '../mappers/movie_mapper.dart';
import 'tmdb_remote_data_source.dart';

class MoviesRepositoryImpl implements MoviesRepository {
  final TmdbRemoteDataSource _remote;

  MoviesRepositoryImpl(this._remote);

  @override
  Future<List<MoviePoster>> getPopularMovies({int page = 1}) async {
    final dto = await _remote.getPopularMovies(page: page);
    return dto.results.map((e) => e.toAppModel()).toList();
  }
}
