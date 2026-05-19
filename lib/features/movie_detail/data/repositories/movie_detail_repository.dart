import '../../models/movie_detail.dart';

abstract class MovieDetailRepository {
  Future<MovieDetail> getMovieDetail(int movieId);
}
