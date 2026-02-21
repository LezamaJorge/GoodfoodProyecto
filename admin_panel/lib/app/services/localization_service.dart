import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../lang/app_ar.dart';
import '../lang/app_en.dart';
import '../lang/app_hi.dart';
import '../lang/app_es.dart';

class LocalizationService extends Translations {
  // Default locale
  static const locale = Locale('en', 'US');

  static final locales = [
    const Locale('en'),
    const Locale('hi'),
    const Locale('ar'),
    const Locale('es'),
  ];

  @override
  Map<String, Map<String, String>> get keys => {
    'en': enUS,
    'hi': hiIN,
    'ar': lnAr,
    'es': esES,
  };

  void changeLocale(String lang) {
    Get.updateLocale(Locale(lang));
  }
}
