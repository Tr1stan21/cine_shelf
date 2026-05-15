import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/avatar_storage_repository.dart';
import 'profile_edit_controller.dart';

final firebaseStorageProvider = Provider<FirebaseStorage>((ref) {
  return FirebaseStorage.instance;
});

final avatarStorageRepositoryProvider = Provider<AvatarStorageRepository>((
  ref,
) {
  return AvatarStorageRepository(ref.watch(firebaseStorageProvider));
});

final profileEditControllerProvider =
    AsyncNotifierProvider.autoDispose<ProfileEditController, void>(
      ProfileEditController.new,
    );
