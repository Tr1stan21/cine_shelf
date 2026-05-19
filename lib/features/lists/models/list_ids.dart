/// Firestore list identifiers for system-provided user lists.
///
/// These constants are used as document IDs under `/user/{uid}/list/{listId}`
/// and must remain stable — changing them would break existing user data.
const String watchedListId = 'watched';
const String watchlistListId = 'watchlist';
const String favoritesListId = 'favorites';
