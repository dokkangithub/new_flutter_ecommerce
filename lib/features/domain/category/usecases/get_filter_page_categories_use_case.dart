import '../../../data/category/models/category_model.dart';
import '../repositories/category_repository.dart';

class GetFilterPageCategoriesUseCase {
  final CategoryRepository categoryRepository;

  GetFilterPageCategoriesUseCase(this.categoryRepository);

  Future<CategoryResponseModel> call() async {
    return await categoryRepository.getFilterPageCategories();
  }
}