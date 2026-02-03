import 'package:flutter/material.dart';
import 'screens/splash.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CineShelf',
      home: const Splash(),
    );
  }
}
