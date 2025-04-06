import 'package:flutter/material.dart';
import 'package:laravel_ecommerce/features/domain/product/usecases/get_all_products_use_case.dart';
import '../../../../core/utils/enums/loading_state.dart';
import '../../../domain/product/entities/product.dart';
import '../../../domain/product/usecases/get_best_selling_products_use_case.dart';
import '../../../domain/product/usecases/get_featured_products_use_case.dart';
import '../../../domain/product/usecases/get_flash_deal_products_use_case.dart';
import '../../../domain/product/usecases/get_new_added_products_use_case.dart';
import '../../../domain/product/usecases/get_todays_deal_products_use_case.dart';
import '../../../domain/product/usecases/get_category_products_use_case.dart';
import '../../../domain/product/usecases/get_brand_products_use_case.dart';
import '../../../domain/product/usecases/get_digital_products_use_case.dart';
import '../../../domain/product/usecases/get_filtered_products_use_case.dart';
import '../../../domain/product/usecases/get_related_products_use_case.dart';
import '../../../domain/product/usecases/get_shop_products_use_case.dart';
import '../../../domain/product/usecases/get_top_from_this_seller_products_use_case.dart';
import '../../../domain/product/usecases/get_variant_wise_info_use_case.dart';


class HomeProvider extends ChangeNotifier {
  final GetAllProductsUseCase getAllProductsUseCase;
  final GetFeaturedProductsUseCase getFeaturedProductsUseCase;
  final GetBestSellingProductsUseCase getBestSellingProductsUseCase;
  final GetNewAddedProductsUseCase getNewAddedProductsUseCase;
  final GetTodaysDealProductsUseCase getTodaysDealProductsUseCase;
  final GetFlashDealProductsUseCase getFlashDealProductsUseCase;
  final GetCategoryProductsUseCase getCategoryProductsUseCase;
  final GetBrandProductsUseCase getBrandProductsUseCase;
  final GetDigitalProductsUseCase getDigitalProductsUseCase;
  final GetFilteredProductsUseCase getFilteredProductsUseCase;
  final GetRelatedProductsUseCase getRelatedProductsUseCase;
  final GetShopProductsUseCase getShopProductsUseCase;
  final GetTopFromThisSellerProductsUseCase getTopFromThisSellerProductsUseCase;
  final GetVariantWiseInfoUseCase getVariantWiseInfoUseCase;

  List<Product> allProducts = [];
  List<Product> featuredProducts = [];
  List<Product> bestSellingProducts = [];
  List<Product> newProducts = [];
  List<Product> todaysDealProducts = [];
  List<Product> flashDealProducts = [];
  List<Product> categoryProducts = [];
  List<Product> brandProducts = [];
  List<Product> digitalProducts = [];
  List<Product> filteredProducts = [];
  Product? selectedProduct;
  List<Product> relatedProducts = [];
  List<Product> shopProducts = [];
  List<Product> topFromThisSellerProducts = [];
  dynamic variantInfo;

  int allProductsPage = 1;
  int featuredProductsPage = 1;
  int bestSellingProductsPage = 1;
  int newProductsPage = 1;
  bool hasMoreFeaturedProducts = true;
  bool hasMoreBestSellingProducts = true;
  bool hasMoreAllProducts = true;
  bool hasMoreNewProducts = true;
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

  LoadingState allProductsState = LoadingState.loading;
  LoadingState featuredProductsState = LoadingState.loading;
  LoadingState bestSellingProductsState = LoadingState.loading;
  LoadingState newProductsState = LoadingState.loading;
  LoadingState todaysDealProductsState = LoadingState.loading;
  LoadingState flashDealProductsState = LoadingState.loading;
  LoadingState categoryProductsState = LoadingState.loading;
  LoadingState brandProductsState = LoadingState.loading;
  LoadingState digitalProductsState = LoadingState.loading;
  LoadingState filteredProductsState = LoadingState.loading;
  LoadingState relatedProductsState = LoadingState.loading;
  LoadingState shopProductsState = LoadingState.loading;
  LoadingState topFromThisSellerProductsState = LoadingState.loading;
  LoadingState variantInfoState = LoadingState.loading;

