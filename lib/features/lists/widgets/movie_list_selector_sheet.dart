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
      child: SizedBox(
        height: MediaQuery.sizeOf(context).height * 0.62,
        child: DecoratedBox(
          decoration: const BoxDecoration(color: CineColors.surfaceRaised),
          child: Column(
            children: [
              const SizedBox(height: CineSpacing.sm),
              Container(
                width: 42,
                height: 4,
                decoration: BoxDecoration(
                  color: CineColors.textMuted,
                  borderRadius: BorderRadius.circular(CineRadius.sm),
                ),
              ),
              const Padding(
                padding: EdgeInsets.fromLTRB(
                  CineSpacing.xxl,
                  CineSpacing.xl,
                  CineSpacing.xxl,
                  CineSpacing.md,
                ),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Save to list',
                    style: TextStyle(
                      color: CineColors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: customListsAsync.when(
                  data: (customLists) {
                    if (customLists.isEmpty) {
                      return const SizedBox.shrink();
                    }

                    return ListView.builder(
                      padding: EdgeInsets.zero,
                      itemCount: customLists.length,
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
                      valueColor: AlwaysStoppedAnimation<Color>(
                        CineColors.amber,
                      ),
                    ),
                  ),
                  error: (_, _) => const SizedBox.shrink(),
                ),
              ),
              const Divider(height: 1, color: Color(0x33FFFFFF)),
              _NewListRow(
                enabled: uid != null,
                onTap: uid == null
                    ? null
                    : () => _openCreateDialog(context, existingListNames),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NewListRow extends StatelessWidget {
  const _NewListRow({required this.enabled, required this.onTap});

  final bool enabled;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: enabled ? onTap : null,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: CineSpacing.lg,
          vertical: CineSpacing.md,
        ),
        child: Row(
          children: [
            const Icon(Icons.add, color: CineColors.amber, size: 24),
            const SizedBox(width: CineSpacing.lg),
            Text(
              'New list',
              style: TextStyle(
                color: enabled ? CineColors.textLight : CineColors.textMuted,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
