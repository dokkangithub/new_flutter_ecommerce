import '../../../../core/api/api_provider.dart';
import '../../../../core/utils/constants/app_endpoints.dart';
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
      '${LaravelApiEndPoint.productDetails}$slug',
    );
    return ProductDetailsModel.fromJson(response.data);
  }


}
