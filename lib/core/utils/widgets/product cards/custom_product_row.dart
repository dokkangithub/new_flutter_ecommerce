import 'package:flutter/material.dart';
import 'package:laravel_ecommerce/core/utils/extension/text_style_extension.dart';
import 'package:laravel_ecommerce/core/utils/widgets/custom_cached_image.dart';
import 'package:provider/provider.dart';
import '../../../../features/presentation/wishlist/controller/wishlist_provider.dart';
import '../../../config/routes.dart/routes.dart';
import '../../helpers.dart';

class ProductItemInRow1 extends StatefulWidget {
  final String imageUrl;
  final String productName;
  final String productSlug;
  final String price;
  final String originalPrice;
  final bool isBestSeller;
  final int productId;

  const ProductItemInRow1({
    super.key,
    required this.imageUrl,
    required this.productName,
    required this.price,
    this.originalPrice = '0',
    this.isBestSeller = false,
    required this.productSlug,
    required this.productId,
  });

  @override
  _ProductItemInRow1State createState() => _ProductItemInRow1State();
}

class _ProductItemInRow1State extends State<ProductItemInRow1> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final wishlistProvider = Provider.of<WishlistProvider>(context, listen: false);
      if (!wishlistProvider.wishlistStatus.containsKey(widget.productSlug)) {
        wishlistProvider.isInWishlist(widget.productSlug);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        AppRoutes.navigateTo(context, AppRoutes.productDetailScreen, arguments: {
          'slug': widget.productSlug,
        });
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
                      if (widget.isBestSeller)
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
                        widget.productName,
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
                        '\$${widget.price}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),

                      // Original price (strikethrough) if present
                      if (widget.originalPrice != '0')
                        Text(
                          '\$${widget.originalPrice}',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade400,
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                      const Spacer(),
                      // Add to cart button
                      GestureDetector(
                        onTap: () => AppFunctions.addProductToCart(
                          context: context,
                          productId: widget.productId,
                          productName: widget.productName,
                        ),
                        child: Container(
                          height: 40,
                          width: 40,
                          decoration: const BoxDecoration(
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
                    child: CustomImage(imageUrl: widget.imageUrl),
                  ),
                ),
              ],
            ),

            // Favorite icon overlay with Consumer
            Positioned(
              top: 0,
              right: 0,
              child: Consumer<WishlistProvider>(
                builder: (context, wishlistProvider, child) {
                  final isFavorite = wishlistProvider.wishlistStatus[widget.productSlug] ?? false;
                  return Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.8),
                      borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(15),
                        bottomLeft: Radius.circular(15),
                      ),
                    ),
                    child: InkWell(
                      onTap: () => AppFunctions.toggleWishlistStatus(context, widget.productSlug),
                      child: Icon(
                        isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: isFavorite ? Colors.red : Colors.black54,
                        size: 20,
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}