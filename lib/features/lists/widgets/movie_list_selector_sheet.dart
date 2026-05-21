import 'package:cine_shelf/features/auth/application/auth_providers.dart';
import 'package:cine_shelf/features/lists/application/list_providers.dart';
import 'package:cine_shelf/features/lists/models/user_custom_list.dart';
import 'package:cine_shelf/features/lists/widgets/create_list_dialog.dart';
import 'package:cine_shelf/features/lists/widgets/custom_list_row.dart';
import 'package:cine_shelf/shared/config/theme.dart';
import 'package:cine_shelf/shared/models/movie_poster.dart';
import 'package:cine_shelf/shared/widgets/dialogs/show_cine_shelf_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MovieListSelectorSheet extends ConsumerWidget {
  const MovieListSelectorSheet({required this.movie, super.key});

  final MoviePoster movie;

  Future<void> _openCreateDialog(
    BuildContext context,
    List<String> existingListNames,
  ) {
    return showCineShelfDialog<void>(
      context: context,
      builder: (context) {
        return CreateListDialog(
          movieId: movie.id,
          posterPath: movie.posterPath,
          existingListNames: existingListNames,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final uid = ref.watch(authStateProvider).asData?.value?.uid;
    final AsyncValue<List<UserCustomList>> customListsAsync = uid == null
        ? const AsyncValue.data(<UserCustomList>[])
        : ref.watch(customListsProvider(uid));

    final customLists = customListsAsync.asData?.value ?? [];
    final existingListNames = customLists.map((list) => list.name).toList();

    return SafeArea(
      top: false,
      child: Align(
        alignment: Alignment.bottomCenter,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.sizeOf(context).height * 0.68,
          ),
          child: Container(
            decoration: BoxDecoration(
              color: CineColors.bgDark,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(CineRadius.xl),
              ),
              boxShadow: [
                BoxShadow(
                  color: CineColors.black.withValues(alpha: 0.35),
                  blurRadius: 30,
                  offset: const Offset(0, -14),
                ),
              ],
            ),
            child: Column(
              children: [
                const SizedBox(height: CineSpacing.xl),
                const _SheetHandle(),
                const SizedBox(height: CineSpacing.lg),
                const _SheetHeader(),
                Expanded(
                  child: _CustomListsContent(
                    customListsAsync: customListsAsync,
                    movie: movie,
                  ),
                ),
                _NewListButton(
                  enabled: uid != null,
                  onTap: uid == null
                      ? null
                      : () => _openCreateDialog(context, existingListNames),
                ),
                const SizedBox(height: CineSpacing.lg),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SheetHandle extends StatelessWidget {
  const _SheetHandle();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 48,
      height: 4,
      decoration: BoxDecoration(
        color: CineColors.textMuted,
        borderRadius: BorderRadius.circular(CineRadius.sm),
      ),
    );
  }
}

class _SheetHeader extends StatelessWidget {
  const _SheetHeader();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: CineSpacing.xxl),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          'Save to list',
          style: TextStyle(
            color: CineColors.amber,
            fontSize: 22,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}

class _CustomListsContent extends StatelessWidget {
  const _CustomListsContent({
    required this.customListsAsync,
    required this.movie,
  });

  final AsyncValue<List<UserCustomList>> customListsAsync;
  final MoviePoster movie;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: CineSpacing.xxl,
        vertical: CineSpacing.sm,
      ),
      child: customListsAsync.when(
        data: (customLists) {
          if (customLists.isEmpty) {
            return const Center(
              child: Text(
                'No custom lists yet',
                style: TextStyle(color: CineColors.textSecondary, fontSize: 16),
              ),
            );
          }

          return ListView.separated(
            padding: EdgeInsets.zero,
            itemCount: customLists.length,
            separatorBuilder: (_, _) => const SizedBox(height: CineSpacing.sm),
            itemBuilder: (context, index) {
              return CustomListRow(
                customList: customLists[index],
                movieId: movie.id,
                posterPath: movie.posterPath,
              );
            },
          );
        },
        loading: () => const Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(CineColors.amber),
          ),
        ),
        error: (_, _) => const Center(
          child: Text(
            'Unable to load lists',
            style: TextStyle(color: CineColors.textSecondary, fontSize: 16),
          ),
        ),
      ),
    );
  }
}

class _NewListButton extends StatelessWidget {
  const _NewListButton({required this.enabled, required this.onTap});

  final bool enabled;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: CineSpacing.xxl),
      child: Material(
        color: CineColors.surfaceRaised,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(CineRadius.lg),
        ),
        child: InkWell(
          onTap: enabled ? onTap : null,
          borderRadius: BorderRadius.circular(CineRadius.lg),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: CineSpacing.lg,
              vertical: CineSpacing.md,
            ),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: enabled
                        ? CineColors.black.withValues(alpha: 0.12)
                        : CineColors.black.withValues(alpha: 0.08),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.add,
                    color: CineColors.amber,
                    size: 24,
                  ),
                ),
                const SizedBox(width: CineSpacing.lg),
                Expanded(
                  child: Text(
                    'New list',
                    style: TextStyle(
                      color: enabled ? CineColors.amber : CineColors.textMuted,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Icon(
                  Icons.chevron_right,
                  color: enabled ? CineColors.amber : CineColors.textMuted,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
