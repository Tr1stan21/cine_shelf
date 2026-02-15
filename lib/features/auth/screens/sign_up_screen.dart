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
import 'package:cine_shelf/features/auth/utils/validators.dart';

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
  String? _emailError;

  bool get _isFormValid {
    return isValidUsername(_username) &&
        _email.trim().isNotEmpty &&
        isValidEmail(_email.trim()) &&
        isValidPassword(_password) &&
        _emailError == null;
  }

  void _onEmailChanged(String value) {
    setState(() {
      _email = value;
      if (value.trim().isEmpty) {
        _emailError = null;
      } else if (!isValidEmail(value.trim())) {
        _emailError = 'Invalid email address.';
      } else {
        _emailError = null;
      }
    });
  }

  Future<void> _showCompletionDialog() {
    // Capture router before entering dialog context
    final router = GoRouter.of(context);

    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          backgroundColor: const Color(0xFF1A1A1A),
          title: const Text(
            'Account Created',
            style: TextStyle(color: Color(0xFFD4AF6A)),
          ),
          content: const Text(
            'Your account has been created successfully. Please sign in with your credentials.',
            style: TextStyle(color: Color(0xFFFFFFFF)),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
                router.go('/login');
              },
              child: const Text(
                'Go to Login',
                style: TextStyle(color: Color(0xFFD4AF6A)),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _onSignUpPressed(BuildContext context) async {
    final String username = _username.trim();
    final String email = _email.trim().toLowerCase();
    final String password = _password;

    if (!_isFormValid) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields correctly.')),
      );
      return;
    }

    setState(() => _isLoading = true);
    // Capture scaffoldMessenger before async operations
    final scaffoldMessenger = ScaffoldMessenger.of(context);

    try {
      // Create user account and Firestore document
      await ref.read(authControllerProvider).signUp(username, email, password);

      if (!mounted) return;

      // Sign out immediately after signup (required by flow)
      try {
        await ref.read(authControllerProvider).signOut();
      } catch (e) {
        debugPrint('Signout after signup error: $e');
        // Continue anyway - show dialog
      }

      if (!mounted) return;

      // Show success dialog and navigate to login
      await _showCompletionDialog();
    } catch (e, st) {
      debugPrint('SIGNUP ERROR TYPE: ${e.runtimeType}');
      debugPrint('SIGNUP ERROR: $e');
      debugPrint('STACK: $st');

      if (!mounted) return;
      scaffoldMessenger.showSnackBar(SnackBar(content: Text(mapAuthError(e))));
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
                  onChanged: (v) => setState(() => _username = v),
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
                AuthTextField(isPassword: false, onChanged: _onEmailChanged),
                if (_emailError != null)
                  Padding(
                    padding: const EdgeInsets.only(top: CineSpacing.sm),
                    child: Text(
                      _emailError!,
                      style: const TextStyle(
                        color: Color(0xFFEF5350),
                        fontSize: 12,
                      ),
                    ),
                  ),

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
                  onChanged: (v) => setState(() => _password = v),
                ),

                const SizedBox(height: CineSpacing.xxxl),

                AuthButton(
                  onPressed: (_isLoading || !_isFormValid)
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
