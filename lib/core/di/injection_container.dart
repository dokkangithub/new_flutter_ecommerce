import 'package:laravel_ecommerce/core/api/laravel_api_provider.dart';
import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import 'package:laravel_ecommerce/features/presentation/home/controller/home_provider.dart';
import '../../features/data/auth/datasources/auth_remote_datasource.dart';
import '../../features/data/auth/repositories/auth_repository_impl.dart';
import '../../features/data/category/datasources/category_remote_datasource.dart';
import '../../features/data/category/repositories/category_repository_impl.dart';
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
import '../../features/presentation/auth/controller/auth_provider.dart';
import '../../features/presentation/category/controller/provider.dart';
import '../../features/presentation/main layout/controller/layout_provider.dart';
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






  // Repositories
  sl.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(sl<AuthRemoteDataSource>()));
  sl.registerLazySingleton<CategoryRepository>(() => CategoryRepositoryImpl(sl<CategoryRemoteDataSource>()));




  // Use Cases
  sl.registerLazySingleton(() => LoginUseCase(sl()));
  sl.registerLazySingleton(() => SignupUseCase(sl()));
  sl.registerLazySingleton(() => SocialLoginUseCase(sl()));
  sl.registerLazySingleton(() => LogoutUseCase(sl()));
  sl.registerLazySingleton(() => ForgetPasswordUseCase(sl()));
  sl.registerLazySingleton(() => ConfirmResetPasswordUseCase(sl()));
  sl.registerLazySingleton(() => ResendCodeUseCase(sl()));
  sl.registerLazySingleton(() => ConfirmCodeUseCase(sl()));
  sl.registerLazySingleton(() => GetUserByTokenUseCase(sl()));
  sl.registerLazySingleton(() => GetCategoriesUseCase(sl()));
  sl.registerLazySingleton(() => GetFeaturedCategoriesUseCase(sl()));
  sl.registerLazySingleton(() => GetTopCategoriesUseCase(sl()));
  sl.registerLazySingleton(() => GetFilterPageCategoriesUseCase(sl()));


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
  sl.registerLazySingleton(() => CategoryProvider(
    getCategoriesUseCase: sl(),
    getFeaturedCategoriesUseCase: sl(),
    getTopCategoriesUseCase: sl(),
    getFilterPageCategoriesUseCase: sl(),
  ));
  sl.registerLazySingleton(() => LanguageProvider());
  sl.registerLazySingleton(() => HomeProvider());
  sl.registerLazySingleton(() => LayoutProvider());
}
