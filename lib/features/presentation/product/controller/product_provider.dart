import 'package:flutter/material.dart';
import 'package:laravel_ecommerce/features/domain/product%20details/entities/product_details.dart';
import '../../../../core/utils/enums/loading_state.dart';
import '../../../domain/product details/usecases/get_product_details_use_case.dart';

class ProductDetailsProvider extends ChangeNotifier {
  final GetProductDetailsUseCase getProductDetailsUseCase;

  ProductDetailsProvider({required this.getProductDetailsUseCase});

  bool _isEditing = false;

  bool get isEditing => _isEditing;

  LoadingState productDetailsState = LoadingState.loading;

  ProductDetails? selectedProduct;
  String productDetailsError = '';

  Future<void> fetchProductDetails(String slug) async {
    try {
      productDetailsState = LoadingState.loading;
      notifyListeners();

      final product = await getProductDetailsUseCase(slug);
      selectedProduct = product;

      productDetailsState = LoadingState.loaded;
    } catch (e) {
      productDetailsState = LoadingState.error;
      productDetailsError = e.toString();
    } finally {
      notifyListeners();
    }
  }

  void toggleEdit() {
    _isEditing = !_isEditing;
    notifyListeners();
  }
}
