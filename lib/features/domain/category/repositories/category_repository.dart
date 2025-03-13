import '../../../data/category/models/category_response_model.dart';

abstract class CategoryRepository {
  Future<CategoryResponseModel> getCategories({String? parentId});
  Future<CategoryResponseModel> getFeaturedCategories();
  Future<CategoryResponseModel> getTopCategories();
  Future<CategoryResponseModel> getFilterPageCategories();
}