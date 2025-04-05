import 'package:laravel_ecommerce/core/api/laravel_api_provider.dart';
import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import 'package:laravel_ecommerce/features/presentation/home/controller/home_provider.dart';
import '../../features/data/auth/datasources/auth_remote_datasource.dart';
import '../../features/data/auth/repositories/auth_repository_impl.dart';
import '../../features/data/category/datasources/category_remote_datasource.dart';
import '../../features/data/category/repositories/category_repository_impl.dart';
import '../../features/data/product/datasources/product_remote_datasource.dart'; // You'll need to create this
import '../../features/data/product/repositories/product_repository_impl.dart'; // You'll need to create this
import '../../features/data/slider/datasources/slider_remote_datasource.dart';
import '../../features/data/slider/repositories/slider_repository_impl.dart';
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
import '../../features/domain/category/repositories/category_repository.dart';
import '../../features/domain/category/usecases/get_categories_use_case.dart';
import '../../features/domain/category/usecases/get_featured_categories_use_case.dart';
import '../../features/domain/category/usecases/get_filter_page_categories_use_case.dart';
import '../../features/domain/category/usecases/get_top_categories_use_case.dart';
import '../../features/domain/product/repositories/product_repository.dart';
import '../../features/domain/product/usecases/get_featured_products_use_case.dart';
import '../../features/domain/product/usecases/get_best_selling_products_use_case.dart';
import '../../features/domain/product/usecases/get_new_added_products_use_case.dart';
import '../../features/domain/product/usecases/get_todays_deal_products_use_case.dart';
import '../../features/domain/product/usecases/get_flash_deal_products_use_case.dart';
import '../../features/domain/slider/repositories/slider_repository.dart';
import '../../features/domain/slider/usecases/get_sliders_use_case.dart';
import '../../features/presentation/auth/controller/auth_provider.dart';
import '../../features/presentation/category/controller/provider.dart';
import '../../features/presentation/main layout/controller/layout_provider.dart';
import '../../features/presentation/slider/controller/provider.dart';
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
  sl.registerLazySingleton<AuthRemoteDataSource>(() => AuthRemoteDataSourceImpl(sl<LaravelApiProvider>()));
  sl.registerLazySingleton<CategoryRemoteDataSource>(() => CategoryRemoteDataSourceImpl(sl<ApiProvider>()));
  sl.registerLazySingleton<ProductRemoteDataSource>(() => ProductRemoteDataSourceImpl(sl<ApiProvider>()));
  sl.registerLazySingleton<SliderRemoteDataSource>(
        () => SliderRemoteDataSourceImpl(sl()),
  );


  // Repositories
  sl.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(sl<AuthRemoteDataSource>()));
  sl.registerLazySingleton<CategoryRepository>(() => CategoryRepositoryImpl(sl<CategoryRemoteDataSource>()));
  sl.registerLazySingleton<ProductRepository>(() => ProductRepositoryImpl(sl<ProductRemoteDataSource>()));
  sl.registerLazySingleton<SliderRepository>(
        () => SliderRepositoryImpl(sl()),
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
  sl.registerLazySingleton(() => GetFeaturedProductsUseCase(sl()));
  sl.registerLazySingleton(() => GetBestSellingProductsUseCase(sl()));
  sl.registerLazySingleton(() => GetNewAddedProductsUseCase(sl()));
  sl.registerLazySingleton(() => GetTodaysDealProductsUseCase(sl()));
  sl.registerLazySingleton(() => GetFlashDealProductsUseCase(sl()));

  sl.registerLazySingleton(() => GetSlidersUseCase(sl()));

  // Providers
  sl.registerLazySingleton(() => AuthProvider(
    loginUseCase: sl(),
    signupUseCase: sl(),
    socialLoginUseCase: sl(),
    logoutUseCase: sl(),
    forgetPasswordUseCase: sl(),
    confirmResetPasswordUseCase: sl(),
    resendCodeUseCase: sl(),
    confirmCodeUseCase: sl(),
    getUserByTokenUseCase: sl(),
  ));

  sl.registerFactory(() => SliderProvider(
    getSlidersUseCase: sl(),
  ));

  sl.registerLazySingleton(() => CategoryProvider(
    getCategoriesUseCase: sl(),
    getFeaturedCategoriesUseCase: sl(),
    getTopCategoriesUseCase: sl(),
    getFilterPageCategoriesUseCase: sl(),
  ));

  sl.registerLazySingleton(() => HomeProvider(
    getFeaturedProductsUseCase: sl(),
    getBestSellingProductsUseCase: sl(),
    getNewAddedProductsUseCase: sl(),
    getTodaysDealProductsUseCase: sl(),
    getFlashDealProductsUseCase: sl(),
  ));

  sl.registerLazySingleton(() => LanguageProvider());
  sl.registerLazySingleton(() => LayoutProvider());
}