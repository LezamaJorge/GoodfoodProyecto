// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:restaurant/themes/app_theme_data.dart';

class Styles {
  static ThemeData themeData(bool isDarkTheme, BuildContext context) {
    return ThemeData(
        scaffoldBackgroundColor: isDarkTheme ? AppThemeData.grey1000 : AppThemeData.grey50,
        dialogBackgroundColor: isDarkTheme ? AppThemeData.grey1000 : AppThemeData.grey100,
        primaryColor: isDarkTheme ? AppThemeData.primary300 : AppThemeData.primary300,
        brightness: isDarkTheme ? Brightness.dark : Brightness.light,
        timePickerTheme: TimePickerThemeData(
            backgroundColor: isDarkTheme ? Color(0xff1A1A1A) : Color(0xffFFFFFF),
            dialTextStyle: TextStyle(fontWeight: FontWeight.bold, color: AppThemeData.grey1000),
            dialTextColor: AppThemeData.grey1000,
            hourMinuteTextColor: AppThemeData.primary300,
            dayPeriodTextColor: isDarkTheme ? AppThemeData.primaryWhite : AppThemeData.primaryBlack,
            dayPeriodColor: AppThemeData.primary300,
            dialHandColor: AppThemeData.primary300,
            hourMinuteColor: AppThemeData.primary300.withOpacity(0.2),
            dialBackgroundColor: isDarkTheme ? Color(0xff1F1F1F) : Color(0xffF6F7F9)),
        floatingActionButtonTheme: FloatingActionButtonThemeData(backgroundColor: AppThemeData.primary300, foregroundColor: AppThemeData.primaryWhite),
        dialogTheme: DialogThemeData(barrierColor: isDarkTheme
            ? AppThemeData.grey50.withOpacity(0.5)
            : AppThemeData.grey1000.withOpacity(0.5),
            elevation: 10),
        popupMenuTheme: PopupMenuThemeData(color: isDarkTheme ? AppThemeData.grey1000 : AppThemeData.grey50));
  }
}
