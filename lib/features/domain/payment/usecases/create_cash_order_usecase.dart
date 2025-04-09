import 'package:flutter/material.dart';
import '../entities/payment_type.dart';
import '../repositories/payment_repository.dart';

class CreateCashOrderUseCase {
  final PaymentRepository repository;

  CreateCashOrderUseCase(this.repository);

  Future<OrderResponse> call({
    required String name,
    required String stateId,
    required String address,
    required String city,
    required String phone,
    String? additionalInfo,
    required BuildContext context,
  }) async {
    return await repository.createCashOrder(
      name: name,
      stateId: stateId,
      address: address,
      city: city,
      phone: phone,
      additionalInfo: additionalInfo,
      context: context,
    );
  }
}
