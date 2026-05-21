import 'package:cine_shelf/features/auth/application/auth_providers.dart';
import 'package:cine_shelf/features/lists/application/list_providers.dart';
import 'package:cine_shelf/features/lists/models/list_ids.dart';
import 'package:cine_shelf/features/lists/widgets/movie_list_selector_sheet.dart';
import 'package:cine_shelf/features/rating/application/rating_providers.dart';
import 'package:cine_shelf/shared/models/movie_poster.dart';
import 'package:cine_shelf/features/movie_detail/widgets/movie_button.dart';
import 'package:cine_shelf/shared/config/theme.dart';
import 'package:cine_shelf/shared/widgets/cine_snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cine_shelf/features/movie_detail/widgets/rating_section.dart';

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
class ListActionButtons extends ConsumerWidget {
  const ListActionButtons({required this.movie, super.key});

  static const String _mustBeWatchedMessage =
      'Mark the movie as watched first.';
  static const String _watchedRemovalBlockedMessage =
      'Movie couldn\'t be removed from "Watched" because there is activity on it';

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

      showCineSnackBar(context, 'Could not update the list. Please try again.');
    }
  }

  void _openListSelector(BuildContext context, WidgetRef ref) {
    final uid = ref.read(authStateProvider).asData?.value?.uid;
    if (uid == null) return;

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: CineColors.surfaceRaised,
      clipBehavior: Clip.antiAlias,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(CineRadius.lg),
        ),
      ),
      builder: (_) => MovieListSelectorSheet(movie: movie),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final uid = ref.watch(authStateProvider).asData?.value?.uid;
    final isFavAsync = ref.watch(
      movieInListProvider((listId: favoritesListId, movieId: movie.id)),
    );
    final isWatchlistAsync = ref.watch(
      movieInListProvider((listId: watchlistListId, movieId: movie.id)),
    );
    final isWatchedAsync = ref.watch(
      movieInListProvider((listId: watchedListId, movieId: movie.id)),
    );
    final ratingAsync = ref.watch(movieRatingProvider(movie.id));

    final isFav = isFavAsync.asData?.value ?? false;
    final isWatchlist = isWatchlistAsync.asData?.value ?? false;
    final isWatched = isWatchedAsync.asData?.value ?? false;
    final hasRating = ratingAsync.asData?.value != null;
    final hasCustomListActivity = uid == null
        ? false
        : ref.watch(
            hasMovieInAnyCustomListProvider((uid: uid, movieId: movie.id)),
          );
    final hasWatchedRemovalActivity =
        isFav || hasCustomListActivity || hasRating;

    return Column(
      children: [
        RatingSection(movie: movie, isWatched: isWatched),
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
                    : () => showCineSnackBar(context, _mustBeWatchedMessage),
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
                    : isWatched && hasWatchedRemovalActivity
                    ? () => showCineSnackBar(
                        context,
                        _watchedRemovalBlockedMessage,
                      )
                    : () => _toggle(context, ref, watchedListId, isWatched),
              ),
            ),
            const SizedBox(width: CineSpacing.md),
            Expanded(
              child: MovieListButton(
                onTap: isWatchedAsync.isLoading
                    ? null
                    : isWatched
                    ? () => _openListSelector(context, ref)
                    : () => showCineSnackBar(context, _mustBeWatchedMessage),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
