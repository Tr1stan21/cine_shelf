import 'package:cine_shelf/features/auth/application/validators.dart';
import 'package:cine_shelf/shared/config/theme.dart';
import 'package:flutter/material.dart';

class EditableUsername extends StatelessWidget {
  const EditableUsername({
    required this.username,
    required this.isLoading,
    required this.onSave,
    super.key,
  });

  final String username;
  final bool isLoading;
  final Future<void> Function(String username) onSave;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Flexible(
          child: Text(
            username,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: CineTypography.profileName,
          ),
        ),
        const SizedBox(width: CineSpacing.xs),
        IconButton(
          tooltip: 'Edit username',
          iconSize: 20,
          visualDensity: VisualDensity.compact,
          onPressed: isLoading ? null : () => _openDialog(context),
          icon: const Icon(Icons.edit_outlined, color: CineColors.amber),
        ),
      ],
    );
  }

  Future<void> _openDialog(BuildContext context) async {
    final controller = TextEditingController(text: username);
    String? errorText;

    void validateAndClose(BuildContext context, StateSetter setDialogState) {
      final value = controller.text.trim();
      if (!isValidUsername(value)) {
        setDialogState(() {
          errorText = 'Use at least 2 characters.';
        });
        return;
      }

      Navigator.of(context).pop(value);
    }

    try {
      final nextUsername = await showDialog<String>(
        context: context,
        builder: (context) {
          return StatefulBuilder(
            builder: (context, setDialogState) {
              return AlertDialog(
                backgroundColor: CineColors.surfaceRaised,
                title: const Text('Edit username'),
                content: TextField(
                  controller: controller,
                  autofocus: true,
                  maxLength: 40,
                  textInputAction: TextInputAction.done,
                  decoration: InputDecoration(
                    errorText: errorText,
                    counterStyle: const TextStyle(
                      color: CineColors.textSecondary,
                    ),
                  ),
                  onSubmitted: (_) => validateAndClose(context, setDialogState),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Cancel'),
                  ),
                  FilledButton.icon(
                    onPressed: () => validateAndClose(context, setDialogState),
                    icon: const Icon(Icons.check),
                    label: const Text('Save'),
                  ),
                ],
              );
            },
          );
        },
      );

      if (nextUsername == null || nextUsername == username.trim()) return;
      await onSave(nextUsername);
    } finally {
      controller.dispose();
    }
  }
}
