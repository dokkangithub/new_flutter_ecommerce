import 'package:laravel_ecommerce/presentation/auth/controller/auth_provider.dart';
import 'package:flutter/material.dart';
import 'config/app_config.dart/app_config.dart';
import 'config/routes.dart/routes.dart';
import 'config/themes.dart/theme.dart';
import 'core/di/injection_container.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'core/providers/localization/app_localizations.dart';
import 'core/providers/localization/language_provider.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setupDependencies();

  Locale locale = await sl<LanguageProvider>().getLocale();


  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => sl<AuthProvider>()),
        ChangeNotifierProvider(create: (_) => sl<LanguageProvider>()..setLocale(locale)),

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
          initialRoute: AppRoutes.login,
        );
      }
    );
  }
}
