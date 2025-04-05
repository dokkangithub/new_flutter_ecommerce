import 'package:flutter/material.dart';
import '../../../../features/domain/category/usecases/get_categories_use_case.dart';
import '../../../../features/domain/category/usecases/get_featured_categories_use_case.dart';
import '../../../../features/domain/category/usecases/get_top_categories_use_case.dart';
import '../../../../features/domain/category/usecases/get_filter_page_categories_use_case.dart';
import '../../../data/category/models/category_model.dart';

enum CategoryLoadingState { initial, loading, loaded, error }

class CategoryProvider extends ChangeNotifier {
  final GetCategoriesUseCase getCategoriesUseCase;
  final GetFeaturedCategoriesUseCase getFeaturedCategoriesUseCase;
  final GetTopCategoriesUseCase getTopCategoriesUseCase;
  final GetFilterPageCategoriesUseCase getFilterPageCategoriesUseCase;

  CategoryLoadingState categoriesState = CategoryLoadingState.initial;
  CategoryLoadingState featuredCategoriesState = CategoryLoadingState.initial;
  CategoryLoadingState topCategoriesState = CategoryLoadingState.initial;
  CategoryLoadingState filterPageCategoriesState = CategoryLoadingState.initial;

  CategoryResponseModel? categoriesResponse;
  CategoryResponseModel? featuredCategoriesResponse;
  CategoryResponseModel? topCategoriesResponse;
  CategoryResponseModel? filterPageCategoriesResponse;

  String? errorMessage;

  CategoryProvider({
    required this.getCategoriesUseCase,
    required this.getFeaturedCategoriesUseCase,
    required this.getTopCategoriesUseCase,
    required this.getFilterPageCategoriesUseCase,
  });

  Future<void> getCategories({String? parentId}) async {
    categoriesState = CategoryLoadingState.loading;
    notifyListeners();

    try {
      categoriesResponse = await getCategoriesUseCase(parentId: parentId);
      categoriesState = CategoryLoadingState.loaded;
    } catch (e) {
      categoriesState = CategoryLoadingState.error;
      errorMessage = e.toString();
    }
    notifyListeners();
  }

  Future<void> getFeaturedCategories() async {
    featuredCategoriesState = CategoryLoadingState.loading;
    notifyListeners();

    try {
      featuredCategoriesResponse = await getFeaturedCategoriesUseCase();
      featuredCategoriesState = CategoryLoadingState.loaded;
    } catch (e) {
      featuredCategoriesState = CategoryLoadingState.error;
      errorMessage = e.toString();
    }
    notifyListeners();
  }

  Future<void> getTopCategories() async {
    topCategoriesState = CategoryLoadingState.loading;
    notifyListeners();

    try {
      topCategoriesResponse = await getTopCategoriesUseCase();
      topCategoriesState = CategoryLoadingState.loaded;
    } catch (e) {
      topCategoriesState = CategoryLoadingState.error;
      errorMessage = e.toString();
    }
    notifyListeners();
  }

  Future<void> getFilterPageCategories() async {
    filterPageCategoriesState = CategoryLoadingState.loading;
    notifyListeners();

    try {
      filterPageCategoriesResponse = await getFilterPageCategoriesUseCase();
      filterPageCategoriesState = CategoryLoadingState.loaded;
    } catch (e) {
      filterPageCategoriesState = CategoryLoadingState.error;
      errorMessage = e.toString();
    }
    notifyListeners();
  }
}