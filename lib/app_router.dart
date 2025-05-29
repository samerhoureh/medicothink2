import 'package:flutter/material.dart';
import 'package:medicothink/UI/splash/splash_screen.dart';

import 'UI/auth/login_screen.dart';
import 'UI/auth/register_screen.dart';
import 'UI/home/chat_screen.dart';
import 'UI/splash/onpording2.dart';
class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => const SplashScreen());
        case '/login':
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case '/register':
        return MaterialPageRoute(builder: (_) => const RegisterScreen());
      case '/onboarding2':
        return MaterialPageRoute(builder: (_) => const Onboarding2Screen());
      case '/chat':
        return MaterialPageRoute(builder: (_) => const ChatScreen());

      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
        );
    }
  }
}
