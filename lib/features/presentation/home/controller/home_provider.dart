import 'package:flutter/material.dart';

import '../../../domain/product/entities/product.dart';
import '../../../domain/product/usecases/get_best_selling_products_use_case.dart';
import '../../../domain/product/usecases/get_featured_products_use_case.dart';
import '../../../domain/product/usecases/get_flash_deal_products_use_case.dart';
import '../../../domain/product/usecases/get_new_added_products_use_case.dart';
import '../../../domain/product/usecases/get_todays_deal_products_use_case.dart';
// Add new imports
import '../../../domain/product/usecases/get_category_products_use_case.dart';
import '../../../domain/product/usecases/get_brand_products_use_case.dart';
import '../../../domain/product/usecases/get_digital_products_use_case.dart';
import '../../../domain/product/usecases/get_filtered_products_use_case.dart';
import '../../../domain/product/usecases/get_product_details_use_case.dart';
import '../../../domain/product/usecases/get_related_products_use_case.dart';
import '../../../domain/product/usecases/get_shop_products_use_case.dart';
import '../../../domain/product/usecases/get_top_from_this_seller_products_use_case.dart';
import '../../../domain/product/usecases/get_variant_wise_info_use_case.dart';

enum HomeLoadingState { loading, loaded, error }

class HomeProvider extends ChangeNotifier {
  // Existing use cases
  final GetFeaturedProductsUseCase getFeaturedProductsUseCase;
  final GetBestSellingProductsUseCase getBestSellingProductsUseCase;
  final GetNewAddedProductsUseCase getNewAddedProductsUseCase;
  final GetTodaysDealProductsUseCase getTodaysDealProductsUseCase;
  final GetFlashDealProductsUseCase getFlashDealProductsUseCase;

  // New use cases
  final GetCategoryProductsUseCase getCategoryProductsUseCase;
  final GetBrandProductsUseCase getBrandProductsUseCase;
  final GetDigitalProductsUseCase getDigitalProductsUseCase;
  final GetFilteredProductsUseCase getFilteredProductsUseCase;
  final GetProductDetailsUseCase getProductDetailsUseCase;
  final GetRelatedProductsUseCase getRelatedProductsUseCase;
  final GetShopProductsUseCase getShopProductsUseCase;
  final GetTopFromThisSellerProductsUseCase getTopFromThisSellerProductsUseCase;
  final GetVariantWiseInfoUseCase getVariantWiseInfoUseCase;

  // Existing product data
  List<Product> featuredProducts = [];
  List<Product> bestSellingProducts = [];
  List<Product> newProducts = [];
  List<Product> todaysDealProducts = [];
  List<Product> flashDealProducts = [];

  // New product data
  List<Product> categoryProducts = [];
  List<Product> brandProducts = [];
  List<Product> digitalProducts = [];
  List<Product> filteredProducts = [];
  Product? selectedProduct;
  List<Product> relatedProducts = [];
  List<Product> shopProducts = [];
  List<Product> topFromThisSellerProducts = [];
  dynamic variantInfo;

  // Existing pagination metadata
  int featuredProductsPage = 1;
  int bestSellingProductsPage = 1;
  int newProductsPage = 1;
  bool hasMoreFeaturedProducts = true;
  bool hasMoreBestSellingProducts = true;
  bool hasMoreNewProducts = true;

  // New pagination metadata
  int categoryProductsPage = 1;
  int brandProductsPage = 1;
  int digitalProductsPage = 1;
  int filteredProductsPage = 1;
  int shopProductsPage = 1;
  bool hasMoreCategoryProducts = true;
  bool hasMoreBrandProducts = true;
  bool hasMoreDigitalProducts = true;
  bool hasMoreFilteredProducts = true;
  bool hasMoreShopProducts = true;

  // Existing loading states
  HomeLoadingState featuredProductsState = HomeLoadingState.loading;
  HomeLoadingState bestSellingProductsState = HomeLoadingState.loading;
  HomeLoadingState newProductsState = HomeLoadingState.loading;
  HomeLoadingState todaysDealProductsState = HomeLoadingState.loading;
  HomeLoadingState flashDealProductsState = HomeLoadingState.loading;

  // New loading states
  HomeLoadingState categoryProductsState = HomeLoadingState.loading;
  HomeLoadingState brandProductsState = HomeLoadingState.loading;
  HomeLoadingState digitalProductsState = HomeLoadingState.loading;
  HomeLoadingState filteredProductsState = HomeLoadingState.loading;
  HomeLoadingState productDetailsState = HomeLoadingState.loading;
  HomeLoadingState relatedProductsState = HomeLoadingState.loading;
  HomeLoadingState shopProductsState = HomeLoadingState.loading;
  HomeLoadingState topFromThisSellerProductsState = HomeLoadingState.loading;
  HomeLoadingState variantInfoState = HomeLoadingState.loading;

  // Existing error messages
  String featuredProductsError = '';
  String bestSellingProductsError = '';
  String newProductsError = '';
  String todaysDealProductsError = '';
  String flashDealProductsError = '';

