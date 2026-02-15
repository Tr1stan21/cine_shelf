import 'package:firebase_auth/firebase_auth.dart';

/// Maps Firebase authentication exceptions to user-friendly error messages.
String mapAuthError(Object error) {
  if (error is FirebaseAuthException) {
    switch (error.code) {
      case 'invalid-email':
        return 'Invalid email address.';
      case 'user-not-found':
        return 'User not found.';
      case 'wrong-password':
        return 'Incorrect password.';
      case 'invalid-credential':
        return 'Invalid credentials.';
      case 'email-already-in-use':
        return 'Email already registered.';
      case 'weak-password':
        return 'Password too weak (min. 6 characters).';
      case 'too-many-requests':
        return 'Too many attempts. Try again later.';
      case 'operation-not-allowed':
        return 'Operation not allowed.';
      case 'account-exists-with-different-credential':
        return 'Account exists with different credential.';
      default:
        return 'Authentication error: ${error.code}.';
    }
  }
  return 'Operation failed. Please try again.';
}
