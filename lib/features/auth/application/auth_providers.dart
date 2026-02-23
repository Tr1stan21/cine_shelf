import 'package:cine_shelf/features/auth/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/auth_repository.dart';
import '../data/user_repository.dart';

/// Provides singleton FirebaseAuth instance.
final firebaseAuthProvider = Provider<FirebaseAuth>(
  (ref) => FirebaseAuth.instance,
);

/// Provides [AuthRepository] instance with [FirebaseAuth] dependency.
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository(ref.watch(firebaseAuthProvider));
});

/// Provides singleton FirebaseFirestore instance.
final firebaseFirestoreProvider = Provider<FirebaseFirestore>(
  (ref) => FirebaseFirestore.instance,
);

/// Provides [UserRepository] instance with [FirebaseFirestore] dependency.
final userRepositoryProvider = Provider<UserRepository>((ref) {
  return UserRepository(ref.watch(firebaseFirestoreProvider));
});

/// Stream provider that emits current authentication state.
///
/// Emits [User] object when signed in, `null` when signed out.
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

/// Notifier that tracks whether a sign-out operation is currently in progress.
///
/// Set to `true` immediately before calling Firebase's sign-out method so that
/// [AuthStateNotifier] can treat the user as unauthenticated right away —
/// before the Firebase auth stream emits `null`. This prevents a window where
/// GoRouter's redirect logic still sees the user as authenticated while
/// sign-out is underway.
///
/// Reset to `false` in the `finally` block of [AuthController.signOut],
/// regardless of success or failure.
///
/// **Usage:**
/// ```dart
/// final isSigningOut = ref.watch(signOutInProgressProvider);
/// ```
class SignOutFlagNotifier extends Notifier<bool> {
  @override
  bool build() => false;

  /// Updates the sign-out progress flag.
  ///
  /// - Pass `true` before initiating sign-out to block authenticated access.
  /// - Pass `false` in `finally` to restore normal auth evaluation.
  void setInProgress(bool value) {
    state = value;
  }
}

/// Future provider that fetches the full [UserModel] for the authenticated user.
///
/// **Flow:**
/// 1. Awaits [authStateProvider] to determine the current [User].
/// 2. Returns `null` if no user is authenticated.
/// 3. Fetches the user's Firestore profile document via [UserRepository].
///
/// **Dependencies:**
/// - [authStateProvider]: Determines which user to fetch.
/// - [userRepositoryProvider]: Performs the Firestore read.
///
/// **Lifecycle (autoDispose):**
/// This provider is autoDisposed — it frees its cache when no widget is
/// watching it. During an authenticated session, [NavShell._UserPreloadWatcher]
/// (see `lib/router/shell.dart`) keeps this provider alive to prevent repeated
/// Firestore reads as the user navigates between tabs.
final currentUserProvider = FutureProvider.autoDispose<UserModel?>((ref) async {
  // Wait for auth state to be determined (converts StreamProvider to Future)
  final user = await ref.watch(authStateProvider.future);

  // If no user authenticated, return null early
  if (user == null) return null;

  // Fetch user's profile document from Firestore
  return ref.read(userRepositoryProvider).getUserDocument(user.uid);
});
