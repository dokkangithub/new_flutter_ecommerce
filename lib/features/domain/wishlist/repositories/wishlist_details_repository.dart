

import '../entities/wishlist_details.dart';

abstract class WishlistRepository {
  Future<List<WishlistItem>> getWishlist();
  Future<WishlistCheck> checkWishlist(String slug);
  Future<void> addToWishlist(String slug);
  Future<void> removeFromWishlist(String slug);
}

