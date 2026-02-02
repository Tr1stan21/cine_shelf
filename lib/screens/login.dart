import 'package:cine_shelf/widgets/background.dart';
import 'package:cine_shelf/widgets/separator.dart';
import 'package:cine_shelf/widgets/text_field.dart';
import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Background.Background(
        noisePercent: 0,
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Image.asset('assets/logo/logo.png'),
                  const SizedBox(height: 30),
                  // Campo de email
                  CineTextField(isPassword: false),
                  const SizedBox(height: 16),
                  const GlowSeparator(),
                  // Campo de contraseña
                  CineTextField(isPassword: true),
                  const SizedBox(height: 24),
                  // Botón de login
                  ElevatedButton(
                    onPressed: () {
                      // TODO: Implementar lógica de login
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Iniciar sesión',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Link de registro
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