  String allProductsError = '';
  String featuredProductsError = '';
  String bestSellingProductsError = '';
  String newProductsError = '';
  String todaysDealProductsError = '';
  String flashDealProductsError = '';
  String categoryProductsError = '';
  String brandProductsError = '';
  String digitalProductsError = '';
  String filteredProductsError = '';
  String relatedProductsError = '';
  String shopProductsError = '';
  String topFromThisSellerProductsError = '';
  String variantInfoError = '';

  HomeProvider({
    required this.getAllProductsUseCase,
    required this.getFeaturedProductsUseCase,
    required this.getBestSellingProductsUseCase,
    required this.getNewAddedProductsUseCase,
    required this.getTodaysDealProductsUseCase,
    required this.getFlashDealProductsUseCase,
    required this.getCategoryProductsUseCase,
    required this.getBrandProductsUseCase,
    required this.getDigitalProductsUseCase,
    required this.getFilteredProductsUseCase,
    required this.getRelatedProductsUseCase,
    required this.getShopProductsUseCase,
    required this.getTopFromThisSellerProductsUseCase,
    required this.getVariantWiseInfoUseCase,
  });

  // Existing initialization method
  Future<void> initHomeData() async {
    await Future.wait([
      fetchAllProducts(),
      fetchFeaturedProducts(),
      fetchBestSellingProducts(),
      fetchNewProducts(),
      fetchTodaysDealProducts(),
    ]);
  }

  void setInitialProducts(List<Product> products) {
    filteredProducts = products;
    filteredProductsState = LoadingState.loaded;
    hasMoreFilteredProducts = false;
    notifyListeners();
  }

