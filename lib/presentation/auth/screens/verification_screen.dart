import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controller/auth_provider.dart';

class VerificationScreen extends StatefulWidget {
  const VerificationScreen({super.key});


  @override
  _VerificationScreenState createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  final TextEditingController codeController = TextEditingController();
  final String email = "user@example.com"; // Pass this dynamically

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      appBar: AppBar(title: Text("Verify Account")),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(controller: codeController, decoration: InputDecoration(labelText: "Verification Code")),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                await authProvider.confirmCode(email, codeController.text);
                Navigator.pushNamed(context, "/login");
              },
              child: Text("Verify"),
            ),
            TextButton(
              onPressed: () async => await authProvider.resendCode(email),
              child: Text("Resend Code"),
            ),
          ],
        ),
      ),
    );
  }
}
