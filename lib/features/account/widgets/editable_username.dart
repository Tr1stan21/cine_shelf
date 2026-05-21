import 'package:cine_shelf/features/auth/application/validators.dart';
import 'package:cine_shelf/shared/config/theme.dart';
import 'package:cine_shelf/shared/widgets/dialogs/cine_shelf_dialog.dart';
import 'package:cine_shelf/shared/widgets/dialogs/cine_shelf_dialog_button.dart';
import 'package:cine_shelf/shared/widgets/dialogs/cine_shelf_dialog_text_field.dart';
import 'package:cine_shelf/shared/widgets/dialogs/show_cine_shelf_dialog.dart';
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
    final nextUsername = await showCineShelfDialog<String>(
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
    return CineShelfDialog(
      title: 'Edit username',
      content: CineShelfDialogTextField(
        controller: _controller,
        labelText: 'Username',
        autofocus: true,
        maxLength: 40,
        textInputAction: TextInputAction.done,
        errorText: _errorText,
        onChanged: (_) {
          if (_errorText != null) {
            setState(() => _errorText = null);
          }
        },
        onSubmitted: (_) => _validateAndClose(),
      ),
      actions: [
        CineShelfDialogButton(
          label: 'Cancel',
          variant: CineShelfDialogButtonVariant.secondary,
          onPressed: () => Navigator.of(context).pop(),
        ),
        CineShelfDialogButton(
          label: 'Save',
          icon: Icons.check,
          onPressed: _validateAndClose,
        ),
      ],
    );
  }
}
