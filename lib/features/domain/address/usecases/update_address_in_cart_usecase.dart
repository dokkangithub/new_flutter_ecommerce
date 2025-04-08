import '../repositories/address_repository.dart';

class UpdateAddressInCartUseCase {
  final AddressRepository repository;
  UpdateAddressInCartUseCase(this.repository);
  Future<void> call(int addressId, int pickupPointId) async {
    await repository.updateAddressInCart(addressId, pickupPointId);
  }
}