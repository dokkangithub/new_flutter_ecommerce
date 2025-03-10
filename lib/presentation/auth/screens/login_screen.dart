import 'package:flutter/material.dart';
import 'package:laravel_ecommerce/config/routes.dart/routes.dart';
import 'package:provider/provider.dart';
import '../controller/auth_provider.dart';

class LoginScreen extends StatefulWidget {

  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text("Login")),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(controller: emailController, decoration: InputDecoration(labelText: "Email")),
            TextField(controller: passwordController, decoration: InputDecoration(labelText: "Password"), obscureText: true),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                await authProvider.login(emailController.text, passwordController.text);
              },
              child: Text("Login"),
            ),
            TextButton(
              onPressed: () => AppRoutes.navigateTo(context, AppRoutes.signUp),
              child: Text("Don't have an account? Sign Up"),
            ),
          ],
        ),
      ),
    );
  }
}
