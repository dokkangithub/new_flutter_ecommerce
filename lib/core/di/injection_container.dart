import 'package:laravel_ecommerce/core/api/laravel_api_provider.dart';
import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import 'package:laravel_ecommerce/features/presentation/home/controller/home_provider.dart';
import 'package:laravel_ecommerce/features/data/profile/repositories/profile_repository_impl.dart';
import 'package:laravel_ecommerce/features/data/profile/datasources/profile_remote_datasource.dart';
import 'package:laravel_ecommerce/features/domain/profile/repositories/profile_repository.dart';
import 'package:laravel_ecommerce/features/domain/profile/usecases/get_profile_counters_use_case.dart';
import 'package:laravel_ecommerce/features/domain/profile/usecases/get_user_profile_use_case.dart';
import 'package:laravel_ecommerce/features/domain/profile/usecases/update_profile_image_use_case.dart';
import 'package:laravel_ecommerce/features/domain/profile/usecases/update_profile_use_case.dart';
import 'package:laravel_ecommerce/features/presentation/profile/controller/profile_provider.dart';
import '../../features/data/address/datasources/address_remote_datasource.dart';
import '../../features/data/address/repositories/address_repository_impl.dart';
import '../../features/data/auth/datasources/auth_remote_datasource.dart';
import '../../features/data/auth/repositories/auth_repository_impl.dart';
import '../../features/data/brand/datasources/brand_remote_datasource.dart';
import '../../features/data/brand/repositories/brand_repository_impl.dart';
import '../../features/data/category/datasources/category_remote_datasource.dart';
import '../../features/data/category/repositories/category_repository_impl.dart';
import '../../features/data/coupon/datasources/coupon_remote_datasource.dart';
import '../../features/data/coupon/repositories/coupon_repository_impl.dart';
import '../../features/data/payment/datasources/payment_remote_datasource.dart';
import '../../features/data/payment/repositories/payment_repository_impl.dart';
import '../../features/data/product details/datasources/product_details_remote_datasource.dart';
import '../../features/data/product details/repositories/product_details_repository_impl.dart';
import '../../features/data/product/datasources/product_remote_datasource.dart';
import '../../features/data/product/repositories/product_repository_impl.dart';
import '../../features/data/review/datasources/review_remote_datasource.dart';
import '../../features/data/review/repositories/review_repository_impl.dart';
import '../../features/data/slider/datasources/slider_remote_datasource.dart';
import '../../features/data/slider/repositories/slider_repository_impl.dart';
import '../../features/data/wishlist/datasources/wishlist_remote_datasource.dart';
import '../../features/data/wishlist/repositories/wishlist_repository_impl.dart';
import '../../features/data/cart/datasources/cart_remote_datasource.dart'; // Add this
import '../../features/data/cart/repositories/cart_repository_impl.dart'; // Add this
import '../../features/domain/address/repositories/address_repository.dart';
import '../../features/domain/address/usecases/add_address_usecases.dart';
import '../../features/domain/address/usecases/delete_address_usecase.dart';
import '../../features/domain/address/usecases/get_address_usecases.dart';
import '../../features/domain/address/usecases/get_cities_by_state_usecase.dart';
import '../../features/domain/address/usecases/get_countries_usecase.dart';
import '../../features/domain/address/usecases/get_home_delivery_usecases.dart';
import '../../features/domain/address/usecases/get_shipping_cost_usecase.dart';
import '../../features/domain/address/usecases/get_states_by_country_usecase.dart';
import '../../features/domain/address/usecases/make_address_default_usecase.dart';
import '../../features/domain/address/usecases/update_address_in_cart_usecase.dart';
import '../../features/domain/address/usecases/update_address_location_usecases.dart';
import '../../features/domain/address/usecases/update_address_usecases.dart';
import '../../features/domain/address/usecases/update_shipping_type_in_cart_usecase.dart';
import '../../features/domain/auth/repositories/auth_repository.dart';
import '../../features/domain/auth/usecases/auth/confirm_code_use_case.dart';
import '../../features/domain/auth/usecases/auth/confirm_reset_password_use_case.dart';
import '../../features/domain/auth/usecases/auth/forget_password_use_case.dart';
import '../../features/domain/auth/usecases/auth/get_user_by_token_use_case.dart';
import '../../features/domain/auth/usecases/auth/login_use_case.dart';
import '../../features/domain/auth/usecases/auth/logout_use_case.dart';
import '../../features/domain/auth/usecases/auth/resend_code_use_case.dart';
import '../../features/domain/auth/usecases/auth/signup_use_case.dart';
import '../../features/domain/auth/usecases/auth/social_login_use_case.dart';
import '../../features/domain/brand/repositories/brand_repository.dart';
import '../../features/domain/brand/usecases/get_brands_usecases.dart';
import '../../features/domain/brand/usecases/get_filter_brands_usecases.dart';
import '../../features/domain/brand/usecases/get_total_brands_pages_usecases.dart';
import '../../features/domain/cart/usecases/add_to_cart_usecases.dart';
import '../../features/domain/cart/usecases/clear_cart_usecases.dart';
import '../../features/domain/cart/usecases/delete_cart_item_usecases.dart';
import '../../features/domain/cart/usecases/get_cart_count_usecases.dart';
import '../../features/domain/cart/usecases/get_cart_items_usecases.dart';
import '../../features/domain/cart/usecases/get_cart_summary_usecases.dart';
import '../../features/domain/cart/usecases/update_cart_quantities_usecases.dart';
import '../../features/domain/cart/usecases/update_shipping_type_usecase.dart';
import '../../features/domain/category/repositories/category_repository.dart';
import '../../features/domain/category/usecases/get_categories_use_case.dart';
import '../../features/domain/category/usecases/get_featured_categories_use_case.dart';
import '../../features/domain/category/usecases/get_filter_page_categories_use_case.dart';
import '../../features/domain/category/usecases/get_top_categories_use_case.dart';
import '../../features/domain/coupon/repositories/coupon_repository.dart';
import '../../features/domain/coupon/usecases/apply_coupon_usecases.dart';
import '../../features/domain/coupon/usecases/remove_coupon_usecases.dart';
import '../../features/domain/payment/repositories/payment_repository.dart';
import '../../features/domain/payment/usecases/create_cash_order_usecase.dart';
import '../../features/domain/payment/usecases/create_kashier_order_usecase.dart';
import '../../features/domain/payment/usecases/get_payment_types_usecase.dart';
import '../../features/domain/payment/usecases/verify_order_success_usecase.dart';
import '../../features/domain/product details/repositories/product_details_repository.dart';
import '../../features/domain/product details/usecases/get_product_details_use_case.dart';
import '../../features/domain/product/repositories/product_repository.dart';
import '../../features/domain/product/usecases/get_all_products_use_case.dart';
import '../../features/domain/product/usecases/get_brand_products_use_case.dart';
import '../../features/domain/product/usecases/get_category_products_use_case.dart';
import '../../features/domain/product/usecases/get_digital_products_use_case.dart';
import '../../features/domain/product/usecases/get_featured_products_use_case.dart';
import '../../features/domain/product/usecases/get_best_selling_products_use_case.dart';
import '../../features/domain/product/usecases/get_filtered_products_use_case.dart';
import '../../features/domain/product/usecases/get_new_added_products_use_case.dart';
import '../../features/domain/product/usecases/get_related_products_use_case.dart';
import '../../features/domain/product/usecases/get_shop_products_use_case.dart';
import '../../features/domain/product/usecases/get_todays_deal_products_use_case.dart';
import '../../features/domain/product/usecases/get_flash_deal_products_use_case.dart';
import '../../features/domain/product/usecases/get_top_from_this_seller_products_use_case.dart';
import '../../features/domain/product/usecases/get_variant_wise_info_use_case.dart';
import '../../features/domain/review/repositories/review_repository.dart';
import '../../features/domain/review/usecases/get_product_reviews_use_case.dart';
import '../../features/domain/review/usecases/submit_review_use_case.dart';
import '../../features/domain/slider/repositories/slider_repository.dart';
import '../../features/domain/slider/usecases/get_sliders_use_case.dart';
import '../../features/domain/wishlist/repositories/wishlist_details_repository.dart';
import '../../features/domain/wishlist/usecases/add_wishlist_usecases.dart';
import '../../features/domain/wishlist/usecases/check_wishlist_usecases.dart';
import '../../features/domain/wishlist/usecases/get_wishlist_usecases.dart';
import '../../features/domain/wishlist/usecases/remove_wishlist_usecases.dart';
import '../../features/domain/cart/repositories/cart_repository.dart';
import '../../features/presentation/address/controller/address_provider.dart';
import '../../features/presentation/auth/controller/auth_provider.dart';
import '../../features/presentation/brand/controller/brand_provider.dart';
import '../../features/presentation/cart/controller/cart_provider.dart';
import '../../features/presentation/category/controller/provider.dart';
import '../../features/presentation/coupon/controller/coupon_provider.dart';
import '../../features/presentation/main layout/controller/layout_provider.dart';
import '../../features/presentation/payment/controller/payment_provider.dart';
import '../../features/presentation/product/controller/product_provider.dart';
import '../../features/presentation/review/controller/reviews_provider.dart';
import '../../features/presentation/slider/controller/provider.dart';
import '../../features/presentation/wishlist/controller/wishlist_provider.dart';
import '../api/api_provider.dart';
import '../config/app_config.dart/app_config.dart';
import '../providers/localization/language_provider.dart';
import '../utils/local_storage/secure_storage.dart';

