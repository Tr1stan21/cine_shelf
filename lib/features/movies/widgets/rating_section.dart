import 'package:cine_shelf/features/auth/application/auth_providers.dart';
import 'package:cine_shelf/features/movies/models/movie_poster.dart';
import 'package:cine_shelf/features/rating/application/rating_controller.dart';
import 'package:cine_shelf/features/rating/application/rating_providers.dart';
import 'package:cine_shelf/features/rating/widgets/star_rating_widget.dart';
import 'package:cine_shelf/shared/config/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Star rating widget connected to Firestore for the detail screen.
///
/// Disabled with a SnackBar guard when the movie is not in Watched.
/// Disabled visually (outline-only stars) while the rating stream loads
/// or when the movie has not been rated yet — matching the unrated appearance.
class RatingSection extends ConsumerWidget {
  const RatingSection({
    required this.movie,
    required this.isWatched,
    super.key,
  });

  final MoviePoster movie;
  final bool isWatched;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ratingAsync = ref.watch(movieRatingProvider(movie.id));
    final rating = ratingAsync.asData?.value; // null while loading or unrated

    return Padding(
      padding: const EdgeInsets.only(top: CineSpacing.md),
      child: StarRatingWidget(
        rating: rating,
        editable: isWatched && !ratingAsync.isLoading,
        onRatingUpdate: (stars) {
          final uid = ref.read(authStateProvider).asData?.value?.uid;
          if (uid == null) return;
          ref
              .read(ratingControllerProvider)
              .setRating(
                context: context,
                uid: uid,
                movieId: movie.id,
                stars: stars,
              );
        },
        onDisabledTap: isWatched
            ? null // loading state — no message needed
            : () => ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Add the movie to Watched before rating it.'),
                ),
              ),
      ),
    );
  }
}
