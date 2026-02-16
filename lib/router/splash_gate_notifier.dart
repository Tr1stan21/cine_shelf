import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Controls when the splash screen is allowed to redirect.
///
/// Keeps the app on `/` while the gate is closed to avoid
/// early redirects and infinite loops.
class SplashGateNotifier extends ChangeNotifier {
  bool _isReady = false;
  bool _isRunning = false;

  bool get isReady => _isReady;

  Future<void> runGate({
    required Duration minDelay,
    required VoidCallback onPreload,
  }) async {
    if (_isRunning) {
      return;
    }

    _isRunning = true;
    _isReady = false;
    notifyListeners();

    onPreload();
    await Future.delayed(minDelay);

    _isReady = true;
    _isRunning = false;
    notifyListeners();
  }
}

/// Provider for SplashGateNotifier instance.
final splashGateNotifierProvider = Provider<SplashGateNotifier>((ref) {
  final notifier = SplashGateNotifier();
  ref.onDispose(notifier.dispose);
  return notifier;
});
