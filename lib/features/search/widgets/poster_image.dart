import 'package:cached_network_image/cached_network_image.dart';
import 'package:cine_shelf/shared/config/constants.dart';
import 'package:cine_shelf/shared/config/theme.dart';
import 'package:flutter/material.dart';

class PosterImage extends StatelessWidget {
  const PosterImage({required this.posterPath, super.key});

  final String? posterPath;

  @override
  Widget build(BuildContext context) {
    final path = posterPath;

    if (path == null || path.isEmpty) {
      return const ColoredBox(
        color: CineColors.surfaceRaised,
        child: Icon(
          Icons.image_not_supported_outlined,
          color: CineColors.textSecondary,
          size: 22,
        ),
      );
    }

    return CachedNetworkImage(
      imageUrl: AppConstants.tmdbPosterUrl(path),
      fit: BoxFit.cover,
      filterQuality: FilterQuality.low,
      placeholder: (_, _) => const Center(
        child: SizedBox(
          width: CineSizes.loaderTiny,
          height: CineSizes.loaderTiny,
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
      ),
      errorWidget: (_, _, _) => const ColoredBox(
        color: CineColors.surfaceRaised,
        child: Icon(
          Icons.broken_image_outlined,
          color: CineColors.textSecondary,
          size: 22,
        ),
      ),
    );
  }
}
