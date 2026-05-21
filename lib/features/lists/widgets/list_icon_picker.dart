import 'package:flutter/material.dart';

import 'package:cine_shelf/features/lists/models/list_icon_catalog.dart';
import 'package:cine_shelf/shared/config/theme.dart';

/// Grid selector for predefined list icons.
///
/// Displays all icons from [listIconCatalog] in a 6-column grid.
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
      padding: const EdgeInsets.only(top: CineSpacing.xs),
      child: GridView.count(
        crossAxisCount: 6,
        shrinkWrap: true,
        padding: EdgeInsets.zero,
        physics: const NeverScrollableScrollPhysics(),
        mainAxisSpacing: CineSpacing.xs,
        crossAxisSpacing: CineSpacing.xs,
        childAspectRatio: 1.3,
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
    return Center(
      child: InkResponse(
        onTap: () => onSelected(iconName),
        radius: 25,
        child: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isSelected
                ? CineColors.amber.withValues(alpha: 0.18)
                : Colors.transparent,
            // border: Border.all(
            //   color: isSelected ? CineColors.amber : Colors.transparent,
            //   width: 1.4,
            // ),
          ),
          child: Center(
            child: Icon(iconData, color: CineColors.amber, size: 24),
          ),
        ),
      ),
    );
  }
}
