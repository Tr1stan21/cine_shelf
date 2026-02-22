class RoutePaths {
  RoutePaths._();

  static const String splash = '/';
  static const String login = '/login';
  static const String signUp = '/sign-up';
  static const String home = '/home';
  static const String myLists = '/mylists';
  static const String account = '/account';
  static const String movies = '/movies';
  static const String movieDetails = '/movies/details';

  static const List<String> protectedPrefixes = <String>[
    home,
    myLists,
    account,
    movies,
  ];

  static const Set<String> authRoutes = <String>{login, signUp};

  /// Checks if the given location is a protected route.
  ///
  /// Returns true if the location exactly matches a protected prefix
  /// or is a sub-route (starts with prefix followed by '/').
  ///
  /// This prevents false positives from simple startsWith checks:
  /// - '/home' -> true (exact match)
  /// - '/home/settings' -> true (sub-route)
  /// - '/homecoming' -> false (not a sub-route)
  static bool isProtectedRoute(String location) {
    return protectedPrefixes.any((prefix) {
      return location == prefix || location.startsWith('$prefix/');
    });
  }
}
