import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:cine_shelf/features/region/application/region_providers.dart';
import 'package:cine_shelf/features/region/models/region_catalog.dart';
import 'package:cine_shelf/shared/config/theme.dart';
import 'package:cine_shelf/shared/widgets/cine_snack_bar.dart';

/// Region selector used in the account screen.
///
/// Reads the current region preference from Riverpod, displays the static
/// region catalog, and persists updates through [SelectedRegionNotifier].
///
/// The control is disabled while the selected region is being initialized or
/// when no region options are available.
class RegionDropdown extends ConsumerWidget {
  const RegionDropdown({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedRegionState = ref.watch(selectedRegionProvider);
    final selectedRegionCode = ref.watch(selectedRegionCodeProvider);
    final regions = staticRegionsCatalog;

    final hasSelected = regions.any(
      (region) => region.code == selectedRegionCode,
    );
    // Keeps the form field value valid even if persisted data points to a
    // region that is no longer present in the static catalog.
    final selectedValue = hasSelected
        ? selectedRegionCode
        : (regions.isNotEmpty ? regions.first.code : null);

    Future<void> onChanged(String? regionCode) async {
      if (regionCode == null || regionCode == selectedRegionCode) {
        return;
      }
      try {
        await ref.read(selectedRegionProvider.notifier).setRegion(regionCode);
      } catch (e) {
        // Surfaces persistence failures to the user while keeping the previous
        // region value managed by the notifier rollback logic.
        if (context.mounted) {
          showCineSnackBar(context, 'Could not update region: $e');
        }
      }
    }

    return DropdownButtonFormField<String>(
      key: ValueKey<String?>(selectedValue),
      initialValue: selectedValue,
      dropdownColor: CineColors.bgDark,
      iconEnabledColor: CineColors.amber,
      style: CineTypography.bodyMedium,
      onChanged: selectedRegionState.isLoading || regions.isEmpty
          ? null
          : onChanged,
      items: regions
          .map(
            (region) => DropdownMenuItem<String>(
              value: region.code,
              child: Text('${region.flagEmoji} ${region.code}'),
            ),
          )
          .toList(growable: false),
    );
  }
}
