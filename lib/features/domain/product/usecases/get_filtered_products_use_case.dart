import '../entities/product.dart';
import '../repositories/product_repository.dart';

class GetFilteredProductsUseCase {
  final ProductRepository productRepository;

  GetFilteredProductsUseCase(this.productRepository);

  Future<ProductsResponse> call(
      int page, {
        String? name,
        String? sortKey,
        String? brands,
        String? categories,
        double? min,
        double? max,
      }) async {
    return await productRepository.getFilteredProducts(
      page,
      name: name,
      sortKey: sortKey,
      brands: brands,
      categories: categories,
      min: min,
      max: max,
    );
  }
}