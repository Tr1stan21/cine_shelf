import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/movies_providers.dart';
import '../data/movies_repository.dart';
import '../models/movie_poster.dart';
import '../models/tmdb/list_category.dart';

/// Immutable state for paginated movie list.
///
/// Tracks:
/// - [items]: Currently loaded movies
/// - [currentPage]: The last fetched page number
/// - [totalPages]: Total pages available for this category
/// - [isLoadingInitial]: Initial load is in progress
/// - [isLoadingMore]: Loading next page (infinite scroll)
/// - [error]: Last error message, if any
///
/// **Initial State:**
/// When first created, [currentPage] is 0, [items] is empty, [totalPages] is 1.
/// This indicates "not yet loaded".
///
/// **Check [hasMore] before loading next page:**
/// If [hasMore] is false, [loadMore] will be a no-op (already at last page).
class PaginatedMoviesState {
  /// Creates a PaginatedMoviesState with pagination and loading metadata.
  const PaginatedMoviesState({
    this.items = const [],
    this.currentPage = 0,
    this.totalPages = 1,
    this.isLoadingInitial = false,
    this.isLoadingMore = false,
    this.error,
  });

  /// Currently loaded movies on the active pages.
  final List<MoviePoster> items;

  /// Last successfully fetched page number (0 means not yet loaded).
  final int currentPage;

  /// Total number of pages available for this category (from TMDB).
  final int totalPages;

  /// True if initial page load is in progress.
  final bool isLoadingInitial;

  /// True if loading the next page for infinite scroll.
  final bool isLoadingMore;

  /// Last error message, or null if no error.
  final String? error;

  /// Returns true if there are more pages to load.
  ///
  /// Useful for checking before calling [loadMore] to avoid unnecessary calls.
  bool get hasMore => currentPage < totalPages;

  /// Creates a copy of this state with specified fields replaced.
  ///
  /// Parameters:
  /// - [clearError]: If true, sets [error] to null regardless of [error] parameter.
  ///
  /// Returns:
  /// - A new [PaginatedMoviesState] with updated fields
  PaginatedMoviesState copyWith({
    List<MoviePoster>? items,
    int? currentPage,
    int? totalPages,
    bool? isLoadingInitial,
    bool? isLoadingMore,
    String? error,
    bool clearError = false,
  }) {
    return PaginatedMoviesState(
      items: items ?? this.items,
      currentPage: currentPage ?? this.currentPage,
      totalPages: totalPages ?? this.totalPages,
      isLoadingInitial: isLoadingInitial ?? this.isLoadingInitial,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      error: clearError ? null : (error ?? this.error),
    );
  }
}

/// Notifier for managing paginated movie list state.
///
/// Implements two patterns:
/// 1. **Seeding**: Initialize with pre-loaded data from HomeScreen (avoid redundant API call)
/// 2. **Lazy loading**: Load initial page on first access, append more pages on scroll
///
/// Both patterns are idempotent:
/// - Calling [seed] twice: second call is ignored
/// - Calling [loadInitialIfNeeded] when already loaded: no-op
/// - Calling [loadMore] at last page: no-op
///
/// **Lifecycle:**
/// - With .autoDispose: notifier is freed when MovieListScreen closes
/// - Next navigation to the same category: new instance created (cache cleared)
/// - Prevents memory leaks and stale data
class PaginatedMoviesNotifier extends Notifier<PaginatedMoviesState> {
  /// Creates a PaginatedMoviesNotifier for the given movie category.
  ///
  /// Parameters:
  /// - [_category]: The movie category to manage (popular, top_rated, etc.)
  PaginatedMoviesNotifier(this._category);

  final ListCategory _category;
  late final MoviesRepository _repository;

  @override
  PaginatedMoviesState build() {
    _repository = ref.read(moviesRepositoryProvider);
    return const PaginatedMoviesState();
  }

