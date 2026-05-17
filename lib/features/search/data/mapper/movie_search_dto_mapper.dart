import '../../models/movie_search_result.dart';
import '../../models/paginated_movie_search_results.dart';
import '../dto/search_movies_dto.dart';

extension SearchMoviesDtoMapper on SearchMoviesDto {
  PaginatedMovieSearchResults toAppModel() {
    return PaginatedMovieSearchResults(
      page: page,
      totalPages: totalPages,
      results: results.map((e) => e.toAppModel()).toList(),
    );
  }
}

extension SearchMovieDtoMapper on SearchMovieDto {
  MovieSearchResult toAppModel() {
    return MovieSearchResult(
      id: id,
      title: title,
      posterPath: posterPath,
      releaseDate: releaseDate,
    );
  }
}
