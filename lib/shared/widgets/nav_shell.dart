import 'package:cine_shelf/shared/config/theme.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:cine_shelf/shared/widgets/background.dart';
import 'package:cine_shelf/shared/widgets/bottom_nav.dart';

class NavShell extends StatelessWidget {
  const NavShell({required this.navigationShell, super.key});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Background(
        padding: EdgeInsets.all(CineSpacing.md),
        child: navigationShell,
      ),
      bottomNavigationBar: BottomNavBar(navigationShell: navigationShell),
    );
  }
}
