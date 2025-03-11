import '../entities/product.dart';
import '../repositories/product_repository.dart';

class GetProductDetailsUseCase {
  final ProductRepository productRepository;

  GetProductDetailsUseCase(this.productRepository);

  Future<Product> call(int id) async {
    return await productRepository.getProductDetails(id);
  }
}