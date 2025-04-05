import 'package:flutter/material.dart';

import '../../../domain/product/entities/product.dart';
import '../../../domain/product/usecases/get_best_selling_products_use_case.dart';
import '../../../domain/product/usecases/get_featured_products_use_case.dart';
import '../../../domain/product/usecases/get_flash_deal_products_use_case.dart';
import '../../../domain/product/usecases/get_new_added_products_use_case.dart';
import '../../../domain/product/usecases/get_todays_deal_products_use_case.dart';

enum HomeLoadingState { loading, loaded, error }

class HomeProvider extends ChangeNotifier {
  // Use cases
  final GetFeaturedProductsUseCase getFeaturedProductsUseCase;
  final GetBestSellingProductsUseCase getBestSellingProductsUseCase;
  final GetNewAddedProductsUseCase getNewAddedProductsUseCase;
  final GetTodaysDealProductsUseCase getTodaysDealProductsUseCase;
  final GetFlashDealProductsUseCase getFlashDealProductsUseCase;

  // Products data
  List<Product> featuredProducts = [];
  List<Product> bestSellingProducts = [];
  List<Product> newProducts = [];
  List<Product> todaysDealProducts = [];
  List<Product> flashDealProducts = [];

  // Pagination metadata
  int featuredProductsPage = 1;
  int bestSellingProductsPage = 1;
  int newProductsPage = 1;
  bool hasMoreFeaturedProducts = true;
  bool hasMoreBestSellingProducts = true;
  bool hasMoreNewProducts = true;

  // Loading states
  HomeLoadingState featuredProductsState = HomeLoadingState.loading;
  HomeLoadingState bestSellingProductsState = HomeLoadingState.loading;
  HomeLoadingState newProductsState = HomeLoadingState.loading;
  HomeLoadingState todaysDealProductsState = HomeLoadingState.loading;
  HomeLoadingState flashDealProductsState = HomeLoadingState.loading;

  // Error messages
  String featuredProductsError = '';
  String bestSellingProductsError = '';
  String newProductsError = '';
  String todaysDealProductsError = '';
  String flashDealProductsError = '';

  HomeProvider({
    required this.getFeaturedProductsUseCase,
    required this.getBestSellingProductsUseCase,
    required this.getNewAddedProductsUseCase,
    required this.getTodaysDealProductsUseCase,
    required this.getFlashDealProductsUseCase,
  });

  // Initialize home data
  Future<void> initHomeData() async {
    await Future.wait([
      fetchFeaturedProducts(),
      fetchBestSellingProducts(),
      fetchNewProducts(),
      fetchTodaysDealProducts(),
    ]);
  }

  // Featured Products methods
  Future<void> fetchFeaturedProducts({bool refresh = false}) async {
    try {
      if (refresh) {
        featuredProductsPage = 1;
        hasMoreFeaturedProducts = true;
        featuredProducts = [];
      }

      if (!hasMoreFeaturedProducts) return;

      featuredProductsState = HomeLoadingState.loading;
      notifyListeners();

      final response = await getFeaturedProductsUseCase(featuredProductsPage);

      if (refresh) {
        featuredProducts = response.data;
      } else {
        featuredProducts.addAll(response.data);
      }

      hasMoreFeaturedProducts = response.meta.currentPage < response.meta.lastPage;
      if (hasMoreFeaturedProducts) {
        featuredProductsPage++;
      }

      featuredProductsState = HomeLoadingState.loaded;
    } catch (e) {
      featuredProductsState = HomeLoadingState.error;
      featuredProductsError = e.toString();
    } finally {
      notifyListeners();
    }
  }

  // Best Selling Products methods
  Future<void> fetchBestSellingProducts({bool refresh = false}) async {
    try {
      if (refresh) {
        bestSellingProductsPage = 1;
        hasMoreBestSellingProducts = true;
        bestSellingProducts = [];
      }

      if (!hasMoreBestSellingProducts) return;

      bestSellingProductsState = HomeLoadingState.loading;
      notifyListeners();

      final response = await getBestSellingProductsUseCase(bestSellingProductsPage);

      if (refresh) {
        bestSellingProducts = response.data;
      } else {
        bestSellingProducts.addAll(response.data);
      }

      hasMoreBestSellingProducts = response.meta.currentPage < response.meta.lastPage;
      if (hasMoreBestSellingProducts) {
        bestSellingProductsPage++;
      }

      bestSellingProductsState = HomeLoadingState.loaded;
    } catch (e) {
      bestSellingProductsState = HomeLoadingState.error;
      bestSellingProductsError = e.toString();
    } finally {
      notifyListeners();
    }
  }

  // New Products methods
  Future<void> fetchNewProducts({bool refresh = false}) async {
    try {
      if (refresh) {
        newProductsPage = 1;
        hasMoreNewProducts = true;
        newProducts = [];
      }

      if (!hasMoreNewProducts) return;

      newProductsState = HomeLoadingState.loading;
      notifyListeners();

      final response = await getNewAddedProductsUseCase(newProductsPage);

      if (refresh) {
        newProducts = response.data;
      } else {
        newProducts.addAll(response.data);
      }

      hasMoreNewProducts = response.meta.currentPage < response.meta.lastPage;
      if (hasMoreNewProducts) {
        newProductsPage++;
      }

      newProductsState = HomeLoadingState.loaded;
    } catch (e) {
      newProductsState = HomeLoadingState.error;
      newProductsError = e.toString();
    } finally {
      notifyListeners();
    }
  }

  // Today's Deal Products methods
  Future<void> fetchTodaysDealProducts() async {
    try {
      todaysDealProductsState = HomeLoadingState.loading;
      notifyListeners();

      final response = await getTodaysDealProductsUseCase();
      todaysDealProducts = response.data;

      todaysDealProductsState = HomeLoadingState.loaded;
    } catch (e) {
      todaysDealProductsState = HomeLoadingState.error;
      todaysDealProductsError = e.toString();
    } finally {
      notifyListeners();
    }
  }

  // Flash Deal Products methods
  Future<void> fetchFlashDealProducts(int dealId) async {
    try {
      flashDealProductsState = HomeLoadingState.loading;
      notifyListeners();

      final response = await getFlashDealProductsUseCase(dealId);
      flashDealProducts = response.data;

      flashDealProductsState = HomeLoadingState.loaded;
    } catch (e) {
      flashDealProductsState = HomeLoadingState.error;
      flashDealProductsError = e.toString();
    } finally {
      notifyListeners();
    }
  }

  // Refresh all home data
  Future<void> refreshHomeData() async {
    await Future.wait([
      fetchFeaturedProducts(refresh: true),
      fetchBestSellingProducts(refresh: true),
      fetchNewProducts(refresh: true),
      fetchTodaysDealProducts(),
    ]);
  }

  // Helper to check if any section is loading
  bool get isAnyLoading {
    return
      featuredProductsState == HomeLoadingState.loading ||
          bestSellingProductsState == HomeLoadingState.loading ||
          newProductsState == HomeLoadingState.loading ||
          todaysDealProductsState == HomeLoadingState.loading ||
          flashDealProductsState == HomeLoadingState.loading;
  }

  // Helper to check if all sections are loaded
  bool get isAllLoaded {
    return
      featuredProductsState == HomeLoadingState.loaded &&
          bestSellingProductsState == HomeLoadingState.loaded &&
          newProductsState == HomeLoadingState.loaded &&
          todaysDealProductsState == HomeLoadingState.loaded;
  }
}