import '../entities/product.dart';
import '../repositories/product_repository.dart';

class GetRelatedProductsUseCase {
  final ProductRepository productRepository;

  GetRelatedProductsUseCase(this.productRepository);

  Future<ProductsResponse> call(int id) async {
    return await productRepository.getRelatedProducts(id);
  }
}
