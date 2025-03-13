import '../../../data/category/models/category_response_model.dart';
import '../repositories/category_repository.dart';

class GetTopCategoriesUseCase {
  final CategoryRepository categoryRepository;

  GetTopCategoriesUseCase(this.categoryRepository);

  Future<CategoryResponseModel> call() async {
    return await categoryRepository.getTopCategories();
  }
}
