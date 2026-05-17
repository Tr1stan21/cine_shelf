import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../catalog/data/dto/tmdb/list_category.dart';
import '../../catalog/models/movie_discovery_query.dart';
import '../../catalog/models/movie_query_params.dart';
import '../data/drift_region_preferences_repository.dart';
import '../data/local/region_preferences_database.dart';
import '../data/region_preferences_repository.dart';

/// Provides a singleton Drift database for local region preferences.
final regionPreferencesDatabaseProvider = Provider<RegionPreferencesDatabase>((
  ref,
) {
  final database = RegionPreferencesDatabase();
  ref.onDispose(database.close);
  return database;
});

/// Provides the local region preferences repository implementation.
final regionPreferencesRepositoryProvider =
    Provider<RegionPreferencesRepository>((ref) {
      final database = ref.watch(regionPreferencesDatabaseProvider);
      return DriftRegionPreferencesRepository(database);
    });

/// Global selected region state loaded from local persistence.
final selectedRegionProvider =
    AsyncNotifierProvider<SelectedRegionNotifier, String>(
      SelectedRegionNotifier.new,
    );

/// Synchronous helper that always returns a usable region code.
///
/// Falls back to the repository default while async bootstrap is still loading.
final selectedRegionCodeProvider = Provider<String>((ref) {
  final regionState = ref.watch(selectedRegionProvider);
  final region = regionState.asData?.value;
  if (region == null || region.length != 2) {
    return RegionPreferencesRepository.defaultRegionCode;
  }
  return region.toUpperCase();
});

/// Derived provider that builds the composite query key from category + region.
final movieQueryParamsByCategoryProvider =
    Provider.family<MovieQueryParams, ListCategory>((ref, category) {
      final region = ref.watch(selectedRegionCodeProvider);
      return MovieQueryParams(category: category, region: region).normalized();
    });

/// Derived provider that builds the composite query key from genre + region.
final movieQueryParamsByGenreProvider = Provider.family<MovieQueryParams, int>((
  ref,
  genreId,
) {
  final region = ref.watch(selectedRegionCodeProvider);
  return MovieQueryParams.discovery(
    discoveryQuery: MovieDiscoveryQuery.genre(genreId),
    region: region,
  ).normalized();
});

/// Async notifier that owns the selected region preference lifecycle.
///
/// Responsibilities:
/// - Load the persisted region during startup.
/// - Normalize all values to uppercase ISO-3166 alpha-2 codes.
/// - Persist updates to local storage.
/// - Keep state consistent if persistence fails.
class SelectedRegionNotifier extends AsyncNotifier<String> {
  RegionPreferencesRepository get _repository =>
      ref.read(regionPreferencesRepositoryProvider);

  @override
  /// Loads the persisted region code and returns a normalized value.
  Future<String> build() async {
    final selected = await _repository.getSelectedRegion();
    return _normalize(selected);
  }

  /// Updates selected region and persists it locally.
  Future<void> setRegion(String regionCode) async {
    final normalized = _normalize(regionCode);
    final previous = state.asData?.value;

    // Keep a valid region value available while persistence is in-flight
    // so list providers never fall back to default region transiently.
    state = AsyncData(normalized);

    try {
      await _repository.setSelectedRegion(normalized);
    } catch (error, stackTrace) {
      if (previous != null) {
        state = AsyncData(previous);
      } else {
        state = AsyncError(error, stackTrace);
      }
      rethrow;
    }
  }

  /// Validates and normalizes an incoming region code.
  ///
  /// Throws an [ArgumentError] when [regionCode] is not a valid two-letter
  /// country/region identifier.
  String _normalize(String regionCode) {
    final normalized = regionCode.trim().toUpperCase();
    if (normalized.length != 2) {
      throw ArgumentError.value(
        regionCode,
        'regionCode',
        'Region must be a 2-letter ISO-3166 alpha-2 code.',
      );
    }
    return normalized;
  }
}
