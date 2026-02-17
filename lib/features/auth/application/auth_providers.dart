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

/// Convenience provider that automatically extracts uid from auth state.
/// Use this provider in UI screens instead of manually extracting uid.
final currentUserProvider = FutureProvider<UserModel?>((ref) async {
  final auth = ref.watch(authStateProvider);

  final user = await auth.when(
    data: (u) async => u,
    loading: () => ref.watch(authStateProvider.future),
    error: (e, st) => Future.error(e, st),
  );

  if (user == null) return null;
  return ref.read(userRepositoryProvider).getUserDocument(user.uid);
});
