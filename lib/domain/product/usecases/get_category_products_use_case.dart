import '../entities/product.dart';
import '../repositories/product_repository.dart';

class GetCategoryProductsUseCase {
  final ProductRepository productRepository;

  GetCategoryProductsUseCase(this.productRepository);

  Future<ProductsResponse> call(int id, int page, {String? name}) async {
    return await productRepository.getCategoryProducts(id, page, name: name);
  }
}