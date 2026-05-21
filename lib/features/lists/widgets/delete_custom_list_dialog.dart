import 'package:cine_shelf/shared/widgets/dialogs/cine_shelf_dialog.dart';
import 'package:cine_shelf/shared/widgets/dialogs/cine_shelf_dialog_button.dart';
import 'package:cine_shelf/shared/widgets/dialogs/dialog_tokens.dart';
import 'package:cine_shelf/shared/widgets/dialogs/show_cine_shelf_dialog.dart';
import 'package:flutter/material.dart';

Future<bool> showDeleteCustomListDialog(
  BuildContext context,
  String listName,
) async {
  final result = await showCineShelfDialog<bool>(
    context: context,
    builder: (context) {
      return CineShelfDialog(
        title: 'Delete list?',
        content: Text(
          'Delete "$listName" and all its saved movies? This action cannot be undone.',
          style: CineShelfDialogTokens.bodyStyle(context),
        ),
        actions: [
          CineShelfDialogButton(
            label: 'Cancel',
            variant: CineShelfDialogButtonVariant.secondary,
            onPressed: () => Navigator.of(context).pop(false),
          ),
          CineShelfDialogButton(
            label: 'Delete',
            variant: CineShelfDialogButtonVariant.danger,
            onPressed: () => Navigator.of(context).pop(true),
          ),
        ],
      );
    },
  );

  return result == true;
}
