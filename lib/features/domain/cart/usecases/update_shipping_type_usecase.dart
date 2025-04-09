import '../entities/shipping_update_response.dart';
import '../repositories/cart_repository.dart';

class UpdateShippingTypeUseCase {
  final CartRepository repository;

  UpdateShippingTypeUseCase(this.repository);

  Future<ShippingUpdateResponse> call({
    required String address,
    required String shippingType,
    required int shippingId,
    required int countryId,
    required String cityId,
    required String stateId,
  }) async {
    return await repository.updateShippingTypeInCart(
      address: address,
      shippingType: shippingType,
      shippingId: shippingId,
      countryId: countryId,
      cityId: cityId,
      stateId: stateId,
    );
  }
}
