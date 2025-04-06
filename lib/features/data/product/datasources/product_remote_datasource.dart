import '../../../../core/api/api_provider.dart';
import '../../../../core/utils/constants/app_endpoints.dart';
import '../models/product_model.dart';
import '../models/product_response_model.dart';

abstract class ProductRemoteDataSource {

  Future<ProductResponseModel> getAllProducts(int page, {String? name});

  Future<ProductResponseModel> getFeaturedProducts(int page);

  Future<ProductResponseModel> getBestSellingProducts(int page);

  Future<ProductResponseModel> getNewAddedProducts(int page);

  Future<ProductResponseModel> getTodaysDealProducts();

  Future<ProductResponseModel> getFlashDealProducts(int id);

  Future<ProductResponseModel> getCategoryProducts(
    int id,
    int page, {
    String? name,
  });

  Future<ProductResponseModel> getShopProducts(
    int id,
    int page, {
    String? name,
  });

  Future<ProductResponseModel> getBrandProducts(
    int id,
    int page, {
    String? name,
  });

  Future<ProductResponseModel> getFilteredProducts(
    int page, {
    String? name,
    String? sortKey,
    String? brands,
    String? categories,
    double? min,
    double? max,
  });

  Future<ProductResponseModel> getDigitalProducts(int page);

  Future<ProductModel> getDigitalProductDetails(int id);

  Future<ProductResponseModel> getRelatedProducts(int id);

  Future<ProductResponseModel> getTopFromThisSellerProducts(int id);

  Future<dynamic> getVariantWiseInfo(int id, {String? color, String? variants});
}

class ProductRemoteDataSourceImpl implements ProductRemoteDataSource {
  final ApiProvider apiProvider;

  ProductRemoteDataSourceImpl(this.apiProvider);

  @override
  Future<ProductResponseModel> getAllProducts(int page, {String? name}) async {
    String url = '${LaravelApiEndPoint.allProducts}?page=$page';
    if (name != null && name.isNotEmpty) {
      url += '&name=$name';
    }
    final response = await apiProvider.get(url);
    return ProductResponseModel.fromJson(response.data);
  }

  @override
  Future<ProductResponseModel> getFeaturedProducts(int page) async {
    final response = await apiProvider.get(
      '${LaravelApiEndPoint.featuredProducts}?page=$page',
    );
    return ProductResponseModel.fromJson(response.data);
  }

  @override
  Future<ProductResponseModel> getBestSellingProducts(int page) async {
    final response = await apiProvider.get(
      '${LaravelApiEndPoint.bestSellerProducts}?page=$page',
    );
    return ProductResponseModel.fromJson(response.data);
  }

  @override
  Future<ProductResponseModel> getNewAddedProducts(int page) async {
    final response = await apiProvider.get(
      '${LaravelApiEndPoint.newAddedProducts}?page=$page',
    );
    return ProductResponseModel.fromJson(response.data);
  }

  @override
  Future<ProductResponseModel> getTodaysDealProducts() async {
    final response = await apiProvider.get(
      LaravelApiEndPoint.todaysDealProducts,
    );
    return ProductResponseModel.fromJson(response.data);
  }

  @override
  Future<ProductResponseModel> getFlashDealProducts(int id) async {
    final response = await apiProvider.get(
      '${LaravelApiEndPoint.flashDealProducts}$id',
    );
    return ProductResponseModel.fromJson(response.data);
  }

  @override
  Future<ProductResponseModel> getCategoryProducts(
    int id,
    int page, {
    String? name,
  }) async {
    String url = '${LaravelApiEndPoint.categoryProducts}$id?page=$page';
    if (name != null && name.isNotEmpty) {
      url += '&name=$name';
    }
    final response = await apiProvider.get(url);
    return ProductResponseModel.fromJson(response.data);
  }

  @override
  Future<ProductResponseModel> getShopProducts(
    int id,
    int page, {
    String? name,
  }) async {
    String url = '${LaravelApiEndPoint.shopProducts}$id?page=$page';
    if (name != null && name.isNotEmpty) {
      url += '&name=$name';
    }
    final response = await apiProvider.get(url);
    return ProductResponseModel.fromJson(response.data);
  }

  @override
  Future<ProductResponseModel> getBrandProducts(
    int id,
    int page, {
    String? name,
  }) async {
    String url = '${LaravelApiEndPoint.brandProducts}$id?page=$page';
    if (name != null && name.isNotEmpty) {
      url += '&name=$name';
    }
    final response = await apiProvider.get(url);
    return ProductResponseModel.fromJson(response.data);
  }

  @override
  Future<ProductResponseModel> getFilteredProducts(
    int page, {
    String? name,
    String? sortKey,
    String? brands,
    String? categories,
    double? min,
    double? max,
  }) async {
    Map<String, dynamic> queryParams = {'page': page.toString()};

    if (name != null && name.isNotEmpty) queryParams['name'] = name;
    if (sortKey != null && sortKey.isNotEmpty)
      queryParams['sort_key'] = sortKey;
    if (brands != null && brands.isNotEmpty) queryParams['brands'] = brands;
    if (categories != null && categories.isNotEmpty)
      queryParams['categories'] = categories;
    if (min != null) queryParams['min'] = min.toString();
    if (max != null) queryParams['max'] = max.toString();

    final response = await apiProvider.get(
      LaravelApiEndPoint.filteredProducts,
      queryParameters: queryParams,
    );
    return ProductResponseModel.fromJson(response.data);
  }

  @override
  Future<ProductResponseModel> getDigitalProducts(int page) async {
    final response = await apiProvider.get(
      '${LaravelApiEndPoint.digitalProducts}?page=$page',
    );
    return ProductResponseModel.fromJson(response.data);
  }


  @override
  Future<ProductModel> getDigitalProductDetails(int id) async {
    final response = await apiProvider.get(
      '${LaravelApiEndPoint.productDetails}$id/digital',
    );
    return ProductModel.fromJson(response.data);
  }

  @override
  Future<ProductResponseModel> getRelatedProducts(int id) async {
    final response = await apiProvider.get(
      '${LaravelApiEndPoint.relatedProducts}$id',
    );
    return ProductResponseModel.fromJson(response.data);
  }

  @override
  Future<ProductResponseModel> getTopFromThisSellerProducts(int id) async {
    final response = await apiProvider.get(
      '${LaravelApiEndPoint.topFromSellerProducts}$id',
    );
    return ProductResponseModel.fromJson(response.data);
  }

  @override
  Future<dynamic> getVariantWiseInfo(
    int id, {
    String? color,
    String? variants,
  }) async {
    Map<String, dynamic> queryParams = {'id': id.toString()};

    if (color != null && color.isNotEmpty) queryParams['color'] = color;
    if (variants != null && variants.isNotEmpty)
      queryParams['variants'] = variants;

    final response = await apiProvider.get(
      LaravelApiEndPoint.variantWiseInfo,
      queryParameters: queryParams,
    );
    return response.data;
  }
}
