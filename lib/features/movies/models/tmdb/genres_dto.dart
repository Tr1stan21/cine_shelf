class GenresResponseDto {
  final List<GenreDto> genres;

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

class GenreDto {
  final int id;
  final String name;

  GenreDto({required this.id, required this.name});

  factory GenreDto.fromJson(Map<String, dynamic> json) {
    return GenreDto(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
    );
  }
}
