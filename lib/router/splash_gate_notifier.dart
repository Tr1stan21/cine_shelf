import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:cine_shelf/features/auth/application/auth_providers.dart';
import 'package:cine_shelf/features/auth/utils/preload_user_data.dart';

/// Controls when the splash screen is allowed to redirect.
///
/// Keeps the app on `/` while the gate is closed to avoid
/// early redirects and infinite loops.
class SplashGateNotifier extends ChangeNotifier {
  SplashGateNotifier(this._ref);

  final Ref _ref;
  bool _isReady = false;
  bool _isRunning = false;

  bool get isReady => _isReady;

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
final splashGateNotifierProvider = Provider<SplashGateNotifier>((ref) {
  final notifier = SplashGateNotifier(ref);
  ref.onDispose(notifier.dispose);
  return notifier;
});
