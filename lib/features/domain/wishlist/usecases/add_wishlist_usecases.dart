import '../repositories/wishlist_details_repository.dart';

class AddToWishlistUseCase {
  final WishlistRepository repository;

  AddToWishlistUseCase(this.repository);

  Future<void> call(String slug) async {
    await repository.addToWishlist(slug);
  }
}