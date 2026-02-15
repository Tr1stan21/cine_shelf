import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'auth_providers.dart';

final authControllerProvider = Provider.autoDispose<AuthController>((ref) {
  return AuthController(ref);
});

class AuthController {
  final Ref ref;

  AuthController(this.ref);

  Future<void> signIn(String email, String password) async {
    await ref
        .read(authRepositoryProvider)
        .signInWithEmailPassword(email: email, password: password);
  }

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

  Future<void> signOut() async {
    await ref.read(authRepositoryProvider).signOut();
  }
}