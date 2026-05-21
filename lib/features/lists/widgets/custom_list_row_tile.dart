import 'package:cine_shelf/features/auth/application/auth_providers.dart';
import 'package:cine_shelf/features/lists/application/custom_list_actions_controller.dart';
import 'package:cine_shelf/features/lists/application/list_providers.dart';
import 'package:cine_shelf/features/lists/models/list_icon_catalog.dart';
import 'package:cine_shelf/features/lists/models/user_custom_list.dart';
import 'package:cine_shelf/features/lists/widgets/delete_custom_list_dialog.dart';
import 'package:cine_shelf/features/lists/widgets/list_row.dart';
import 'package:cine_shelf/features/movie_list/nav/movie_scroll_args.dart';
import 'package:cine_shelf/router/route_paths.dart';
import 'package:cine_shelf/shared/widgets/cine_snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class CustomListRowTile extends ConsumerWidget {
  const CustomListRowTile({required this.customList, super.key});

  final UserCustomList customList;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final iconData =
        listIconCatalog[customList.iconName] ?? Icons.bookmark_outline;
    final movieCount =
        ref.watch(listCountProvider(customList.id)).asData?.value ?? 0;

    return ListRow(
      icon: iconData,
      label: customList.name,
      numMovies: movieCount,
      onTap: () => _openList(context, ref),
      onLongPress: () => _confirmAndDeleteList(context, ref),
    );
  }

  Future<void> _openList(BuildContext context, WidgetRef ref) async {
    final uid = ref.read(authStateProvider).asData?.value?.uid;
    if (uid == null) return;

    try {
      final movies = await ref
          .read(listRepositoryProvider)
          .getListMovies(uid: uid, listId: customList.id);

      if (!context.mounted) return;

      context.push(
        RoutePaths.movies,
        extra: MovieListArgs(
          title: customList.name,
          items: movies,
          totalPages: 1,
        ),
      );
    } catch (error, stackTrace) {
      debugPrint('_openList [${customList.id}] error: $error\n$stackTrace');

      if (!context.mounted) return;
      showCineSnackBar(context, 'Could not open this list. Please try again.');
    }
  }

  Future<void> _confirmAndDeleteList(
    BuildContext context,
    WidgetRef ref,
  ) async {
    final shouldDelete = await showDeleteCustomListDialog(
      context,
      customList.name,
    );

    if (!shouldDelete) return;

    try {
      await ref
          .read(customListActionsControllerProvider)
          .deleteCustomList(customList);
    } catch (error, stackTrace) {
      debugPrint('CUSTOM LIST DELETE ERROR: $error\n$stackTrace');
      if (!context.mounted) return;
      showCineSnackBar(context, 'Could not delete the list. Please try again.');
    }
  }
}
