// ignore_for_file: constant_identifier_names
import 'dart:developer' as developer;

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DarkThemePreference {
  static const THEME_STATUS = "THEMESTATUS";

  Future<void> setDarkTheme(int value) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setInt(THEME_STATUS, value);
    } catch (e,stack) {
      if (kDebugMode) {
        developer.log("Error Setting Dark Theme:", error: e, stackTrace: stack);
      }
    }
  }

  Future<int> isDarkTheme() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      return prefs.getInt(THEME_STATUS) ?? 2;
    } catch (e,stack) {
      if (kDebugMode) {
        developer.log("Error Getting Dark Theme:", error: e, stackTrace: stack);
      }
      return 2;
    }
  }
}
