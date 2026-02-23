import 'package:cine_shelf/features/movies/models/movie_details_args.dart';
import 'package:cine_shelf/features/movies/models/movie_poster.dart';
import 'package:cine_shelf/features/movies/models/tmdb/list_category.dart';
import 'package:cine_shelf/features/movies/application/paginated_movies_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:cine_shelf/shared/config/theme.dart';
import 'package:cine_shelf/shared/config/constants.dart';
import 'package:cine_shelf/shared/widgets/background.dart';
import 'package:cine_shelf/router/route_paths.dart';

/// Full-screen movie list displaying movies in a responsive grid layout.
///
/// When [category] is provided the screen supports infinite scroll:
/// - [initialItems] (page 1) are shown immediately without a network call.
/// - Scrolling to 80% of the current scroll extent triggers
///   [PaginatedMoviesNotifier.loadMore].
/// - A loading indicator row is appended while the next page is fetching.
/// - On error, an inline retry button lets the user try again without losing
///   the items already displayed.
///
/// When [category] is null the list is static — identical to the original
/// behaviour so existing call-sites that do not pass a category are unaffected.
///
/// **Performance optimisations:**
/// - [ListView.builder] for lazy row rendering.
/// - `addRepaintBoundaries: true` to isolate off-screen row repaints.
/// - [CachedNetworkImage] with [FilterQuality.low] for smooth scrolling.
class MovieListScreen extends ConsumerStatefulWidget {
  const MovieListScreen({
    required this.title,
    required this.initialItems,
    required this.totalPages,
    this.category,
    super.key,
  });

  final String title;
  final List<MoviePoster> initialItems;
  final int totalPages;

  /// When non-null, enables infinite scroll for this category.
  final ListCategory? category;

  @override
  ConsumerState<MovieListScreen> createState() => _MovieListScreenState();
}

class _MovieListScreenState extends ConsumerState<MovieListScreen> {
  late final ScrollController _scrollController;

