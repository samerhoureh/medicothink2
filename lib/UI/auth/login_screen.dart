import 'package:flutter/material.dart';

import '../home/chat_drawer.dart';
import 'auth_card.dart' hide kTeal;
import 'register_screen.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

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
              decoration: const BoxDecoration(
                color: kTeal,
              
                borderRadius: BorderRadius.only(
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
                            'Welcome to Medico',
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
                    PrimaryButton(text: 'LOGIN', onTap: () {
                      Navigator.pushReplacementNamed(context, '/chat');
                    }),
                    const SizedBox(height: 24),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Expanded(child: Divider(color: Colors.white)),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text('or continue', style: TextStyle(color: Colors.white70)),
                        ),
                        Expanded(child: Divider(color: Colors.white)),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: const [
                        SocialIcon(icon: Icons.facebook),
                        SocialIcon(icon: Icons.facebook),
                        SocialIcon(icon: Icons.g_mobiledata),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Don't have account? ", style: TextStyle(color: Colors.white70)),
                        GestureDetector(
                          onTap: () => Navigator.of(context).push(
                            MaterialPageRoute(builder: (_) => const RegisterScreen()),
                          ),
                          child: const Text('Sign',
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
