import 'package:firebase_auth/firebase_auth.dart';

/// Repository for Firebase Authentication operations.
///
/// Wraps Firebase Auth SDK to provide a clean interface for:
/// - Email/password authentication (sign in, sign up)
/// - Auth state monitoring
/// - User session management (sign out, delete account)
///
/// All methods throw [FirebaseAuthException] on failure.
///
/// **Dependency Injection for Testability:**
///
/// The [FirebaseAuth] instance is injected via constructor, allowing:
/// - Easy mocking in unit tests without Firebase initialization
/// - Alternative implementations or adapters in the future
/// - Decoupling from Firebase SDK specifics
///
/// Example for production:
/// ```dart
/// final authRepository = AuthRepository(FirebaseAuth.instance);
/// ```
///
/// Example for testing (with mock):
/// ```dart
/// final mockAuth = MockFirebaseAuth();
/// final authRepository = AuthRepository(mockAuth);
/// ```
class AuthRepository {
  /// Creates an AuthRepository with the provided FirebaseAuth instance.
  ///
  /// Parameters:
  /// - [auth]: FirebaseAuth instance to use for operations.
  ///   Injected for testability and flexibility.
  AuthRepository(this._auth);

  final FirebaseAuth _auth;

  /// Stream that emits whenever authentication state changes.
  ///
  /// Emits:
  /// - [User] object when signed in
  /// - `null` when signed out
  ///
  /// This is the single source of truth for authentication state.
  /// Multiple listeners can subscribe to this stream simultaneously.
  Stream<User?> authStateChanges() => _auth.authStateChanges();

  /// Returns currently authenticated user, or null if not signed in.
  ///
  /// Returns the cached user from Firebase Auth's session.
  /// For reactive updates, prefer [authStateChanges] stream instead.
  User? get currentUser => _auth.currentUser;

  /// Authenticates user with email and password.
  ///
  /// Throws [FirebaseAuthException] with codes:
  /// - `invalid-email`: Email format is invalid
  /// - `user-not-found`: No user found with this email
  /// - `wrong-password`: Password is incorrect
  /// - `invalid-credential`: General credential validation failure
  ///
  /// Upon success, triggers [authStateChanges] stream emission.
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
  ///
  /// Upon success, [authStateChanges] stream emits the new user.
  /// The returned [UserCredential] contains the newly authenticated user.
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
  ///
  /// Upon success, triggers [authStateChanges] stream with `null`.
  ///
  /// Throws [FirebaseAuthException] if deletion fails.
  Future<void> deleteCurrentUser() async {
    final user = _auth.currentUser;
    if (user != null) {
      await user.delete();
    }
  }

  /// Signs out the current user.
  ///
  /// Clears authentication state and triggers [authStateChanges] stream with `null`.
  ///
  /// Throws [FirebaseAuthException] if sign-out fails.
  Future<void> signOut() => _auth.signOut();
}
