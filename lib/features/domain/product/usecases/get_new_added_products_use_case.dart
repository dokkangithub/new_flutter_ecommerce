import '../entities/product.dart';
import '../repositories/product_repository.dart';

class GetNewAddedProductsUseCase {
  final ProductRepository productRepository;

  GetNewAddedProductsUseCase(this.productRepository);

  Future<ProductsResponse> call(int page) async {
    return await productRepository.getNewAddedProducts(page);
  }
}