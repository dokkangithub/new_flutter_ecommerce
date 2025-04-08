import '../repositories/wishlist_details_repository.dart';

class RemoveFromWishlistUseCase {
  final WishlistRepository repository;

  RemoveFromWishlistUseCase(this.repository);

  Future<void> call(String slug) async {
    await repository.removeFromWishlist(slug);
  }
}