/// Local persistence contract for region preference.
///
/// The selected region is a local presentation preference and must not be
/// stored in remote user profile services.
abstract class RegionPreferencesRepository {
  /// Default fallback region used when there is no persisted value yet.
  static const String defaultRegionCode = 'US';

  /// Returns the currently selected region code.
  Future<String> getSelectedRegion();

  /// Persists the selected region code.
  Future<void> setSelectedRegion(String regionCode);

  /// Watches region changes from local storage.
  Stream<String> watchSelectedRegion();
}
