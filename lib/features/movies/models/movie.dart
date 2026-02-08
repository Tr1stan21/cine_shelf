/// Data model for a movie
///
/// Represents basic movie information displayed
/// in lists and carousels throughout the application.
class Movie {
  const Movie({required this.title, required this.imageUrl, required this.id});

  /// Movie title
  final String title;

  /// Poster image URL
  final String imageUrl;

  /// Unique ID to identify the movie
  final String id;
}
