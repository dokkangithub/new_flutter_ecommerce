import 'package:flutter/material.dart';
import 'package:laravel_ecommerce/core/utils/extension/responsive_extension.dart';
import 'package:laravel_ecommerce/core/utils/extension/text_style_extension.dart';
import 'package:laravel_ecommerce/core/utils/widgets/custom_cached_image.dart';
import 'package:provider/provider.dart';

import '../../../../features/presentation/cart/controller/cart_provider.dart';
import '../../../../features/presentation/wishlist/controller/wishlist_provider.dart';
import '../../../config/routes.dart/routes.dart';

class ProductCard extends StatelessWidget {
  final String imageUrl;
  final String productName;
  final String productSlug;
  final String price;
  final bool isBestSeller;
  final bool isFavorite;
  final int productId;

  const ProductCard({
    super.key,
    required this.imageUrl,
    required this.productName,
    required this.price,
    this.isBestSeller = false,
    this.isFavorite = false,
 required this.productSlug, required this.productId,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        AppRoutes.navigateTo(context, AppRoutes.productDetailScreen,arguments: {
          'slug': productSlug,
        }, );
      },
      child: Container(
        width: context.responsive(180),
        margin: EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.grey.shade200, width: 1),
        ),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Product image with no horizontal padding
                ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(19),
                    topRight: Radius.circular(19),
                  ),
                  child: SizedBox(
                    width: double.infinity,
                    height: context.responsive(120),
                    child: CustomImage(imageUrl: imageUrl, fit: BoxFit.contain),
                  ),
                ),

                // Content padding
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  child: Column(
                    spacing: 4,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Product name
                      Text(
                        productName,
                        style: context.titleSmall,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),

                      // Price and add to cart button
                      Column(
                        children: [
                          Text(
                            '\$${price.toString()}',
                            style: context.titleMedium,
                          ),
                          Text(
                            '\$${price.toString()}',
                            style: context.bodyMedium.copyWith(
                              color: Colors.grey.shade400,
                              decoration: TextDecoration.lineThrough,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),

            // Add to cart button (repositioned to bottom right)
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    bottomRight: Radius.circular(19),
                  ),
                ),
                child: IconButton(
                  icon: const Icon(Icons.add, color: Colors.white),
                  onPressed: (){
                    Provider.of<CartProvider>(context, listen: false).addToCart(
                      productId,
                      "", // variant - adjust if needed
                      1,  // default quantity
                    );
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('${productName} added to cart')),
                    );
                  },
                  padding: EdgeInsets.zero,
                ),
              ),
            ),

            // Favorite icon
            Positioned(
              top: 0,
              left: 0,
              child: Container(
                width: 40,
                height: 40,
                padding: EdgeInsets.all(2),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.8),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    bottomRight: Radius.circular(19),
                  ),
                ),
                child: InkWell(
                  onTap: () {
                    final wishlistProvider = Provider.of<WishlistProvider>(context, listen: false);
                    final isCurrentlyInWishlist = wishlistProvider.wishlistStatus[productSlug] ?? false;

                    if (isCurrentlyInWishlist) {
                      wishlistProvider.removeFromWishlist(productSlug);
                    } else {
                      wishlistProvider.addToWishlist(productSlug);
                    }},
                  child: Icon(
                    isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: isFavorite ? Colors.red : Colors.black54,
                    size: 22,
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
