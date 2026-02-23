import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'firebase_options.dart';
import 'app.dart';

/// Application entry point.
///
/// Performs necessary initialization before the widget tree is mounted:
/// - Ensures Flutter binding is initialized before any async operations.
/// - Initializes Firebase with platform-specific configuration.
/// - Configures the Flutter image cache size.
/// - Wraps the app in [ProviderScope] for Riverpod state management.
///
/// **Image Caching Strategy:**
/// [CachedNetworkImage] is used throughout the app for movie posters. It
/// maintains two cache layers:
/// - **In-memory (LRU):** Configured below via [imageCache.maximumSizeBytes].
///   Limited to 128 MB to balance performance and memory pressure.
/// - **Disk cache:** Managed automatically by the `cached_network_image`
///   package. No additional initialization is required; caching is automatic
///   and persists across app sessions until manually cleared.
///
/// First load: downloads from network and stores in both caches.
/// Subsequent loads: served from disk or memory without a network request,
/// reducing data usage and improving scroll performance.
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Limit Flutter's native in-memory image cache to 128 MB.
  // The default is unbounded, which can cause excessive memory usage when
  // scrolling through large movie poster grids.
  imageCache.maximumSizeBytes = 128 * 1024 * 1024;

  runApp(const ProviderScope(child: App()));
}
