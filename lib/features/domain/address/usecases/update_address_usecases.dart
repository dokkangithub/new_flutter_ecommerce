import '../entities/address.dart';
import '../repositories/address_repository.dart';

class UpdateAddressUseCase {
  final AddressRepository repository;
  UpdateAddressUseCase(this.repository);
  Future<Address> call({
    required int id,
    required String address,
    required String title,
    required int countryId,
    required int stateId,
    required int cityId,
    required String postalCode,
    required String phone,
  }) async {
    return await repository.updateAddress(
      id: id,
      address: address,
      countryId: countryId,
      title: title,
      stateId: stateId,
      cityId: cityId,
      postalCode: postalCode,
      phone: phone,
    );
  }
}