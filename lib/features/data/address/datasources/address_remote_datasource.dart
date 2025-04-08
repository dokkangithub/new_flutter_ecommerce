import '../../../../core/api/api_provider.dart';
import '../../../../core/utils/constants/app_endpoints.dart';
import '../../../../core/utils/constants/app_strings.dart';
import '../models/address_model.dart';
import '../../../../core/utils/local_storage/secure_storage.dart';

abstract class AddressRemoteDataSource {
  Future<List<AddressModel>> getAddresses();
  Future<AddressModel> getHomeDeliveryAddress();
  Future<AddressModel> addAddress({
    required String address,
    required int countryId,
    required String title,
    required int stateId,
    required int cityId,
    required String postalCode,
    required String phone,
  });
  Future<AddressModel> updateAddress({
    required int id,
    required String address,
    required String title,
    required int countryId,
    required int stateId,
    required int cityId,
    required String postalCode,
    required String phone,
  });
  Future<void> updateAddressLocation(int id, double latitude, double longitude);
  Future<void> makeAddressDefault(int id);
  Future<void> deleteAddress(int id);
  Future<List<LocationModel>> getCitiesByState(int stateId, {String name = ''});
  Future<List<LocationModel>> getStatesByCountry(int countryId, {String name = ''});
  Future<List<LocationModel>> getCountries({String name = ''});
  Future<ShippingCostModel> getShippingCost(String shippingType);
  Future<void> updateAddressInCart(int addressId, int pickupPointId);
  Future<void> updateShippingTypeInCart(int shippingId, String shippingType);
}

class AddressRemoteDataSourceImpl implements AddressRemoteDataSource {
  final ApiProvider apiProvider;
  final SecureStorage secureStorage;

  AddressRemoteDataSourceImpl(this.apiProvider, this.secureStorage);



  @override
  Future<List<AddressModel>> getAddresses() async {
    final response = await apiProvider.get(
      LaravelApiEndPoint.userShippingAddress,
    );
    if (response.data != null && response.data['data'] is List) {
      return (response.data['data'] as List)
          .map((item) => AddressModel.fromJson(item))
          .toList();
    }
    throw Exception('Invalid address response');
  }

  @override
  Future<AddressModel> getHomeDeliveryAddress() async {
    final response = await apiProvider.get(
      LaravelApiEndPoint.getHomeDeliveryAddress,
    );
    if (response.data != null && response.data['data'] is Map) {
      return AddressModel.fromJson(response.data['data']);
    }
    throw Exception('Invalid home delivery address response');
  }

  @override
  Future<AddressModel> addAddress({
    required String address,
    required int countryId,
    required String title,
    required int stateId,
    required int cityId,
    required String postalCode,
    required String phone,
  }) async {
    final response = await apiProvider.post(
      LaravelApiEndPoint.userShippingCreate,
      data: {
        'user_id': AppStrings.userId.toString(),
        'address': address,
        'title': title,
        'country_id': countryId.toString(),
        'state_id': stateId.toString(),
        'city_id': cityId.toString(),
        'postal_code': postalCode,
        'phone': phone,
      },
    );
    if (response.data != null && response.data['data'] is Map) {
      return AddressModel.fromJson(response.data['data']);
    }
    throw Exception('Failed to add address');
  }

  @override
  Future<AddressModel> updateAddress({
    required int id,
    required String address,
    required String title,
    required int countryId,
    required int stateId,
    required int cityId,
    required String postalCode,
    required String phone,
  }) async {
    final response = await apiProvider.post(
      LaravelApiEndPoint.userShippingUpdate,
      data: {
        'id': id.toString(),
        'user_id': AppStrings.userId.toString(),
        'address': address,
        'title': title,
        'country_id': countryId.toString(),
        'state_id': stateId.toString(),
        'city_id': cityId.toString(),
        'postal_code': postalCode,
        'phone': phone,
      },
    );
    if (response.data != null && response.data['data'] is Map) {
      return AddressModel.fromJson(response.data['data']);
    }
    throw Exception('Failed to update address');
  }

  @override
  Future<void> updateAddressLocation(int id, double latitude, double longitude) async {
    await apiProvider.post(
      LaravelApiEndPoint.userShippingUpdateLocation,
      data: {
        'id': id.toString(),
        'user_id': AppStrings.userId.toString(),
        'latitude': latitude.toString(),
        'longitude': longitude.toString(),
      },
    );
  }

  @override
  Future<void> makeAddressDefault(int id) async {
    await apiProvider.post(
      LaravelApiEndPoint.userShippingMakeDefault,
      data: {'id': id.toString()},
    );
  }

  @override
  Future<void> deleteAddress(int id) async {
    await apiProvider.get(
      '${LaravelApiEndPoint.userShippingDelete}/$id',
    );
  }

  @override
  Future<List<LocationModel>> getCitiesByState(int stateId, {String name = ''}) async {
    final response = await apiProvider.get(
      '${LaravelApiEndPoint.citiesByState}/$stateId?name=$name',
    );
    if (response.data != null && response.data['data'] is List) {
      return (response.data['data'] as List)
          .map((item) => LocationModel.fromJson(item))
          .toList();
    }
    throw Exception('Invalid cities response');
  }

  @override
  Future<List<LocationModel>> getStatesByCountry(int countryId, {String name = ''}) async {
    final response = await apiProvider.get(
      '${LaravelApiEndPoint.statesByCountry}/$countryId?name=$name',
    );
    if (response.data != null && response.data['data'] is List) {
      return (response.data['data'] as List)
          .map((item) => LocationModel.fromJson(item))
          .toList();
    }
    throw Exception('Invalid states response');
  }

  @override
  Future<List<LocationModel>> getCountries({String name = ''}) async {
    final response = await apiProvider.get(
      '${LaravelApiEndPoint.countries}?name=$name',
    );
    if (response.data != null && response.data['data'] is List) {
      return (response.data['data'] as List)
          .map((item) => LocationModel.fromJson(item))
          .toList();
    }
    throw Exception('Invalid countries response');
  }

  @override
  Future<ShippingCostModel> getShippingCost(String shippingType) async {
    final response = await apiProvider.post(
      LaravelApiEndPoint.shippingCost,
      data: {'seller_list': shippingType},
    );
    if (response.data != null && response.data['data'] is Map) {
      return ShippingCostModel.fromJson(response.data['data']);
    }
    throw Exception('Invalid shipping cost response');
  }

  @override
  Future<void> updateAddressInCart(int addressId, int pickupPointId) async {
    await apiProvider.post(
      LaravelApiEndPoint.updateAddressInCart,
      data: {
        'address_id': addressId.toString(),
        'pickup_point_id': pickupPointId.toString(),
        'user_id': AppStrings.userId.toString(),
      },
    );
  }

  @override
  Future<void> updateShippingTypeInCart(int shippingId, String shippingType) async {
    await apiProvider.post(
      LaravelApiEndPoint.updateShippingTypeInCart,
      data: {
        'shipping_id': shippingId.toString(),
        'shipping_type': shippingType,
      },
    );
  }
}