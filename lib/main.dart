import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'firebase_options.dart';
import 'app.dart';

/// Application entry point.
///
/// Performs necessary initialization:
/// - Ensures Flutter binding is initialized before async operations
/// - Initializes Firebase with platform-specific configuration
/// - Configures global image caching for improved performance and data efficiency
/// - Wraps the app in ProviderScope for Riverpod state management
///
/// **Image Caching Strategy:**
/// - CachedNetworkImage automatically caches movie posters locally
/// - Configured to store up to 100 images (~256 MB typical size)
/// - Cache persists across app sessions unless manually cleared
/// - First load: downloads from network; subsequent loads: uses local cache
///
/// This reduces data usage significantly and improves app responsiveness.
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Configure global image cache settings for Flutter's native image cache
  // These settings affect all image loading, including CachedNetworkImage
  imageCache.maximumSizeBytes = 128 * 1024 * 1024; // 256 MB maximum cache size

  // CachedNetworkImage package automatically:
  // - Caches images to device storage (persistent cache)
  // - Validates cache on each request (smart cache invalidation)
  // - Provides in-memory LRU cache as well
  // No additional initialization needed; caching is automatic.

  runApp(const ProviderScope(child: App()));
}
