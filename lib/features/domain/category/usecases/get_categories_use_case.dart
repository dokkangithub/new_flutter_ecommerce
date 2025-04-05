import '../../../data/category/models/category_model.dart';
import '../repositories/category_repository.dart';

class GetCategoriesUseCase {
  final CategoryRepository categoryRepository;

  GetCategoriesUseCase(this.categoryRepository);

  Future<CategoryResponseModel> call({String? parentId}) async {
    return await categoryRepository.getCategories(parentId: parentId);
  }
}