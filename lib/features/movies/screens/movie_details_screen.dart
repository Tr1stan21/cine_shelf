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
import 'package:cine_shelf/features/rating/application/rating_providers.dart';
import 'package:cine_shelf/features/rating/application/rating_controller.dart';
import 'package:cine_shelf/features/rating/widgets/star_rating_widget.dart';

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
      body: detailAsync.when(
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

  Future<void> _toggle(
    BuildContext context,
    WidgetRef ref,
    String listId,
    bool isIn,
  ) async {
    final uid = ref.read(authStateProvider).asData?.value?.uid;
    if (uid == null) return;

    final repo = ref.read(listRepositoryProvider);

    try {
      if (isIn) {
        await repo.removeMovieFromList(
          uid: uid,
          listId: listId,
          movieId: movie.id,
        );
      } else {
        await repo.addMovieToList(
          uid: uid,
          listId: listId,
          movieId: movie.id,
          posterPath: movie.posterPath,
        );
      }
    } catch (_) {
      if (!context.mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Could not update the list. Please try again.'),
        ),
      );
    }
  }

  void _showMustBeWatchedSnackBar(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Mark the movie as watched first.')),
    );
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
        _RatingSection(movie: movie, isWatched: isWatched),
        const SizedBox(height: CineSpacing.xxxl),
        Row(
          children: [
            Expanded(
              child: FavoriteMovieButton(
                isFavorite: isFav,
                onTap: isFavAsync.isLoading
                    ? null
                    : isWatched
                    ? () => _toggle(context, ref, favoritesListId, isFav)
                    : () => _showMustBeWatchedSnackBar(context),
              ),
            ),
            const SizedBox(width: CineSpacing.md),
            Expanded(
              child: WatchlistMovieButton(
                isWatchlist: isWatchlist,
                onTap: isWatchlistAsync.isLoading
                    ? null
                    : () => _toggle(context, ref, watchlistListId, isWatchlist),
              ),
            ),
          ],
        ),
        const SizedBox(height: CineSpacing.md),
        Row(
          children: [
            Expanded(
              child: WatchedMovieButton(
                isWatched: isWatched,
                onTap: isWatchedAsync.isLoading
                    ? null
                    : () => _toggle(context, ref, watchedListId, isWatched),
              ),
            ),
            const SizedBox(width: CineSpacing.md),
            const Expanded(child: MovieListButton()),
          ],
        ),
      ],
    );
  }
}

/// Star rating widget connected to Firestore for the detail screen.
///
/// Disabled with a SnackBar guard when the movie is not in Watched.
/// Disabled visually (outline-only stars) while the rating stream loads
/// or when the movie has not been rated yet — matching the unrated appearance.
class _RatingSection extends ConsumerWidget {
  const _RatingSection({required this.movie, required this.isWatched});

  final MoviePoster movie;
  final bool isWatched;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ratingAsync = ref.watch(movieRatingProvider(movie.id));
    final rating = ratingAsync.asData?.value; // null while loading or unrated

    return Padding(
      padding: const EdgeInsets.only(top: CineSpacing.md),
      child: StarRatingWidget(
        rating: rating,
        editable: isWatched && !ratingAsync.isLoading,
        onRatingUpdate: (stars) {
          final uid = ref.read(authStateProvider).asData?.value?.uid;
          if (uid == null) return;
          ref
              .read(ratingControllerProvider)
              .setRating(
                context: context,
                uid: uid,
                movieId: movie.id,
                stars: stars,
              );
        },
        onDisabledTap: isWatched
            ? null // loading state — no message needed
            : () => ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Add the movie to Watched before rating it.'),
                ),
              ),
      ),
    );
  }
}
