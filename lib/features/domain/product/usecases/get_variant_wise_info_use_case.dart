import '../repositories/product_repository.dart';

class GetVariantWiseInfoUseCase {
  final ProductRepository productRepository;

  GetVariantWiseInfoUseCase(this.productRepository);

  Future<dynamic> call(int id, {String? color, String? variants}) async {
    return await productRepository.getVariantWiseInfo(id, color: color, variants: variants);
  }
}