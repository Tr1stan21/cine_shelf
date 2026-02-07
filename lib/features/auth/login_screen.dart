import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:cine_shelf/config/theme.dart';
import 'package:cine_shelf/core/widgets/background.dart';
import 'package:cine_shelf/features/auth/widgets/login_button.dart';
import 'package:cine_shelf/features/auth/widgets/login_text_field.dart';
import 'package:cine_shelf/features/home/widgets/separators.dart';

/// Pantalla de autenticación de usuario
///
/// Permite al usuario ingresar credenciales (email y contraseña)
/// y navegar a la pantalla principal una vez autenticado.
class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  static const String _loginButton = 'Login';

  @override
  Widget build(BuildContext context) {
    return Background(
      padding: const EdgeInsets.symmetric(horizontal: CineSpacing.xxl),
      child: Center(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Image.asset('assets/logo/logo2.png'),
              const SizedBox(height: CineSpacing.xxxl),
              const LoginTextField(isPassword: false),
              const GlowSeparator(),
              const LoginTextField(isPassword: true),
              const SizedBox(height: CineSpacing.xxl),
              CinePrimaryGoldButton(
                onPressed: () => context.go('/home'),
                text: _loginButton,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
