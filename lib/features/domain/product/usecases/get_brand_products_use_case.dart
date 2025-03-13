import '../entities/product.dart';
import '../repositories/product_repository.dart';

class GetBrandProductsUseCase {
  final ProductRepository productRepository;

  GetBrandProductsUseCase(this.productRepository);

  Future<ProductsResponse> call(int id, int page, {String? name}) async {
    return await productRepository.getBrandProducts(id, page, name: name);
  }
}