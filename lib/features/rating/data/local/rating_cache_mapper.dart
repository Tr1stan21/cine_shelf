import 'package:cine_shelf/core/database/drift_database.dart';

/// Extension providing mapping from cached rating data to app-layer value.
///
/// Converts [CachedRatingsData] (Drift representation) to app-layer `double`
/// (the star rating value).
///
/// **Usage:**
/// ```dart
/// final cached = await datasource.getRating(uid, movieId);
/// if (cached != null) {
///   final stars = cached.toAppModel(); // Gets the stars value
/// }
/// ```
extension CachedRatingToAppMapper on CachedRatingData {
  /// Extracts the star rating value from cached data.
  ///
  /// **Returns:** The `stars` field as a double
  double toAppModel() => stars;
}
