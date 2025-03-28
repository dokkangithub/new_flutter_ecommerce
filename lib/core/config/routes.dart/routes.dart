import 'package:flutter/material.dart';
import 'package:laravel_ecommerce/features/presentation/category/screens/category_screen.dart';
import 'package:laravel_ecommerce/features/presentation/profile/screens/profile_screen.dart';
import 'package:laravel_ecommerce/features/presentation/wishlist/screens/wishlist_screen.dart';

import '../../../features/presentation/auth/screens/forgot_password_screen.dart';
import '../../../features/presentation/auth/screens/login_screen.dart';
import '../../../features/presentation/auth/screens/reset_password_screen.dart';
import '../../../features/presentation/auth/screens/signup_screen.dart';
import '../../../features/presentation/auth/screens/verification_screen.dart';
import '../../../features/presentation/cart/screens/cart_screen.dart';
import '../../../features/presentation/home/screens/home.dart';
import '../../../features/presentation/main layout/screens/main_layout_screen.dart';
import '../../../features/presentation/onboarding/onboarding_screen.dart';
import '../../../features/presentation/product/screens/product_screen.dart';
import '../../../features/presentation/splash/splash_screen.dart';

class AppRoutes {
  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String signUp = '/sign-up';
  static const String forgetPassword = '/forgot-password';
  static const String resetPassword = '/reset-password';
  static const String verificationScreen = '/verification';
  static const String homeScreen = '/home';
  static const String categoryScreen = '/category';
  static const String wishListScreen = '/wishList';
  static const String profileScreen = '/profile';
  static const String mainLayoutScreen = '/mainLayout';
  static const String cartScreen = '/cart';
  static const String productScreen = '/product';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    Widget page;
    switch (settings.name) {
      case splash:
        page = const SplashScreen();
        break;
      case onboarding:
        page = OnboardingScreen();
        break;
      case login:
        page = LoginScreen();
        break;
      case signUp:
        page = const RegistrationScreen();
        break;
      case forgetPassword:
        page = ForgotPasswordScreen();
        break;
      case resetPassword:
        page = const ResetPasswordScreen();
        break;
      case verificationScreen:
        page = VerificationScreen(contactInfo: '',);
        break;
      case homeScreen:
        page = HomeScreen();
      case categoryScreen:
        page = CategoryScreen();
      case wishListScreen:
        page = WishlistScreen();
      case profileScreen:
        page = ProfileScreen();
      case mainLayoutScreen:
        page = MainLayoutScreen();
      case cartScreen:
        page = CartScreen();
      case productScreen:
        page = ProductDetailScreen();
        break;
      default:
        page = Scaffold(
          body: Center(child: Text('Route ${settings.name} not found')),
        );
    }

    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: animation,
          child: child,
        );
      },
    );
  }

  static void navigateTo(BuildContext context, String route, {Object? arguments}) {
    Navigator.push(context, generateRoute(RouteSettings(name: route, arguments: arguments)));
  }

  static void navigateToAndReplace(BuildContext context, String route, {Object? arguments}) {
    Navigator.pushReplacement(context, generateRoute(RouteSettings(name: route, arguments: arguments)));
  }

  static void navigateToAndRemoveUntil(BuildContext context, String route) {
    Navigator.pushAndRemoveUntil(context, generateRoute(RouteSettings(name: route)), (route) => false);
  }
}
