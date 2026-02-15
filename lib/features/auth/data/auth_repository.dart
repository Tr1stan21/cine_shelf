import 'package:firebase_auth/firebase_auth.dart';

/// Repository for Firebase Authentication operations.
///
/// Wraps Firebase Auth SDK to provide a clean interface for:
/// - Email/password authentication (sign in, sign up)
/// - Auth state monitoring
/// - User session management (sign out, delete account)
///
/// All methods throw FirebaseAuthException on failure.
class AuthRepository {
  AuthRepository(this._auth);

  final FirebaseAuth _auth;

  /// Stream that emits whenever authentication state changes.
  ///
  /// Emits:
  /// - User object when signed in
  /// - null when signed out
  Stream<User?> authStateChanges() => _auth.authStateChanges();

  /// Returns currently authenticated user, or null if not signed in.
  User? get currentUser => _auth.currentUser;

  /// Authenticates user with email and password.
  ///
  /// Throws [FirebaseAuthException] with codes:
  /// - `invalid-email`: Email format is invalid
  /// - `user-not-found`: No user found with this email
  /// - `wrong-password`: Password is incorrect
  /// - `invalid-credential`: General credential validation failure
  Future<void> signInWithEmailPassword({
    required String email,
    required String password,
  }) async {
    await _auth.signInWithEmailAndPassword(email: email, password: password);
  }

  /// Creates new user account with email and password.
  ///
  /// Returns [UserCredential] containing the newly created user.
  ///
  /// Throws [FirebaseAuthException] with codes:
  /// - `email-already-in-use`: Email is already registered
  /// - `weak-password`: Password does not meet requirements (min 6 chars)
  /// - `invalid-email`: Email format is invalid
  Future<UserCredential> signUpWithEmailPassword({
    required String email,
    required String password,
  }) async {
    return _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  /// Deletes the currently authenticated user account.
  ///
  /// Used for rollback in case user profile creation fails after signup.
  /// Does nothing if no user is currently authenticated.
  Future<void> deleteCurrentUser() async {
    final user = _auth.currentUser;
    if (user != null) {
      await user.delete();
    }
  }

  /// Signs out the current user.
  ///
  /// Clears authentication state and triggers authStateChanges stream.
  Future<void> signOut() => _auth.signOut();
}
