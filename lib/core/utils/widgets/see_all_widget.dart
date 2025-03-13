import 'package:flutter/material.dart';
import 'package:laravel_ecommerce/core/utils/extension/text_style_extension.dart';

class SeeAllWidget extends StatelessWidget {
  const SeeAllWidget({super.key, required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title,style: context.titleLarge),
        Text('SEE ALL ➔',style: context.titleSmall.copyWith(color: Theme.of(context).primaryColor)),
      ],
    );
  }
}