  /// Initializes the paginated list with pre-loaded data (HomeScreen pattern).
  ///
  /// Used when the home screen has already fetched page 1.
  /// This method avoids making a redundant API call.
  ///
  /// **Idempotency:**
  /// If the notifier is already initialized (currentPage != 0), this call is ignored.
  ///
  /// Parameters:
  /// - [initialItems]: Movies already loaded (typically from HomeScreen)
  /// - [totalPages]: Total pages available from TMDB
  /// - [initialPage]: The page number of initialItems (default: 1)
  void seed({
    required List<MoviePoster> initialItems,
    required int totalPages,
    int initialPage = 1,
  }) {
    // If already seeded or loaded, ignore to prevent overwriting state
    if (state.currentPage != 0) return;

    state = state.copyWith(
      items: initialItems,
      currentPage: initialPage,
      totalPages: totalPages,
      clearError: true,
    );
  }

  /// Loads the first page of movies if not already loaded.
  ///
  /// Used when the notifier is accessed without prior seeding (lazy load pattern).
  /// Idempotent: if already loading or loaded, this is a no-op.
  ///
  /// **Error handling:**
  /// - Errors are stored in [PaginatedMoviesState.error]
  /// - Calling this again after error may retry (check your app logic)
  Future<void> loadInitialIfNeeded() async {
    // Skip if already initialized or currently loading
    if (state.currentPage != 0 || state.isLoadingInitial) return;

    state = state.copyWith(isLoadingInitial: true, clearError: true);
    try {
      final dto = await _repository.getMoviesPage(_category, page: 1);

      state = state.copyWith(
        items: dto.movies,
        currentPage: 1,
        totalPages: dto.totalPages,
        isLoadingInitial: false,
      );
    } catch (e) {
      state = state.copyWith(isLoadingInitial: false, error: e.toString());
    }
  }

  /// Loads the next page and appends to the current list (infinite scroll).
  ///
  /// Idempotent: if already loading more, at last page, or not yet initialized, this is a no-op.
  ///
  /// **Usage:**
  /// Typically called from a scroll controller or infinite_scroll_pagination package:
  /// ```dart
  /// if (isNearBottom) {
  ///   ref.read(paginatedMoviesProvider(_category).notifier).loadMore();
  /// }
  /// ```
  ///
  /// **Error handling:**
  /// - Errors are stored in [PaginatedMoviesState.error]
  /// - The current items remain unchanged; only the next page fetch failed
  Future<void> loadMore() async {
    // Skip if already loading, at last page, or not yet initialized
    if (state.isLoadingMore || !state.hasMore) return;

    state = state.copyWith(isLoadingMore: true, clearError: true);

    try {
      final nextPage = state.currentPage + 1;
      final dto = await _repository.getMoviesPage(_category, page: nextPage);

      state = state.copyWith(
        items: [...state.items, ...dto.movies],
        currentPage: nextPage,
        totalPages: dto.totalPages,
        isLoadingMore: false,
      );
    } catch (e) {
      state = state.copyWith(isLoadingMore: false, error: e.toString());
    }
  }
}

/// Provider for paginated movie list state management.
///
/// **How it works:**
/// - Parametrized by [ListCategory]: each category gets its own independent notifier instance
/// - .autoDispose: notifier is freed when no one is watching
/// - .family: allows multiple independent instances (one per category)
///
/// **Caching behavior:**
/// - As long as MovieListScreen is watching, state persists in memory
/// - On screen close (notifier unwatched), Riverpod clears the cache
/// - Next navigation to the same category creates a fresh notifier
///
/// **Usage:**
/// ```dart
/// // Get the notifier for a category
/// final notifier = ref.read(paginatedMoviesProvider(category).notifier);
///
/// // Watch the state
/// final state = ref.watch(paginatedMoviesProvider(category));
///
/// // Call methods
/// await notifier.loadInitialIfNeeded();
/// await notifier.loadMore();
/// ```
final paginatedMoviesProvider = NotifierProvider.autoDispose
    .family<PaginatedMoviesNotifier, PaginatedMoviesState, ListCategory>(
      PaginatedMoviesNotifier.new,
    );
