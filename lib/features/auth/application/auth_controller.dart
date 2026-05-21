import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'auth_providers.dart';
import 'package:cine_shelf/features/auth/data/local/user_local_datasource_provider.dart';
import 'package:cine_shelf/features/lists/data/local/list_local_datasource_provider.dart';
import 'package:cine_shelf/features/rating/data/local/rating_cache_datasource_provider.dart';

/// Provider for AuthController instances.
final authControllerProvider = Provider<AuthController>((ref) {
  return AuthController(ref);
});

/// Application-level controller for authentication operations.
///
/// Orchestrates auth and user repository interactions to ensure:
/// - Atomic user creation (auth + profile document)
/// - Proper rollback on failures
/// - Clean state management
///
/// All methods throw exceptions on failure for proper error handling in UI.
class AuthController {
  final Ref ref;

  AuthController(this.ref);

  /// Authenticates user with email and password.
  ///
  /// Delegates to AuthRepository. Throws FirebaseAuthException on failure.
  Future<void> signIn(String email, String password) async {
    await ref
        .read(authRepositoryProvider)
        .signInWithEmailPassword(email: email, password: password);
  }

  /// Creates new user account with profile document.
  ///
  /// Atomicity guarantee:
  /// 1. Creates Firebase Auth user
  /// 2. Creates Firestore profile document
  /// 3. If step 2 fails, deletes Auth user (best-effort rollback)
  ///
  /// This prevents orphaned auth accounts without profile data.
  ///
  /// Throws:
  /// - [FirebaseAuthException] if account creation fails
  /// - Generic exception if profile creation fails (after rollback attempt)
  Future<void> signUp(String username, String email, String password) async {
    final authRepository = ref.read(authRepositoryProvider);
    final userRepository = ref.read(userRepositoryProvider);

    final userCredential = await authRepository.signUpWithEmailPassword(
      email: email,
      password: password,
    );

    final user = userCredential.user;
    if (user == null) {
      throw FirebaseAuthException(
        code: 'unknown',
        message: 'Could not create user.',
      );
    }

    try {
      await userRepository.createUserDocument(
        uid: user.uid,
        username: username,
        email: email,
      );
    } catch (error) {
      // Compensation to avoid auth users without a profile document.
      try {
        await authRepository.deleteCurrentUser();
      } catch (rollbackError, rollbackStack) {
        debugPrint(
          'ROLLBACK ERROR: $rollbackError\nROLLBACK STACK: $rollbackStack',
        );
      }
      debugPrint('SIGNUP PROFILE ERROR: $error');
      rethrow;
    }
  }

  /// Signs out current user and clears all cached user data.
  Future<void> signOut() async {
    final signOutFlag = ref.read(signOutInProgressProvider.notifier);
    signOutFlag.setInProgress(true);

    final uid = ref.read(authStateProvider).asData?.value?.uid;

    try {
      if (uid != null) {
        await _clearUserCache(uid);
      }

      await ref.read(authRepositoryProvider).signOut();
    } catch (_) {
      signOutFlag.setInProgress(false);
      rethrow;
    }
  }

  Future<void> _clearUserCache(String uid) async {
    final userCache = ref.read(userLocalDataSourceProvider);
    final listCache = ref.read(listLocalDataSourceProvider);
    final listMovieCache = ref.read(listMovieLocalDataSourceProvider);
    final ratingCache = ref.read(ratingCacheLocalDataSourceProvider);

    await listMovieCache.clearByUid(uid);
    await listCache.clearLists(uid);
    await ratingCache.clearByUid(uid);
    await userCache.clearUser(uid);
  }
}
