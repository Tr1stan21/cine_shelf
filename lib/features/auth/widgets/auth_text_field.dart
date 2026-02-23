import 'package:flutter/material.dart';

import 'package:cine_shelf/shared/config/theme.dart';

/// Custom text field for authentication forms.
///
/// Supports two modes controlled by [isPassword]:
/// - **Email mode** (default): Displays an email icon prefix and the hint
///   text "Email".
/// - **Password mode**: Displays a lock icon prefix, obscures the text by
///   default, and includes a suffix button to toggle visibility.
///
/// The optional [onChanged] callback allows parent widgets to react to input
/// changes in real time, enabling form validation as the user types.
class AuthTextField extends StatefulWidget {
  const AuthTextField({required this.isPassword, this.onChanged, super.key});

  /// When `true`, the field operates in password mode: text is obscured
  /// and a visibility toggle button is shown.
  final bool isPassword;

  /// Called with the current field value on every keystroke.
  ///
  /// Use this to drive real-time validation in the parent widget.
  /// If `null`, input changes are not reported to the parent.
  final ValueChanged<String>? onChanged;

  static const String _emailHint = 'Email';
  static const String _passwordHint = 'Password';

  @override
  State<AuthTextField> createState() => _AuthTextFieldState();
}

class _AuthTextFieldState extends State<AuthTextField> {
  /// Controls whether the password text is hidden. Starts `true` (hidden).
  /// Only relevant when [AuthTextField.isPassword] is `true`.
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    final isPassword = widget.isPassword;

    return Container(
      height: 56,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(CineRadius.xl),
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xB8171212), Color(0xB80F0B0B)],
        ),
        border: Border.all(
          color: const Color.fromARGB(70, 255, 255, 255),
          width: 1,
        ),
      ),
      child: Align(
        alignment: Alignment.center,
        child: TextField(
          onChanged: widget.onChanged,
          textAlignVertical: TextAlignVertical.center,
          obscureText: isPassword && _obscureText,
          style: const TextStyle(
            color: Color(0xE6FFFFFF),
            fontSize: 17,
            fontWeight: FontWeight.w500,
          ),
          cursorColor: const Color(0xFFFFA84B),
          decoration: InputDecoration(
            hintText: isPassword
                ? AuthTextField._passwordHint
                : AuthTextField._emailHint,
            hintStyle: const TextStyle(
              color: CineColors.textMuted,
              fontSize: 17,
              fontWeight: FontWeight.w500,
            ),
            prefixIcon: Icon(
              isPassword ? Icons.lock_outlined : Icons.email_outlined,
              color: CineColors.amber,
              size: CineSizes.iconSize,
            ),
            suffixIcon: isPassword
                ? IconButton(
                    icon: Icon(
                      _obscureText ? Icons.visibility_off : Icons.visibility,
                      color: CineColors.amber,
                      size: CineSizes.iconSize,
                    ),
                    onPressed: () =>
                        setState(() => _obscureText = !_obscureText),
                  )
                : null,
            border: InputBorder.none,
          ),
        ),
      ),
    );
  }
}
