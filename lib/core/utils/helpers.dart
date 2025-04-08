import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../features/presentation/cart/controller/cart_provider.dart';
import '../../features/presentation/wishlist/controller/wishlist_provider.dart';

abstract class AppFunctions{

  static void addProductToCart({
    required BuildContext context,
    required int productId,
    required String productName,
    String variant = "",
    int quantity = 1,
  }) {
    Provider.of<CartProvider>(
      context,
      listen: false,
    ).addToCart(
      productId,
      variant,
      quantity,
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$productName added to cart'),
      ),
    );
  }

  static Future<void> toggleWishlistStatus(BuildContext context, String productSlug) async {
    try {
      final wishlistProvider = Provider.of<WishlistProvider>(
        context,
        listen: false,
      );

      final isCurrentlyInWishlist =
          wishlistProvider.wishlistStatus[productSlug] ?? false;

      if (isCurrentlyInWishlist) {
        await wishlistProvider.removeFromWishlist(productSlug);
      } else {
        await wishlistProvider.addToWishlist(productSlug);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error updating wishlist: $e')),
      );
    }
  }

}