import 'package:cine_shelf/features/account/widgets/account_row.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:cine_shelf/shared/config/theme.dart';
import 'package:cine_shelf/shared/widgets/separators.dart';
import 'package:cine_shelf/features/account/widgets/stat_pill.dart';
import 'package:cine_shelf/features/account/widgets/region_dropdown.dart';
import 'package:cine_shelf/features/auth/application/auth_controller.dart';
import 'package:cine_shelf/features/auth/application/auth_error_mapper.dart';
import 'package:cine_shelf/features/auth/application/auth_providers.dart';
import 'package:cine_shelf/features/lists/application/list_providers.dart';
import 'package:cine_shelf/router/route_paths.dart';
import 'package:cine_shelf/features/lists/domain/list_ids.dart';

/// User profile and account management screen.
///
/// **Currently active:**
/// - Profile avatar placeholder (icon only; photo upload not yet implemented)
/// - Username and email loaded from Firestore via [currentUserProvider]
/// - Navigation to Credits screen
/// - Sign Out action
///
/// **Temporarily disabled (pending feature completion):**
/// - Statistics pill ([StatsPill]) showing watched, watchlist, and favorites counts
/// - Edit Profile option ([AccountRow] for profile editing)
///
/// Data is loaded from Firestore via [currentUserProvider] with
/// loading/error states handled inline. Sign out is delegated to
/// [AuthController.signOut], which sets [signOutInProgressProvider] before
/// the Firebase stream updates, ensuring GoRouter redirects immediately.
class AccountScreen extends ConsumerWidget {
  const AccountScreen({super.key});

  /// Handles sign out with proper state cleanup.
  ///
  /// Delegates to [AuthController.signOut], which sets [signOutInProgressProvider]
  /// to `true` before calling Firebase so GoRouter redirects to login before
  /// the auth stream emits `null`. Errors are shown in a [SnackBar].
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
    final userDocument = ref.watch(currentUserProvider);
    final watchedCount = ref.watch(listCountProvider(watchedListId));
    final watchlistCount = ref.watch(listCountProvider(watchlistListId));
    final favoritesCount = ref.watch(listCountProvider(favoritesListId));

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: CineSpacing.lg),
      child: Column(
        children: [
          const RegionDropdown(),
          const SizedBox(height: CineSpacing.xxxl),

          // Avatar placeholder.
          Container(
            width: CineSizes.profileAvatar,
            height: CineSizes.profileAvatar,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: CineColors.amber, width: 2),
              color: CineColors.bgDark,
            ),
            child: const Center(
              child: Icon(
                Icons.person,
                size: CineSizes.profileAvatarIcon,
                color: CineColors.textMuted,
              ),
            ),
          ),

          const SizedBox(height: CineSpacing.lg),

          // Username and email from Firestore
          userDocument.when(
            data: (user) {
              if (user == null) {
                return const Column(
                  children: [
                    Text('User', style: CineTypography.profileName),
                    SizedBox(height: CineSpacing.xs),
                    Text('No email', style: CineTypography.profileEmail),
                  ],
                );
              }

              return Column(
                children: [
                  Text(user.username, style: CineTypography.profileName),
                  const SizedBox(height: CineSpacing.xs),
                  Text(user.email, style: CineTypography.profileEmail),
                ],
              );
            },
            loading: () => const Column(
              children: [
                SizedBox(
                  width: CineSizes.loaderSmall,
                  height: CineSizes.loaderSmall,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(CineColors.amber),
                  ),
                ),
              ],
            ),
            error: (error, stackTrace) => const Column(
              children: [
                Text('User', style: CineTypography.profileName),
                SizedBox(height: CineSpacing.xs),
                Text(
                  'Error loading profile',
                  style: CineTypography.profileEmail,
                ),
              ],
            ),
          ),

          const SizedBox(height: CineSpacing.xxl),

          // Stats (1 pill, 4 items)
          StatsPill(
            watchedValue: watchedCount.value ?? 0,
            favoriteValue: favoritesCount.value ?? 0,
            watchlistValue: watchlistCount.value ?? 0,
          ),
          const SizedBox(height: CineSpacing.xl),
          const SizedBox(height: CineSpacing.xxl),
          const GlowSeparator(),
          const SizedBox(height: CineSpacing.xxl),

          const AccountRow(
            icon: Icons.person_outline,
            label: 'Edit Profile',
            onTap: null,
          ),
          const ThinDivider(),
          AccountRow(
            icon: Icons.format_list_bulleted,
            label: 'Credits',
            onTap: () => context.push(RoutePaths.credits),
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
