import 'dart:developer' as developer;

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Preferences {
  static const languageCodeKey = "languageCodeKey";
  static const themKey = "themKey";
  static const isFinishOnBoardingKey = "isFinishOnBoardingKey";

  static late SharedPreferences pref;

  static Future<void> initPref() async {
    try {
      pref = await SharedPreferences.getInstance();
    } catch (e,stack) {
      if (kDebugMode) {
        developer.log("Error Initializing Shared Preferences:", error: e, stackTrace: stack);
      }
    }
  }

  static bool getBoolean(String key) {
    try {
      return pref.getBool(key) ?? false;
    } catch (e,stack) {
      if (kDebugMode) {
        developer.log("Error Getting Boolean Value:", error: e, stackTrace: stack);
      }
      return false;
    }
  }

  static Future<void> setBoolean(String key, bool value) async {
    try {
      await pref.setBool(key, value);
    } catch (e,stack) {
      if (kDebugMode) {
        developer.log("Error Setting Boolean Value:", error: e, stackTrace: stack);
      }
    }
  }

  static String getString(String key) {
    try {
      return pref.getString(key) ?? "";
    } catch (e,stack) {
      if (kDebugMode) {
        developer.log("Error Getting String Value:", error: e, stackTrace: stack);
      }
      return "";
    }
  }

  static Future<void> setString(String key, String value) async {
    try {
      await pref.setString(key, value);
    } catch (e,stack) {
      if (kDebugMode) {
        developer.log("Error Setting String Value:", error: e, stackTrace: stack);
      }
    }
  }

  static int getInt(String key) {
    try {
      return pref.getInt(key) ?? 0;
    } catch (e,stack) {
      if (kDebugMode) {
        developer.log("Error Getting Int Value:", error: e, stackTrace: stack);
      }
      return 0;
    }
  }

  static Future<void> setInt(String key, int value) async {
    try {
      await pref.setInt(key, value);
    } catch (e,stack) {
      if (kDebugMode) {
        developer.log("Error Setting Int Value:", error: e, stackTrace: stack);
      }
    }
  }

  static Future<void> clearSharedPreference() async {
    try {
      await pref.clear();
    } catch (e,stack) {
      if (kDebugMode) {
        developer.log("Error Clear Shared Preference:", error: e, stackTrace: stack);
      }
    }
  }

  static Future<void> clearKeyData(String key) async {
    try {
      await pref.remove(key);
    } catch (e,stack) {
      if (kDebugMode) {
        developer.log("Error Clear Key Data:", error: e, stackTrace: stack);
      }
    }
  }
}
