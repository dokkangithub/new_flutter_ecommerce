import 'package:flutter/material.dart';
import 'package:laravel_ecommerce/features/domain/product%20details/entities/product_details.dart';

class ColorVariantsWidget extends StatefulWidget {
  final ProductDetails product;

  const ColorVariantsWidget({super.key, required this.product});

  @override
  State<ColorVariantsWidget> createState() => _ColorVariantsWidgetState();
}

class _ColorVariantsWidgetState extends State<ColorVariantsWidget> {
  int selectedColorIndex = 0;

  @override
  Widget build(BuildContext context) {
    final colorList = widget.product.colors.map((color) {
      try {
        return Color(int.parse(color.replaceAll('#', '0xff')));
      } catch (e) {
        return Colors.grey;
      }
    }).toList();

    return widget.product.colors.isNotEmpty
        ? Row(
      children: List.generate(colorList.length, (index) {
        return GestureDetector(
          onTap: () => setState(() => selectedColorIndex = index),
          child: Container(
            width: 50,
            height: 50,
            margin: const EdgeInsets.only(right: 12),
            decoration: BoxDecoration(
              color: colorList[index],
              shape: BoxShape.circle,
              boxShadow: selectedColorIndex == index
                  ? [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.2),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ]
                  : null,
            ),
          ),
        );
      }),
    )
        : const SizedBox.shrink();
  }
}