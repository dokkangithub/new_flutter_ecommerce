import 'package:laravel_ecommerce/presentation/auth/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:laravel_ecommerce/presentation/auth/screens/signup_screen.dart';
import '../../presentation/auth/screens/forgot_password_screen.dart';
import '../../presentation/auth/screens/reset_password_screen.dart';
import '../../presentation/auth/screens/verification_screen.dart';
import '../../presentation/home/screens/home.dart';
import '../../presentation/onboarding/onboarding_screen.dart';
import '../../presentation/splash/splash_screen.dart';


class AppRoutes {
  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String signUp = '/sign-up';
  static const String forgetPassword = '/forgot-password';
  static const String resetPassword = '/reset-password';
  static const String verificationScreen = '/verification';
  static const String homeScreen = '/home';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splash:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case onboarding:
        return MaterialPageRoute(builder: (_) => OnboardingScreen());
      case login:
        return MaterialPageRoute(builder: (_) =>  LoginScreen());
      case signUp:
        return MaterialPageRoute(builder: (_) => const RegistrationScreen());
      case forgetPassword:
        return MaterialPageRoute(builder: (_) => ForgotPasswordScreen());
      case resetPassword:
        return MaterialPageRoute(builder: (_) => const ResetPasswordScreen());
      case verificationScreen:
        return MaterialPageRoute(builder: (_) => VerificationScreen(contactInfo: '',));
      case homeScreen:
        return MaterialPageRoute(builder: (_) => HomeScreen());
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('Route ${settings.name} not found')),
          ),
        );
    }
  }


  static void navigateTo(BuildContext context, String route, {Object? arguments}) {
    Navigator.pushNamed(context, route, arguments: arguments);
  }

  static void navigateToAndReplace(BuildContext context, String route, {Object? arguments}) {
    Navigator.pushReplacementNamed(context, route, arguments: arguments);
  }

  static void navigateToAndRemoveUntil(BuildContext context, String route) {
    Navigator.pushNamedAndRemoveUntil(context, route, (route) => false);
  }
}