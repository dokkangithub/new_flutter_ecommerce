import '../entities/product.dart';

abstract class ProductRepository {
  Future<ProductsResponse> getFeaturedProducts(int page);
  Future<ProductsResponse> getBestSellingProducts(int page);
  Future<ProductsResponse> getNewAddedProducts(int page);
  Future<ProductsResponse> getTodaysDealProducts();
  Future<ProductsResponse> getFlashDealProducts(int id);
  Future<ProductsResponse> getCategoryProducts(int id, int page, {String? name});
  Future<ProductsResponse> getShopProducts(int id, int page, {String? name});
  Future<ProductsResponse> getBrandProducts(int id, int page, {String? name});
  Future<ProductsResponse> getFilteredProducts(int page, {String? name, String? sortKey, String? brands, String? categories, double? min, double? max});
  Future<ProductsResponse> getDigitalProducts(int page);
  Future<Product> getProductDetails(int id);
  Future<Product> getDigitalProductDetails(int id);
  Future<ProductsResponse> getRelatedProducts(int id);
  Future<ProductsResponse> getTopFromThisSellerProducts(int id);
  Future<dynamic> getVariantWiseInfo(int id, {String? color, String? variants});
}