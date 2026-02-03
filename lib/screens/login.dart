import 'package:cine_shelf/widgets/separator.dart';
import 'package:cine_shelf/widgets/text_field.dart';
import 'package:cine_shelf/widgets/background.dart';
import 'package:flutter/material.dart';

class Login extends StatelessWidget {
  const Login({super.key});

  @override
  Widget build(BuildContext context) {
    return Background(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Center(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Image.asset('assets/logo/logo2.png'),
              const SizedBox(height: 30),

              CineTextField(isPassword: false),
              const SizedBox(height: 16),

              const GlowSeparator(),

              CineTextField(isPassword: true),
              const SizedBox(height: 24),

              ElevatedButton(
                onPressed: () {},
                child: const Text('Iniciar sesión'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
