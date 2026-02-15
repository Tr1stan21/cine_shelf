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
/// - Wraps the app in ProviderScope for Riverpod state management
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const ProviderScope(child: App()));
}
