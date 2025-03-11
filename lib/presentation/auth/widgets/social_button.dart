import 'package:flutter/material.dart';

import '../../../core/utils/constants/app_assets.dart';

class SocialButton extends StatelessWidget {
  const SocialButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _socialButton(
          onPressed: () {
            // TODO: Implement Google login
          },
          icon: AppIcons.google,
          color: Colors.red,
        ),
        _socialButton(
          onPressed: () {
            // TODO: Implement Facebook login
          },
          icon: AppIcons.facebook,
          color: Colors.blue[800]!,
        ),
        _socialButton(
          onPressed: () {
            // TODO: Implement Apple login
          },
          icon: AppIcons.apple,
          color: Colors.black,
        ),
      ],
    );
  }

  Widget _socialButton({
    required VoidCallback onPressed,
    required String icon,
    required Color color,
  }) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(50),
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(50),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Center(child: Image.asset(icon, height: 20, width: 20)),
      ),
    );
  }

}
