import 'package:flutter/material.dart';
import 'package:laravel_ecommerce/config/routes.dart/routes.dart';
import 'package:laravel_ecommerce/core/utils/extension/translate_extension.dart';
import 'package:laravel_ecommerce/core/utils/widgets/custom_button.dart';
import 'package:laravel_ecommerce/core/utils/widgets/custom_form_field.dart';
import 'package:laravel_ecommerce/core/utils/widgets/custom_loading.dart';
import 'package:laravel_ecommerce/presentation/auth/controller/auth_provider.dart';
import 'package:provider/provider.dart';

import '../../../core/di/injection_container.dart';
import '../../../core/utils/constants/app_assets.dart';
import '../../../core/utils/widgets/custom_snackbar.dart';
import '../widgets/social_button.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  final _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    AuthProvider authProvider = Provider.of<AuthProvider>(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Logo
                    Hero(
                      tag: 'logo',
                      child: CircleAvatar(
                        radius: 60,
                        backgroundImage: AssetImage(AppImages.appLogo),
                      ),
                    ),
                    const SizedBox(height: 40),

                    // Welcome Text
                    Text(
                      'Welcome Back',
                      style: Theme.of(context).textTheme.displayMedium,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Sign in to continue shopping',
                      style: Theme.of(context).textTheme.displaySmall,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 40),

                    // Email Input
                    CustomTextFormField(
                      controller: emailController,
                      hint: 'email'.tr(context),
                    ),
                    const SizedBox(height: 16),

                    // Password Input
                    CustomTextFormField(
                      controller: passwordController,
                      isPassword: true,
                      hint: 'password'.tr(context),
                    ),

                    // Forgot Password
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {
                          AppRoutes.navigateTo(
                            context,
                            AppRoutes.forgetPassword,
                          );
                        },
                        child: Text(
                          'Forgot Password?',
                          style: TextStyle(
                            color: Colors.indigo[700],
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Login Button
                    authProvider.isLoading
                        ? CustomLoadingWidget()
                        : CustomButton(
                          text: 'login'.tr(context),
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              bool isSuccess = await authProvider.login(
                                emailController.text,
                                passwordController.text,
                                emailController.text.contains('@')?'email':'phone'
                              );
                              if (isSuccess) {
                                AppRoutes.navigateToAndRemoveUntil(
                                  context,
                                  AppRoutes.homeScreen,
                                );
                              } else {
                                CustomSnackbar.show(
                                  context,
                                  message:
                                      'Login failed. Please check your credentials.',
                                  isError: true,
                                );
                              }
                            }
                          },
                        ),
                    const SizedBox(height: 24),

                    // OR Divider
                    Row(
                      children: [
                        Expanded(
                          child: Divider(color: Colors.grey[400], thickness: 1),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Text(
                            'OR',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Divider(color: Colors.grey[400], thickness: 1),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Social Login Buttons
                    SocialButton(),
                    const SizedBox(height: 20),

                    // Sign Up Option
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Don\'t have an account?',
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                        TextButton(
                          onPressed: () {
                            AppRoutes.navigateTo(context, AppRoutes.signUp);
                          },
                          child: Text(
                            'Sign Up',
                            style: TextStyle(
                              color: Colors.indigo[700],
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

}
