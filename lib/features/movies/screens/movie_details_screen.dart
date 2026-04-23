import 'package:cine_shelf/features/movies/models/movie_poster.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:cine_shelf/shared/config/theme.dart';
import 'package:cine_shelf/shared/config/constants.dart';
import 'package:cine_shelf/shared/widgets/back_button.dart';
import 'package:cine_shelf/features/movies/widgets/movie_button.dart';
import 'package:cine_shelf/features/movies/application/movie_details_provider.dart';
import 'package:cine_shelf/features/auth/application/auth_providers.dart';
import 'package:cine_shelf/features/lists/application/list_providers.dart';
import 'package:cine_shelf/features/lists/domain/list_ids.dart';

/// Full-screen detail view for a single movie.
///
/// **Layout structure:**
/// - Full-width hero poster image occupying the top ~56% of the screen.
/// - Scrollable content panel that begins [overlap] pixels above the poster's
///   bottom edge, creating a layered card effect.
/// - Movie metadata: title, release year, genres.
/// - Overview/synopsis text.
/// - Back button overlay anchored to the top-left safe area.
///
/// Action buttons (Favorite, Watchlist, Watched) are connected to Firestore
/// via [movieInListProvider] and [listRepositoryProvider]. State is reactive —
/// each button reflects real-time membership and toggles on tap.
///
/// Data is fetched via [movieDetailProvider] parametrized by [MoviePoster.id].
/// Loading and error states are handled inline within the [Stack].
class MovieDetailsScreen extends ConsumerWidget {
  const MovieDetailsScreen({required this.movie, super.key});

  /// Lightweight poster model carrying the TMDB [id] used to fetch full details.
  final MoviePoster movie;

  static const int _maxStars = 5;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final detailAsync = ref.watch(movieDetailProvider(movie.id));

    final size = MediaQuery.sizeOf(context);

    // The content panel overlaps the poster by this many pixels, creating
    // the layered card visual where the panel slides over the image.
    const overlap = 26.0;

    // Height of the scrollable content panel. The poster fills the remaining
    // space above it (size.height - panelHeight + overlap).
    final panelHeight = size.height * 0.44;

