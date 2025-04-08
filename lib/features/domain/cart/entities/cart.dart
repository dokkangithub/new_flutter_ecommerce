class CartItem {
  final int id;
  final String productName;
  final String thumbnailImage;
  final String variant;
  final double price;
  final String currencySymbol;
  final int quantity;

  CartItem({
    required this.id,
    required this.productName,
    required this.thumbnailImage,
    required this.variant,
    required this.price,
    required this.currencySymbol,
    required this.quantity,
  });
}

class CartSummary {
  final double subtotal;
  final double tax;
  final double shippingCost;
  final double total;
  final String currencySymbol;

  CartSummary({
    required this.subtotal,
    required this.tax,
    required this.shippingCost,
    required this.total,
    required this.currencySymbol,
  });
}