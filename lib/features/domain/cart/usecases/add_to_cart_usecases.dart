import '../entities/cart.dart';
import '../repositories/cart_repository.dart';

class AddToCartUseCase {
  final CartRepository repository;

  AddToCartUseCase(this.repository);

  Future<CartItem> call(int productId, String variant, int quantity) async {
    return await repository.addToCart(productId, variant, quantity);
  }
}