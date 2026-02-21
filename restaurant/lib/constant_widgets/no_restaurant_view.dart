// ignore_for_file: deprecated_member_use, depend_on_referenced_packages

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:restaurant/app/modules/add_restaurant_screen/views/add_restaurant_screen_view.dart';
import 'package:restaurant/app/modules/restaurant_screen/controllers/restaurant_screen_controller.dart';
import 'package:restaurant/app/widget/global_widgets.dart';
import 'package:restaurant/app/widget/text_widget.dart';
import 'package:restaurant/constant/constant.dart';
import 'package:restaurant/themes/app_fonts.dart';
import 'package:restaurant/themes/app_theme_data.dart';
import 'package:restaurant/themes/responsive.dart';
import 'package:restaurant/utils/dark_theme_provider.dart';

import '../themes/screen_size.dart';
import 'round_shape_button.dart';

class NoRestaurantView extends StatelessWidget {
  final double? height;
  final RestaurantScreenController controller;

  const NoRestaurantView({
    super.key,
    required this.themeChange,
    this.height,
    required this.controller,
  });

  final DarkThemeProvider themeChange;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Responsive.width(100, context),
      height: Responsive.height(100, context),
      decoration: BoxDecoration(
          gradient: LinearGradient(
              stops: const [0.1, 0.3],
              colors: themeChange.isDarkTheme() ? [const Color(0xff180202), const Color(0xff1C1C22)] : [const Color(0xffFDE7E7), const Color(0xffFAFAFA)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter)),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          systemOverlayStyle: const SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: Brightness.dark, // Android → black
            statusBarBrightness: Brightness.light, // iOS → black
          ),
          title: Row(
            children: [
              SizedBox(
                height: 28,
                width: 28,
                child: SvgPicture.asset(
                  "assets/images/logo.svg",
                  color: AppThemeData.primary300,
                ),
              ),
              spaceW(),
              TextCustom(
                title: Constant.appName.value,
                fontSize: 20,
                color: AppThemeData.primary300,
                fontFamily: FontFamily.bold,
              ),
            ],
          ),
          actions: [
            Container(
              height: 36.h,
              width: 36.w,
              decoration: BoxDecoration(color: themeChange.isDarkTheme() ? AppThemeData.grey900 : AppThemeData.grey100, shape: BoxShape.circle),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SvgPicture.asset(
                  "assets/icons/ic_wallet.svg",
                  color: themeChange.isDarkTheme() ? AppThemeData.grey200 : AppThemeData.grey800,
                ),
              ),
            ),
            spaceW(),
            Container(
              height: 36.h,
              width: 36.w,
              decoration: BoxDecoration(color: themeChange.isDarkTheme() ? AppThemeData.grey900 : AppThemeData.grey100, shape: BoxShape.circle),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SvgPicture.asset(
                  "assets/icons/ic_bell.svg",
                  color: themeChange.isDarkTheme() ? AppThemeData.grey200 : AppThemeData.grey800,
                ),
              ),
            ),
            spaceW()
          ],
        ),
        body: Container(
          color: Colors.transparent,
          height: height ?? Responsive.height(75, context),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                child: Image.asset(
                  "assets/images/no_restaurant.png",
                  height: 140.0,
                  width: 140.0,
                ),
              ),
              TextCustom(
                title: "No Restaurants Found".tr,
                fontSize: 18,
                fontFamily: FontFamily.bold,
                color: themeChange.isDarkTheme() ? AppThemeData.grey200 : AppThemeData.grey800,
              ),
              spaceH(height: 4),
              Padding(
                padding: paddingEdgeInsets(horizontal: 53.w, vertical: 0),
                child: TextCustom(
                  title: "Looks like there are no restaurants listed yet. Start by adding your restaurant to get started!".tr,
                  maxLine: 3,
                  fontSize: 14,
                  fontFamily: FontFamily.regular,
                  color: themeChange.isDarkTheme() ? AppThemeData.grey400 : AppThemeData.grey600,
                ),
              ),
              spaceH(height: 4),
              RichText(
                text: TextSpan(text: 'Click add button to '.tr, style: TextStyle(fontSize: 16, color: AppThemeData.primary300, fontFamily: FontFamily.regular), children: [
                  TextSpan(
                    text: 'add the restaurant'.tr,
                    style: TextStyle(fontSize: 16, color: AppThemeData.primary300, fontFamily: FontFamily.regular, decoration: TextDecoration.underline),
                    recognizer: TapGestureRecognizer()..onTap = () => Get.to(() => AddRestaurantScreenView()),
                  )
                ]),
              ),
              spaceH(height: 24),
              Center(
                child: RoundShapeButton(
                    size: Size(358.w, ScreenSize.height(6, context)),
                    title: "Add Restaurant".tr,
                    buttonColor: AppThemeData.primary300,
                    buttonTextColor: AppThemeData.primaryWhite,
                    onTap: () {
                      Get.to(() => AddRestaurantScreenView())!.then(
                        (value) async {
                          if (value == true) {
                            await controller.getData();
                          }
                        },
                      );
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
