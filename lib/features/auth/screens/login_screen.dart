import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:cine_shelf/shared/config/theme.dart';
import 'package:cine_shelf/shared/config/constants.dart';
import 'package:cine_shelf/shared/widgets/wordmark.dart';
import 'package:cine_shelf/shared/widgets/background.dart';
import 'package:cine_shelf/features/auth/widgets/auth_button.dart';
import 'package:cine_shelf/features/auth/widgets/auth_text_field.dart';
import 'package:cine_shelf/features/auth/application/auth_error_mapper.dart';
import 'package:cine_shelf/features/auth/application/auth_controller.dart';
import 'package:cine_shelf/features/auth/utils/validators.dart';
import 'package:cine_shelf/router/route_paths.dart';

/// Login screen for existing users.
///
/// Features:
/// - Email and password input with real-time validation
/// - Email format validation with error display
/// - Password visibility toggle
/// - Form validation (button disabled until valid)
/// - Loading state during authentication
/// - Navigation to sign-up screen
/// - Firebase authentication error handling with user-friendly messages
class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  static const String _loginButton = 'Sign in';

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  String _email = '';
  String _password = '';
  bool _isLoading = false;
  String? _emailError;

  /// Returns true when form is valid and ready for submission.
  bool get _isFormValid {
    return _email.trim().isNotEmpty &&
        _password.isNotEmpty &&
        isValidEmail(_email.trim()) &&
        _emailError == null;
  }

  /// Validates email in real-time as user types.
  ///
  /// Shows error message only when email is non-empty and invalid,
  /// clearing error when field is empty or email becomes valid.
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

  /// Handles login button press.
  ///
  /// Flow:
  /// 1. Validates form completeness
  /// 2. Triggers authentication via AuthController
  /// 3. Navigates to splash (which redirects to home) on success
  /// 4. Displays user-friendly error message on failure
  ///
  /// Loading state prevents multiple concurrent submissions.
  Future<void> _onLoginPressed() async {
    final email = _email.trim();
    final password = _password;

    if (!_isFormValid) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields correctly.')),
      );
      return;
    }

    setState(() => _isLoading = true);
    try {
      await ref.read(authControllerProvider).signIn(email, password);

      if (!mounted) return;
      context.go(RoutePaths.splash);
    } catch (e, st) {
      debugPrint('LOGIN ERROR TYPE: ${e.runtimeType}');
      debugPrint('LOGIN ERROR: $e');
      debugPrint('STACK: $st');

      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(mapAuthError(e))));
      }
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
                const Text('Sign in to CineShelf'),
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
                      : _onLoginPressed,
                  text: LoginScreen._loginButton,
                ),

                const SizedBox(height: CineSpacing.lg),

                // Sign up link
                Center(
                  child: GestureDetector(
                    onTap: () => context.push(RoutePaths.signUp),
                    child: const Text(
                      'Don\'t have an account? Sign up',
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
