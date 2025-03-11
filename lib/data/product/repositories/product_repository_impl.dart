import '../../../domain/product/entities/product.dart';
import '../../../domain/product/repositories/product_repository.dart';
import '../../product/datasources/product_remote_datasource.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductRemoteDataSource remoteDataSource;

  ProductRepositoryImpl(this.remoteDataSource);

  @override
  Future<ProductsResponse> getFeaturedProducts(int page) async {
    return await remoteDataSource.getFeaturedProducts(page);
  }

  @override
  Future<ProductsResponse> getBestSellingProducts(int page) async {
    return await remoteDataSource.getBestSellingProducts(page);
  }

  @override
  Future<ProductsResponse> getNewAddedProducts(int page) async {
    return await remoteDataSource.getNewAddedProducts(page);
  }

  @override
  Future<ProductsResponse> getTodaysDealProducts() async {
    return await remoteDataSource.getTodaysDealProducts();
  }

  @override
  Future<ProductsResponse> getFlashDealProducts(int id) async {
    return await remoteDataSource.getFlashDealProducts(id);
  }

  @override
  Future<ProductsResponse> getCategoryProducts(int id, int page, {String? name}) async {
    return await remoteDataSource.getCategoryProducts(id, page, name: name);
  }

  @override
  Future<ProductsResponse> getShopProducts(int id, int page, {String? name}) async {
    return await remoteDataSource.getShopProducts(id, page, name: name);
  }

  @override
  Future<ProductsResponse> getBrandProducts(int id, int page, {String? name}) async {
    return await remoteDataSource.getBrandProducts(id, page, name: name);
  }

  @override
  Future<ProductsResponse> getFilteredProducts(
      int page, {
        String? name,
        String? sortKey,
        String? brands,
        String? categories,
        double? min,
        double? max,
      }) async {
    return await remoteDataSource.getFilteredProducts(
      page,
      name: name,
      sortKey: sortKey,
      brands: brands,
      categories: categories,
      min: min,
      max: max,
    );
  }

  @override
  Future<ProductsResponse> getDigitalProducts(int page) async {
    return await remoteDataSource.getDigitalProducts(page);
  }

  @override
  Future<Product> getProductDetails(int id) async {
    return await remoteDataSource.getProductDetails(id);
  }

  @override
  Future<Product> getDigitalProductDetails(int id) async {
    return await remoteDataSource.getDigitalProductDetails(id);
  }

  @override
  Future<ProductsResponse> getRelatedProducts(int id) async {
    return await remoteDataSource.getRelatedProducts(id);
  }

  @override
  Future<ProductsResponse> getTopFromThisSellerProducts(int id) async {
    return await remoteDataSource.getTopFromThisSellerProducts(id);
  }

  @override
  Future<dynamic> getVariantWiseInfo(int id, {String? color, String? variants}) async {
    return await remoteDataSource.getVariantWiseInfo(id, color: color, variants: variants);
  }
}