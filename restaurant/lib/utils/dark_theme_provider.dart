import 'dart:developer' as developer;

import 'package:flutter/foundation.dart';
import 'package:flutter/scheduler.dart';
import 'package:restaurant/utils/dark_theme_preference.dart';

class DarkThemeProvider with ChangeNotifier {
  DarkThemePreference darkThemePreference = DarkThemePreference();
  int _darkTheme = 0;

  int get darkTheme => _darkTheme;

  set darkTheme(int value) {
    try {
      _darkTheme = value;
      darkThemePreference.setDarkTheme(value);
      notifyListeners();
    } catch (e,stack) {
      if (kDebugMode) {
        developer.log('Error setting dark theme: $e', stackTrace: stack);
      }
    }
  }

  bool isDarkTheme() {
    try {
      if (darkTheme == 0) {
        return true;
      } else if (darkTheme == 1) {
        return false;
      } else {
        return DarkThemeProvider().getSystemThem();
      }
    } catch (e,stack) {
      if (kDebugMode) {
        developer.log('Error determining dark theme: $e', stackTrace: stack);
      }
      return false;
    }
  }

  bool getSystemThem() {
    try {
      var brightness = SchedulerBinding.instance.platformDispatcher.platformBrightness;
      return brightness == Brightness.dark;
    } catch (e,stack) {
      if (kDebugMode) {
        developer.log('Error getting system theme: $e', stackTrace: stack);
      }
      return false;
    }
  }
}
