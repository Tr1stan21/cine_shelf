import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:cine_shelf/shared/config/theme.dart';
import 'package:cine_shelf/shared/widgets/background.dart';
import 'package:cine_shelf/features/auth/widgets/login_button.dart';
import 'package:cine_shelf/features/auth/widgets/login_text_field.dart';

/// Authentication screen for user login
///
/// Allows the user to enter credentials (email and password)
/// and navigate to the home screen after authentication.
class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  static const String _loginButton = 'Login';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Background(
        padding: const EdgeInsets.symmetric(horizontal: CineSpacing.xxl),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Image.asset('assets/logo/logo2.png'),
                const SizedBox(height: CineSpacing.xxxl),
                const LoginTextField(isPassword: false),
                const LoginTextField(isPassword: true),
                const SizedBox(height: CineSpacing.xxl),
                LoginButton(
                  onPressed: () => context.go('/home'),
                  text: _loginButton,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
