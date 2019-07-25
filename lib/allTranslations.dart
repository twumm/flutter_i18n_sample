import 'dart:async';
import 'dart:convert';
import 'dart:ui';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Preferences related
const String _storageKey = "MyApplication_";
const List<String> _supportedLanguages = ['en', 'pt'];
Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

class GlobalTranslations {
  Locale _locale;
  Map<dynamic, dynamic> _localizedValues;
  VoidCallback _onLocaleChangedCallback;

  // Returns the list of supported Locales
  Iterable<Locale> supportedLocales() => _supportedLanguages.map<Locale>((lang) => new Locale(lang, ''));

  // Returns the translation that corresponds to the [key]
  String text(String key) {
    // Return the requested string
    return (_localizedValues == null || _localizedValues[key] == null) ? '** $key not found' : _localizedValues[key];
  }

  // Returns the current language code
  get currentLanguage => _locale == null ? '' : _locale.languageCode;

  // Returns the current locale
  get locale => _locale;

  // One time initialization
  Future<Null> init([String language]) async {
    if (_locale == null) {
      await setNewLanguage(language);
    }
    return null;
  }

  // METHOD THAT SAVES/RESTORES THE PREFERRED LANGUAGE
  getPreferredLanguage() async {
    return _getApplicationSavedInformation('language');
  }
  setPreferredLanguage(String lang) async {
    return _setApplicationSavedInformation('language', lang);
  }

  // Routine to change the language
  Future<Null> setNewLanguage([String newLanguage, bool saveInPrefs = false]) async {
    String language = newLanguage;
    if (language == null) {
      language = await getPreferredLanguage();
    }

    // Set the locale
    if (language == "") {
      language = "en";
    }
    _locale = Locale(language, "");

    // Load the language strings
    String jsonContent = await rootBundle.loadString("locale/i18n_${_locale.languageCode}.json");
    _localizedValues = json.decode(jsonContent);
  }
}