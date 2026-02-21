// ignore_for_file: deprecated_member_use

import 'package:customer/app/widget/text_widget.dart';
import 'package:customer/themes/app_fonts.dart';
import 'package:customer/themes/app_theme_data.dart';
import 'package:customer/utils/dark_theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class UiInterface {
  UiInterface({Key? key});

  static AppBar customAppBar(
    BuildContext context,
    themeChange,
    String title, {
    bool isBack = true,
    Color? backgroundColor,
    Color? iconColor,
    Color? textColor,
    List<Widget>? actions,
    Function()? onBackTap,
  }) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return AppBar(
      leading: isBack
          ? Padding(
              padding: const EdgeInsets.all(8),
              child: GestureDetector(
                onTap: () {
                  Get.back();
                },
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: themeChange.isDarkTheme() ? AppThemeData.grey900 : AppThemeData.grey100,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 6, right: 10, bottom: 6, top: 6),
                    child: Icon(
                      Icons.arrow_back_ios_rounded,
                      size: 20,
                      color: themeChange.isDarkTheme() ? AppThemeData.grey100 : AppThemeData.grey900,
                    ),
                  ),
                ),
              ),
            )
          : SizedBox(),
      title: Padding(
        padding: const EdgeInsets.only(left: 8.0),
        child: TextCustom(color: themeChange.isDarkTheme() ? AppThemeData.grey100 : AppThemeData.grey900, fontFamily: FontFamily.bold, fontSize: 18, title: title.tr),
      ),
      backgroundColor: themeChange.isDarkTheme() ? backgroundColor ?? AppThemeData.primaryBlack : backgroundColor ?? AppThemeData.primaryWhite,
      automaticallyImplyLeading: false,
      elevation: 0,
      centerTitle: false,
      titleSpacing: 10,
      surfaceTintColor: Colors.transparent,
      actions: actions,
    );
  }
}
