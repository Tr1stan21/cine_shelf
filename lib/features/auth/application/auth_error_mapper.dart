import 'package:firebase_auth/firebase_auth.dart';

/// Minimum auth error mapping to readable messages.
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