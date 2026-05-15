import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';

/// Handles avatar binary storage in Firebase Storage.
class AvatarStorageRepository {
  AvatarStorageRepository(this._storage);

  final FirebaseStorage _storage;

  Future<String> uploadAvatar({
    required String uid,
    required Uint8List bytes,
    required String contentType,
  }) async {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final extension = _extensionForContentType(contentType);
    final ref = _storage.ref('avatars/$uid/avatar_$timestamp.$extension');

    await ref.putData(
      bytes,
      SettableMetadata(
        contentType: contentType,
        cacheControl: 'public,max-age=31536000,immutable',
      ),
    );

    return ref.getDownloadURL();
  }

  Future<void> deleteByUrl(String url) async {
    try {
      await _storage.refFromURL(url).delete();
    } on FirebaseException catch (error) {
      if (error.code != 'object-not-found') {
        rethrow;
      }
    }
  }

  String _extensionForContentType(String contentType) {
    return switch (contentType.toLowerCase()) {
      'image/png' => 'png',
      'image/webp' => 'webp',
      'image/heic' => 'heic',
      'image/heif' => 'heif',
      _ => 'jpg',
    };
  }
}
