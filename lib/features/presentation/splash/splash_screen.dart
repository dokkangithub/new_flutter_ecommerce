import 'package:laravel_ecommerce/core/utils/constants/app_strings.dart';
import 'package:laravel_ecommerce/core/utils/local_storage/local_storage_keys.dart';
import 'package:flutter/material.dart';

import '../../../core/config/routes.dart/routes.dart';
import '../../../core/di/injection_container.dart';
import '../../../core/utils/local_storage/secure_storage.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToStartScreen();
  }

  Future<String> getStartupScreen() async {
    final secureStorage = sl<SecureStorage>();
    final bool hasCompletedOnboarding =
        await secureStorage.get<bool>(LocalStorageKey.hasCompletedOnboarding) ?? false;

    if (!hasCompletedOnboarding) {
      return AppRoutes.onboarding;
    } else if(AppStrings.token==null){
      return AppRoutes.login;
    }else{
      return AppRoutes.mainLayoutScreen;
    }
  }

  Future<void> _navigateToStartScreen() async {
    final String startupRoute = await getStartupScreen();

    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      AppRoutes.navigateToAndReplace(context, startupRoute);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/logo.png', width: 150),
            const SizedBox(height: 20),
            const CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}