
import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

part 'drift_database.g.dart';

// ============================================================================
// TABLE DEFINITIONS
// ============================================================================

/// Represents the cached user profile data.
///
/// Stores a single row per authenticated user. Populated when the user's
/// profile is loaded from Firestore while online. Cleared on sign-out.
@DataClassName('UserLocalEntity')
class UsersTable extends Table {
  TextColumn get uid => text()();

  TextColumn get email => text()();

  TextColumn get username => text()();

  TextColumn get avatarUrl => text().nullable()();

  DateTimeColumn get updatedAt => dateTime()();

  DateTimeColumn get cachedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {uid};
}

/// Represents the user's movie lists (base and custom).
///
/// Includes predefined lists (watched, watchlist, favorites) and any custom
/// lists created by the user. Data is populated when lists are loaded from
/// Firestore. One row per list.
@DataClassName('UserListLocalEntity')
class UserListsTable extends Table {
  TextColumn get listId => text()();

  TextColumn get uid => text()();

  TextColumn get name => text()();

  /// Type of list: 'watched', 'watchlist', 'favorites', or 'custom'
  TextColumn get type => text()();

  TextColumn get iconName => text().nullable()();

  DateTimeColumn get createdAt => dateTime().nullable()();

  DateTimeColumn get updatedAt => dateTime().nullable()();

  DateTimeColumn get cachedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {listId};

  @override
  List<Set<Column>> get uniqueKeys => [
        {uid, listId}
      ];
}

/// Represents cached movie data for movies stored in user lists.
///
/// This table is shared across all lists to avoid duplication. A single
/// movie can be in multiple lists; it is stored once here and referenced
/// via [ListMovieRelationsTable].
///
/// Includes essential fields: title, posterPath, overview, releaseDate,
/// and genres serialized as JSON.
@DataClassName('CachedMoviesData')
class CachedMoviesTable extends Table {
  IntColumn get movieId => integer()();

  TextColumn get title => text()();

  TextColumn get posterPath => text().nullable()();

  TextColumn get overview => text().nullable()();

  /// ISO format date string, e.g., "2023-12-15"
  TextColumn get releaseDate => text().nullable()();

  /// JSON array of genre objects: [{"id": 1, "name": "Action"}, ...]
  TextColumn get genresJson => text().nullable()();

  DateTimeColumn get cachedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {movieId};
}

/// Represents the relationship between lists and movies.
///
/// This is a junction table that avoids duplication of movie data.
/// A movie can exist in multiple lists; each relation is a separate row here.
/// The UNIQUE constraint prevents the same movie from being added to the same
/// list twice.
@DataClassName('ListMovieRelationData')
class ListMovieRelationsTable extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get uid => text()();

  TextColumn get listId => text()();

  IntColumn get movieId => integer()();

  DateTimeColumn get addedAt => dateTime().nullable()();

  DateTimeColumn get cachedAt => dateTime()();

  @override
  List<Set<Column>> get uniqueKeys => [
        {uid, listId, movieId}
      ];
}

/// Represents cached user ratings for movies.
///
/// Stores ratings (0.0 - 10.0) for movies that the user has rated.
/// One row per (user, movie) pair.
@DataClassName('CachedRatingData')
class CachedRatingsTable extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get uid => text()();

  IntColumn get movieId => integer()();

  RealColumn get stars => real()();

  DateTimeColumn get updatedAt => dateTime()();

  DateTimeColumn get cachedAt => dateTime()();

  @override
  List<Set<Column>> get uniqueKeys => [
        {uid, movieId}
      ];
}

// ============================================================================
// DATABASE CLASS
// ============================================================================

/// Main Drift database instance for CineShelf offline caching.
///
/// Manages all local caching tables:
/// - [UsersTable]: Cached user profile
/// - [UserListsTable]: Cached user lists (base + custom)
/// - [CachedMoviesTable]: Cached movie data (deduplicated)
/// - [ListMovieRelationsTable]: List-to-movie relationships (junction table)
/// - [CachedRatingsTable]: Cached user ratings
///
/// **Lifecycle:**
/// - Database file is stored in app's documents directory (persistent).
/// - No migrations: schema is fixed for this MVP.
/// - All data is cleared on user sign-out via [clearUserCache].
///
/// **Usage:**
/// ```dart
/// final db = AppDatabase();
/// final users = await db.usersDao.getUser(uid);
/// ```
@DriftDatabase(
  tables: [
    UsersTable,
    UserListsTable,
    CachedMoviesTable,
    ListMovieRelationsTable,
    CachedRatingsTable,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  // =========================================================================
  // DATA ACCESS OBJECTS (DAOs) - Auto-generated accessors
  // =========================================================================

  // Access via: db.usersTable, db.usersCompanion, etc.
  // Drift auto-generates CRUD methods for each table.
  // Use db.into(usersTable).insert(), db.update(usersTable), etc.
}

// ============================================================================
// CONNECTION SETUP
// ============================================================================

/// Opens and initializes the Drift database connection.
///
/// For Flutter apps, uses [driftDatabase] from [drift_flutter] package,
/// which handles platform-specific initialization (SQLite on Android/iOS,
/// etc.) and stores the database file persistently in the app's documents
/// directory.
LazyDatabase _openConnection() {
  return LazyDatabase(() => driftDatabase(name: 'cine_shelf_cache'));
}
