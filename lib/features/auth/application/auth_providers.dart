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

/// Future provider that fetches the current user's document from Firestore.
/// - Depends on authStateProvider (waits for authenticated user)
/// - Returns UserModel if logged in and document exists, null otherwise
/// - Used in AccountScreen to display username and email
final currentUserDocumentProvider = FutureProvider<UserModel?>((ref) async {
  // Watch auth state - if not logged in, will return null
  final authState = ref.watch(authStateProvider);

  // Extract the user object from AsyncValue
  final currentUser = authState.whenData((user) => user).value;
  if (currentUser == null) {
    return null;
  }

  // Fetch user document from Firestore
  return ref.watch(userRepositoryProvider).getUserDocument(currentUser.uid);
});