  // New error messages
  String categoryProductsError = '';
  String brandProductsError = '';
  String digitalProductsError = '';
  String filteredProductsError = '';
  String productDetailsError = '';
  String relatedProductsError = '';
  String shopProductsError = '';
  String topFromThisSellerProductsError = '';
  String variantInfoError = '';

  HomeProvider({
    required this.getFeaturedProductsUseCase,
    required this.getBestSellingProductsUseCase,
    required this.getNewAddedProductsUseCase,
    required this.getTodaysDealProductsUseCase,
    required this.getFlashDealProductsUseCase,
    required this.getCategoryProductsUseCase,
    required this.getBrandProductsUseCase,
    required this.getDigitalProductsUseCase,
    required this.getFilteredProductsUseCase,
    required this.getProductDetailsUseCase,
    required this.getRelatedProductsUseCase,
    required this.getShopProductsUseCase,
    required this.getTopFromThisSellerProductsUseCase,
    required this.getVariantWiseInfoUseCase,
  });

  // Existing initialization method
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


  // New method for Category Products
  Future<void> fetchCategoryProducts(int categoryId, {bool refresh = false, String? name}) async {
    try {
      if (refresh) {
        categoryProductsPage = 1;
        hasMoreCategoryProducts = true;
        categoryProducts = [];
      }

      if (!hasMoreCategoryProducts) return;

      categoryProductsState = HomeLoadingState.loading;
      notifyListeners();

      final response = await getCategoryProductsUseCase(categoryId, categoryProductsPage, name: name);

      if (refresh) {
        categoryProducts = response.data;
      } else {
        categoryProducts.addAll(response.data);
      }

      hasMoreCategoryProducts = response.meta.currentPage < response.meta.lastPage;
      if (hasMoreCategoryProducts) {
        categoryProductsPage++;
      }

      categoryProductsState = HomeLoadingState.loaded;
    } catch (e) {
      categoryProductsState = HomeLoadingState.error;
      categoryProductsError = e.toString();
    } finally {
      notifyListeners();
    }
  }

  // New method for Brand Products
  Future<void> fetchBrandProducts(int brandId, {bool refresh = false, String? name}) async {
    try {
      if (refresh) {
        brandProductsPage = 1;
        hasMoreBrandProducts = true;
        brandProducts = [];
      }

      if (!hasMoreBrandProducts) return;

      brandProductsState = HomeLoadingState.loading;
      notifyListeners();

      final response = await getBrandProductsUseCase(brandId, brandProductsPage, name: name);

      if (refresh) {
        brandProducts = response.data;
      } else {
        brandProducts.addAll(response.data);
      }

      hasMoreBrandProducts = response.meta.currentPage < response.meta.lastPage;
      if (hasMoreBrandProducts) {
        brandProductsPage++;
      }

      brandProductsState = HomeLoadingState.loaded;
    } catch (e) {
      brandProductsState = HomeLoadingState.error;
      brandProductsError = e.toString();
    } finally {
      notifyListeners();
    }
  }

  // New method for Digital Products
  Future<void> fetchDigitalProducts({bool refresh = false}) async {
    try {
      if (refresh) {
        digitalProductsPage = 1;
        hasMoreDigitalProducts = true;
        digitalProducts = [];
      }

      if (!hasMoreDigitalProducts) return;

      digitalProductsState = HomeLoadingState.loading;
      notifyListeners();

      final response = await getDigitalProductsUseCase(digitalProductsPage);

      if (refresh) {
        digitalProducts = response.data;
      } else {
        digitalProducts.addAll(response.data);
      }

      hasMoreDigitalProducts = response.meta.currentPage < response.meta.lastPage;
      if (hasMoreDigitalProducts) {
        digitalProductsPage++;
      }

      digitalProductsState = HomeLoadingState.loaded;
    } catch (e) {
      digitalProductsState = HomeLoadingState.error;
      digitalProductsError = e.toString();
    } finally {
      notifyListeners();
    }
  }

  // New method for Filtered Products
  Future<void> fetchFilteredProducts({
    bool refresh = false,
    String? name,
    String? sortKey,
    String? brands,
    String? categories,
    double? min,
    double? max,
  }) async {
    try {
      if (refresh) {
        filteredProductsPage = 1;
        hasMoreFilteredProducts = true;
        filteredProducts = [];
      }

      if (!hasMoreFilteredProducts) return;

      filteredProductsState = HomeLoadingState.loading;
      notifyListeners();

      final response = await getFilteredProductsUseCase(
        filteredProductsPage,
        name: name,
        sortKey: sortKey,
        brands: brands,
        categories: categories,
        min: min,
        max: max,
      );

      if (refresh) {
        filteredProducts = response.data;
      } else {
        filteredProducts.addAll(response.data);
      }

      hasMoreFilteredProducts = response.meta.currentPage < response.meta.lastPage;
      if (hasMoreFilteredProducts) {
        filteredProductsPage++;
      }

      filteredProductsState = HomeLoadingState.loaded;
    } catch (e) {
      filteredProductsState = HomeLoadingState.error;
      filteredProductsError = e.toString();
    } finally {
      notifyListeners();
    }
  }

