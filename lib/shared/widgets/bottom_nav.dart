import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:cine_shelf/shared/config/theme.dart';

/// Custom bottom navigation bar for main app tabs.
///
/// Displays three navigation items:
/// - Home: Browse and discover movies
/// - My Lists: Access user's collections (disabled — see note below)
/// - Account: Profile and settings
///
/// Integrates with GoRouter's [StatefulNavigationShell] for
/// persistent tab state and independent navigation stacks.
///
/// **Note on My Lists tab:**
/// The My Lists tab item is currently not rendered in the bar even though
/// its branch is registered in the router and [MyListsScreen] is fully
/// implemented. It is hidden until list management actions (add/remove movies)
/// are complete. Re-enable by uncommenting the corresponding [_BottomNavItem].
class BottomNavBar extends StatelessWidget {
  const BottomNavBar({required this.navigationShell, super.key});

  final StatefulNavigationShell navigationShell;

  /// Handles tab selection from the bottom navigation bar.
  ///
  /// If the user taps the tab that is already active, [goBranch] is called
  /// with `initialLocation: true`, which pops the tab's navigation stack back
  /// to its root route. This mirrors standard iOS/Android tab bar behavior.
  ///
  /// If the user taps a different tab, [goBranch] switches to that branch
  /// while preserving each tab's independent navigation stack.
  void _onTap(int newIndex) {
    navigationShell.goBranch(
      newIndex,
      // Re-tapping the active tab resets it to its root route.
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
            // _BottomNavItem(
            //   selected: index == 1,
            //   icon: Icons.view_list_rounded,
            //   label: 'My Lists',
            //   onTap: () => _onTap(1),
            // ),
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
/// Renders an icon and a label. Visual state (color and font weight) changes
/// based on whether this item is the currently [selected] tab.
class _BottomNavItem extends StatelessWidget {
  const _BottomNavItem({
    required this.selected,
    required this.icon,
    required this.label,
    required this.onTap,
  });

  /// Whether this item represents the currently active tab.
  final bool selected;

  /// Icon to display for this navigation destination.
  final IconData icon;

  /// Short label displayed below the icon.
  final String label;

  /// Callback invoked when the user taps this item.
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
