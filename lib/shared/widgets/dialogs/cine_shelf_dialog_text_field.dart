import 'package:cine_shelf/shared/config/theme.dart';
import 'package:cine_shelf/shared/widgets/dialogs/dialog_tokens.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CineShelfDialogTextField extends StatelessWidget {
  const CineShelfDialogTextField({
    required this.controller,
    this.labelText,
    this.hintText,
    this.errorText,
    this.enabled = true,
    this.autofocus = false,
    this.maxLength,
    this.keyboardType,
    this.textInputAction,
    this.inputFormatters,
    this.onChanged,
    this.onSubmitted,
    super.key,
  });

  final TextEditingController controller;
  final String? labelText;
  final String? hintText;
  final String? errorText;
  final bool enabled;
  final bool autofocus;
  final int? maxLength;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final List<TextInputFormatter>? inputFormatters;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      enabled: enabled,
      autofocus: autofocus,
      maxLength: maxLength,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      inputFormatters: inputFormatters,
      cursorColor: CineShelfDialogTokens.primaryGold,
      style: CineShelfDialogTokens.inputStyle(context),
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        errorText: errorText,
        filled: true,
        fillColor: CineShelfDialogTokens.dialogField,
        labelStyle: CineShelfDialogTokens.labelStyle(context),
        hintStyle: CineShelfDialogTokens.labelStyle(context),
        counterStyle: const TextStyle(
          color: CineShelfDialogTokens.primaryGold,
          fontSize: 12,
        ),
        errorStyle: const TextStyle(color: CineColors.error, fontSize: 12),
        contentPadding: CineShelfDialogTokens.fieldContentPadding,
        border: _border(CineShelfDialogTokens.dialogBorder),
        enabledBorder: _border(CineShelfDialogTokens.dialogBorder),
        focusedBorder: _border(CineShelfDialogTokens.primaryGold),
        errorBorder: _border(CineColors.error),
        focusedErrorBorder: _border(CineColors.error),
      ),
      onChanged: onChanged,
      onSubmitted: onSubmitted,
    );
  }

  static OutlineInputBorder _border(Color color) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(CineShelfDialogTokens.fieldRadius),
      borderSide: BorderSide(color: color, width: 1.2),
    );
  }
}
