import '../entities/product.dart';
import '../repositories/product_repository.dart';

class GetShopProductsUseCase {
  final ProductRepository productRepository;

  GetShopProductsUseCase(this.productRepository);

  Future<ProductsResponse> call(int id, int page, {String? name}) async {
    return await productRepository.getShopProducts(id, page, name: name);
  }
}