import 'package:cine_shelf/features/account/widgets/account_row.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:cine_shelf/shared/config/theme.dart';
import 'package:cine_shelf/shared/widgets/cine_snack_bar.dart';
import 'package:cine_shelf/shared/widgets/separators.dart';
import 'package:cine_shelf/features/account/application/profile_edit_providers.dart';
import 'package:cine_shelf/features/account/widgets/editable_avatar.dart';
import 'package:cine_shelf/features/account/widgets/editable_username.dart';
import 'package:cine_shelf/features/account/widgets/stat_pill.dart';
import 'package:cine_shelf/features/region/widgets/region_dropdown.dart';
import 'package:cine_shelf/features/auth/application/auth_controller.dart';
import 'package:cine_shelf/features/auth/mappers/auth_error_mapper.dart';
import 'package:cine_shelf/features/auth/application/auth_providers.dart';
import 'package:cine_shelf/features/lists/application/list_providers.dart';
import 'package:cine_shelf/router/route_paths.dart';
import 'package:cine_shelf/features/lists/models/list_ids.dart';

/// User profile and account management screen.
///
/// **Currently active:**
/// - Editable profile avatar loaded from Firebase Storage URL when present
/// - Username and email loaded from Firestore via [currentUserProvider]
/// - Inline username editing
/// - Navigation to Credits screen
/// - Sign Out action
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
        showCineSnackBar(context, mapAuthError(e));
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userDocument = ref.watch(currentUserProvider);
    final loadedUser = switch (userDocument) {
      AsyncData(:final value) => value,
      _ => null,
    };
    final profileEditState = ref.watch(profileEditControllerProvider);
    final isProfileEditing = profileEditState.isLoading;
    final watchedCount = ref.watch(listCountProvider(watchedListId));
    final watchlistCount = ref.watch(listCountProvider(watchlistListId));
    final favoritesCount = ref.watch(listCountProvider(favoritesListId));

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: CineSpacing.lg),
      child: Column(
        children: [
          const Align(
            alignment: Alignment.centerRight,
            child: SizedBox(width: 96, child: RegionDropdown()),
          ),
          const SizedBox(height: CineSpacing.xxxl),

          EditableAvatar(
            avatarUrl: loadedUser?.avatarUrl,
            isLoading: userDocument.isLoading || isProfileEditing,
            onTap: loadedUser == null || isProfileEditing
                ? null
                : () => ref
                      .read(profileEditControllerProvider.notifier)
                      .pickAndUploadAvatar(context),
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
                  EditableUsername(
                    username: user.username,
                    isLoading: isProfileEditing,
                    onSave: (username) => ref
                        .read(profileEditControllerProvider.notifier)
                        .updateUsername(context: context, username: username),
                  ),
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
