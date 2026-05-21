import 'package:cine_shelf/shared/widgets/dialogs/dialog_tokens.dart';
import 'package:flutter/material.dart';

class CineShelfDialogTitle extends StatelessWidget {
  const CineShelfDialogTitle({
    required this.text,
    this.textAlign = TextAlign.start,
    super.key,
  });

  final String text;
  final TextAlign textAlign;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign,
      style: CineShelfDialogTokens.titleStyle(context),
    );
  }
}
