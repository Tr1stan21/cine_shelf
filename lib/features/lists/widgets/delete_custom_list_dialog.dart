import 'package:cine_shelf/shared/config/theme.dart';
import 'package:flutter/material.dart';

Future<bool> showDeleteCustomListDialog(
  BuildContext context,
  String listName,
) async {
  final result = await showDialog<bool>(
    context: context,
    builder: (context) {
      return AlertDialog(
        backgroundColor: CineColors.surfaceRaised,
        title: const Text('Delete list?'),
        content: Text(
          'Delete "$listName" and all its saved movies? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Delete'),
          ),
        ],
      );
    },
  );

  return result == true;
}
