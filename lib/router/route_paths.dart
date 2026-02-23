/// Centralized route path constants for the CineShelf application.
///
/// All navigation in GoRouter uses these string constants to avoid
/// hard-coded paths scattered across the codebase.
///
/// **Route groups:**
/// - Public: [splash], [login], [signUp] — accessible without authentication.
/// - Protected: [home], [myLists], [account], [movies], [movieDetails], [credits]
///   — redirect to [login] when the user is not authenticated.
///
/// Use [isProtectedRoute] to check membership at runtime (e.g., in redirect logic).
/// Use [authRoutes] to check if the current location is an auth-only screen
/// (used to redirect already-authenticated users away from login/sign-up).
class RoutePaths {
  RoutePaths._();

  // ── Public routes ──────────────────────────────────────────────────────────

  /// Initial route shown while auth state is being determined.
  static const String splash = '/';

  /// Email/password login screen.
  static const String login = '/login';

  /// New account registration screen.
  static const String signUp = '/sign-up';

  // ── Protected routes (require authentication) ──────────────────────────────

  /// Main home screen with categorized movie carousels.
  static const String home = '/home';

  /// User's personal movie lists (watched, watchlist, favorites).
  static const String myLists = '/mylists';

  /// User profile and account settings.
  static const String account = '/account';

  /// Full-screen movie grid list (supports infinite scroll).
  static const String movies = '/movies';

  /// Movie detail screen (poster, overview, genres).
  static const String movieDetails = '/movies/details';

  /// App credits and third-party attributions.
  static const String credits = '/credits';

  // ── Route sets ─────────────────────────────────────────────────────────────

  /// Route prefixes that require the user to be authenticated.
  ///
  /// Used by [isProtectedRoute] to match both exact paths and sub-routes.
  static const List<String> protectedPrefixes = <String>[
    home,
    myLists,
    account,
    movies,
    credits,
  ];

  /// Routes that are only meaningful when the user is **not** authenticated.
  ///
  /// An authenticated user visiting these routes is redirected to [home].
  static const Set<String> authRoutes = <String>{login, signUp};

  /// Returns `true` if [location] is a protected route requiring authentication.
  ///
  /// Matches both exact paths and sub-routes to prevent false positives:
  /// - `'/home'` → `true` (exact match)
  /// - `'/home/settings'` → `true` (sub-route)
  /// - `'/homecoming'` → `false` (unrelated path that starts with `/home`)
  static bool isProtectedRoute(String location) {
    return protectedPrefixes.any((prefix) {
      return location == prefix || location.startsWith('$prefix/');
    });
  }
}
