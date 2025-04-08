import '../../../domain/wishlist/entities/wishlist_details.dart';

class WishlistItemModel {
  final int id;
  final String slug;
  final String name;
  final String thumbnailImage;
  final String price;
  final String currencySymbol;

  WishlistItemModel({
    required this.id,
    required this.slug,
    required this.name,
    required this.thumbnailImage,
    required this.price,
    required this.currencySymbol,
  });

  factory WishlistItemModel.fromJson(Map<String, dynamic> json) {
    return WishlistItemModel(
      id: json['id'] ?? 0,
      slug: json['slug'] ?? '',
      name: json['name'] ?? '',
      thumbnailImage: json['thumbnail_image'] ?? '',
      price: json['main_price'] ?? '',
      currencySymbol: json['currency_symbol'] ?? '',
    );
  }

  WishlistItem toEntity() {
    return WishlistItem(
      id: id,
      slug: slug,
      name: name,
      thumbnailImage: thumbnailImage,
      price: price,
      currencySymbol: currencySymbol,
    );
  }
}

class WishlistCheckModel {
  final bool isInWishlist;

  WishlistCheckModel({required this.isInWishlist});

  factory WishlistCheckModel.fromJson(Map<String, dynamic> json) {
    return WishlistCheckModel(
      isInWishlist: json['is_in_wishlist'] ?? false,
    );
  }

  WishlistCheck toEntity() {
    return WishlistCheck(isInWishlist: isInWishlist);
  }
}