import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:laravel_ecommerce/core/utils/constants/app_assets.dart';
import 'package:laravel_ecommerce/core/utils/extension/translate_extension.dart';
import 'package:laravel_ecommerce/core/utils/widgets/custom_form_field.dart';
import 'package:laravel_ecommerce/presentation/auth/widgets/social_button.dart';
import 'package:provider/provider.dart';

import '../../../config/routes.dart/routes.dart';
import '../../../core/utils/widgets/custom_button.dart';
import '../../../core/utils/widgets/custom_loading.dart';
import '../../../core/utils/widgets/custom_snackbar.dart';
import '../controller/auth_provider.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({Key? key}) : super(key: key);

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;


  // Controllers for form fields
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    AuthProvider authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Form(
                key: _formKey,
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Logo
                      Hero(
                        tag: 'logo',
                        child: Image.asset(AppImages.appLogo, height: 100),
                      ),
                      const SizedBox(height: 32),

                      // Heading
                      Text(
                        'Create Account',
                        style: Theme.of(context).textTheme.titleLarge,
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        'Sign up to start shopping',
                        style: Theme.of(context).textTheme.titleMedium,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 32),
                      // Full Name
                      _buildInputField(
                        controller: _nameController,
                        hintText: 'Full Name',
                        keyboardType: TextInputType.name,
                        prefixIcon: Icons.person_outline,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your name';
                          }
                          return null;
                        },
                      ),

                      // Email or Phone
                      _buildInputField(
                        controller: _emailController,
                        hintText: 'email or phone',
                        keyboardType: TextInputType.name,
                        prefixIcon: Icons.person_outline,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your email or phone';
                          }
                          return null;
                        },
                      ),

                      // Password
                      _buildInputField(
                        controller: _passwordController,
                        hintText: 'Password',
                        prefixIcon: Icons.lock_clock_outlined,
                        isPassword: true,
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your password';
                          }
                          return null;
                        },
                      ),

                      // Confirmation Password
                      _buildInputField(
                        controller: _confirmPasswordController,
                        hintText: 'Confirm password',
                        prefixIcon: Icons.lock_clock_outlined,
                        keyboardType: TextInputType.emailAddress,
                        isPassword: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your confirmation password';
                          } else if (value != _passwordController.text) {
                            return 'Passwords do not match';
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 10),

                      // Sign Up Button
                      authProvider.isLoading
                          ? const CustomLoadingWidget()
                          : CustomButton(
                            text: 'sign up'.tr(context),
                            onPressed: () async {
                              Map<String, dynamic> userData = {
                                "name": _nameController.text,
                                "password": _passwordController.text,
                                "email_or_phone": _emailController.text ,
                                "password_confirmation":
                                    _confirmPasswordController.text,
                                "register_by": _emailController.text.contains('@')?'email':'phone',
                              };

                              if (_formKey.currentState!.validate()) {
                                bool isSuccess= await authProvider.signup(
                                  userData,
                                );
                                 CustomSnackbar.show(
                                   context,
                                   message: authProvider.errorMessage!,
                                   isError: !isSuccess,
                                 );
                                 if(isSuccess){
                                   AppRoutes.navigateToAndRemoveUntil(context, AppRoutes.homeScreen);
                                 }
                              }
                            },
                          ),
                      const SizedBox(height: 24),

                      // OR Divider
                      Row(
                        children: [
                          Expanded(
                            child: Divider(
                              color: Colors.grey[400],
                              thickness: 1,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Text(
                              'OR SIGN UP WITH',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Divider(
                              color: Colors.grey[400],
                              thickness: 1,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),

                      // Social Signup Options
                      SocialButton(),
                      const SizedBox(height: 32),

                      // Already have account
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Already have an account?',
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                          TextButton(
                            onPressed: () {
                              // TODO: Navigate to login screen
                            },
                            child: Text(
                              'Login',
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
      ),
    );
  }

  Widget _buildInputField({
    Key? key,
    required TextEditingController controller,
    required String hintText,
    required IconData prefixIcon,
    bool isPassword = false,
    required String? Function(String?) validator,
    TextInputType? keyboardType,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: CustomTextFormField(
        key: key,
        controller: controller,
        hint: hintText,
        isPassword: isPassword,
        keyboardType: keyboardType!,
        validator: validator,
      ),
    );
  }
}
