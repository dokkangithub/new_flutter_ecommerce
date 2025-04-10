import 'package:flutter/material.dart';
import '../entities/payment_type.dart';

abstract class PaymentRepository {
  /// Get available payment types
  Future<List<PaymentType>> getPaymentTypes();
  
  /// Create a Kashier payment order
  Future<OrderResponse> createKashierOrder({
    required String postalCode,
    required String stateId,
    required String address,
    required String city,
    required String phone,
    String? additionalInfo,
    BuildContext? context,
  });
  
  /// Create a Cash on Delivery payment order
  Future<OrderResponse> createCashOrder({
    required String postalCode,
    required String stateId,
    required String address,
    required String city,
    required String phone,
    String? additionalInfo,
    required BuildContext context,
  });
  
  /// Verify order success by order ID
  Future<Map<String, dynamic>> verifyOrderSuccess(String orderId);

  Future<Map<String, dynamic>> updateShippingTypeInCart({
    required String stateId,
    required String cityId,
    required String address,
  });
}
