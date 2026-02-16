import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/auth_repository.dart';
import '../data/user_repository.dart';

export '../data/user_repository.dart' show UserModel;

/// Provides singleton FirebaseAuth instance.
final firebaseAuthProvider = Provider<FirebaseAuth>(
  (ref) => FirebaseAuth.instance,
);

/// Provides AuthRepository instance with FirebaseAuth dependency.
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository(ref.watch(firebaseAuthProvider));
});

/// Provides singleton FirebaseFirestore instance.
final firebaseFirestoreProvider = Provider<FirebaseFirestore>(
  (ref) => FirebaseFirestore.instance,
);

/// Provides UserRepository instance with FirebaseFirestore dependency.
final userRepositoryProvider = Provider<UserRepository>((ref) {
  return UserRepository(ref.watch(firebaseFirestoreProvider));
});

/// Stream provider that emits current authentication state.
///
/// Emits User object when signed in, null when signed out.
/// Used throughout the app to react to auth changes.
final authStateProvider = StreamProvider<User?>((ref) {
  return ref.watch(authRepositoryProvider).authStateChanges();
});

/// Family provider that fetches user document from Firestore by uid.
/// - Keyed by uid to enable proper caching per user
/// - Auto-disposes when no longer observed to prevent cross-session leakage
/// - Returns null if uid is null (not authenticated)
final currentUserDocumentProvider = FutureProvider.autoDispose
    .family<UserModel?, String?>((ref, uid) async {
      if (uid == null) {
        return null;
      }

      // Fetch user document from Firestore
      final userDoc = await ref
          .watch(userRepositoryProvider)
          .getUserDocument(uid);

      return userDoc;
    });

/// Convenience provider that automatically extracts uid from auth state.
/// Use this provider in UI screens instead of manually extracting uid.
/// Auto-disposes when no longer observed to prevent cross-session leakage.
final currentUserProvider = FutureProvider.autoDispose<UserModel?>((ref) async {
  // Watch auth state to get current user's uid
  final authState = ref.watch(authStateProvider);
  final user =
      authState.asData?.value ?? ref.watch(authRepositoryProvider).currentUser;
  final uid = user?.uid;

  // Watch the family provider with the extracted uid
  final result = ref
      .watch(currentUserDocumentProvider(uid))
      .when(
        data: (user) => user,
        loading: () => throw const AsyncLoading<UserModel?>(),
        error: (error, stack) => throw AsyncError<UserModel?>(error, stack),
      );

  return result;
});
