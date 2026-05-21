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
    final nextUsername = await showDialog<String>(
      context: context,
      builder: (_) => _EditUsernameDialog(initialUsername: username),
    );

    if (nextUsername == null || nextUsername == username.trim()) return;
    await onSave(nextUsername);
  }
}

class _EditUsernameDialog extends StatefulWidget {
  const _EditUsernameDialog({required this.initialUsername});

  final String initialUsername;

  @override
  State<_EditUsernameDialog> createState() => _EditUsernameDialogState();
}

class _EditUsernameDialogState extends State<_EditUsernameDialog> {
  late final TextEditingController _controller;
  String? _errorText;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialUsername);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _validateAndClose() {
    final value = _controller.text.trim();
    if (!isValidUsername(value)) {
      setState(() {
        _errorText = 'Use at least 2 characters.';
      });
      return;
    }

    Navigator.of(context).pop(value);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: CineColors.surfaceRaised,
      title: const Text('Edit username'),
      content: TextField(
        controller: _controller,
        autofocus: true,
        maxLength: 40,
        textInputAction: TextInputAction.done,
        decoration: InputDecoration(
          errorText: _errorText,
          counterStyle: const TextStyle(color: CineColors.textSecondary),
        ),
        onSubmitted: (_) => _validateAndClose(),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        FilledButton.icon(
          onPressed: _validateAndClose,
          icon: const Icon(Icons.check),
          label: const Text('Save'),
        ),
      ],
    );
  }
}
