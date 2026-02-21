abstract class Env {
  static const String tmdbApiKey = String.fromEnvironment('TMDB_API_KEY');
  static const String tmdbReadToken = String.fromEnvironment('TMDB_READ_TOKEN');

  static bool get isTmdbConfigured =>
      tmdbApiKey.isNotEmpty && tmdbReadToken.isNotEmpty;
}
