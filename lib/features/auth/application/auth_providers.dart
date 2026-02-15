import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/auth_repository.dart';
import '../data/user_repository.dart';

export '../data/user_repository.dart' show UserModel;

final firebaseAuthProvider = Provider<FirebaseAuth>(
  (ref) => FirebaseAuth.instance,
);

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository(ref.watch(firebaseAuthProvider));
});

final firebaseFirestoreProvider = Provider<FirebaseFirestore>(
  (ref) => FirebaseFirestore.instance,
);

final userRepositoryProvider = Provider<UserRepository>((ref) {
  return UserRepository(ref.watch(firebaseFirestoreProvider));
});

final authStateProvider = StreamProvider<User?>((ref) {
  return ref.watch(authRepositoryProvider).authStateChanges();
});

/// Family provider that fetches user document from Firestore by uid.
/// - Keyed by uid to enable proper caching per user
/// - Uses keepAlive to persist cache across rebuilds while user is authenticated
/// - Returns null if uid is null (not authenticated)
final currentUserDocumentProvider = FutureProvider.family<UserModel?, String?>((
  ref,
  uid,
) async {
  if (uid == null) {
    return null;
  }

  // Fetch user document from Firestore
  final userDoc = await ref.watch(userRepositoryProvider).getUserDocument(uid);

  // Keep provider alive to avoid refetching on every rebuild
  ref.keepAlive();

  return userDoc;
});

/// Convenience provider that automatically extracts uid from auth state.
/// Use this provider in UI screens instead of manually extracting uid.
final currentUserProvider = FutureProvider<UserModel?>((ref) async {
  // Watch auth state to get current user's uid
  final authState = ref.watch(authStateProvider);
  final uid = authState.whenData((user) => user?.uid).value;

  // Watch the family provider with the extracted uid
  return ref
      .watch(currentUserDocumentProvider(uid))
      .when(
        data: (user) => user,
        loading: () => throw const AsyncLoading<UserModel?>(),
        error: (error, stack) => throw AsyncError<UserModel?>(error, stack),
      );
});
