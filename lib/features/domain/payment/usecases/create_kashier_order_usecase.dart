import 'package:flutter/material.dart';
import '../entities/payment_type.dart';
import '../repositories/payment_repository.dart';

class CreateKashierOrderUseCase {
  final PaymentRepository repository;

  CreateKashierOrderUseCase(this.repository);

  Future<OrderResponse> call({
    required String name,
    required String stateId,
    required String address,
    required String city,
    required String phone,
    required String paymentMethod,
    String? additionalInfo,
    BuildContext? context,
  }) async {
    return await repository.createKashierOrder(
      name: name,
      stateId: stateId,
      address: address,
      city: city,
      phone: phone,
      paymentMethod: paymentMethod,
      additionalInfo: additionalInfo,
      context: context,
    );
  }
}
