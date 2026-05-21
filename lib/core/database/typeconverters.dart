import 'package:drift/drift.dart';

// ============================================================================
// CUSTOM TYPE CONVERTERS FOR DRIFT
// ============================================================================

/// Custom converter for JSON serialization in Drift.
///
/// Currently used for [CachedMoviesTable.genresJson] to store genre arrays
/// as JSON strings. In the future, can be extended for other complex types.
///
/// **Usage in table definitions:**
/// ```dart
/// TextColumn get genresJson => text().map(const JsonConverter())();
/// ```
class JsonConverter extends TypeConverter<String, String> {
  const JsonConverter();

  @override
  String fromSql(String fromDb) {
    // No transformation needed; already stored as JSON string
    return fromDb;
  }

  @override
  String toSql(String value) {
    // No transformation needed; pass as-is
    return value;
  }
}

// Note: DateTime conversion is handled automatically by Drift's
// dateTime() column type; no custom converter needed.
