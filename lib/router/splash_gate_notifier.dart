import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:cine_shelf/features/auth/application/auth_providers.dart';
import 'package:cine_shelf/router/preload_user_data.dart';

/// Controls when the splash screen is allowed to redirect.
///
/// Keeps the app on `/` while the gate is closed to avoid
/// early redirects and infinite loops.
///
/// The [_ref] parameter allows for dependency injection,
/// enabling easy mocking of auth and user repositories in tests.
class SplashGateNotifier extends ChangeNotifier {
  /// Creates a SplashGateNotifier with Riverpod reference for provider access.
  ///
  /// Parameters:
  /// - [_ref]: Riverpod reference for accessing providers
  SplashGateNotifier(this._ref);

  final Ref _ref;
  bool _isReady = false;
  bool _isRunning = false;

  bool get isReady => _isReady;

  /// Executes the splash gate sequence:
  /// 1. Waits for minimum splash display duration
  /// 2. Waits for auth state to be determined
  /// 3. If authenticated, preloads all user-related data
  ///
  /// Parameters:
  /// - [minDelay]: Minimum time to keep splash screen visible
  ///
  /// Guards against concurrent execution with [_isRunning] flag.
  Future<void> runGate({required Duration minDelay}) async {
    if (_isRunning) {
      return;
    }

    _isRunning = true;
    _isReady = false;
    notifyListeners();

    try {
      final results = await Future.wait([
        Future.delayed(minDelay),
        // Use read() to obtain the Future from authStateProvider without maintaining subscription
        // This is appropriate for one-time operations in Future.wait()
        _ref.read(authStateProvider.future),
      ]);
      final streamUser = results[1] as User?;
      final user = streamUser ?? _ref.read(authRepositoryProvider).currentUser;
      if (user != null) {
        await preloadUserData(_ref);
      }
    } catch (error, stackTrace) {
      debugPrint('SPLASH GATE ERROR: $error\n$stackTrace');
    }

    _isReady = true;
    _isRunning = false;
    notifyListeners();
  }
}

/// Provider for SplashGateNotifier instance.
///
/// The notifier is properly disposed when no longer needed,
/// ensuring that any listeners are cleaned up.
final splashGateNotifierProvider = Provider<SplashGateNotifier>((ref) {
  final notifier = SplashGateNotifier(ref);
  ref.onDispose(notifier.dispose);
  return notifier;
});
