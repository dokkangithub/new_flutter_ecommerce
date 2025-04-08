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

  static Future<void> toggleWishlistStatus(BuildContext context, String slug) async {
    final provider = Provider.of<WishlistProvider>(context, listen: false);

    // Check if item is already in wishlist
    final isInWishlist = provider.wishlistStatus[slug] ?? false;

    if (isInWishlist) {
      await provider.removeFromWishlist(slug);
    } else {
      await provider.addToWishlist(slug);
    }

    // Show a snackbar with the result message
    if (context.mounted && provider.lastActionMessage != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(provider.lastActionMessage!)),
      );
    }
  }
}