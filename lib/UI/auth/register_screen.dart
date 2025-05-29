import 'package:flutter/material.dart';

import '../home/chat_drawer.dart';
import 'auth_card.dart' hide kTeal;

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 24),
            Image.asset('assets/images/splash/medico_logo.jpg', height: 150,width: 150,),
            const SizedBox(height: 24),

            const Spacer(),

            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: kTeal,
               
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(50),
                  topRight: Radius.circular(50),
                ),
              ),
              padding: const EdgeInsets.fromLTRB(24, 32, 24, 40),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Column(
                        children: [
                          const Text(
                            'Register to Continue',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Container(
                            height: 4,
                            width: 60,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),

                    LabeledField(
                      label: 'Username',
                      hint: 'your username...',
                      icon: Icons.person_outlined,
                    ),
                    const SizedBox(height: 16),
                    LabeledField(
                      label: 'Email',
                      hint: 'your email id...',
                      icon: Icons.email_outlined,
                    ),
                    const SizedBox(height: 16),
                    LabeledField(
                      label: 'Password',
                      hint: 'password',
                      icon: Icons.lock_outline,
                      obscure: true,
                    ),
                    const SizedBox(height: 32),
                    PrimaryButton(text: 'REGISTER', onTap: () {
                      Navigator.pushReplacementNamed(context, '/chat');
                    }),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('Already have an account? ', style: TextStyle(color: Colors.white70)),
                        GestureDetector(
                          onTap: () => Navigator.of(context).pop(),
                          child: const Text('Login',
                              style: TextStyle(color: Colors.white, decoration: TextDecoration.underline)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
