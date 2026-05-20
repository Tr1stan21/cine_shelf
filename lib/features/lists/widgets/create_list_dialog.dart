import 'package:cine_shelf/features/auth/application/auth_providers.dart';
import 'package:cine_shelf/features/lists/application/list_providers.dart';
import 'package:cine_shelf/features/lists/models/list_icon_catalog.dart';
import 'package:cine_shelf/features/lists/widgets/list_icon_picker.dart';
import 'package:cine_shelf/shared/config/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CreateListDialog extends ConsumerStatefulWidget {
  const CreateListDialog({
    required this.movieId,
    required this.posterPath,
    this.existingListNames = const [],
    super.key,
  });

  final int movieId;
  final String? posterPath;
  final Iterable<String> existingListNames;

  @override
  ConsumerState<CreateListDialog> createState() => _CreateListDialogState();
}

class _CreateListDialogState extends ConsumerState<CreateListDialog> {
  final TextEditingController _nameController = TextEditingController();

  String _selectedIconName = defaultIconName;
  String? _errorText;
  bool _isCreating = false;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _createList() async {
    final name = _nameController.text.trim();
    final validationError = _validateName(name);

    if (validationError != null) {
      setState(() => _errorText = validationError);
      return;
    }

    final uid = ref.read(authStateProvider).asData?.value?.uid;
    if (uid == null) {
      setState(() => _errorText = 'Sign in to create a list.');
      return;
    }

    setState(() {
      _isCreating = true;
      _errorText = null;
    });

    try {
      final repo = ref.read(listRepositoryProvider);
      final listId = await repo.createCustomList(
        uid: uid,
        name: name,
        iconName: _selectedIconName,
      );

      await repo.addMovieToList(
        uid: uid,
        listId: listId,
        movieId: widget.movieId,
        posterPath: widget.posterPath,
      );

      if (mounted) {
        Navigator.of(context).pop();
      }
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _isCreating = false;
        _errorText = 'Could not create the list. Please try again.';
      });
    }
  }

  String? _validateName(String name) {
    if (name.isEmpty || !_containsLetter(name)) {
      return 'Use at least one letter.';
    }

    if (name.length > 30) {
      return 'Use 30 characters or fewer.';
    }

    final normalizedName = name.toLowerCase();
    final hasDuplicate = widget.existingListNames.any(
      (existingName) => existingName.trim().toLowerCase() == normalizedName,
    );
    if (hasDuplicate) {
      return 'A list with this name already exists.';
    }

    return null;
  }

  bool _containsLetter(String value) {
    return RegExp(r'[A-Za-zÁÉÍÓÚáéíóúÜüÑñ]').hasMatch(value);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: CineColors.surfaceRaised,
      title: const Text('New list'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _nameController,
              autofocus: true,
              enabled: !_isCreating,
              maxLength: 30,
              textInputAction: TextInputAction.done,
              decoration: InputDecoration(
                labelText: 'Name',
                errorText: _errorText,
                counterStyle: const TextStyle(color: CineColors.textSecondary),
              ),
              onChanged: (_) {
                if (_errorText != null) {
                  setState(() => _errorText = null);
                }
              },
              onSubmitted: (_) {
                if (!_isCreating) {
                  _createList();
                }
              },
            ),
            ListIconPicker(
              selectedIconName: _selectedIconName,
              onIconSelected: _isCreating
                  ? (_) {}
                  : (iconName) {
                      setState(() => _selectedIconName = iconName);
                    },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isCreating ? null : () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        FilledButton.icon(
          onPressed: _isCreating ? null : _createList,
          icon: _isCreating
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Icon(Icons.check),
          label: const Text('Create'),
        ),
      ],
    );
  }
}
