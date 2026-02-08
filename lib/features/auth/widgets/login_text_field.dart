import 'package:flutter/material.dart';

import 'package:cine_shelf/shared/config/theme.dart';

/// Custom text field for login form
///
/// Supports two modes: email (default) and password.
/// In password mode, includes a button to show/hide the text.
class LoginTextField extends StatefulWidget {
  const LoginTextField({required this.isPassword, super.key});

  final bool isPassword;

  static const String _emailHint = 'Email';
  static const String _passwordHint = 'Password';

  @override
  State<LoginTextField> createState() => _LoginTextFieldState();
}

class _LoginTextFieldState extends State<LoginTextField> {
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
                ? LoginTextField._passwordHint
                : LoginTextField._emailHint,
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
