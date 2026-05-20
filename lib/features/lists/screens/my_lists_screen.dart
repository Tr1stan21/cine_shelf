import 'package:cine_shelf/features/auth/application/auth_providers.dart';
import 'package:cine_shelf/features/lists/application/list_providers.dart';
import 'package:cine_shelf/features/lists/models/list_icon_catalog.dart';
import 'package:cine_shelf/features/lists/models/list_ids.dart';
import 'package:cine_shelf/features/lists/widgets/list_row.dart';
import 'package:cine_shelf/features/movie_list/nav/movie_scroll_args.dart';
import 'package:cine_shelf/router/route_paths.dart';
import 'package:cine_shelf/shared/config/constants.dart';
import 'package:cine_shelf/shared/config/theme.dart';
import 'package:cine_shelf/shared/widgets/cine_snack_bar.dart';
import 'package:cine_shelf/shared/widgets/separators.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

Future<void> _navigateToList(
  BuildContext context,
  WidgetRef ref,
  String listId,
  String title,
) async {
  final uid = ref.read(authStateProvider).asData?.value?.uid;
  if (uid == null) return;

  try {
    final movies = await ref
        .read(listRepositoryProvider)
        .getListMovies(uid: uid, listId: listId);

    if (!context.mounted) return;

    context.push(
      RoutePaths.movies,
      extra: MovieListArgs(title: title, items: movies, totalPages: 1),
    );
  } catch (error, stackTrace) {
    debugPrint('_navigateToList [$listId] error: $error\n$stackTrace');

    if (!context.mounted) return;

    showCineSnackBar(context, 'Could not open this list. Please try again.');
  }
}

/// User's personal movie lists screen.
///
/// Displays two sections:
/// 1. Base Lists - System-provided lists:
///    - Watched: Movies the user has marked as watched
///    - Watchlist: Movies saved to watch later
///    - Favorites: Movies marked as favorites
///
/// 2. My Lists - User-created custom lists
///
/// Counts and movie content are observed from Firestore in real time via
/// Riverpod stream providers. Tapping a list navigates to [MovieListScreen]
/// in static mode (no infinite scroll) with the current list contents.
class MyListsScreen extends ConsumerWidget {
  const MyListsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final uid = ref.watch(authStateProvider).asData?.value?.uid;
    final customListsAsync = uid == null
        ? null
        : ref.watch(customListsProvider(uid));

    final watchedCount =
        ref.watch(listCountProvider(watchedListId)).asData?.value ?? 0;

    final watchlistCount =
        ref.watch(listCountProvider(watchlistListId)).asData?.value ?? 0;

    final favoritesCount =
        ref.watch(listCountProvider(favoritesListId)).asData?.value ?? 0;

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: CineSpacing.lg),
        child: Column(
          children: [
            Image.asset(AppConstants.logoPath, height: 100),

            const SizedBox(height: CineSpacing.xxxl),
            const Text(
              'Base Lists',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w600,
                color: CineColors.amber,
              ),
            ),
            const SizedBox(height: CineSpacing.lg),
            ListRow(
              icon: Icons.visibility_outlined,
              label: 'Watched',
              numMovies: watchedCount,
              onTap: () =>
                  _navigateToList(context, ref, watchedListId, 'Watched'),
            ),
            const SizedBox(height: CineSpacing.md),
            ListRow(
              icon: Icons.access_time_rounded,
              label: 'Watchlist',
              numMovies: watchlistCount,
              onTap: () =>
                  _navigateToList(context, ref, watchlistListId, 'Watchlist'),
            ),
            const SizedBox(height: CineSpacing.md),
            ListRow(
              icon: Icons.favorite_border,
              label: 'Favorites',
              numMovies: favoritesCount,
              onTap: () =>
                  _navigateToList(context, ref, favoritesListId, 'Favorites'),
            ),
            const SizedBox(height: CineSpacing.xl),
            const GlowSeparator(),
            const SizedBox(height: CineSpacing.xl),
            const Text(
              'My Lists',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w600,
                color: CineColors.amber,
              ),
            ),
            const SizedBox(height: CineSpacing.md),
            if (customListsAsync != null)
              customListsAsync.when(
                data: (customLists) {
                  return Column(
                    children: [
                      for (var index = 0; index < customLists.length; index++)
                        Padding(
                          padding: EdgeInsets.only(
                            bottom: index == customLists.length - 1
                                ? 0
                                : CineSpacing.md,
                          ),
                          child: ListRow(
                            icon:
                                listIconCatalog[customLists[index].iconName] ??
                                Icons.bookmark_outline,
                            label: customLists[index].name,
                            numMovies:
                                ref
                                    .watch(
                                      listCountProvider(customLists[index].id),
                                    )
                                    .asData
                                    ?.value ??
                                0,
                            onTap: () => _navigateToList(
                              context,
                              ref,
                              customLists[index].id,
                              customLists[index].name,
                            ),
                          ),
                        ),
                    ],
                  );
                },
                loading: () => const Padding(
                  padding: EdgeInsets.only(top: CineSpacing.md),
                  child: Center(
                    child: SizedBox(
                      width: CineSizes.loaderSmall,
                      height: CineSizes.loaderSmall,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  ),
                ),
                error: (error, stackTrace) => const Padding(
                  padding: EdgeInsets.only(top: CineSpacing.md),
                  child: Text(
                    'Could not load custom lists.',
                    style: TextStyle(color: CineColors.textMuted),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