    return Scaffold(
      //Eliminar container
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(AppConstants.backgroundPath),
            fit: BoxFit.cover,
          ),
        ),
        child: detailAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stack) => Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 64, color: Colors.grey),
                const SizedBox(height: 16),
                Text(
                  'Error al cargar detalles',
                  style: CineTypography.bodyMedium.copyWith(color: Colors.grey),
                ),
                const SizedBox(height: 8),
                TextButton(
                  onPressed: () => context.pop(),
                  child: const Text('Volver'),
                ),
              ],
            ),
          ),
          data: (detail) => Stack(
            children: [
              SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(
                      height: size.height - panelHeight + overlap,
                      width: double.infinity,
                      child: CachedNetworkImage(
                        imageUrl: detail.posterUrl,
                        fit: BoxFit.cover,
                        placeholder: (context, url) =>
                            const Center(child: CircularProgressIndicator()),
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.error_outline, color: Colors.grey),
                      ),
                    ),
                    SafeArea(
                      top: false,
                      child: Container(
                        padding: const EdgeInsets.all(CineSpacing.xl),
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage(AppConstants.backgroundPath),
                            fit: BoxFit.cover,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 2),
                            Text(detail.title, style: CineTypography.headline1),
                            const SizedBox(height: CineSpacing.sm),
                            Text.rich(
                              TextSpan(
                                children: [
                                  TextSpan(
                                    text: detail.year,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: CineColors.amber,
                                    ),
                                  ),
                                  if (detail.genres.isNotEmpty)
                                    TextSpan(
                                      text: '  |  ${detail.genres.join(', ')}',
                                      style: const TextStyle(
                                        color: CineColors.textSecondary,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                ],
                              ),
                            ),
                            const SizedBox(height: CineSpacing.lg),
                            Text(
                              detail.overview,
                              style: const TextStyle(
                                fontSize: 14,
                                height: 1.35,
                                color: CineColors.textLight,
                              ),
                            ),
                            const SizedBox(height: CineSpacing.lg),
                            Row(
                              children: List.generate(
                                _maxStars,
                                (_) => const Padding(
                                  padding: EdgeInsets.only(right: 6),
                                  child: Icon(
                                    Icons.star,
                                    size: 22,
                                    color: CineColors.amber,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: CineSpacing.xxxl),
                            _ListActionButtons(movie: movie),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Back button floated over the poster in the top-left safe area.
              const SafeArea(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: CineBackButton(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Action buttons (Favorite, Watchlist, Watched, List...) for the detail screen.
///
/// Extracted as a [ConsumerWidget] so [ref.watch] is called directly in its
/// own [build] method — avoiding the anti-pattern of capturing ref inside a
/// [Builder] callback of a parent widget.
///
/// Each list button:
/// - Reads membership state reactively from [movieInListProvider].
/// - Disables tap while the stream is still loading to prevent double-writes.
/// - Calls [listRepositoryProvider] at tap time (not at build time) to avoid
///   holding a stale repository reference across rebuilds.
class _ListActionButtons extends ConsumerWidget {
  const _ListActionButtons({required this.movie});

  final MoviePoster movie;

  void _toggle(WidgetRef ref, String listId, bool isIn) {
    final uid = ref.read(authStateProvider).asData?.value?.uid;
    if (uid == null) return;
    final repo = ref.read(listRepositoryProvider);
    if (isIn) {
      repo.removeMovieFromList(uid: uid, listId: listId, movieId: movie.id);
    } else {
      repo.addMovieToList(
        uid: uid,
        listId: listId,
        movieId: movie.id,
        posterPath: movie.posterPath,
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isFavAsync = ref.watch(
      movieInListProvider((listId: favoritesListId, movieId: movie.id)),
    );
    final isWatchlistAsync = ref.watch(
      movieInListProvider((listId: watchlistListId, movieId: movie.id)),
    );
    final isWatchedAsync = ref.watch(
      movieInListProvider((listId: watchedListId, movieId: movie.id)),
    );

    final isFav = isFavAsync.asData?.value ?? false;
    final isWatchlist = isWatchlistAsync.asData?.value ?? false;
    final isWatched = isWatchedAsync.asData?.value ?? false;

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: MovieActionButton(
                label: 'Favorite',
                icon: Icons.favorite,
                backgroundColor: isFav ? const Color(0xFFB56610) : null,
                foregroundColor: isFav ? CineColors.white : CineColors.amber,
                outlined: !isFav,
                onTap: isFavAsync.isLoading
                    ? null
                    : () => _toggle(ref, favoritesListId, isFav),
              ),
            ),
            const SizedBox(width: CineSpacing.md),
            Expanded(
              child: MovieActionButton(
                label: 'Watchlist',
                icon: Icons.access_time_rounded,
                backgroundColor: isWatchlist ? const Color(0xFF5C4B2A) : null,
                foregroundColor: CineColors.amber,
                outlined: !isWatchlist,
                onTap: isWatchlistAsync.isLoading
                    ? null
                    : () => _toggle(ref, watchlistListId, isWatchlist),
              ),
            ),
          ],
        ),
        const SizedBox(height: CineSpacing.md),
        Row(
          children: [
            Expanded(
              child: MovieActionButton(
                label: 'Watched',
                icon: Icons.visibility_outlined,
                backgroundColor: isWatched ? const Color(0xFF7A3E07) : null,
                foregroundColor: CineColors.amber,
                outlined: !isWatched,
                onTap: isWatchedAsync.isLoading
                    ? null
                    : () => _toggle(ref, watchedListId, isWatched),
              ),
            ),
            const SizedBox(width: CineSpacing.md),
            const Expanded(
              child: MovieActionButton(
                label: 'List...',
                icon: Icons.add,
                outlined: true,
                trailingIcon: Icons.chevron_right_rounded,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
