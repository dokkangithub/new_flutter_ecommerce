import '../../../data/product details/models/product_details_model.dart';

abstract class ProductDetailsRepository {
  Future<ProductDetailsModel> getProductDetails(String slug);
}
