import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'package:cine_shelf/shared/config/theme.dart';

class EditableAvatar extends StatelessWidget {
  const EditableAvatar({
    required this.avatarUrl,
    required this.isLoading,
    required this.onTap,
    super.key,
  });

  final String? avatarUrl;
  final bool isLoading;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final hasAvatar = avatarUrl != null && avatarUrl!.trim().isNotEmpty;

    return Semantics(
      button: onTap != null,
      label: 'Edit avatar',
      child: Tooltip(
        message: 'Edit avatar',
        child: SizedBox(
          width: CineSizes.profileAvatar,
          height: CineSizes.profileAvatar,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Material(
                color: CineColors.bgDark,
                shape: const CircleBorder(
                  side: BorderSide(color: CineColors.amber, width: 2),
                ),
                clipBehavior: Clip.antiAlias,
                child: InkWell(
                  onTap: isLoading ? null : onTap,
                  customBorder: const CircleBorder(),
                  child: Ink(
                    width: CineSizes.profileAvatar,
                    height: CineSizes.profileAvatar,
                    child: hasAvatar
                        ? CachedNetworkImage(
                            imageUrl: avatarUrl!,
                            cacheKey: avatarUrl,
                            fit: BoxFit.cover,
                            placeholder: (context, url) =>
                                const _AvatarPlaceholder(showLoader: true),
                            errorWidget: (context, url, error) =>
                                const _AvatarPlaceholder(),
                          )
                        : const _AvatarPlaceholder(),
                  ),
                ),
              ),
              if (onTap != null)
                Positioned(
                  right: 0,
                  bottom: 2,
                  child: IgnorePointer(
                    child: Container(
                      width: 34,
                      height: 34,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: CineColors.surfaceRaised,
                        border: Border.all(color: CineColors.amber, width: 1.5),
                      ),
                      child: const Icon(
                        Icons.photo_camera_outlined,
                        size: 18,
                        color: CineColors.amber,
                      ),
                    ),
                  ),
                ),
              if (isLoading)
                Positioned.fill(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: CineColors.black.withValues(alpha: 0.55),
                    ),
                    child: const Center(
                      child: SizedBox(
                        width: CineSizes.loaderSmall,
                        height: CineSizes.loaderSmall,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            CineColors.amber,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AvatarPlaceholder extends StatelessWidget {
  const _AvatarPlaceholder({this.showLoader = false});

  final bool showLoader;

  @override
  Widget build(BuildContext context) {
    if (showLoader) {
      return const Center(
        child: SizedBox(
          width: CineSizes.loaderSmall,
          height: CineSizes.loaderSmall,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation<Color>(CineColors.amber),
          ),
        ),
      );
    }

    return const Center(
      child: Icon(
        Icons.person,
        size: CineSizes.profileAvatarIcon,
        color: CineColors.textMuted,
      ),
    );
  }
}
