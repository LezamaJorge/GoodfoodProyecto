
// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:restaurant/app/widget/global_widgets.dart';
import 'package:restaurant/app/widget/text_widget.dart';
import 'package:restaurant/constant/constant.dart';
import 'package:restaurant/themes/app_fonts.dart';
import 'package:restaurant/themes/app_theme_data.dart';
import 'package:restaurant/utils/dark_theme_provider.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../controllers/splash_screen_controller.dart';

class SplashScreenView extends GetView<SplashScreenController> {

  const SplashScreenView({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetBuilder(
      init: SplashScreenController(),
      builder: (GetxController controller) {
        return Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: themeChange.isDarkTheme() ? [Color(0xff020218), Color(0xff180202)] : [Color(0xffE7E7FD), Color(0xffFDE7E7)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter)),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  "assets/images/logo.svg",
                height: 96.h,
                  width: 96.h,
                ),
                spaceH(height: 16),
                Obx(
                  ()=> TextCustom(
                    title: Constant.appName.value,
                    fontSize: 20,
                    fontFamily: FontFamily.bold,
                    color: themeChange.isDarkTheme() ? AppThemeData.grey100 : AppThemeData.grey900,
                  ),
                ),
                const TextCustom(
                  title: "Quick Bites, Big Delights",
                  fontSize: 14,
                  fontFamily: FontFamily.italic,
                  color: AppThemeData.grey600,
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
