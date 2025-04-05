import '../../../domain/category/repositories/category_repository.dart';
import '../datasources/category_remote_datasource.dart';
import '../models/category_model.dart';

class CategoryRepositoryImpl implements CategoryRepository {
  final CategoryRemoteDataSource categoryRemoteDataSource;

  CategoryRepositoryImpl(this.categoryRemoteDataSource);

  @override
  Future<CategoryResponseModel> getCategories({String? parentId}) async {
    return await categoryRemoteDataSource.getCategories(parentId: parentId);
  }

  @override
  Future<CategoryResponseModel> getFeaturedCategories() async {
    return await categoryRemoteDataSource.getFeaturedCategories();
  }

  @override
  Future<CategoryResponseModel> getTopCategories() async {
    return await categoryRemoteDataSource.getTopCategories();
  }

  @override
  Future<CategoryResponseModel> getFilterPageCategories() async {
    return await categoryRemoteDataSource.getFilterPageCategories();
  }
}