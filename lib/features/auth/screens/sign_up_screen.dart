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
import 'package:cine_shelf/router/route_paths.dart';

/// Registration screen for new users.
///
/// Features:
/// - Username, email, and password input with validation
/// - Real-time email format validation
/// - Password requirements (min 6 characters)
/// - Username requirements (min 2 characters)
/// - Form validation (button disabled until all fields valid)
/// - Loading state during account creation
/// - Atomic user creation (auth + Firestore profile)
/// - Error handling with user-friendly messages
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

  /// Returns true when all form fields are valid and ready for submission.
  bool get _isFormValid {
    return isValidUsername(_username) &&
        _email.trim().isNotEmpty &&
        isValidEmail(_email.trim()) &&
        isValidPassword(_password) &&
        _emailError == null;
  }

  /// Validates email in real-time as user types.
  ///
  /// Shows error only when email is non-empty and invalid.
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

  /// Handles sign-up button press with atomic user creation.
  ///
  /// Process:
  /// 1. Validates all form fields
  /// 2. Creates Firebase Auth account
  /// 3. Creates Firestore profile document (with Cloud Function enrichment)
  /// 4. Rollback auth account if profile creation fails
  /// 5. Navigates to splash (which redirects to home) on success
  ///
  /// Captures ScaffoldMessenger and GoRouter before async operations
  /// to avoid BuildContext issues across async gaps.
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
    // Capture scaffoldMessenger and router before async operations
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    final router = GoRouter.of(context);

    try {
      // Create user account and Firestore document
      await ref.read(authControllerProvider).signUp(username, email, password);

      if (!mounted) return;

      // Navigate to splash - router will redirect to home automatically
      router.go(RoutePaths.splash);
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
