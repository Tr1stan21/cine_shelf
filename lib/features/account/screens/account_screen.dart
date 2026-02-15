import 'package:cine_shelf/features/account/widgets/account_row.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:cine_shelf/shared/config/theme.dart';
import 'package:cine_shelf/shared/widgets/separators.dart';
import 'package:cine_shelf/features/account/widgets/stat_pill.dart';
import 'package:cine_shelf/features/auth/application/auth_controller.dart';
import 'package:cine_shelf/features/auth/application/auth_error_mapper.dart';

class AccountScreen extends ConsumerWidget {
  const AccountScreen({super.key});

  Future<void> _onSignOut(BuildContext context, WidgetRef ref) async {
    try {
      await ref.read(authControllerProvider).signOut();
    } catch (e) {
      debugPrint('SIGNOUT ERROR: $e');
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(mapAuthError(e))));
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: CineSpacing.lg),
      child: Column(
        children: [
          const SizedBox(height: CineSpacing.xxxl),

          // Avatar (simple)
          Container(
            width: 110,
            height: 110,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: CineColors.amber, width: 2),
              color: CineColors.bgDark,
            ),
            child: const Center(
              child: Icon(Icons.person, size: 46, color: CineColors.textMuted),
            ),
          ),

          const SizedBox(height: CineSpacing.lg),
          const Text(
            'John Doe',
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w600,
              color: CineColors.amber,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'john.doe@example.com',
            style: TextStyle(fontSize: 16, color: CineColors.textSecondary),
          ),

          const SizedBox(height: CineSpacing.xxl),

          // Stats (1 pill, 4 items)
          const StatsPill(),

          const SizedBox(height: CineSpacing.xxl),
          const GlowSeparator(),
          const SizedBox(height: CineSpacing.xxl),

          const AccountRow(
            icon: Icons.person_outline,
            label: 'Edit Profile',
            onTap: null,
          ),
          const ThinDivider(),
          const AccountRow(
            icon: Icons.format_list_bulleted,
            label: 'Credits',
            onTap: null,
          ),
          const ThinDivider(),
          AccountRow(
            icon: Icons.power_settings_new,
            label: 'Sign Out',
            onTap: () => _onSignOut(context, ref),
          ),
        ],
      ),
    );
  }
}
