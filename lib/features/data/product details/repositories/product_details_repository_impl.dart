import '../../../domain/product details/repositories/product_details_repository.dart';
import '../datasources/product_details_remote_datasource.dart';
import '../models/product_details_model.dart';

class ProductDetailsRepositoryImpl implements ProductDetailsRepository {
  final ProductDetailsRemoteDataSource remoteDataSource;

  ProductDetailsRepositoryImpl(this.remoteDataSource);


  @override
  Future<ProductDetailsModel> getProductDetails(String slug) async {
    return await remoteDataSource.getProductDetails(slug);
  }


}