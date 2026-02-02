import 'package:flutter/material.dart';

class CineTextField extends StatefulWidget {
  const CineTextField({super.key, required this.isPassword});

  final bool isPassword;

  @override
  State<CineTextField> createState() => _CineTextFieldState();
}

class _CineTextFieldState extends State<CineTextField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    final isPassword = widget.isPassword;

    return Container(
      height: 56,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xB8171212), Color(0xB80F0B0B)],
        ),
        border: Border.all(color: Colors.white.withAlpha(36), width: 1),
      ),
      child: TextField(
        obscureText: isPassword && _obscureText,
        style: const TextStyle(
          color: Color(0xE6FFFFFF),
          fontSize: 17,
          fontWeight: FontWeight.w500,
        ),
        cursorColor: const Color(0xFFFFA84B),
        decoration: InputDecoration(
          hintText: isPassword ? 'Password' : 'Email',
          hintStyle: const TextStyle(
            color: Color(0x73FFFFFF),
            fontSize: 17,
            fontWeight: FontWeight.w500,
          ),
          prefixIcon: Icon(
            isPassword ? Icons.lock_outlined : Icons.email_outlined,
            color: const Color(0xFFCAA35C),
            size: 24,
          ),
          suffixIcon: isPassword
              ? IconButton(
                  icon: Icon(
                    _obscureText
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                    color: Colors.white.withAlpha(140),
                    size: 24,
                  ),
                  onPressed: () => setState(() => _obscureText = !_obscureText),
                )
              : null,
          border: InputBorder.none,
          isDense: true,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 15,
          ),
        ),
      ),
    );
  }
}
