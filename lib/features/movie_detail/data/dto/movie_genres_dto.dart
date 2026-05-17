/// Data Transfer Object for TMDB genre list response.
///
/// Represents the response from TMDB's genre endpoints.
/// Contains a list of all available genres with IDs and names.
class GenresResponseDto {
  /// List of all available genres.
  final List<GenreDto> genres;

  /// Creates a GenresResponseDto with a list of genres.
  GenresResponseDto({required this.genres});

  factory GenresResponseDto.fromJson(Map<String, dynamic> json) {
    final list = (json['genres'] as List<dynamic>? ?? const []);
    return GenresResponseDto(
      genres: list
          .map((e) => GenreDto.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

/// Data Transfer Object representing a single genre.
///
/// Received from TMDB API responses, contains the genre ID and display name.
/// Used in [MovieDetailDto] where genres are resolved server-side.
class GenreDto {
  /// Unique TMDB genre identifier.
  final int id;

  /// Display name of the genre (e.g., "Action", "Comedy").
  final String name;

  /// Creates a GenreDTO with an ID and name.
  GenreDto({required this.id, required this.name});

  factory GenreDto.fromJson(Map<String, dynamic> json) {
    return GenreDto(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
    );
  }
}
