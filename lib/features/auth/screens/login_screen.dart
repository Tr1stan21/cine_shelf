import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:cine_shelf/shared/config/theme.dart';
import 'package:cine_shelf/shared/config/constants.dart';
import 'package:cine_shelf/shared/widgets/wordmark.dart';
import 'package:cine_shelf/shared/widgets/background.dart';
import 'package:cine_shelf/features/auth/widgets/login_button.dart';
import 'package:cine_shelf/features/auth/widgets/login_text_field.dart';

/// Authentication screen for user login
///
/// Allows the user to enter credentials (email and password)
/// and navigate to the home screen after authentication.
class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  static const String _loginButton = 'Sign in';

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
                Image.asset(AppConstants.logoPath, height: 100),
                const CineShelfWordmark(fontSize: 35),
                const SizedBox(height: CineSpacing.xxxl),
                const Text('Sign in to CineShelf'),
                const LoginTextField(isPassword: false),
                const SizedBox(height: 16),
                const LoginTextField(isPassword: true),
                const SizedBox(height: CineSpacing.xxxl),
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
