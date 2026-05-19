import 'dart:async';

import 'package:cine_shelf/features/auth/models/profile_update.dart';
import 'package:cine_shelf/features/auth/application/auth_providers.dart';
import 'package:cine_shelf/features/auth/application/validators.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import 'profile_edit_providers.dart';

class ProfileEditController extends AsyncNotifier<void> {
  @override
  FutureOr<void> build() {}

  Future<void> updateUsername({
    required BuildContext context,
    required String username,
  }) async {
    final trimmedUsername = username.trim();
    if (!isValidUsername(trimmedUsername)) {
      _showSnackBar(context, 'Username must be at least 2 characters.');
      return;
    }

    state = const AsyncLoading();
    try {
      final user = await ref.read(authStateProvider.future);
      if (user == null) {
        throw StateError('No authenticated user found.');
      }

      await ref
          .read(userRepositoryProvider)
          .updateEditableProfile(
            uid: user.uid,
            update: ProfileUpdate(username: trimmedUsername),
          );
      ref.invalidate(currentUserProvider);
      await ref.read(currentUserProvider.future);
      state = const AsyncData(null);
    } catch (error, stackTrace) {
      debugPrint('PROFILE USERNAME UPDATE ERROR: $error\n$stackTrace');
      state = AsyncError(error, stackTrace);
      if (context.mounted) {
        _showSnackBar(context, 'Could not update username. Please try again.');
      }
    }
  }

  Future<void> pickAndUploadAvatar(BuildContext context) async {
    final XFile? pickedImage;
    try {
      pickedImage = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 88,
      );
    } on PlatformException catch (error, stackTrace) {
      debugPrint('AVATAR PICKER ERROR: $error\n$stackTrace');
      if (context.mounted) {
        _showSnackBar(context, 'Could not open the photo library.');
      }
      return;
    }

    if (pickedImage == null) return;

    state = const AsyncLoading();
    String? uploadedUrl;
    try {
      final user = await ref.read(authStateProvider.future);
      if (user == null) {
        throw StateError('No authenticated user found.');
      }

      final bytes = await pickedImage.readAsBytes();
      final contentType = _contentTypeFor(pickedImage);
      uploadedUrl = await ref
          .read(avatarStorageRepositoryProvider)
          .uploadAvatar(uid: user.uid, bytes: bytes, contentType: contentType);

      await ref
          .read(userRepositoryProvider)
          .updateEditableProfile(
            uid: user.uid,
            update: ProfileUpdate(avatarUrl: uploadedUrl),
          );
      ref.invalidate(currentUserProvider);
      await ref.read(currentUserProvider.future);
      state = const AsyncData(null);
    } catch (error, stackTrace) {
      debugPrint('AVATAR UPDATE ERROR: $error\n$stackTrace');
      if (uploadedUrl != null) {
        await _deleteUploadedAvatar(uploadedUrl);
      }
      state = AsyncError(error, stackTrace);
      if (context.mounted) {
        _showSnackBar(context, 'Could not update avatar. Please try again.');
      }
    }
  }

  Future<void> _deleteUploadedAvatar(String url) async {
    try {
      await ref.read(avatarStorageRepositoryProvider).deleteByUrl(url);
    } catch (error, stackTrace) {
      debugPrint('AVATAR CLEANUP ERROR: $error\n$stackTrace');
    }
  }

  String _contentTypeFor(XFile file) {
    final mimeType = file.mimeType;
    if (mimeType != null && mimeType.startsWith('image/')) {
      return mimeType;
    }

    final name = file.name.toLowerCase();
    if (name.endsWith('.png')) return 'image/png';
    if (name.endsWith('.webp')) return 'image/webp';
    if (name.endsWith('.heic')) return 'image/heic';
    if (name.endsWith('.heif')) return 'image/heif';
    return 'image/jpeg';
  }

  void _showSnackBar(BuildContext context, String message) {
    if (!context.mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }
}
