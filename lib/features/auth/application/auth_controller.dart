import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'auth_providers.dart';

/// Provider for AuthController instances.
///
/// Auto-disposed to avoid keeping controller in memory unnecessarily.
final authControllerProvider = Provider.autoDispose<AuthController>((ref) {
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

  /// Signs out current user and clears cached user data.
  ///
  /// Invalidates currentUserProvider to ensure stale data is not retained
  /// after logout.
  Future<void> signOut() async {
    await ref.read(authRepositoryProvider).signOut();
    // Invalidates the provider to clear user data from memory
    ref.invalidate(currentUserProvider);
  }
}
