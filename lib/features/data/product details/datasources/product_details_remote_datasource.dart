import '../../../../core/api/api_provider.dart';
import '../../../../core/utils/constants/app_endpoints.dart';
import '../../../../core/utils/constants/app_strings.dart';
import '../models/product_details_model.dart';

abstract class ProductDetailsRemoteDataSource {


  Future<ProductDetailsModel> getProductDetails(String slug);

}

class ProductDetailsRemoteDataSourceImpl implements ProductDetailsRemoteDataSource {
  final ApiProvider apiProvider;

  ProductDetailsRemoteDataSourceImpl(this.apiProvider);


  @override
  Future<ProductDetailsModel> getProductDetails(String slug) async {
    final response = await apiProvider.get(
      '${LaravelApiEndPoint.productDetails}/$slug/${AppStrings.userId}',
    );

    if (response.data != null && response.data['data'] is List && response.data['data'].isNotEmpty) {
      return ProductDetailsModel.fromJson(response.data['data'][0]);
    } else {
      throw Exception('Product details not found or invalid response format');
    }
  }


}
