import 'package:flutter/material.dart';

import 'package:cine_shelf/features/lists/models/list_icon_catalog.dart';
import 'package:cine_shelf/shared/config/theme.dart';

/// Grid selector for predefined list icons.
///
/// Displays all icons from [listIconCatalog] in a 3-column grid.
/// Selected icon is highlighted with an amber circle background.
///
/// Callback notifies parent of selected iconName key.
class ListIconPicker extends StatelessWidget {
  const ListIconPicker({
    required this.selectedIconName,
    required this.onIconSelected,
    super.key,
  });

  /// The currently selected icon key in [listIconCatalog].
  final String selectedIconName;

  /// Callback fired when user taps a different icon.
  /// Receives the iconName key (e.g., 'bookmark_outline').
  final ValueChanged<String> onIconSelected;

  @override
  Widget build(BuildContext context) {
    final iconEntries = listIconCatalog.entries.toList();

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: CineSpacing.md),
      child: Center(
        child: Wrap(
          spacing: CineSpacing.lg,
          runSpacing: CineSpacing.lg,
          children: [
            for (final entry in iconEntries)
              _IconOption(
                iconName: entry.key,
                iconData: entry.value,
                isSelected: entry.key == selectedIconName,
                onSelected: onIconSelected,
              ),
          ],
        ),
      ),
    );
  }
}

class _IconOption extends StatelessWidget {
  const _IconOption({
    required this.iconName,
    required this.iconData,
    required this.isSelected,
    required this.onSelected,
  });

  final String iconName;
  final IconData iconData;
  final bool isSelected;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    return InkResponse(
      onTap: () => onSelected(iconName),
      radius: 30,
      child: Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isSelected
              ? CineColors.amber.withValues(alpha: 0.2)
              : Colors.transparent,
          border: Border.all(
            color: isSelected ? CineColors.amber : Colors.transparent,
            width: 2,
          ),
        ),
        child: Center(child: Icon(iconData, color: CineColors.amber, size: 30)),
      ),
    );
  }
}
