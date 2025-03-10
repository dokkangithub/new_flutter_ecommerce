import 'package:laravel_ecommerce/core/utils/local_storage/secure_storage.dart';
import 'package:flutter/material.dart';
import '../../utils/local_storage/local_storage_keys.dart';
import 'language_model.dart';

class LanguageProvider extends ChangeNotifier {
  final Locale _locale = const Locale('en', 'US');

  final List<LanguageModel> languages = [
    LanguageModel(
      code: 'en',
      name: 'English',
      languageCode: 'en',
      countryCode: 'US',
    ),
    LanguageModel(
      code: 'ar',
      name: 'العربية',
      languageCode: 'ar',
      countryCode: 'SA',
    ),
  ];

  Locale get locale => _locale;

  Future<Locale> getLocale() async {
    String? languageCode = await SecureStorage().get(LocalStorageKey.languageCode);
    String? countryCode = await SecureStorage().get(LocalStorageKey.countryCode);

    // Provide default values if null is returned
    languageCode ??= 'en'; // Default to English
    countryCode ??= 'US';  // Default to US

    return Locale(languageCode, countryCode);
  }


  Future<bool> setLocale(Locale tempLocale) async {
    await SecureStorage().save(LocalStorageKey.languageCode, tempLocale.languageCode);
    await SecureStorage().save(LocalStorageKey.countryCode, tempLocale.countryCode);
    notifyListeners(); // Notify UI to rebuild with the new locale
    return true;
  }

  Future<void> changeLanguage(String languageCode, String countryCode) async {
    Locale tempLocale = Locale(languageCode, countryCode);
    await setLocale(tempLocale);
    notifyListeners(); // Notify UI after the change
  }


}

