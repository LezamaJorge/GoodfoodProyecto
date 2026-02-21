import 'package:admin_panel/app/utils/app_colors.dart';
import 'package:admin_panel/app/utils/app_them_data.dart';
import 'package:admin_panel/app/utils/dark_theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

SizedBox buildTopWidget(BuildContext context,String title,String description,Color  color) {
  final themeChange = Provider.of<DarkThemeProvider>(context);

  return SizedBox(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          textAlign: TextAlign.start,
          text: TextSpan(
            children: [
              TextSpan(
                  text: title,
                  style: TextStyle(
                    fontFamily: FontFamily.bold,
                    fontSize: 24,
                    color: themeChange.isDarkTheme() ? AppThemeData.lynch200 : AppThemeData.lynch800,
                    fontWeight: FontWeight.w400,
                  )),
            ],
          ),
        ),
        Text(description,
            style: TextStyle(
              fontFamily: FontFamily.regular,
              fontSize: 14,
              color: themeChange.isDarkTheme() ? AppThemeData.lynch300 : AppThemeData.lynch400,
              fontWeight: FontWeight.w400,
            ),
            textAlign: TextAlign.start),
      ],
    ),
  );
}
