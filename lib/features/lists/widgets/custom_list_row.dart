import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:cine_shelf/features/auth/application/auth_providers.dart';
import 'package:cine_shelf/features/lists/application/list_providers.dart';
import 'package:cine_shelf/features/lists/models/list_icon_catalog.dart';
import 'package:cine_shelf/features/lists/models/user_custom_list.dart';
import 'package:cine_shelf/shared/config/theme.dart';

/// Interactive row representing a custom list with movie membership toggle.
///
/// Displays:
/// - List icon (from catalog)
/// - List name
/// - Tappable circle with +/✓ indicator
///
/// Behavior:
/// - If movie is not in list: shows +, tapping adds movie
/// - If movie is in list: shows ✓, tapping removes movie
/// - Disabled during loading
/// - Watches movieInListProvider for reactive membership state
class CustomListRow extends ConsumerWidget {
  const CustomListRow({
    required this.customList,
    required this.movieId,
    required this.posterPath,
    super.key,
  });

  final UserCustomList customList;
  final int movieId;
  final String? posterPath;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final membershipAsync = ref.watch(
      movieInListProvider((listId: customList.id, movieId: movieId)),
    );

    return membershipAsync.when(
      data: (isInList) {
        return _buildRow(context, ref, isInList, false);
      },
      loading: () {
        return _buildRow(context, ref, false, true);
      },
      error: (error, stackTrace) {
        return _buildRow(context, ref, false, false);
      },
    );
  }

  Widget _buildRow(
    BuildContext context,
    WidgetRef ref,
    bool isInList,
    bool isLoading,
  ) {
    final iconData =
        listIconCatalog[customList.iconName] ?? Icons.bookmark_outline;

    return GestureDetector(
      onTap: isLoading
          ? null
          : () async {
              final repo = ref.read(listRepositoryProvider);
              final authState = ref.read(authStateProvider);
              final uid = authState.asData?.value?.uid;

              if (uid == null) return;

              try {
                if (isInList) {
                  await repo.removeMovieFromList(
                    uid: uid,
                    listId: customList.id,
                    movieId: movieId,
                  );
                } else {
                  await repo.addMovieToList(
                    uid: uid,
                    listId: customList.id,
                    movieId: movieId,
                    posterPath: posterPath,
                  );
                }
              } catch (e) {
                debugPrint('Error toggling movie in list: $e');
              }
            },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: CineSpacing.xs),
        padding: const EdgeInsets.symmetric(
          horizontal: CineSpacing.lg,
          vertical: CineSpacing.md,
        ),
        decoration: BoxDecoration(
          color: CineColors.surfaceRaised,
          borderRadius: BorderRadius.circular(CineRadius.lg),
          border: Border.all(color: CineColors.white.withValues(alpha: 0.06)),
        ),
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: CineColors.black.withValues(alpha: 0.14),
                shape: BoxShape.circle,
              ),
              child: Icon(iconData, color: CineColors.amber, size: 24),
            ),
            const SizedBox(width: CineSpacing.lg),
            Expanded(
              child: Text(
                customList.name,
                style: const TextStyle(
                  fontSize: 16,
                  color: CineColors.textLight,
                  fontWeight: FontWeight.w500,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: CineSpacing.lg),
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: CineColors.black.withValues(alpha: 0.14),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            CineColors.amber,
                          ),
                        ),
                      )
                    : Icon(
                        isInList ? Icons.check : Icons.add,
                        color: CineColors.amber,
                        size: 24,
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
