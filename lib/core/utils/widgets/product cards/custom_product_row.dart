import 'package:flutter/material.dart';
import 'package:laravel_ecommerce/core/utils/extension/responsive_extension.dart';
import 'package:laravel_ecommerce/core/utils/extension/text_style_extension.dart';
import 'package:laravel_ecommerce/core/utils/widgets/custom_cached_image.dart';

import '../../../config/routes.dart/routes.dart';

class ProductItemInRow1 extends StatelessWidget {
  final String imageUrl;
  final String productName;
  final String price;
  final String originalPrice;
  final bool isBestSeller;
  final bool isFavorite;
  final VoidCallback onFavoriteToggle;
  final VoidCallback onAddToCart;

  const ProductItemInRow1({
    super.key,
    required this.imageUrl,
    required this.productName,
    required this.price,
    this.originalPrice = '0',
    this.isBestSeller = false,
    this.isFavorite = false,
    required this.onFavoriteToggle,
    required this.onAddToCart,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        AppRoutes.navigateTo(context, AppRoutes.productScreen);
      },
      child: Container(
        width: MediaQuery.sizeOf(context).width,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Stack(
          children: [
            // Main content
            Row(
              children: [
                // Left section with product details
                Expanded(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Best seller tag (conditionally shown)
                      if (isBestSeller)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            'BEST SELLER',
                            style: context.bodySmall.copyWith(
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                        ),
                      const SizedBox(height: 8),

                      // Product name
                      Text(
                        productName,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),

                      // Price display
                      Text(
                        '\$${price.toString()}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),

                      // Original price (strikethrough) if present
                      //if (originalPrice > 0)
                        Text(
                          '\$${originalPrice.toString()}',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade400,
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                      Spacer(),
                      // Add to cart button
                      GestureDetector(
                        onTap: onAddToCart,
                        child: Container(
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(15),
                              bottomLeft: Radius.circular(15),
                            ),
                          ),
                          padding: const EdgeInsets.all(8),
                          child: const Icon(
                            Icons.add,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Right section with product image
                Expanded(
                  flex: 3,
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(16),
                      bottomRight: Radius.circular(16),
                    ),
                    child: CustomImage(imageUrl: imageUrl),
                  ),
                ),
              ],
            ),

            // Favorite icon overlay
            Positioned(
              top: 0,
              right: 0,
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.8),
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(15),
                    bottomLeft: Radius.circular(15),
                  ),
                ),
                child: InkWell(
                  onTap: onFavoriteToggle,
                  child: Icon(
                    isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: isFavorite ? Colors.red : Colors.black54,
                    size: 20,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
