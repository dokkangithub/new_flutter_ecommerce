import '../entities/cart.dart';
import '../entities/shipping_update_response.dart';

abstract class CartRepository {
  Future<List<CartItem>> getCartItems();
  Future<int> getCartCount();
  Future<void> deleteCartItem(int cartId);
  Future<void> clearCart();
  Future<void> updateCartQuantities(String cartIds, String quantities);
  Future<CartItem> addToCart(int productId, String variant, int quantity);
  Future<CartSummary> getCartSummary();

}