import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:cine_shelf/features/auth/application/auth_providers.dart';
import 'package:cine_shelf/features/lists/application/list_providers.dart';
import 'package:cine_shelf/features/lists/models/user_custom_list.dart';

final customListActionsControllerProvider =
    Provider<CustomListActionsController>((ref) {
      return CustomListActionsController(ref);
    });

class CustomListActionsController {
  CustomListActionsController(this._ref);

  final Ref _ref;

  Future<void> deleteCustomList(UserCustomList list) async {
    final uid = _ref.read(authStateProvider).asData?.value?.uid;
    if (uid == null) return;

    await _ref
        .read(listRepositoryProvider)
        .deleteCustomList(uid: uid, listId: list.id);
  }
}
