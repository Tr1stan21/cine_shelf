import 'package:flutter/material.dart';

import 'package:cine_shelf/shared/config/theme.dart';

class StarRatingWidget extends StatelessWidget {
  const StarRatingWidget({
    required this.rating,
    this.editable = false,
    this.onRatingUpdate,
    this.onRatingClear,
    this.onDisabledTap,
    super.key,
  });

  final double? rating;
  final bool editable;
  final ValueChanged<double>? onRatingUpdate;
  final VoidCallback? onRatingClear;
  final VoidCallback? onDisabledTap;

  static const int _maxStars = 5;

  double get _value => (rating ?? 0).clamp(0, _maxStars).toDouble();

  double _nextRating(int starNumber) {
    final fullStars = _value.floor();
    final hasHalfStar = _value % 1 != 0;

    if (!hasHalfStar && starNumber == fullStars) {
      return starNumber - 0.5;
    }

    if (hasHalfStar && starNumber == fullStars + 1) {
      return starNumber.toDouble();
    }

    return starNumber.toDouble();
  }

  double _fillFor(int starNumber) {
    if (_value >= starNumber) return 1;
    if (_value >= starNumber - 0.5) return 0.5;
    return 0;
  }

  void _handleStarTap(int starNumber) {
    if (_value == 0.5 && starNumber == 1) {
      onRatingClear?.call();
      return;
    }

    onRatingUpdate?.call(_nextRating(starNumber));
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(_maxStars, (index) {
        final starNumber = index + 1;
        final fill = _fillFor(starNumber);

        return Padding(
          padding: const EdgeInsets.only(right: 6),
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: editable ? () => _handleStarTap(starNumber) : onDisabledTap,
            child: SizedBox.square(
              dimension: 30,
              child: Stack(
                children: [
                  const Icon(Icons.star, size: 30, color: CineColors.textMuted),
                  ClipRect(
                    child: Align(
                      alignment: Alignment.centerLeft,
                      widthFactor: fill,
                      child: const Icon(
                        Icons.star,
                        size: 30,
                        color: CineColors.amber,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}
