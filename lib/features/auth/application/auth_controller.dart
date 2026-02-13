import 'package:firebase_auth/firebase_auth.dart';
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

  Future<void> signUp(String email, String password) async {
    await ref
        .read(authRepositoryProvider)
        .signUpWithEmailPassword(email: email, password: password);
  }

  Future<void> signOut() async {
    await ref.read(authRepositoryProvider).signOut();
  }
}

/// Mapeo mínimo de errores a mensajes legibles (industrial, sin humo)
String mapAuthError(Object error) {
  if (error is FirebaseAuthException) {
    switch (error.code) {
      case 'invalid-email':
        return 'Email inválido.';
      case 'user-not-found':
      case 'wrong-password':
      case 'invalid-credential':
        return 'Credenciales incorrectas.';
      case 'email-already-in-use':
        return 'Ese email ya está registrado.';
      case 'weak-password':
        return 'La contraseña es demasiado débil.';
      case 'too-many-requests':
        return 'Demasiados intentos. Prueba más tarde.';
      default:
        return 'Error de autenticación: ${error.code}.';
    }
  }
  return 'Error inesperado. Inténtalo de nuevo.';
}
