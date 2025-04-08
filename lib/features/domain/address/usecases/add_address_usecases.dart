import '../entities/address.dart';
import '../repositories/address_repository.dart';

class AddAddressUseCase {
  final AddressRepository repository;
  AddAddressUseCase(this.repository);
  Future<Address> call({
    required String address,
    required int countryId,
    required String title,
    required int stateId,
    required int cityId,
    required String postalCode,
    required String phone,
  }) async {
    return await repository.addAddress(
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