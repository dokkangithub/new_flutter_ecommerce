import 'package:flutter/material.dart';
import 'package:laravel_ecommerce/features/presentation/home/controller/home_provider.dart';
import 'core/config/app_config.dart/app_config.dart';
import 'core/config/routes.dart/routes.dart';
import 'core/config/themes.dart/theme.dart';
import 'core/di/injection_container.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'core/providers/localization/app_localizations.dart';
import 'core/providers/localization/language_provider.dart';
import 'features/presentation/auth/controller/auth_provider.dart';
import 'features/presentation/category/controller/provider.dart';
import 'features/presentation/main layout/controller/layout_provider.dart';
import 'features/presentation/slider/controller/provider.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setupDependencies();

  Locale locale = await sl<LanguageProvider>().getLocale();


  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => sl<AuthProvider>()),
        ChangeNotifierProvider(create: (_) => sl<HomeProvider>()),
        ChangeNotifierProvider(create: (_) => sl<LayoutProvider>()),
        ChangeNotifierProvider(create: (_) => sl<LanguageProvider>()..setLocale(locale)),
        ChangeNotifierProvider(create: (_) => sl<CategoryProvider>()),  // Add this line
        ChangeNotifierProvider(create: (_) => sl<SliderProvider>()),


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
