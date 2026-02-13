import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:cine_shelf/shared/config/theme.dart';
import 'package:cine_shelf/shared/config/constants.dart';
import 'package:cine_shelf/shared/widgets/wordmark.dart';
import 'package:cine_shelf/shared/widgets/background.dart';
import 'package:cine_shelf/features/auth/widgets/login_button.dart';
import 'package:cine_shelf/features/auth/widgets/login_text_field.dart';

import 'package:cine_shelf/features/auth/application/auth_controller.dart';

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

  Future<void> _onLoginPressed(BuildContext context) async {
    final email = _email.trim();
    final password = _password;

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Introduce email y contraseña.')),
      );
      return;
    }

    setState(() => _isLoading = true);
    try {
      await ref.read(authControllerProvider).signIn(email, password);

      // Ideal: que tu router redirija por authStateChanges().
      // Si aún NO tienes redirect, puedes navegar manualmente:
      // if (mounted) context.go('/home');
    } catch (e, st) {
      debugPrint('LOGIN ERROR TYPE: ${e.runtimeType}');
      debugPrint('LOGIN ERROR: $e');
      debugPrint('STACK: $st');

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
                const Text('Sign in to CineShelf'),

                LoginTextField(
                  isPassword: false,
                  onChanged: (v) => _email = v, // <-- cableado
                ),

                const SizedBox(height: 16),

                LoginTextField(
                  isPassword: true,
                  onChanged: (v) => _password = v, // <-- cableado
                ),

                const SizedBox(height: CineSpacing.xxxl),

                LoginButton(
                  onPressed: _isLoading ? null : () => _onLoginPressed(context),
                  text: LoginScreen._loginButton,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
