import '../models/movie_poster.dart';

abstract class MoviesRepository {
  Future<List<MoviePoster>> getPopularMovies({int page = 1});
}
