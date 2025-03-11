import '../entities/product.dart';
import '../repositories/product_repository.dart';

class GetFlashDealProductsUseCase {
  final ProductRepository productRepository;

  GetFlashDealProductsUseCase(this.productRepository);

  Future<ProductsResponse> call(int id) async {
    return await productRepository.getFlashDealProducts(id);
  }
}
