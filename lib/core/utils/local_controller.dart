import 'package:flutter/material.dart';

class LocaleController extends ChangeNotifier {
  Locale? _locale;

  Locale? get locale => _locale;

  void setLocale(Locale? locale) {
    _locale = locale;
    notifyListeners();
  }

  // Call this once at startup (optional: choose default language)
  void init({Locale defaultLocale = const Locale('en')}) {
    _locale ??= defaultLocale;
  }

  void toggle() {
    final code = _locale?.languageCode ?? 'en';
    setLocale(code == 'ar' ? const Locale('en') : const Locale('ar'));
  }
}