final sl = GetIt.instance;

void setupDependencies() {
  // Core
  sl.registerLazySingleton<AppConfig>(() => AppConfig());
  sl.registerLazySingleton<SecureStorage>(() => SecureStorage());

  sl.registerLazySingleton<Dio>(() {
    final dio = Dio();
    final appConfig = sl<AppConfig>();
    dio.options.baseUrl = appConfig.apiBaseUrl;
    dio.options.connectTimeout = const Duration(seconds: 15);
    dio.options.receiveTimeout = const Duration(seconds: 15);
    return dio;
  });

  // API Providers
  sl.registerLazySingleton<LaravelApiProvider>(() => LaravelApiProvider());
  sl.registerLazySingleton<ApiProvider>(() => sl<LaravelApiProvider>());

  // Data Sources
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(sl<LaravelApiProvider>()),
  );
  sl.registerLazySingleton<CategoryRemoteDataSource>(
    () => CategoryRemoteDataSourceImpl(sl<ApiProvider>()),
  );
  sl.registerLazySingleton<ProductRemoteDataSource>(
    () => ProductRemoteDataSourceImpl(sl<ApiProvider>()),
  );
  sl.registerLazySingleton<ProductDetailsRemoteDataSource>(
    () => ProductDetailsRemoteDataSourceImpl(sl<ApiProvider>()),
  );
  sl.registerLazySingleton<SliderRemoteDataSource>(
    () => SliderRemoteDataSourceImpl(sl<ApiProvider>()),
  );
  sl.registerLazySingleton<ReviewRemoteDataSource>(
    () => ReviewRemoteDataSourceImpl(sl<ApiProvider>()),
  );
  sl.registerLazySingleton<WishlistRemoteDataSource>(
    () => WishlistRemoteDataSourceImpl(sl<ApiProvider>()),
  );
  sl.registerLazySingleton<CartRemoteDataSource>(
    () => CartRemoteDataSourceImpl(sl<ApiProvider>(), sl<SecureStorage>()),
  );
  sl.registerLazySingleton<AddressRemoteDataSource>(
    () => AddressRemoteDataSourceImpl(sl<ApiProvider>(), sl<SecureStorage>()),
  );
  sl.registerLazySingleton<BrandRemoteDataSource>(
    () => BrandRemoteDataSourceImpl(sl<ApiProvider>(), sl<SecureStorage>()),
  );
  sl.registerLazySingleton<CouponRemoteDataSource>(
    () => CouponRemoteDataSourceImpl(sl<ApiProvider>(), sl<SecureStorage>()),
  );
  sl.registerLazySingleton<PaymentRemoteDataSource>(
    () => PaymentRemoteDataSourceImpl(sl<ApiProvider>()),
  );

  // Repositories
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(sl<AuthRemoteDataSource>()),
  );
  sl.registerLazySingleton<CategoryRepository>(
    () => CategoryRepositoryImpl(sl<CategoryRemoteDataSource>()),
  );
  sl.registerLazySingleton<ProductRepository>(
    () => ProductRepositoryImpl(sl<ProductRemoteDataSource>()),
  );
  sl.registerLazySingleton<ProductDetailsRepository>(
    () => ProductDetailsRepositoryImpl(sl<ProductDetailsRemoteDataSource>()),
  );
  sl.registerLazySingleton<SliderRepository>(() => SliderRepositoryImpl(sl()));
  sl.registerLazySingleton<ReviewRepository>(() => ReviewRepositoryImpl(sl()));
  sl.registerLazySingleton<WishlistRepository>(
    () => WishlistRepositoryImpl(sl<WishlistRemoteDataSource>()),
  );
  sl.registerLazySingleton<CartRepository>(
    () => CartRepositoryImpl(sl<CartRemoteDataSource>()),
  );
  sl.registerLazySingleton<AddressRepository>(
    () => AddressRepositoryImpl(sl<AddressRemoteDataSource>()),
  );
  sl.registerLazySingleton<BrandRepository>(
    () => BrandRepositoryImpl(sl<BrandRemoteDataSource>()),
  );
  sl.registerLazySingleton<CouponRepository>(
    () => CouponRepositoryImpl(sl<CouponRemoteDataSource>()),
  );
  sl.registerLazySingleton<PaymentRepository>(
    () => PaymentRepositoryImpl(remoteDataSource: sl<PaymentRemoteDataSource>()),
  );
  
  // Profile Data Sources
  sl.registerLazySingleton<ProfileRemoteDataSource>(
    () => ProfileRemoteDataSourceImpl(sl<ApiProvider>()),
  );
  
  sl.registerLazySingleton<ProfileRepository>(
    () => ProfileRepositoryImpl(sl<ProfileRemoteDataSource>()),
  );


  // Use Cases - Auth
  sl.registerLazySingleton(() => LoginUseCase(sl()));
  sl.registerLazySingleton(() => SignupUseCase(sl()));
  sl.registerLazySingleton(() => SocialLoginUseCase(sl()));
  sl.registerLazySingleton(() => LogoutUseCase(sl()));
  sl.registerLazySingleton(() => ForgetPasswordUseCase(sl()));
  sl.registerLazySingleton(() => ConfirmResetPasswordUseCase(sl()));
  sl.registerLazySingleton(() => ResendCodeUseCase(sl()));
  sl.registerLazySingleton(() => ConfirmCodeUseCase(sl()));
  sl.registerLazySingleton(() => GetUserByTokenUseCase(sl()));

  // Use Cases - Category
  sl.registerLazySingleton(() => GetCategoriesUseCase(sl()));
  sl.registerLazySingleton(() => GetFeaturedCategoriesUseCase(sl()));
  sl.registerLazySingleton(() => GetTopCategoriesUseCase(sl()));
  sl.registerLazySingleton(() => GetFilterPageCategoriesUseCase(sl()));

  // Use Cases - Product
  sl.registerLazySingleton(() => GetAllProductsUseCase(sl()));
  sl.registerLazySingleton(() => GetFeaturedProductsUseCase(sl()));
  sl.registerLazySingleton(() => GetBestSellingProductsUseCase(sl()));
  sl.registerLazySingleton(() => GetNewAddedProductsUseCase(sl()));
  sl.registerLazySingleton(() => GetTodaysDealProductsUseCase(sl()));
  sl.registerLazySingleton(() => GetFlashDealProductsUseCase(sl()));
  sl.registerLazySingleton(() => GetCategoryProductsUseCase(sl()));
  sl.registerLazySingleton(() => GetBrandProductsUseCase(sl()));
  sl.registerLazySingleton(() => GetDigitalProductsUseCase(sl()));
  sl.registerLazySingleton(() => GetFilteredProductsUseCase(sl()));
  sl.registerLazySingleton(() => GetRelatedProductsUseCase(sl()));
  sl.registerLazySingleton(() => GetShopProductsUseCase(sl()));
  sl.registerLazySingleton(() => GetTopFromThisSellerProductsUseCase(sl()));
  sl.registerLazySingleton(() => GetVariantWiseInfoUseCase(sl()));

  // Use Cases - Product Details
  sl.registerLazySingleton(() => GetProductDetailsUseCase(sl()));

  // Use Cases - Sliders
  sl.registerLazySingleton(() => GetSlidersUseCase(sl()));

  // Use Cases - Reviews
  sl.registerLazySingleton(() => GetProductReviewsUseCase(sl()));
  sl.registerLazySingleton(() => SubmitReviewUseCase(sl()));

  // Use Cases - Wishlist
  sl.registerLazySingleton(() => GetWishlistUseCase(sl()));
  sl.registerLazySingleton(() => CheckWishlistUseCase(sl()));
  sl.registerLazySingleton(() => AddToWishlistUseCase(sl()));
  sl.registerLazySingleton(() => RemoveFromWishlistUseCase(sl()));

  // Use Cases - Cart
  sl.registerLazySingleton(() => GetCartItemsUseCase(sl()));
  sl.registerLazySingleton(() => GetCartCountUseCase(sl()));
  sl.registerLazySingleton(() => DeleteCartItemUseCase(sl()));
  sl.registerLazySingleton(() => ClearCartUseCase(sl()));
  sl.registerLazySingleton(() => UpdateCartQuantitiesUseCase(sl()));
  sl.registerLazySingleton(() => AddToCartUseCase(sl()));
  sl.registerLazySingleton(() => GetCartSummaryUseCase(sl()));
  sl.registerLazySingleton(() => UpdateShippingTypeUseCase(sl()));

  // Use Cases - Address
  sl.registerLazySingleton(() => GetAddressesUseCase(sl()));
  sl.registerLazySingleton(() => GetHomeDeliveryAddressUseCase(sl()));
  sl.registerLazySingleton(() => AddAddressUseCase(sl()));
  sl.registerLazySingleton(() => UpdateAddressUseCase(sl()));
  sl.registerLazySingleton(() => UpdateAddressLocationUseCase(sl()));
  sl.registerLazySingleton(() => MakeAddressDefaultUseCase(sl()));
  sl.registerLazySingleton(() => DeleteAddressUseCase(sl()));
  sl.registerLazySingleton(() => GetCitiesByStateUseCase(sl()));
  sl.registerLazySingleton(() => GetStatesByCountryUseCase(sl()));
  sl.registerLazySingleton(() => GetCountriesUseCase(sl()));
  sl.registerLazySingleton(() => GetShippingCostUseCase(sl()));
  sl.registerLazySingleton(() => UpdateAddressInCartUseCase(sl()));
  sl.registerLazySingleton(() => UpdateShippingTypeInCartUseCase(sl()));

  // Use Cases - Brand
  sl.registerLazySingleton(() => GetFilterPageBrandsUseCase(sl()));
  sl.registerLazySingleton(() => GetBrandsUseCase(sl()));
  sl.registerLazySingleton(() => GetTotalBrandPagesUseCase(sl()));

  // Use Cases - Coupon
  sl.registerLazySingleton(() => ApplyCouponUseCase(sl()));
  sl.registerLazySingleton(() => RemoveCouponUseCase(sl()));

  // Use Cases - payment
  sl.registerLazySingleton(() => GetPaymentTypesUseCase(sl()));
  sl.registerLazySingleton(() => CreateKashierOrderUseCase(sl()));
  sl.registerLazySingleton(() => CreateCashOrderUseCase(sl()));
  sl.registerLazySingleton(() => VerifyOrderSuccessUseCase(sl()));
  
  // Use Cases - Profile
  sl.registerLazySingleton(() => GetProfileCountersUseCase(sl()));
  sl.registerLazySingleton(() => GetUserProfileUseCase(sl()));
  sl.registerLazySingleton(() => UpdateProfileUseCase(sl()));
  sl.registerLazySingleton(() => UpdateProfileImageUseCase(sl()));

  // Providers
  sl.registerLazySingleton(
    () => AuthProvider(
      loginUseCase: sl(),
      signupUseCase: sl(),
      socialLoginUseCase: sl(),
      logoutUseCase: sl(),
      forgetPasswordUseCase: sl(),
      confirmResetPasswordUseCase: sl(),
      resendCodeUseCase: sl(),
      confirmCodeUseCase: sl(),
      getUserByTokenUseCase: sl(),
    ),
  );

  sl.registerFactory(() => SliderProvider(getSlidersUseCase: sl()));

  sl.registerLazySingleton(
    () => CategoryProvider(
      getCategoriesUseCase: sl(),
      getFeaturedCategoriesUseCase: sl(),
      getTopCategoriesUseCase: sl(),
      getFilterPageCategoriesUseCase: sl(),
    ),
  );

  sl.registerFactory(
    () => CouponProvider(applyCouponUseCase: sl(), removeCouponUseCase: sl()),
  );

  sl.registerLazySingleton(
    () => HomeProvider(
      getAllProductsUseCase: sl(),
      getFeaturedProductsUseCase: sl(),
      getBestSellingProductsUseCase: sl(),
      getNewAddedProductsUseCase: sl(),
      getTodaysDealProductsUseCase: sl(),
      getFlashDealProductsUseCase: sl(),
      getCategoryProductsUseCase: sl(),
      getBrandProductsUseCase: sl(),
      getDigitalProductsUseCase: sl(),
      getFilteredProductsUseCase: sl(),
      getRelatedProductsUseCase: sl(),
      getShopProductsUseCase: sl(),
      getTopFromThisSellerProductsUseCase: sl(),
      getVariantWiseInfoUseCase: sl(),
    ),
  );

  sl.registerFactory(
    () => ProductDetailsProvider(getProductDetailsUseCase: sl()),
  );

  sl.registerFactory(
    () => ReviewProvider(getProductReviews: sl(), submitReview: sl()),
  );

  sl.registerFactory(
    () => WishlistProvider(
      getWishlistUseCase: sl(),
      checkWishlistUseCase: sl(),
      addToWishlistUseCase: sl(),
      removeFromWishlistUseCase: sl(),
    ),
  );

  sl.registerFactory(
    () => CartProvider(
      getCartItemsUseCase: sl(),
      getCartCountUseCase: sl(),
      deleteCartItemUseCase: sl(),
      clearCartUseCase: sl(),
      updateCartQuantitiesUseCase: sl(),
      addToCartUseCase: sl(),
      getCartSummaryUseCase: sl(),
      updateShippingTypeUseCase: sl(),
    ),
  );

  sl.registerFactory(
    () => AddressProvider(
      getAddressesUseCase: sl(),
      getHomeDeliveryAddressUseCase: sl(),
      addAddressUseCase: sl(),
      updateAddressUseCase: sl(),
      updateAddressLocationUseCase: sl(),
      makeAddressDefaultUseCase: sl(),
      deleteAddressUseCase: sl(),
      getCitiesByStateUseCase: sl(),
      getStatesByCountryUseCase: sl(),
      getCountriesUseCase: sl(),
      getShippingCostUseCase: sl(),
      updateAddressInCartUseCase: sl(),
      updateShippingTypeInCartUseCase: sl(),
    ),
  );

  sl.registerFactory(
    () => BrandProvider(
      getFilterPageBrandsUseCase: sl(),
      getBrandsUseCase: sl(),
      getTotalBrandPagesUseCase: sl(),
    ),
  );

  sl.registerFactory(
    () => PaymentProvider(
      getPaymentTypesUseCase: sl(),
      createKashierOrderUseCase: sl(),
      createCashOrderUseCase: sl(),
      verifyOrderSuccessUseCase: sl(),
    ),
  );

  sl.registerLazySingleton(() => LanguageProvider());
  sl.registerLazySingleton(() => LayoutProvider());
  
  sl.registerFactory(
    () => ProfileProvider(
      getUserProfileUseCase: sl(),
      getProfileCountersUseCase: sl(),
      updateProfileUseCase: sl(),
      updateProfileImageUseCase: sl(),
    ),
  );
}
