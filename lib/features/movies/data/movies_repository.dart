import '../models/movie_poster.dart';
import '../models/tmdb/list_category.dart';
import '../models/movie_detail.dart';

abstract class MoviesRepository {
  Future<List<MoviePoster>> getMovies(ListCategory category, {int page = 1});
  Future<MovieDetail> getMovieDetail(int movieId);
}
