import 'package:laravel_ecommerce/core/utils/constants/app_strings.dart';

import '../../../../core/api/api_provider.dart';
import '../../../../core/utils/constants/app_endpoints.dart';
import '../../../../core/utils/local_storage/local_storage_keys.dart';
import '../models/cart_model.dart';
import '../../../../core/utils/local_storage/secure_storage.dart';

abstract class CartRemoteDataSource {
  Future<List<CartItemModel>> getCartItems();

  Future<CartCountModel> getCartCount();

  Future<void> deleteCartItem(int cartId);

  Future<void> clearCart();

  Future<void> updateCartQuantities(String cartIds, String quantities);

  Future<CartItemModel> addToCart(int productId, String variant, int quantity);

  Future<CartSummaryModel> getCartSummary();
}

class CartRemoteDataSourceImpl implements CartRemoteDataSource {
  final ApiProvider apiProvider;
  final SecureStorage secureStorage;

  CartRemoteDataSourceImpl(this.apiProvider, this.secureStorage);

  Future<Map<String, dynamic>> _getUserParams() async {
    return {
      if (AppStrings.userId == null && AppStrings.tempUserId != null)
        'temp_user_id': AppStrings.tempUserId,
      if (AppStrings.userId != null) 'user_id': AppStrings.userId.toString(),
    };
  }

  Future<Map<String, String>> _getHeaders() async {
    return {
      if (AppStrings.token != null)
        'Authorization': 'Bearer ${AppStrings.token}',
      'App-Language': 'en',
    };
  }

  @override
  Future<List<CartItemModel>> getCartItems() async {
    final response = await apiProvider.post(
      LaravelApiEndPoint.cart,
      data: await _getUserParams(),
    );
    if (response.data != null && response.data['data'] is List) {
      return (response.data['data'] as List)
          .map((item) => CartItemModel.fromJson(item))
          .toList();
    }
    throw Exception('Invalid cart response format');
  }

  @override
  Future<CartCountModel> getCartCount() async {
    final response = await apiProvider.post(
      LaravelApiEndPoint.cartCount,
      data: await _getUserParams(),
    );
    if (response.data != null) {
      return CartCountModel.fromJson(response.data);
    }
    throw Exception('Invalid cart count response');
  }

  @override
  Future<void> deleteCartItem(int cartId) async {
    await apiProvider.delete('${LaravelApiEndPoint.cart}/$cartId');
  }

  @override
  Future<void> clearCart() async {
    await apiProvider.post(
      LaravelApiEndPoint.clearCart,
      data: await _getUserParams(),
    );
  }

  @override
  Future<void> updateCartQuantities(String cartIds, String quantities) async {
    await apiProvider.post(
      LaravelApiEndPoint.cartProcess,
      data: {'cart_ids': cartIds, 'cart_quantities': quantities},
    );
  }

  @override
  Future<CartItemModel> addToCart(
    int productId,
    String variant,
    int quantity,
  ) async {
    final userParams = await _getUserParams();
    final response = await apiProvider.post(
      LaravelApiEndPoint.cartAdd,
      data: {
        'id': productId.toString(),
        'variant': variant,
        'quantity': quantity.toString(),
        ...userParams,
      },
    );
    if (response.data != null && response.data['result'] == true) {
      if (response.data['temp_user_id'] != null) {
        await SecureStorage().save(
          LocalStorageKey.tempUserId,
          response.data['temp_user_id'],
        );
      }
      return CartItemModel.fromJson(response.data['data']);
    }
    throw Exception('Failed to add to cart');
  }

  @override
  Future<CartSummaryModel> getCartSummary() async {
    final response = await apiProvider.post(
      LaravelApiEndPoint.cartSummary,
      data: await _getUserParams(),
    );
    if (response.data != null) {
      return CartSummaryModel.fromJson(response.data);
    }
    throw Exception('Invalid cart summary response');
  }
}
