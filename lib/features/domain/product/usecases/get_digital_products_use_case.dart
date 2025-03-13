import '../entities/product.dart';
import '../repositories/product_repository.dart';

class GetDigitalProductsUseCase {
  final ProductRepository productRepository;

  GetDigitalProductsUseCase(this.productRepository);

  Future<ProductsResponse> call(int page) async {
    return await productRepository.getDigitalProducts(page);
  }
}