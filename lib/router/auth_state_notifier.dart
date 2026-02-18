import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cine_shelf/features/auth/data/auth_repository.dart';
import 'package:cine_shelf/features/auth/application/auth_providers.dart';

/// ChangeNotifier that wraps Firebase auth state stream.
/// Used by GoRouter as refreshListenable to trigger redirect logic on auth changes.
///
/// This bridges Riverpod's StreamProvider with GoRouter's Listenable requirement,
/// ensuring router reacts to auth state changes consistently with the rest of the app.
///
/// The notifier accepts an optional [AuthRepository] for dependency injection.
/// If not provided, it defaults to reading from [authRepositoryProvider],
/// allowing for easy mocking in tests or alternative implementations.
class AuthStateNotifier extends ChangeNotifier {
  /// Creates an AuthStateNotifier with optional dependency injection.
  ///
  /// Parameters:
  /// - [ref]: Reference to Riverpod for provider access
  /// - [authRepository]: Optional AuthRepository for dependency injection.
  ///   If null, will read from [authRepositoryProvider]
  AuthStateNotifier(this._ref, {AuthRepository? authRepository})
    : _authRepository = authRepository {
    _isSigningOut = _ref.read(signOutInProgressProvider);
    _signOutSubscription = _ref.listen<bool>(signOutInProgressProvider, (
      previous,
      next,
    ) {
      _isSigningOut = next;
      notifyListeners();
    });
    _subscription = _getAuthRepository().authStateChanges().listen((user) {
      _currentUser = user;
      _isInitialized = true;
      notifyListeners();
    });
  }

  final Ref _ref;
  final AuthRepository? _authRepository;
  StreamSubscription<User?>? _subscription;
  ProviderSubscription<bool>? _signOutSubscription;
  User? _currentUser;
  bool _isInitialized = false;
  bool _isSigningOut = false;

  /// Returns the AuthRepository instance to use.
  /// Prefers injected instance, falls back to provider read.
  AuthRepository _getAuthRepository() {
    return _authRepository ?? _ref.read(authRepositoryProvider);
  }

  /// Returns true if user is currently authenticated and not signing out.
  bool get isAuthenticated => _currentUser != null && !_isSigningOut;

  /// Returns true if a sign-out operation is currently running.
  bool get isSigningOut => _isSigningOut;

  /// Returns true if auth state has been determined (stream emitted at least once)
  bool get isInitialized => _isInitialized;

  @override
  void dispose() {
    _subscription?.cancel();
    _signOutSubscription?.close();
    super.dispose();
  }
}

/// Provider for AuthStateNotifier instance
final authStateNotifierProvider = Provider<AuthStateNotifier>((ref) {
  final notifier = AuthStateNotifier(ref);
  ref.onDispose(() {
    notifier.dispose();
  });
  return notifier;
});
