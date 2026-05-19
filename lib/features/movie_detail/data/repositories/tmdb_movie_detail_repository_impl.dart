import 'movie_detail_repository.dart';
import 'package:cine_shelf/features/movie_detail/data/sources/tmdb_movie_detail_source.dart';
import 'package:cine_shelf/features/movie_detail/mappers/movie_detail_mapper.dart';
import 'package:cine_shelf/features/movie_detail/models/movie_detail.dart';

class TmdbMovieDetailRepositoryImpl implements MovieDetailRepository {
  final TmdbMovieDetailSource _remote;

  TmdbMovieDetailRepositoryImpl(this._remote);

  @override
  Future<MovieDetail> getMovieDetail(int movieId) async {
    final dto = await _remote.getMovieDetail(movieId);
    return dto.toMovieDetail();
  }
}
