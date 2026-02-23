/// Environment configuration for CineShelf.
///
/// Provides compile-time constants injected via `--dart-define` or
/// a `.env`-equivalent build system (e.g., `flutter run --dart-define=TMDB_API_KEY=xxx`).
///
/// **Usage in CI/CD:**
/// Pass secrets as `--dart-define` flags to avoid committing them to source control.
///
/// **Validation:**
/// Use [isTmdbConfigured] at startup or in debug builds to detect missing
/// configuration early, before API calls fail at runtime.
abstract class Env {
  /// TMDB API key (v3 auth).
  ///
  /// Used for endpoints that accept `?api_key=` query parameter authentication.
  /// Injected at build time via `--dart-define=TMDB_API_KEY=<value>`.
  static const String tmdbApiKey = String.fromEnvironment('TMDB_API_KEY');

  /// TMDB read-access token (v4 Bearer auth).
  ///
  /// Used as the `Authorization: Bearer <token>` header in all API requests
  /// configured in [dioProvider]. Preferred over [tmdbApiKey] for v3 endpoints
  /// as it provides finer-grained permission scoping.
  /// Injected at build time via `--dart-define=TMDB_READ_TOKEN=<value>`.
  static const String tmdbReadToken = String.fromEnvironment('TMDB_READ_TOKEN');

  /// Returns `true` if both TMDB credentials are present.
  ///
  /// Useful for guard clauses in debug builds or startup checks.
  /// Both values are empty strings when the `--dart-define` flags are omitted.
  static bool get isTmdbConfigured =>
      tmdbApiKey.isNotEmpty && tmdbReadToken.isNotEmpty;
}
