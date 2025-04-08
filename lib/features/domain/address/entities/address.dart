enum AddressType { home, company, other }

class Address {
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

  Address({
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
}

class Location {
  final int id;
  final String name;

  Location({
    required this.id,
    required this.name,
  });
}

class ShippingCost {
  final double cost;
  final String currencySymbol;

  ShippingCost({
    required this.cost,
    required this.currencySymbol,
  });
}