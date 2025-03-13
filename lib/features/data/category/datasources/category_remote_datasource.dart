import '../../../../core/api/api_provider.dart';
import '../../../../core/utils/constants/app_endpoints.dart';
import '../models/category_response_model.dart';

abstract class CategoryRemoteDataSource {
  Future<CategoryResponseModel> getCategories({String? parentId});
  Future<CategoryResponseModel> getFeaturedCategories();
  Future<CategoryResponseModel> getTopCategories();
  Future<CategoryResponseModel> getFilterPageCategories();
}

class CategoryRemoteDataSourceImpl implements CategoryRemoteDataSource {
  final ApiProvider apiProvider;

  CategoryRemoteDataSourceImpl(this.apiProvider);

  @override
  Future<CategoryResponseModel> getCategories({String? parentId}) async {
    final Map<String, dynamic> queryParams = {};
    if (parentId != null) {
      queryParams['parent_id'] = parentId;
    }

    final response = await apiProvider.get(
      LaravelApiEndPoint.categories,
      queryParameters: queryParams,
    );
    return CategoryResponseModel.fromJson(response.data);
  }

  @override
  Future<CategoryResponseModel> getFeaturedCategories() async {
    final response = await apiProvider.get(
      LaravelApiEndPoint.featuredCategories,
    );
    return CategoryResponseModel.fromJson(response.data);
  }

  @override
  Future<CategoryResponseModel> getTopCategories() async {
    final response = await apiProvider.get(
      LaravelApiEndPoint.topCategories,
    );
    return CategoryResponseModel.fromJson(response.data);
  }

  @override
  Future<CategoryResponseModel> getFilterPageCategories() async {
    final response = await apiProvider.get(
      LaravelApiEndPoint.filterPageCategories,
    );
    return CategoryResponseModel.fromJson(response.data);
  }
}