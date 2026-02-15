import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cine_shelf/features/auth/application/auth_providers.dart';

/// ChangeNotifier that wraps Firebase auth state stream.
/// Used by GoRouter as refreshListenable to trigger redirect logic on auth changes.
///
/// This bridges Riverpod's StreamProvider with GoRouter's Listenable requirement,
/// ensuring router reacts to auth state changes consistently with the rest of the app.
class AuthStateNotifier extends ChangeNotifier {
  AuthStateNotifier(this._ref) {
    _subscription = _ref.read(authRepositoryProvider).authStateChanges().listen(
      (user) {
        _currentUser = user;
        _isInitialized = true;
        notifyListeners();
      },
    );
  }

  final Ref _ref;
  StreamSubscription<User?>? _subscription;
  User? _currentUser;
  bool _isInitialized = false;

  /// Returns true if user is currently authenticated
  bool get isAuthenticated => _currentUser != null;

  /// Returns true if auth state has been determined (stream emitted at least once)
  bool get isInitialized => _isInitialized;

  @override
  void dispose() {
    _subscription?.cancel();
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
