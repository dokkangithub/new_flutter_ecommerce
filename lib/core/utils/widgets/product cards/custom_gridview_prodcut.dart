import 'package:flutter/material.dart';
import 'package:laravel_ecommerce/core/config/routes.dart/routes.dart';
import 'package:laravel_ecommerce/core/utils/extension/text_style_extension.dart';
import 'package:laravel_ecommerce/core/utils/helpers.dart';
import 'package:provider/provider.dart';
import '../../../../features/presentation/wishlist/controller/wishlist_provider.dart';

class ProductGridCard extends StatelessWidget {
  final String imageUrl;
  final String productName;
  final String productSlug;
  final String price;
  final bool isBestSeller;
  final int productId;

  const ProductGridCard({
    super.key,
    required this.imageUrl,
    required this.productName,
    required this.price,
    this.isBestSeller = false,
    required this.productSlug,
    required this.productId,
  });

  @override
  Widget build(BuildContext context) {
    // Access the WishlistProvider once for async operations
    final wishlistProvider = Provider.of<WishlistProvider>(context, listen: false);

    // Create a ValueNotifier to manage the wishlist status locally
    final ValueNotifier<bool> isInWishlistNotifier = ValueNotifier<bool>(false);

    // Check initial wishlist status asynchronously
    wishlistProvider.isInWishlist(productSlug).then((isInWishlist) {
      isInWishlistNotifier.value = isInWishlist;
    });

    return InkWell(
      onTap: () {
        AppRoutes.navigateTo(
          context,
          AppRoutes.productDetailScreen,
          arguments: {'slug': productSlug},
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withValues(alpha: 0.1),
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product image with favorite button
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                  child: Image.network(
                    imageUrl,
                    height: 100,
                    width: double.infinity,
                    fit: BoxFit.contain,
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: GestureDetector(
                    onTap: () async {
                      // Toggle wishlist status
                      if (isInWishlistNotifier.value) {
                        await wishlistProvider.removeFromWishlist(productSlug);
                      } else {
                        await wishlistProvider.addToWishlist(productSlug);
                      }
                      // Update the notifier with the latest status
                      isInWishlistNotifier.value =
                          wishlistProvider.wishlistStatus[productSlug] ?? false;
                    },
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            spreadRadius: 1,
                            blurRadius: 2,
                          ),
                        ],
                      ),
                      child: ValueListenableBuilder<bool>(
                        valueListenable: isInWishlistNotifier,
                        builder: (context, isInWishlist, child) {
                          return Icon(
                            isInWishlist ? Icons.favorite : Icons.favorite_border,
                            size: 20,
                            color: isInWishlist ? Colors.red : Colors.grey,
                          );
                        },
                      ),
                    ),
                  ),
                ),
                if (isBestSeller)
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        'BEST SELLER',
                        style: context.bodySmall.copyWith(color: Colors.white),
                      ),
                    ),
                  ),
              ],
            ),
            // Product details
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    productName,
                    style: context.titleSmall,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '\$${price.toString()}',
                    style: context.titleSmall.copyWith(
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Add to cart button
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () => AppFunctions.addProductToCart(
                          context: context,
                          productId: productId,
                          productName: productName,
                        ),
                        borderRadius: BorderRadius.circular(8),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.shopping_cart_outlined,
                                size: 16,
                                color: Colors.blue,
                              ),
                              SizedBox(width: 4),
                              Text(
                                'Add to cart',
                                style: context.bodySmall.copyWith(
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}