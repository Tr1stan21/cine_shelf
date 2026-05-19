import '../sources/region_preferences_database.dart';
import 'region_preferences_repository.dart';

/// Drift-backed local repository for selected region persistence.
class DriftRegionPreferencesRepository implements RegionPreferencesRepository {
  /// Creates a repository that delegates persistence to [RegionPreferencesDatabase].
  DriftRegionPreferencesRepository(this._database);

  final RegionPreferencesDatabase _database;

  @override
  /// Returns the currently persisted region code from local storage.
  Future<String> getSelectedRegion() {
    return _database.getSelectedRegionCode();
  }

  @override
  /// Stores a normalized region code in local Drift storage.
  Future<void> setSelectedRegion(String regionCode) {
    return _database.setSelectedRegionCode(regionCode);
  }

  @override
  /// Emits region updates whenever the local preference row changes.
  Stream<String> watchSelectedRegion() {
    return _database.watchSelectedRegionCode();
  }
}