  // Featured Products methods
  Future<void> fetchAllProducts({bool refresh = false}) async {
    try {
      if (refresh) {
        allProductsPage = 1;
        hasMoreAllProducts = true;
        allProducts = [];
      }

      if (!hasMoreAllProducts) return;

      allProductsState = LoadingState.loading;
      notifyListeners();

      final response = await getAllProductsUseCase(allProductsPage);

      if (refresh) {
        allProducts = response.data;
      } else {
        allProducts.addAll(response.data);
      }

      hasMoreAllProducts =
          response.meta.currentPage < response.meta.lastPage;
      if (hasMoreAllProducts) {
        allProductsPage++;
      }

      allProductsState = LoadingState.loaded;
    } catch (e) {
      allProductsState = LoadingState.error;
      allProductsError = e.toString();
    } finally {
      notifyListeners();
    }
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

      featuredProductsState = LoadingState.loading;
      notifyListeners();

      final response = await getFeaturedProductsUseCase(featuredProductsPage);

      if (refresh) {
        featuredProducts = response.data;
      } else {
        featuredProducts.addAll(response.data);
      }

      hasMoreFeaturedProducts =
          response.meta.currentPage < response.meta.lastPage;
      if (hasMoreFeaturedProducts) {
        featuredProductsPage++;
      }

      featuredProductsState = LoadingState.loaded;
    } catch (e) {
      featuredProductsState = LoadingState.error;
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

      bestSellingProductsState = LoadingState.loading;
      notifyListeners();

      final response = await getBestSellingProductsUseCase(
        bestSellingProductsPage,
      );

      if (refresh) {
        bestSellingProducts = response.data;
      } else {
        bestSellingProducts.addAll(response.data);
      }

      hasMoreBestSellingProducts =
          response.meta.currentPage < response.meta.lastPage;
      if (hasMoreBestSellingProducts) {
        bestSellingProductsPage++;
      }

      bestSellingProductsState = LoadingState.loaded;
    } catch (e) {
      bestSellingProductsState = LoadingState.error;
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

      newProductsState = LoadingState.loading;
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

      newProductsState = LoadingState.loaded;
    } catch (e) {
      newProductsState = LoadingState.error;
      newProductsError = e.toString();
    } finally {
      notifyListeners();
    }
  }

  // Today's Deal Products methods
  Future<void> fetchTodaysDealProducts() async {
    try {
      todaysDealProductsState = LoadingState.loading;
      notifyListeners();

      final response = await getTodaysDealProductsUseCase();
      todaysDealProducts = response.data;

      todaysDealProductsState = LoadingState.loaded;
    } catch (e) {
      todaysDealProductsState = LoadingState.error;
      todaysDealProductsError = e.toString();
    } finally {
      notifyListeners();
    }
  }

  // Flash Deal Products methods
  Future<void> fetchFlashDealProducts(int dealId) async {
    try {
      flashDealProductsState = LoadingState.loading;
      notifyListeners();

      final response = await getFlashDealProductsUseCase(dealId);
      flashDealProducts = response.data;

      flashDealProductsState = LoadingState.loaded;
    } catch (e) {
      flashDealProductsState = LoadingState.error;
      flashDealProductsError = e.toString();
    } finally {
      notifyListeners();
    }
  }

  // New method for Category Products
  Future<void> fetchCategoryProducts(
    int categoryId, {
    bool refresh = false,
    String? name,
  }) async {
    try {
      if (refresh) {
        categoryProductsPage = 1;
        hasMoreCategoryProducts = true;
        categoryProducts = [];
      }

      if (!hasMoreCategoryProducts) return;

      categoryProductsState = LoadingState.loading;
      notifyListeners();

      final response = await getCategoryProductsUseCase(
        categoryId,
        categoryProductsPage,
        name: name,
      );

      if (refresh) {
        categoryProducts = response.data;
      } else {
        categoryProducts.addAll(response.data);
      }

      hasMoreCategoryProducts =
          response.meta.currentPage < response.meta.lastPage;
      if (hasMoreCategoryProducts) {
        categoryProductsPage++;
      }

      categoryProductsState = LoadingState.loaded;
    } catch (e) {
      categoryProductsState = LoadingState.error;
      categoryProductsError = e.toString();
    } finally {
      notifyListeners();
    }
  }

  // New method for Brand Products
  Future<void> fetchBrandProducts(
    int brandId, {
    bool refresh = false,
    String? name,
  }) async {
    try {
      if (refresh) {
        brandProductsPage = 1;
        hasMoreBrandProducts = true;
        brandProducts = [];
      }

      if (!hasMoreBrandProducts) return;

      brandProductsState = LoadingState.loading;
      notifyListeners();

      final response = await getBrandProductsUseCase(
        brandId,
        brandProductsPage,
        name: name,
      );

      if (refresh) {
        brandProducts = response.data;
      } else {
        brandProducts.addAll(response.data);
      }

      hasMoreBrandProducts = response.meta.currentPage < response.meta.lastPage;
      if (hasMoreBrandProducts) {
        brandProductsPage++;
      }

      brandProductsState = LoadingState.loaded;
    } catch (e) {
      brandProductsState = LoadingState.error;
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

      digitalProductsState = LoadingState.loading;
      notifyListeners();

      final response = await getDigitalProductsUseCase(digitalProductsPage);

      if (refresh) {
        digitalProducts = response.data;
      } else {
        digitalProducts.addAll(response.data);
      }

      hasMoreDigitalProducts =
          response.meta.currentPage < response.meta.lastPage;
      if (hasMoreDigitalProducts) {
        digitalProductsPage++;
      }

      digitalProductsState = LoadingState.loaded;
    } catch (e) {
      digitalProductsState = LoadingState.error;
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

      filteredProductsState = LoadingState.loading;
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

      hasMoreFilteredProducts =
          response.meta.currentPage < response.meta.lastPage;
      if (hasMoreFilteredProducts) {
        filteredProductsPage++;
      }

      filteredProductsState = LoadingState.loaded;
    } catch (e) {
      filteredProductsState = LoadingState.error;
      filteredProductsError = e.toString();
    } finally {
      notifyListeners();
    }
  }


  // New method for Related Products
  Future<void> fetchRelatedProducts(int productId) async {
    try {
      relatedProductsState = LoadingState.loading;
      notifyListeners();

      final response = await getRelatedProductsUseCase(productId);
      relatedProducts = response.data;

      relatedProductsState = LoadingState.loaded;
    } catch (e) {
      relatedProductsState = LoadingState.error;
      relatedProductsError = e.toString();
    } finally {
      notifyListeners();
    }
  }

  // New method for Shop Products
  Future<void> fetchShopProducts(
    int shopId, {
    bool refresh = false,
    String? name,
  }) async {
    try {
      if (refresh) {
        shopProductsPage = 1;
        hasMoreShopProducts = true;
        shopProducts = [];
      }

      if (!hasMoreShopProducts) return;

      shopProductsState = LoadingState.loading;
      notifyListeners();

      final response = await getShopProductsUseCase(
        shopId,
        shopProductsPage,
        name: name,
      );

      if (refresh) {
        shopProducts = response.data;
      } else {
        shopProducts.addAll(response.data);
      }

      hasMoreShopProducts = response.meta.currentPage < response.meta.lastPage;
      if (hasMoreShopProducts) {
        shopProductsPage++;
      }

      shopProductsState = LoadingState.loaded;
    } catch (e) {
      shopProductsState = LoadingState.error;
      shopProductsError = e.toString();
    } finally {
      notifyListeners();
    }
  }

  // New method for Top From This Seller Products
  Future<void> fetchTopFromThisSellerProducts(int sellerId) async {
    try {
      topFromThisSellerProductsState = LoadingState.loading;
      notifyListeners();

      final response = await getTopFromThisSellerProductsUseCase(sellerId);
      topFromThisSellerProducts = response.data;

      topFromThisSellerProductsState = LoadingState.loaded;
    } catch (e) {
      topFromThisSellerProductsState = LoadingState.error;
      topFromThisSellerProductsError = e.toString();
    } finally {
      notifyListeners();
    }
  }

  // New method for Variant Wise Info
  Future<void> fetchVariantWiseInfo(
    int productId, {
    String? color,
    String? variants,
  }) async {
    try {
      variantInfoState = LoadingState.loading;
      notifyListeners();

      variantInfo = await getVariantWiseInfoUseCase(
        productId,
        color: color,
        variants: variants,
      );

      variantInfoState = LoadingState.loaded;
    } catch (e) {
      variantInfoState = LoadingState.error;
      variantInfoError = e.toString();
    } finally {
      notifyListeners();
    }
  }

  // Update the refresh method to include all refreshable sections
  Future<void> refreshHomeData() async {
    await Future.wait([
      fetchAllProducts(refresh: true),
      fetchFeaturedProducts(refresh: true),
      fetchBestSellingProducts(refresh: true),
      fetchNewProducts(refresh: true),
      fetchTodaysDealProducts(),
      fetchDigitalProducts(refresh: true),
    ]);
  }

  // Updated helper to check if any section is loading
  bool get isAnyLoading {
    return allProductsState == LoadingState.loading ||
        featuredProductsState == LoadingState.loading ||
        bestSellingProductsState == LoadingState.loading ||
        newProductsState == LoadingState.loading ||
        todaysDealProductsState == LoadingState.loading ||
        flashDealProductsState == LoadingState.loading ||
        categoryProductsState == LoadingState.loading ||
        brandProductsState == LoadingState.loading ||
        digitalProductsState == LoadingState.loading ||
        filteredProductsState == LoadingState.loading ||
        relatedProductsState == LoadingState.loading ||
        shopProductsState == LoadingState.loading ||
        topFromThisSellerProductsState == LoadingState.loading ||
        variantInfoState == LoadingState.loading;
  }

  // Updated helper to check if main sections are loaded
  bool get isAllLoaded {
    return allProductsState == LoadingState.loaded &&
        featuredProductsState == LoadingState.loaded &&
        bestSellingProductsState == LoadingState.loaded &&
        newProductsState == LoadingState.loaded &&
        todaysDealProductsState == LoadingState.loaded;
  }
}
