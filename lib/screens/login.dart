import 'package:cine_shelf/widgets/separator.dart';
import 'package:cine_shelf/widgets/txt_login.dart';
import 'package:cine_shelf/widgets/background.dart';
import 'package:cine_shelf/widgets/btn_login.dart';
import 'package:cine_shelf/screens/home.dart';
import 'package:flutter/material.dart';

class Login extends StatelessWidget {
  const Login({super.key});

  @override
  Widget build(BuildContext context) {
    return Background(
      padding: EdgeInsets.symmetric(horizontal: 24),
      child: Center(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Image.asset('assets/logo/logo2.png'),
              const SizedBox(height: 30),

              TxtLogin(isPassword: false),

              const GlowSeparator(),

              TxtLogin(isPassword: true),
              const SizedBox(height: 24),

              CinePrimaryGoldButton(
                onPressed: () => {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (_) => const Home()),
                  ),
                },
                text: 'Login',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
