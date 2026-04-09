import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

import '../region_preferences_repository.dart';

part 'region_preferences_database.g.dart';

/// Drift table that stores the selected region preference.
///
/// This table intentionally uses a singleton row keyed by [id] so the app can
/// upsert and watch a single stable record.
class RegionPreferences extends Table {
  /// Singleton row key used by the preferences table.
  IntColumn get id => integer()();

  /// Selected region as a 2-letter ISO-3166 alpha-2 code.
  TextColumn get regionCode => text().withLength(min: 2, max: 2)();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

@DriftDatabase(tables: [RegionPreferences])
/// Local Drift database responsible for region preference persistence.
class RegionPreferencesDatabase extends _$RegionPreferencesDatabase {
  /// Creates the database connection for the region preferences store.
  RegionPreferencesDatabase() : super(_openConnection());

  static const int _singletonId = 1;

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (Migrator m) async {
      await m.createAll();
    },
  );

  /// Returns the persisted region code.
  ///
  /// Falls back to [RegionPreferencesRepository.defaultRegionCode] when the
  /// singleton preference row has not been created yet.
  Future<String> getSelectedRegionCode() async {
    final row = await (select(
      regionPreferences,
    )..where((tbl) => tbl.id.equals(_singletonId))).getSingleOrNull();
    return row?.regionCode ?? RegionPreferencesRepository.defaultRegionCode;
  }

  /// Persists [regionCode] in uppercase form using singleton upsert semantics.
  ///
  /// Throws an [ArgumentError] when [regionCode] is not exactly 2 characters.
  Future<void> setSelectedRegionCode(String regionCode) async {
    final normalized = regionCode.toUpperCase();
    if (normalized.length != 2) {
      throw ArgumentError.value(
        regionCode,
        'regionCode',
        'Region must be a 2-letter ISO-3166 alpha-2 code.',
      );
    }

    await into(regionPreferences).insertOnConflictUpdate(
      RegionPreferencesCompanion.insert(
        id: const Value(_singletonId),
        regionCode: normalized,
      ),
    );
  }

  /// Watches the selected region and emits a default value when missing.
  Stream<String> watchSelectedRegionCode() {
    return (select(
      regionPreferences,
    )..where((tbl) => tbl.id.equals(_singletonId))).watchSingleOrNull().map(
      (row) => row?.regionCode ?? RegionPreferencesRepository.defaultRegionCode,
    );
  }
}

/// Opens the Drift database used by [RegionPreferencesDatabase].
QueryExecutor _openConnection() {
  return driftDatabase(name: 'region_preferences_db');
}
