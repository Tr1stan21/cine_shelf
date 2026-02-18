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

/// Tracks whether a sign-out operation is in progress.
///
/// Used to trigger immediate navigation to auth routes before auth stream updates.
final signOutInProgressProvider = NotifierProvider<SignOutFlagNotifier, bool>(
  SignOutFlagNotifier.new,
);

class SignOutFlagNotifier extends Notifier<bool> {
  @override
  bool build() => false;

  void setInProgress(bool value) {
    state = value;
  }
}

/// Future provider that fetches the full UserModel for the authenticated user.
///
/// Flow:
/// 1. Waits for authentication state to be determined via [authStateProvider.future]
/// 2. If no user is authenticated, returns null
/// 3. If authenticated, fetches the user's profile document from Firestore
///
/// Uses .autoDispose to automatically clean up resources when no longer watched,
/// reducing memory usage and preventing stale cached data.
///
/// Typical usage:
/// ```dart
/// final userModel = await ref.read(currentUserProvider.future);
/// final userAsyncValue = ref.watch(currentUserProvider);
/// ```
final currentUserProvider = FutureProvider.autoDispose<UserModel?>((ref) async {
  // Wait for auth state to be determined (converts StreamProvider to Future)
  final user = await ref.watch(authStateProvider.future);

  // If no user authenticated, return null early
  if (user == null) return null;

  // Fetch user's profile document from Firestore
  return ref.read(userRepositoryProvider).getUserDocument(user.uid);
});
