class WishlistItem {
  final int id;
  final String slug;
  final String name;
  final String thumbnailImage;
  final String price;
  final String currencySymbol;

  WishlistItem({
    required this.id,
    required this.slug,
    required this.name,
    required this.thumbnailImage,
    required this.price,
    required this.currencySymbol,
  });
}

class WishlistCheck {
  final bool isInWishlist;

  WishlistCheck({required this.isInWishlist});
}