import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:cine_shelf/config/theme.dart';

class BottomNav extends StatelessWidget {
  const BottomNav({required this.navigationShell, super.key});

  final StatefulNavigationShell navigationShell;

  void _onTap(int newIndex) {
    navigationShell.goBranch(
      newIndex,
      // Si pulsas el tab activo: vuelve a la raíz del tab.
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
            _Item(
              selected: index == 0,
              icon: Icons.home_rounded,
              label: 'Inicio',
              onTap: () => _onTap(0),
            ),
            _Item(
              selected: index == 1,
              icon: Icons.view_list_rounded,
              label: 'Mis listas',
              onTap: () => _onTap(1),
            ),
            _Item(
              selected: index == 2,
              icon: Icons.person_rounded,
              label: 'Cuenta',
              onTap: () => _onTap(2),
            ),
          ],
        ),
      ),
    );
  }
}

class _Item extends StatelessWidget {
  const _Item({
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
