import 'package:flutter/material.dart';

/// Predefined, hardcoded catalog of icons available for custom lists.
///
/// Each key is a unique identifier (matching the `iconName` field in Firestore).
/// The value is the corresponding Flutter [IconData].
///
/// Icons are persisted by name to allow icon asset changes across app versions.
/// The selected icon is always rendered in amber ([CineColors.amber]).
const Map<String, IconData> listIconCatalog = {
  'bookmark_outline': Icons.bookmark_outline,
  'favorite_border': Icons.favorite_border,
  'star_outline': Icons.star_outline,
  'visibility_outlined': Icons.visibility_outlined,
  'movie_outlined': Icons.movie_outlined,
  'local_movies_outlined': Icons.local_movies_outlined,
  'emoji_events_outlined': Icons.emoji_events_outlined,
  'thumb_up_outlined': Icons.thumb_up_outlined,
  'nightlife_outlined': Icons.nightlife_outlined,
  'local_fire_department_outlined': Icons.local_fire_department_outlined,
  'science_outlined': Icons.science_outlined,
  'auto_awesome_outlined': Icons.auto_awesome_outlined,
};

/// Default icon when a custom list is created without explicit icon selection.
const String defaultIconName = 'bookmark_outline';
