import 'package:flutter/material.dart';
import 'package:laravel_ecommerce/core/utils/widgets/custom_cached_image.dart';
import 'package:laravel_ecommerce/features/domain/product%20details/entities/product_details.dart';
import 'package:laravel_ecommerce/features/presentation/product/widgets/shimmers/shimmer_widget.dart';

class ProductImageWidget extends StatelessWidget {
  final ProductDetails product;
  final double height;
  final bool isLoading;

  const ProductImageWidget({
    super.key,
    required this.product,
    required this.height,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? ShimmerWidget(height: height)
        : CustomImage(
      imageUrl: product.thumbnailImage,
      fit: BoxFit.cover,
      height: height,
      width: double.infinity,
    );
  }
}