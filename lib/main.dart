import 'package:flutter/material.dart';
import 'package:laravel_ecommerce/core/utils/constants/app_strings.dart';
import 'package:laravel_ecommerce/features/domain/coupon/entities/coupon.dart';
import 'package:laravel_ecommerce/features/presentation/home/controller/home_provider.dart';
import 'core/config/app_config.dart/app_config.dart';
import 'core/config/routes.dart/routes.dart';
import 'core/config/themes.dart/theme.dart';
import 'core/di/injection_container.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'core/providers/localization/app_localizations.dart';
import 'core/providers/localization/language_provider.dart';
import 'core/utils/local_storage/local_storage_keys.dart';
import 'core/utils/local_storage/secure_storage.dart';
import 'features/presentation/address/controller/address_provider.dart';
import 'features/presentation/auth/controller/auth_provider.dart';
import 'features/presentation/cart/controller/cart_provider.dart';
import 'features/presentation/category/controller/provider.dart';
import 'features/presentation/coupon/controller/coupon_provider.dart';
import 'features/presentation/main layout/controller/layout_provider.dart';
import 'features/presentation/payment/controller/payment_provider.dart';
import 'features/presentation/product/controller/product_provider.dart';
import 'features/presentation/profile/controller/profile_provider.dart';
import 'features/presentation/review/controller/reviews_provider.dart';
import 'features/presentation/slider/controller/provider.dart';
import 'features/presentation/wishlist/controller/wishlist_provider.dart';

Future<void> getInitData() async {
  AppStrings.token = await SecureStorage().get<String>(LocalStorageKey.userToken);
  AppStrings.userId = await SecureStorage().get<String>(LocalStorageKey.userId);
  AppStrings.userEmail = await SecureStorage().get<String>(LocalStorageKey.userEmail);
  AppStrings.userName = await SecureStorage().get<String>(LocalStorageKey.userName);
}


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setupDependencies();

  Locale locale = await sl<LanguageProvider>().getLocale();
  await getInitData();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => sl<AuthProvider>()),
        ChangeNotifierProvider(create: (_) => sl<HomeProvider>()),
        ChangeNotifierProvider(create: (_) => sl<LayoutProvider>()),
        ChangeNotifierProvider(create: (_) => sl<ProductDetailsProvider>()),
        ChangeNotifierProvider(create: (_) => sl<LanguageProvider>()..setLocale(locale)),
        ChangeNotifierProvider(create: (_) => sl<CategoryProvider>()),
        ChangeNotifierProvider(create: (_) => sl<SliderProvider>()),
        ChangeNotifierProvider(create: (_) => sl<ReviewProvider>()),
        ChangeNotifierProvider(create: (_) => sl<WishlistProvider>()),
        ChangeNotifierProvider(create: (_) => sl<CartProvider>()),
        ChangeNotifierProvider(create: (_) => sl<AddressProvider>()),
        ChangeNotifierProvider(create: (_) => sl<CouponProvider>()),
        ChangeNotifierProvider(create: (_) => sl<PaymentProvider>()),
        ChangeNotifierProvider(create: (_) => sl<ProfileProvider>()),

      ],
      child: const MyApp(),
    ),
  );}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<LanguageProvider>(
        builder: (context, languageProvider, child) {
          return MaterialApp(
            title: AppConfig().appName,
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: ThemeMode.light,
            locale: languageProvider.locale,
            supportedLocales: const [
              Locale('en', 'US'),
              Locale('ar', 'SA'),
            ],
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            localeResolutionCallback: (locale, supportedLocales) {
              for (var supportedLocale in supportedLocales) {
                if (supportedLocale.languageCode == locale?.languageCode &&
                    supportedLocale.countryCode == locale?.countryCode) {
                  return supportedLocale;
                }
              }
              return supportedLocales.first;
            },
            onGenerateRoute: AppRoutes.generateRoute,
            initialRoute: AppRoutes.splash,
          );
        }
    );
  }
}
