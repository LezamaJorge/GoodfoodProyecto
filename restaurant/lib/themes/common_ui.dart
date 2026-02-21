// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:restaurant/app/widget/text_widget.dart';
import 'package:restaurant/themes/app_fonts.dart';
import 'package:restaurant/themes/app_theme_data.dart';
import 'package:restaurant/utils/dark_theme_provider.dart';

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
      title: Row(
        children: [
          if (isBack)
            GestureDetector(
              onTap: () {
                Get.back();
              },
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: themeChange.isDarkTheme() ? AppThemeData.grey900 : AppThemeData.grey100,
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 10,right: 12,top: 10,bottom: 10),
                  child: Icon(
                    Icons.arrow_back_ios_rounded,
                    size: 20,
                    color: themeChange.isDarkTheme() ? AppThemeData.grey100 : AppThemeData.grey900,
                  ),
                ),
              ),
            ),
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: TextCustom(color: themeChange.isDarkTheme() ? AppThemeData.grey100 : AppThemeData.grey900, fontFamily: FontFamily.bold, fontSize: 18, title: title.tr),
          ),
        ],
      ),
      backgroundColor: themeChange.isDarkTheme() ? backgroundColor ?? AppThemeData.primaryBlack : backgroundColor ?? AppThemeData.primaryWhite,
      automaticallyImplyLeading: false,
      elevation: 0,
      centerTitle: false,
      titleSpacing: 8,
      surfaceTintColor: Colors.transparent,
      actions: actions,
    );
  }
}
