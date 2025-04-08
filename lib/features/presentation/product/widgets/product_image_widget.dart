import 'package:flutter/material.dart';
import 'package:laravel_ecommerce/core/utils/widgets/custom_cached_image.dart';
import 'package:laravel_ecommerce/features/domain/product%20details/entities/product_details.dart';

class ProductImageWidget extends StatelessWidget {
  final ProductDetails product;
  final double height;

  const ProductImageWidget({
    super.key,
    required this.product,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    return CustomImage(
      imageUrl: product.thumbnailImage,
      fit: BoxFit.cover,
      height: height,
      width: double.infinity,
    );
  }
}