  /// Tracks whether the list is scrolled to the very top.
  /// Used to show/hide the scroll-to-top floating button — the button is only
  /// shown after the user has scrolled past page 2 and is no longer at top.
  bool _isAtTop = true;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_onScroll);

    // Seed the paginated provider with the items already loaded by HomeScreen
    // so the list appears instantly without an extra network round-trip.
    if (widget.category != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final notifier = ref.read(
          paginatedMoviesProvider(widget.category!).notifier,
        );
        if (widget.initialItems.isNotEmpty) {
          notifier.seed(
            initialItems: widget.initialItems,
            totalPages: widget.totalPages,
          );
        } else {
          notifier.loadInitialIfNeeded();
        }
      });
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  /// Triggers loadMore when the user reaches 80 % of the current scroll extent.
  void _onScroll() {
    if (widget.category == null) return;
    final atTop =
        !_scrollController.hasClients || _scrollController.offset <= 0;
    if (atTop != _isAtTop) {
      setState(() {
        _isAtTop = atTop;
      });
    }
    final pos = _scrollController.position;
    if (pos.pixels >= pos.maxScrollExtent * 0.80) {
      ref.read(paginatedMoviesProvider(widget.category!).notifier).loadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    // Resolve items and pagination state.
    final List<MoviePoster> items;
    final bool isLoadingMore;
    final String? error;
    final int currentPage;

    if (widget.category != null) {
      final s = ref.watch(paginatedMoviesProvider(widget.category!));
      // Fall back to initialItems while the seed hasn't been applied yet
      // (i.e. currentPage == 0 on the very first frame).
      items = s.items.isNotEmpty ? s.items : widget.initialItems;
      isLoadingMore = s.isLoadingMore;
      error = s.error;
      currentPage = s.currentPage;
    } else {
      items = widget.initialItems;
      isLoadingMore = false;
      error = null;
      currentPage = 0;
    }

    // Number of grid rows needed for the current item list.
    final int gridRows = (items.length / AppConstants.moviesPerRow).ceil();

    // Extra rows at the bottom: loading indicator and/or error message.
    final int extraRows = (isLoadingMore ? 1 : 0) + (error != null ? 1 : 0);
    final int totalRows = gridRows + extraRows;

    // Only show the scroll-to-top button once the user is at least on page 2
    // and has scrolled away from the top — avoids premature button appearance.
    final showScrollToTop =
        widget.category != null && currentPage >= 2 && !_isAtTop;

    return Stack(
      children: [
        Background(
          padding: const EdgeInsets.symmetric(horizontal: CineSpacing.sm),
          child: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  controller: _scrollController,
                  // +1 for the sticky header row at index 0.
                  itemCount: totalRows + 1,
                  addRepaintBoundaries: true,
                  itemBuilder: (context, rowIndex) {
                    // Row 0 is the screen header (back button + title).
                    if (rowIndex == 0) {
                      return Padding(
                        padding: const EdgeInsets.only(
                          top: CineSpacing.sm,
                          bottom: CineSpacing.md,
                        ),
                        child: Row(
                          children: [
                            IconButton(
                              onPressed: () => context.pop(),
                              icon: const Icon(
                                Icons.arrow_back_ios_new,
                                color: CineColors.amber,
                                size: 18,
                              ),
                              splashRadius: 18,
                            ),
                            Expanded(
                              child: Center(
                                child: Text(
                                  widget.title,
                                  style: CineTypography.headline2,
                                ),
                              ),
                            ),
                            // Spacer balances the back button so the title
                            // appears visually centered.
                            const SizedBox(width: 44),
                          ],
                        ),
                      );
                    }

                    final gridRowIndex = rowIndex - 1;

                    // Loading indicator row — shown while fetching the next page.
                    if (gridRowIndex == gridRows && isLoadingMore) {
                      return const Padding(
                        padding: EdgeInsets.symmetric(vertical: 24),
                        child: Center(
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                              CineColors.amber,
                            ),
                          ),
                        ),
                      );
                    }

                    // Error row — shown after a failed page fetch with a retry button.
                    final isErrorRow =
                        error != null &&
                        gridRowIndex == gridRows + (isLoadingMore ? 1 : 0);
                    if (isErrorRow) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        child: Column(
                          children: [
                            const Text(
                              'Failed to load more movies.',
                              style: TextStyle(
                                color: Color(0xFFEF5350),
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 8),
                            TextButton(
                              onPressed: () => ref
                                  .read(
                                    paginatedMoviesProvider(
                                      widget.category!,
                                    ).notifier,
                                  )
                                  .loadMore(),
                              child: const Text(
                                'Retry',
                                style: TextStyle(color: CineColors.amber),
                              ),
                            ),
                          ],
                        ),
                      );
                    }

                    // Movie grid row — renders up to [AppConstants.moviesPerRow]
                    // posters side by side. The last row may have fewer items;
                    // empty slots are filled with invisible [SizedBox] widgets
                    // to maintain consistent column widths.
                    final start = gridRowIndex * AppConstants.moviesPerRow;
                    final end = (start + AppConstants.moviesPerRow).clamp(
                      0,
                      items.length,
                    );
                    final rowItems = items.sublist(start, end);

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        children: List.generate(AppConstants.moviesPerRow, (i) {
                          if (i >= rowItems.length) {
                            return const Expanded(child: SizedBox());
                          }
                          return Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 4,
                              ),
                              child: _MoviePosterCard(item: rowItems[i]),
                            ),
                          );
                        }),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        if (showScrollToTop)
          Positioned(
            right: 16,
            bottom: 24,
            child: SafeArea(
              top: false,
              left: false,
              right: false,
              child: GestureDetector(
                onTap: () {
                  if (!_scrollController.hasClients) return;
                  _scrollController.animateTo(
                    0,
                    duration: const Duration(milliseconds: 350),
                    curve: Curves.easeOutCubic,
                  );
                },
                child: Container(
                  width: 34,
                  height: 34,
                  decoration: const BoxDecoration(
                    color: Color(0xFF101012),
                    shape: BoxShape.circle,
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.keyboard_arrow_up,
                      size: 18,
                      color: CineColors.amber,
                    ),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

/// Isolated widget for an individual movie poster card.
///
/// Extracted from the list builder to reduce unnecessary rebuilds of sibling
/// cards and to allow Flutter to manage its lifecycle independently via
/// element reuse.
class _MoviePosterCard extends StatelessWidget {
  const _MoviePosterCard({required this.item});

  final MoviePoster item;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push(
        RoutePaths.movieDetails,
        extra: MovieDetailsArgs(movie: item),
      ),
      child: AspectRatio(
        aspectRatio: AppConstants.posterAspectRatio,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(CineRadius.md),
          child: CachedNetworkImage(
            imageUrl: AppConstants.tmdbPosterUrl(item.posterPath),
            fit: BoxFit.cover,
            // Low filter quality reduces GPU cost during fast scrolling
            // while remaining visually acceptable for poster thumbnails.
            filterQuality: FilterQuality.low,
            placeholder: (context, url) =>
                const Center(child: CircularProgressIndicator()),
            errorWidget: (context, url, error) =>
                const Icon(Icons.error_outline, color: Colors.grey),
          ),
        ),
      ),
    );
  }
}
