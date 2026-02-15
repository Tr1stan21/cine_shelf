import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:cine_shelf/shared/config/theme.dart';
import 'package:cine_shelf/shared/config/constants.dart';
import 'package:cine_shelf/shared/widgets/wordmark.dart';
import 'package:cine_shelf/shared/widgets/background.dart';
import 'package:cine_shelf/features/auth/widgets/auth_button.dart';
import 'package:cine_shelf/features/auth/widgets/auth_text_field.dart';

import 'package:cine_shelf/features/auth/application/auth_controller.dart';
import 'package:cine_shelf/features/auth/application/auth_error_mapper.dart';

class SignUpScreen extends ConsumerStatefulWidget {
  const SignUpScreen({super.key});

  static const String _signUpButton = 'Sign Up';

  @override
  ConsumerState<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends ConsumerState<SignUpScreen> {
  String _username = '';
  String _email = '';
  String _password = '';
  bool _isLoading = false;

  Future<void> _onSignUpPressed(BuildContext context) async {
    final String username = _username.trim();
    final String email = _email.trim().toLowerCase();
    final String password = _password;

    if (username.isEmpty || email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Introduce username, email y contrasena.'),
        ),
      );
      return;
    }

    setState(() => _isLoading = true);
    try {
      await ref.read(authControllerProvider).signUp(username, email, password);
      if (!mounted) return;
      await ref.read(authControllerProvider).signOut();
      if (!mounted) return;
      // TODO: navegar tras signup si no hay redirect basado en authStateChanges.
    } catch (e, st) {
      debugPrint('SIGNUP ERROR TYPE: ${e.runtimeType}');
      debugPrint('SIGNUP ERROR: $e');
      debugPrint('STACK: $st');

      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(mapAuthError(e))));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

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
                const Text('Create your CineShelf account'),
                const SizedBox(height: CineSpacing.lg),

                // Username field
                const Text(
                  'Username',
                  style: TextStyle(
                    color: Color(0xE6FFFFFF),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: CineSpacing.md),
                AuthTextField(
                  isPassword: false,
                  onChanged: (v) => _username = v,
                ),

                const SizedBox(height: CineSpacing.lg),

                // Email field
                const Text(
                  'Email',
                  style: TextStyle(
                    color: Color(0xE6FFFFFF),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: CineSpacing.md),
                AuthTextField(isPassword: false, onChanged: (v) => _email = v),

                const SizedBox(height: CineSpacing.lg),

                // Password field
                const Text(
                  'Password',
                  style: TextStyle(
                    color: Color(0xE6FFFFFF),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: CineSpacing.md),
                AuthTextField(
                  isPassword: true,
                  onChanged: (v) => _password = v,
                ),

                const SizedBox(height: CineSpacing.xxxl),

                AuthButton(
                  onPressed: _isLoading
                      ? null
                      : () => _onSignUpPressed(context),
                  text: SignUpScreen._signUpButton,
                ),

                const SizedBox(height: CineSpacing.lg),

                // Back to login link
                Center(
                  child: GestureDetector(
                    onTap: () => context.pop(),
                    child: const Text(
                      'Already have an account? Sign in',
                      style: TextStyle(
                        color: Color(0xFFD4AF6A),
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