  // New method for Product Details
  Future<void> fetchProductDetails(int productId) async {
    try {
      productDetailsState = HomeLoadingState.loading;
      notifyListeners();

      final product = await getProductDetailsUseCase(productId);
      selectedProduct = product;

      productDetailsState = HomeLoadingState.loaded;
    } catch (e) {
      productDetailsState = HomeLoadingState.error;
      productDetailsError = e.toString();
    } finally {
      notifyListeners();
    }
  }

  // New method for Related Products
  Future<void> fetchRelatedProducts(int productId) async {
    try {
      relatedProductsState = HomeLoadingState.loading;
      notifyListeners();

      final response = await getRelatedProductsUseCase(productId);
      relatedProducts = response.data;

      relatedProductsState = HomeLoadingState.loaded;
    } catch (e) {
      relatedProductsState = HomeLoadingState.error;
      relatedProductsError = e.toString();
    } finally {
      notifyListeners();
    }
  }

  // New method for Shop Products
  Future<void> fetchShopProducts(int shopId, {bool refresh = false, String? name}) async {
    try {
      if (refresh) {
        shopProductsPage = 1;
        hasMoreShopProducts = true;
        shopProducts = [];
      }

      if (!hasMoreShopProducts) return;

      shopProductsState = HomeLoadingState.loading;
      notifyListeners();

      final response = await getShopProductsUseCase(shopId, shopProductsPage, name: name);

      if (refresh) {
        shopProducts = response.data;
      } else {
        shopProducts.addAll(response.data);
      }

      hasMoreShopProducts = response.meta.currentPage < response.meta.lastPage;
      if (hasMoreShopProducts) {
        shopProductsPage++;
      }

      shopProductsState = HomeLoadingState.loaded;
    } catch (e) {
      shopProductsState = HomeLoadingState.error;
      shopProductsError = e.toString();
    } finally {
      notifyListeners();
    }
  }

  // New method for Top From This Seller Products
  Future<void> fetchTopFromThisSellerProducts(int sellerId) async {
    try {
      topFromThisSellerProductsState = HomeLoadingState.loading;
      notifyListeners();

      final response = await getTopFromThisSellerProductsUseCase(sellerId);
      topFromThisSellerProducts = response.data;

      topFromThisSellerProductsState = HomeLoadingState.loaded;
    } catch (e) {
      topFromThisSellerProductsState = HomeLoadingState.error;
      topFromThisSellerProductsError = e.toString();
    } finally {
      notifyListeners();
    }
  }

  // New method for Variant Wise Info
  Future<void> fetchVariantWiseInfo(int productId, {String? color, String? variants}) async {
    try {
      variantInfoState = HomeLoadingState.loading;
      notifyListeners();

      variantInfo = await getVariantWiseInfoUseCase(productId, color: color, variants: variants);

      variantInfoState = HomeLoadingState.loaded;
    } catch (e) {
      variantInfoState = HomeLoadingState.error;
      variantInfoError = e.toString();
    } finally {
      notifyListeners();
    }
  }

  // Update the refresh method to include all refreshable sections
  Future<void> refreshHomeData() async {
    await Future.wait([
      fetchFeaturedProducts(refresh: true),
      fetchBestSellingProducts(refresh: true),
      fetchNewProducts(refresh: true),
      fetchTodaysDealProducts(),
      fetchDigitalProducts(refresh: true),
      // Note: Category, Brand, Shop, Filtered products need specific IDs so they're not included here
    ]);
  }

  // Updated helper to check if any section is loading
  bool get isAnyLoading {
    return
      featuredProductsState == HomeLoadingState.loading ||
          bestSellingProductsState == HomeLoadingState.loading ||
          newProductsState == HomeLoadingState.loading ||
          todaysDealProductsState == HomeLoadingState.loading ||
          flashDealProductsState == HomeLoadingState.loading ||
          categoryProductsState == HomeLoadingState.loading ||
          brandProductsState == HomeLoadingState.loading ||
          digitalProductsState == HomeLoadingState.loading ||
          filteredProductsState == HomeLoadingState.loading ||
          productDetailsState == HomeLoadingState.loading ||
          relatedProductsState == HomeLoadingState.loading ||
          shopProductsState == HomeLoadingState.loading ||
          topFromThisSellerProductsState == HomeLoadingState.loading ||
          variantInfoState == HomeLoadingState.loading;
  }

  // Updated helper to check if main sections are loaded
  bool get isAllLoaded {
    return
      featuredProductsState == HomeLoadingState.loaded &&
          bestSellingProductsState == HomeLoadingState.loaded &&
          newProductsState == HomeLoadingState.loaded &&
          todaysDealProductsState == HomeLoadingState.loaded;
  }
}