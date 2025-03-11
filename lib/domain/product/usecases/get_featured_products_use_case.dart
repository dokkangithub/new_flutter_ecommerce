import '../entities/product.dart';
import '../repositories/product_repository.dart';

class GetFeaturedProductsUseCase {
  final ProductRepository productRepository;

  GetFeaturedProductsUseCase(this.productRepository);

  Future<ProductsResponse> call(int page) async {
    return await productRepository.getFeaturedProducts(page);
  }
}