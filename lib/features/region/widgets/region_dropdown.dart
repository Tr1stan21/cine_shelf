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
        if (context.mounted) {
          showCineSnackBar(context, 'Could not update region: $e');
        }
      }
    }

    return DropdownButtonFormField<String>(
      key: ValueKey<String?>(selectedValue),
      initialValue: selectedValue,
      isDense: true,
      isExpanded: true,
      dropdownColor: CineColors.bgDark,
      iconEnabledColor: CineColors.amber,
      iconDisabledColor: CineColors.textMuted,
      style: CineTypography.bodyMedium,
      decoration: InputDecoration(
        isDense: true,
        filled: true,
        fillColor: CineColors.black.withValues(alpha: 0.28),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: CineSpacing.md,
          vertical: CineSpacing.sm,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(CineRadius.lg),
          borderSide: const BorderSide(color: CineColors.amber, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(CineRadius.lg),
          borderSide: BorderSide(
            color: CineColors.amber.withValues(alpha: 0.75),
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(CineRadius.lg),
          borderSide: const BorderSide(color: CineColors.amber, width: 1),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(CineRadius.lg),
          borderSide: BorderSide(
            color: CineColors.textMuted.withValues(alpha: 0.35),
            width: 1,
          ),
        ),
      ),
      selectedItemBuilder: (context) {
        return regions
            .map((region) => _SelectedRegionLabel(flagEmoji: region.flagEmoji))
            .toList(growable: false);
      },
      onChanged: selectedRegionState.isLoading || regions.isEmpty
          ? null
          : onChanged,
      items: regions
          .map(
            (region) => DropdownMenuItem<String>(
              value: region.code,
              child: Text(
                '${region.flagEmoji} ${region.code}',
                overflow: TextOverflow.ellipsis,
              ),
            ),
          )
          .toList(growable: false),
    );
  }
}

class _SelectedRegionLabel extends StatelessWidget {
  const _SelectedRegionLabel({required this.flagEmoji});

  final String flagEmoji;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(Icons.public, size: 18, color: CineColors.amber),
        const SizedBox(width: CineSpacing.sm),
        Text(
          'Region:',
          style: CineTypography.bodyMedium.copyWith(
            color: CineColors.textLight,
          ),
        ),
        const SizedBox(width: CineSpacing.xs),
        Text(flagEmoji, style: const TextStyle(fontSize: 18)),
      ],
    );
  }
}
