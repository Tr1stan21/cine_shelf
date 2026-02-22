import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/movies_providers.dart';
import '../data/movies_repository.dart';
import '../models/movie_poster.dart';
import '../models/tmdb/list_category.dart';

class PaginatedMoviesState {
  const PaginatedMoviesState({
    this.items = const [],
    this.currentPage = 0,
    this.totalPages = 1,
    this.isLoadingInitial = false,
    this.isLoadingMore = false,
    this.error,
  });

  final List<MoviePoster> items;
  final int currentPage;
  final int totalPages;
  final bool isLoadingInitial;
  final bool isLoadingMore;
  final String? error;

  bool get hasMore => currentPage < totalPages;

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

class PaginatedMoviesNotifier extends Notifier<PaginatedMoviesState> {
  PaginatedMoviesNotifier(this._category);

  final ListCategory _category;
  late final MoviesRepository _repository;

  @override
  PaginatedMoviesState build() {
    _repository = ref.read(moviesRepositoryProvider);
    return const PaginatedMoviesState();
  }

  /// Seed con la página 1 ya cargada (HomeScreen).
  /// Idempotente: si ya hay página asignada, no hace nada.
  void seed({
    required List<MoviePoster> initialItems,
    required int totalPages,
    int initialPage = 1,
  }) {
    if (state.currentPage != 0) return;

    state = state.copyWith(
      items: initialItems,
      currentPage: initialPage,
      totalPages: totalPages,
      clearError: true,
    );
  }

  /// Carga inicial solo si no hubo seed.
  Future<void> loadInitialIfNeeded() async {
    if (state.currentPage != 0 || state.isLoadingInitial) return;

    state = state.copyWith(isLoadingInitial: true, clearError: true);
    try {
      // Ajusta el nombre según tu repo: getMoviesDto / getCategoryMoviesDto, etc.
      final dto = await _repository.getMoviesPage(_category, page: 1);

      state = state.copyWith(
        items: dto.movies, // <-- asegura que tu DTO expone `movies`
        currentPage: 1,
        totalPages: dto.totalPages,
        isLoadingInitial: false,
      );
    } catch (e) {
      state = state.copyWith(isLoadingInitial: false, error: e.toString());
    }
  }

  /// Scroll infinito
  Future<void> loadMore() async {
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

/// Provider Riverpod 3: autoDispose + family.
final paginatedMoviesProvider = NotifierProvider.autoDispose
    .family<PaginatedMoviesNotifier, PaginatedMoviesState, ListCategory>(
      PaginatedMoviesNotifier.new,
    );
