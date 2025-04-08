import '../../../domain/cart/entities/cart.dart';

class CartItemModel {
  final int id;
  final String productName;
  final String thumbnailImage;
  final String variant;
  final double price;
  final String currencySymbol;
  final int quantity;

  CartItemModel({
    required this.id,
    required this.productName,
    required this.thumbnailImage,
    required this.variant,
    required this.price,
    required this.currencySymbol,
    required this.quantity,
  });

  factory CartItemModel.fromJson(Map<String, dynamic> json) {
    return CartItemModel(
      id: json['id'] ?? 0,
      productName: json['product_name'] ?? '',
      thumbnailImage: json['thumbnail_image'] ?? '',
      variant: json['variant'] ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      currencySymbol: json['currency_symbol'] ?? '',
      quantity: json['quantity'] ?? 1,
    );
  }

  CartItem toEntity() {
    return CartItem(
      id: id,
      productName: productName,
      thumbnailImage: thumbnailImage,
      variant: variant,
      price: price,
      currencySymbol: currencySymbol,
      quantity: quantity,
    );
  }
}

class CartSummaryModel {
  final double subtotal;
  final double tax;
  final double shippingCost;
  final double total;
  final String currencySymbol;

  CartSummaryModel({
    required this.subtotal,
    required this.tax,
    required this.shippingCost,
    required this.total,
    required this.currencySymbol,
  });

  factory CartSummaryModel.fromJson(Map<String, dynamic> json) {
    return CartSummaryModel(
      subtotal: (json['subtotal'] as num?)?.toDouble() ?? 0.0,
      tax: (json['tax'] as num?)?.toDouble() ?? 0.0,
      shippingCost: (json['shipping_cost'] as num?)?.toDouble() ?? 0.0,
      total: (json['total'] as num?)?.toDouble() ?? 0.0,
      currencySymbol: json['currency_symbol'] ?? '',
    );
  }

  CartSummary toEntity() {
    return CartSummary(
      subtotal: subtotal,
      tax: tax,
      shippingCost: shippingCost,
      total: total,
      currencySymbol: currencySymbol,
    );
  }
}

class CartCountModel {
  final int count;

  CartCountModel({required this.count});

  factory CartCountModel.fromJson(Map<String, dynamic> json) {
    return CartCountModel(count: json['count'] ?? 0);
  }
}