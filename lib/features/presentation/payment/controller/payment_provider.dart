import 'package:flutter/material.dart';
import '../../../../core/utils/enums/loading_state.dart';
import '../../../domain/payment/entities/payment_type.dart';
import '../../../domain/payment/usecases/get_payment_types_usecase.dart';
import '../../../domain/payment/usecases/create_kashier_order_usecase.dart';
import '../../../domain/payment/usecases/create_cash_order_usecase.dart';
import '../../../domain/payment/usecases/verify_order_success_usecase.dart';

class PaymentProvider extends ChangeNotifier {
  final GetPaymentTypesUseCase getPaymentTypesUseCase;
  final CreateKashierOrderUseCase createKashierOrderUseCase;
  final CreateCashOrderUseCase createCashOrderUseCase;
  final VerifyOrderSuccessUseCase verifyOrderSuccessUseCase;

  PaymentProvider({
    required this.getPaymentTypesUseCase,
    required this.createKashierOrderUseCase,
    required this.createCashOrderUseCase,
    required this.verifyOrderSuccessUseCase,
  });

  LoadingState paymentTypesState = LoadingState.initial;
  LoadingState orderCreationState = LoadingState.initial;
  List<PaymentType> paymentTypes = [];
  String selectedPaymentTypeKey = '';
  String errorMessage = '';

  Future<void> fetchPaymentTypes() async {
    try {
      paymentTypesState = LoadingState.loading;
      notifyListeners();

      paymentTypes = await getPaymentTypesUseCase();
      
      if (paymentTypes.isNotEmpty && selectedPaymentTypeKey.isEmpty) {
        selectedPaymentTypeKey = paymentTypes.first.paymentTypeKey;
      }
      
      paymentTypesState = LoadingState.loaded;
    } catch (e) {
      paymentTypesState = LoadingState.error;
      errorMessage = e.toString();
    } finally {
      notifyListeners();
    }
  }

  void selectPaymentType(String paymentTypeKey) {
    selectedPaymentTypeKey = paymentTypeKey;
    notifyListeners();
  }

  Future<OrderResponse> createOrder({
    required String postalCode,
    required String stateId,
    required String address,
    required String city,
    required String phone,
    String? additionalInfo,
    required BuildContext context,
  }) async {
    try {
      orderCreationState = LoadingState.loading;
      notifyListeners();

      late OrderResponse response;

      if (selectedPaymentTypeKey == 'kashier') {
        response = await createKashierOrderUseCase(
          postalCode: postalCode,
          stateId: stateId,
          address: address,
          city: city,
          phone: phone,
          additionalInfo: additionalInfo,
          context: context,
        );
      } else if (selectedPaymentTypeKey == 'cash_on_delivery') {
        response = await createCashOrderUseCase(
          postalCode: postalCode,
          stateId: stateId,
          address: address,
          city: city,
          phone: phone,
          additionalInfo: additionalInfo,
          context: context,
        );
      } else {
        throw Exception('Invalid payment method selected');
      }

      orderCreationState = response.result ? LoadingState.loaded : LoadingState.error;
      if (!response.result) {
        errorMessage = response.message;
      }
      
      return response;
    } catch (e) {
      orderCreationState = LoadingState.error;
      errorMessage = e.toString();
      return OrderResponse(
        result: false,
        message: e.toString(),
        status: 'error',
      );
    } finally {
      notifyListeners();
    }
  }

  Future<Map<String, dynamic>> verifyOrder(String orderId) async {
    try {
      return await verifyOrderSuccessUseCase(orderId);
    } catch (e) {
      errorMessage = e.toString();
      return {
        'result': false,
        'message': e.toString(),
      };
    }
  }

  PaymentType? getSelectedPaymentType() {
    if (selectedPaymentTypeKey.isEmpty) return null;
    
    try {
      return paymentTypes.firstWhere(
        (type) => type.paymentTypeKey == selectedPaymentTypeKey
      );
    } catch (e) {
      return null;
    }
  }

  void resetOrderCreationState() {
    orderCreationState = LoadingState.initial;
    errorMessage = '';
    notifyListeners();
  }

}
