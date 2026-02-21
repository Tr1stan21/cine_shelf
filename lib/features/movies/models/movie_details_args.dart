import 'package:cine_shelf/features/movies/models/movie_poster.dart';

/// Arguments for MovieDetailsScreen
///
/// Carries movie identifier for detail screen navigation.
class MovieDetailsArgs {
  const MovieDetailsArgs({required this.movie});

  final MoviePoster movie;
}
