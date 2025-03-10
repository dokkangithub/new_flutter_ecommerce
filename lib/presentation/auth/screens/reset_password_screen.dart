import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controller/auth_provider.dart';

class ResetPasswordScreen extends StatefulWidget {

  const ResetPasswordScreen({super.key});

  @override
  _ResetPasswordScreenState createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final TextEditingController codeController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final String email = "user@example.com";

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      appBar: AppBar(title: Text("Reset Password")),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(controller: codeController, decoration: InputDecoration(labelText: "Reset Code")),
            TextField(controller: passwordController, decoration: InputDecoration(labelText: "New Password"), obscureText: true),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                await authProvider.confirmResetPassword(email, codeController.text, passwordController.text);
                Navigator.pushNamed(context, "/login");
              },
              child: Text("Reset Password"),
            ),
          ],
        ),
      ),
    );
  }
}
