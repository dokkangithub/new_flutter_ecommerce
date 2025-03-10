import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controller/auth_provider.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});


  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      appBar: AppBar(title: Text("Sign Up")),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(controller: nameController, decoration: InputDecoration(labelText: "Name")),
            TextField(controller: emailController, decoration: InputDecoration(labelText: "Email")),
            TextField(controller: passwordController, decoration: InputDecoration(labelText: "Password"), obscureText: true),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                final userData = {
                  "name": nameController.text,
                  "email": emailController.text,
                  "password": passwordController.text,
                };
                await authProvider.signup(userData);
                Navigator.pushNamed(context, "/verify");
              },
              child: Text("Sign Up"),
            ),
          ],
        ),
      ),
    );
  }
}
