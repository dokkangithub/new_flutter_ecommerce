import 'package:flutter/material.dart';
import 'package:laravel_ecommerce/core/utils/extension/text_style_extension.dart';

class SeeAllWidget extends StatelessWidget {
  const SeeAllWidget({
    super.key,
    required this.title,
    required this.onTap,
  });

  final String title;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: context.titleLarge),
        InkWell(
          onTap: onTap,
          child: Text(
            'SEE ALL ➔',
            style: context.titleSmall.copyWith(
              color: Theme.of(context).primaryColor,
            ),
          ),
        ),
      ],
    );
  }
}