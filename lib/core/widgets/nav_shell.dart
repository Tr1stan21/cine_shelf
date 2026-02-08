import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:cine_shelf/core/widgets/background.dart';
import 'package:cine_shelf/core/widgets/bottom_nav.dart';

class NavShell extends StatelessWidget {
  const NavShell({required this.navigationShell, super.key});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Background(child: navigationShell),
      bottomNavigationBar: BottomNav(navigationShell: navigationShell),
    );
  }
}
