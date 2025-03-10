import 'package:laravel_ecommerce/core/api/laravel_api_provider.dart';
import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import '../../config/app_config.dart/app_config.dart';
import '../../data/auth/datasources/auth_remote_datasource.dart';
import '../../data/auth/repositories/auth_repository_impl.dart';
import '../../domain/auth/repositories/auth_repository.dart';
import '../../domain/auth/usecases/auth/confirm_code_use_case.dart';
import '../../domain/auth/usecases/auth/confirm_reset_password_use_case.dart';
import '../../domain/auth/usecases/auth/forget_password_use_case.dart';
import '../../domain/auth/usecases/auth/get_user_by_token_use_case.dart';
import '../../domain/auth/usecases/auth/login_use_case.dart';
import '../../domain/auth/usecases/auth/logout_use_case.dart';
import '../../domain/auth/usecases/auth/resend_code_use_case.dart';
import '../../domain/auth/usecases/auth/signup_use_case.dart';
import '../../domain/auth/usecases/auth/social_login_use_case.dart';
import '../../presentation/auth/controller/auth_provider.dart';
import '../api/api_provider.dart';
import '../providers/localization/language_provider.dart';
import '../utils/local_storage/secure_storage.dart';



final sl = GetIt.instance;

void setupDependencies() {
  // Register AppConfig
  sl.registerLazySingleton<AppConfig>(() => AppConfig());

  // Register Dio instance with configurations
  sl.registerLazySingleton<Dio>(() {
    final dio = Dio();
    final appConfig = sl<AppConfig>();
    dio.options.baseUrl = appConfig.apiBaseUrl;
    dio.options.connectTimeout = const Duration(seconds: 15);
    dio.options.receiveTimeout = const Duration(seconds: 15);
    return dio;
  });

  // Register API providers
  sl.registerLazySingleton<LaravelApiProvider>(() => LaravelApiProvider());

  // Register ApiProvider as the implementation you want to use
  sl.registerLazySingleton<ApiProvider>(() => sl<LaravelApiProvider>());

  // Register AuthRemoteDataSource
  sl.registerLazySingleton<AuthRemoteDataSource>(
        () => AuthRemoteDataSourceImpl(sl<LaravelApiProvider>()),
  );

  // Register AuthRepository
  sl.registerLazySingleton<AuthRepository>(
        () => AuthRepositoryImpl(sl<AuthRemoteDataSource>()),
  );
  sl.registerLazySingleton<SecureStorage>(() => SecureStorage());


  // Register Use Cases
  sl.registerLazySingleton(() => LoginUseCase(sl()));
  sl.registerLazySingleton(() => SignupUseCase(sl()));
  sl.registerLazySingleton(() => SocialLoginUseCase(sl()));
  sl.registerLazySingleton(() => LogoutUseCase(sl()));
  sl.registerLazySingleton(() => ForgetPasswordUseCase(sl()));
  sl.registerLazySingleton(() => ConfirmResetPasswordUseCase(sl()));
  sl.registerLazySingleton(() => ResendCodeUseCase(sl()));
  sl.registerLazySingleton(() => ConfirmCodeUseCase(sl()));
  sl.registerLazySingleton(() => GetUserByTokenUseCase(sl()));


  // Register AuthProvider
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

  // Register LanguageProvider
  sl.registerLazySingleton(() => LanguageProvider());







}
