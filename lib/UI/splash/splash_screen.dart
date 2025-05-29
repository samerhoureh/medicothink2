import 'dart:async';
import 'package:flutter/material.dart';

import 'onpording.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 6), () {
      if (mounted) {
        Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) =>  OnboardingScreen()),
      );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                    Color(0xFFB3E5F1), 
                    Color(0xFF20A9C3), 
                  ],
                ),
              ),
            ),
          ),
           Center(
            child: Image(
              height: 300,
              width: 300,
              image: AssetImage('assets/images/splash/medico_logo.jpg'),
              fit: BoxFit.contain,
            ),
          ),
        ],
      ),
    );
  }
}
