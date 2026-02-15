import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:cine_shelf/shared/config/theme.dart';

/// Custom bottom navigation bar for main app tabs.
///
/// Displays three navigation items:
/// - Home: Browse and discover movies
/// - My Lists: Access user's collections
/// - Account: Profile and settings
///
/// Integrates with GoRouter's StatefulNavigationShell for
/// persistent tab state and independent navigation stacks.
class BottomNavBar extends StatelessWidget {
  const BottomNavBar({required this.navigationShell, super.key});

  final StatefulNavigationShell navigationShell;

  /// Handles tab selection.
  ///
  /// If tapping the currently active tab, resets to root of that tab's stack.
  /// Otherwise, switches to the selected tab.
  void _onTap(int newIndex) {
    navigationShell.goBranch(
      newIndex,
      // If you tap the active tab: return to the root of the tab.
      initialLocation: newIndex == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    final int index = navigationShell.currentIndex;

    return SafeArea(
      top: false,
      child: SizedBox(
        height: 72,
        child: Row(
          children: [
            _BottomNavItem(
              selected: index == 0,
              icon: Icons.home_rounded,
              label: 'Home',
              onTap: () => _onTap(0),
            ),
            _BottomNavItem(
              selected: index == 1,
              icon: Icons.view_list_rounded,
              label: 'My Lists',
              onTap: () => _onTap(1),
            ),
            _BottomNavItem(
              selected: index == 2,
              icon: Icons.person_rounded,
              label: 'Account',
              onTap: () => _onTap(2),
            ),
          ],
        ),
      ),
    );
  }
}

/// Individual navigation item within the bottom bar.
///
/// Displays icon and label with selected/unselected visual states.
class _BottomNavItem extends StatelessWidget {
  const _BottomNavItem({
    required this.selected,
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final bool selected;
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final Color active = CineColors.amber;
    final Color inactive = CineColors.textMuted;

    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 28, color: selected ? active : inactive),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                color: selected ? active : inactive,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
