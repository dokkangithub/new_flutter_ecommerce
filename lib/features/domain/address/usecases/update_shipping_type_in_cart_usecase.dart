import '../repositories/address_repository.dart';

class UpdateShippingTypeInCartUseCase {
  final AddressRepository repository;
  UpdateShippingTypeInCartUseCase(this.repository);
  Future<void> call(int shippingId, String shippingType) async {
    await repository.updateShippingTypeInCart(shippingId, shippingType);
  }
}