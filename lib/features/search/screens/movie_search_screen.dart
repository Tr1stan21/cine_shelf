import 'dart:async';

import 'package:cine_shelf/features/movie_detail/nav/movie_detail_args.dart';
import 'package:cine_shelf/features/region/application/region_providers.dart';
import 'package:cine_shelf/features/search/application/movie_search_provider.dart';
import 'package:cine_shelf/features/search/models/movie_search_result.dart';
import 'package:cine_shelf/features/search/widgets/poster_image.dart';
import 'package:cine_shelf/features/search/widgets/search_bar.dart';
import 'package:cine_shelf/router/route_paths.dart';
import 'package:cine_shelf/shared/config/constants.dart';
import 'package:cine_shelf/shared/config/theme.dart';
import 'package:cine_shelf/shared/models/movie_poster.dart';
import 'package:cine_shelf/shared/widgets/background.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class MovieSearchScreen extends ConsumerStatefulWidget {
  const MovieSearchScreen({super.key});

  @override
  ConsumerState<MovieSearchScreen> createState() => _MovieSearchScreenState();
}

class _MovieSearchScreenState extends ConsumerState<MovieSearchScreen> {
  static const int _minQueryLength = 3;
  static const Duration _debounceDuration = Duration(milliseconds: 400);

  final _controller = TextEditingController();

  Timer? _debounce;
  String _query = '';

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _onSearchChanged(String value) {
    _debounce?.cancel();

    final text = value.trim();

    if (text.length < _minQueryLength) {
      if (_query.isNotEmpty) {
        setState(() => _query = '');
      }
      return;
    }

    _debounce = Timer(_debounceDuration, () {
      if (!mounted || text == _query) return;
      setState(() => _query = text);
    });
  }

  @override
  Widget build(BuildContext context) {
    final region = ref.watch(selectedRegionCodeProvider);

    final searchQuery = _query.isEmpty
        ? null
        : MovieSearchQuery(query: _query, region: region).normalized();

    final resultsAsync = searchQuery == null
        ? null
        : ref.watch(movieSearchProvider(searchQuery));

    return Background(
      padding: const EdgeInsets.symmetric(horizontal: CineSpacing.lg),
      child: Column(
        children: [
          _buildHeader(context),
          CineSearchBar(
            controller: _controller,
            autofocus: true,
            onChanged: _onSearchChanged,
          ),
          const SizedBox(height: CineSpacing.lg),
          Expanded(child: _buildBody(resultsAsync, searchQuery)),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.only(top: CineSpacing.sm, bottom: CineSpacing.md),
      child: Expanded(
        child: Text(
          'Search',
          textAlign: TextAlign.center,
          style: CineTypography.headline2,
        ),
      ),
    );
  }

  Widget _buildBody(
    AsyncValue<dynamic>? resultsAsync,
    MovieSearchQuery? searchQuery,
  ) {
    if (_query.isEmpty || resultsAsync == null) {
      return const Center();
    }

    return resultsAsync.when(
      loading: () => const Center(
        child: CircularProgressIndicator(color: CineColors.amber),
      ),
      error: (_, _) => Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Could not search movies.',
              style: TextStyle(color: CineColors.error),
            ),
            const SizedBox(height: CineSpacing.sm),
            OutlinedButton(
              onPressed: searchQuery == null
                  ? null
                  : () => ref.invalidate(movieSearchProvider(searchQuery)),
              style: OutlinedButton.styleFrom(
                foregroundColor: CineColors.amber,
                side: const BorderSide(color: CineColors.amber),
              ),
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
      data: (page) {
        final results = page.results as List<MovieSearchResult>;

        if (results.isEmpty) {
          return const Center(
            child: Text(
              'No results found.',
              style: TextStyle(color: CineColors.textSecondary),
            ),
          );
        }

        return ListView.separated(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          itemCount: results.length,
          separatorBuilder: (_, _) => const SizedBox(height: CineSpacing.sm),
          itemBuilder: (context, index) {
            final movie = results[index];
            return _buildResultItem(movie);
          },
        );
      },
    );
  }

  Widget _buildResultItem(MovieSearchResult movie) {
    return InkWell(
      borderRadius: BorderRadius.circular(CineRadius.md),
      onTap: () {
        FocusScope.of(context).unfocus();

        context.push(
          RoutePaths.movieDetails,
          extra: MovieDetailsArgs(
            movie: MoviePoster(id: movie.id, posterPath: movie.posterPath),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: CineSpacing.sm),
        child: Row(
          children: [
            SizedBox(
              width: 58,
              child: AspectRatio(
                aspectRatio: AppConstants.posterAspectRatio,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(CineRadius.sm),
                  child: PosterImage(posterPath: movie.posterPath),
                ),
              ),
            ),
            const SizedBox(width: CineSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    movie.title.isEmpty ? 'Untitled' : movie.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: CineTypography.bodyMedium.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (movie.year != null) ...[
                    const SizedBox(height: CineSpacing.xs),
                    Text(
                      movie.year!,
                      style: CineTypography.bodyMedium.copyWith(
                        color: CineColors.textSecondary,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: CineColors.textSecondary),
          ],
        ),
      ),
    );
  }
}
