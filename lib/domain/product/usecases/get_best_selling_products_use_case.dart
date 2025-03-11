import '../entities/product.dart';
import '../repositories/product_repository.dart';

class GetBestSellingProductsUseCase {
  final ProductRepository productRepository;

  GetBestSellingProductsUseCase(this.productRepository);

  Future<ProductsResponse> call(int page) async {
    return await productRepository.getBestSellingProducts(page);
  }
}