import '../../../domain/address/entities/address.dart';

class AddressModel {
  final int id;
  final String title;
  final String address;
  final int countryId;
  final int stateId;
  final int cityId;
  final String postalCode;
  final String phone;
  final double? latitude;
  final double? longitude;
  final bool isDefault;

  AddressModel({
    required this.id,
    required this.title,
    required this.address,
    required this.countryId,
    required this.stateId,
    required this.cityId,
    required this.postalCode,
    required this.phone,
    this.latitude,
    this.longitude,
    required this.isDefault,
  });

  factory AddressModel.fromJson(Map<String, dynamic> json) {
    return AddressModel(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      address: json['address'] ?? '',
      countryId: json['country_id'] ?? 0,
      stateId: json['state_id'] ?? 0,
      cityId: json['city_id'] ?? 0,
      postalCode: json['postal_code'] ?? '',
      phone: json['phone'] ?? '',
      latitude: json['latitude']?.toDouble(),
      longitude: json['longitude']?.toDouble(),
      isDefault: json['is_default'] ?? false,
    );
  }

  Address toEntity() {
    return Address(
      id: id,
      title: title,
      address: address,
      countryId: countryId,
      stateId: stateId,
      cityId: cityId,
      postalCode: postalCode,
      phone: phone,
      latitude: latitude,
      longitude: longitude,
      isDefault: isDefault,
    );
  }
}

class LocationModel {
  final int id;
  final String name;

  LocationModel({
    required this.id,
    required this.name,
  });

  factory LocationModel.fromJson(Map<String, dynamic> json) {
    return LocationModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
    );
  }

  Location toEntity() {
    return Location(id: id, name: name);
  }
}

class ShippingCostModel {
  final double cost;
  final String currencySymbol;

  ShippingCostModel({
    required this.cost,
    required this.currencySymbol,
  });

  factory ShippingCostModel.fromJson(Map<String, dynamic> json) {
    return ShippingCostModel(
      cost: (json['cost'] as num?)?.toDouble() ?? 0.0,
      currencySymbol: json['currency_symbol'] ?? '',
    );
  }

  ShippingCost toEntity() {
    return ShippingCost(cost: cost, currencySymbol: currencySymbol);
  }
}