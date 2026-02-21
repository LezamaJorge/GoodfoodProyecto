
// ignore_for_file: deprecated_member_use, depend_on_referenced_packages

import 'dart:io';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:restaurant/app/modules/login_screen/controllers/login_screen_controller.dart';
import 'package:restaurant/app/modules/login_screen/views/login_screen_view.dart';
import 'package:restaurant/app/modules/signup_screen/views/signup_screen_view.dart';
import 'package:restaurant/app/widget/global_widgets.dart';
import 'package:restaurant/app/widget/text_widget.dart';
import 'package:restaurant/constant/constant.dart';
import 'package:restaurant/constant_widgets/round_shape_button.dart';
import 'package:restaurant/themes/app_fonts.dart';
import 'package:restaurant/themes/app_theme_data.dart';
import 'package:restaurant/themes/screen_size.dart';
import 'package:restaurant/utils/dark_theme_provider.dart';

class LandingScreenView extends StatelessWidget {
  const LandingScreenView({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetBuilder(
        init: LoginScreenController(),
        builder: (controller) {
          return Container(
            height: ScreenSize.height(100, context),
            width: ScreenSize.width(100, context),
            decoration: const BoxDecoration(image: DecorationImage(image: AssetImage("assets/images/landing_page.png"), fit: BoxFit.fill)),
            child: Padding(
              padding: paddingEdgeInsets(),
              child: Column(
                children: [
                  spaceH(height: 412.h),
                  TextCustom(
                    title: 'join_app'.trParams({'appName': Constant.appName.value}),
                    color: AppThemeData.grey50,
                    fontSize: 28,
                    fontFamily: FontFamily.bold,
                  ),
                  TextCustom(
                    title: "Create an account to start managing your restaurant.".tr,
                    maxLine: 2,
                    color: AppThemeData.grey50,
                    fontSize: 16,
                    fontFamily: FontFamily.light,
                  ),
                  spaceH(height: 32),
                  RoundShapeButton(
                      size: Size(358.w, ScreenSize.height(6, context)),
                      title: "Sign up".tr,
                      buttonColor: AppThemeData.primary300,
                      buttonTextColor: themeChange.isDarkTheme() ? AppThemeData.grey1000 : AppThemeData.grey100,
                      onTap: () {
                        Get.to(()=>SignupScreenView(), arguments: {"type": Constant.emailLoginType} );
                      }),
                  spaceH(height: 12),
                  RoundShapeButton(
                    titleWidget: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          "assets/icons/ic_google.svg",
                        ),
                        const Spacer(),
                        Text(
                          "Continue with Google".tr,
                          style: TextStyle(fontFamily: FontFamily.medium, color: themeChange.isDarkTheme() ? AppThemeData.grey100 : AppThemeData.grey1000, fontSize: 16),
                        ),
                        const Spacer(),
                      ],
                    ),
                    buttonColor: themeChange.isDarkTheme() ? AppThemeData.grey900 : AppThemeData.grey50,
                    buttonTextColor: themeChange.isDarkTheme() ? AppThemeData.grey1000 : AppThemeData.grey100,
                    onTap: () {
                      controller.loginWithGoogle();
                    },
                    size: Size(358.w, ScreenSize.height(6, context)),
                    title: '',
                  ),
                  spaceH(height: 12),
                  if (Platform.isIOS)
                  RoundShapeButton(
                    titleWidget: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          "assets/icons/ic_apple.svg",
                          color: themeChange.isDarkTheme() ? AppThemeData.grey100 : AppThemeData.grey1000,
                        ),
                        const Spacer(),
                        Text(
                          "Continue with Apple".tr,
                          style: TextStyle(fontFamily: FontFamily.medium, color: themeChange.isDarkTheme() ? AppThemeData.grey100 : AppThemeData.grey1000, fontSize: 16),
                        ),
                        const Spacer(),
                      ],
                    ),
                    buttonColor: themeChange.isDarkTheme() ? AppThemeData.grey900 : AppThemeData.grey50,
                    buttonTextColor: themeChange.isDarkTheme() ? AppThemeData.grey1000 : AppThemeData.grey100,
                    onTap: () {
                      controller.loginWithApple();
                    },
                    size: Size(358.w, ScreenSize.height(6, context)),
                    title: '',
                  ),
                  const Spacer(),
                    Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        RichText(
                          text: TextSpan(
                              text: 'Already have an account? '.tr,
                              style: const TextStyle(fontSize: 14, color: AppThemeData.grey50, fontFamily: FontFamily.regular),
                              children: [
                                TextSpan(
                                  text: 'Log in'.tr,
                                  style: TextStyle(fontSize: 14, color: AppThemeData.primary300, fontFamily: FontFamily.medium, decoration: TextDecoration.underline),
                                  recognizer: TapGestureRecognizer()..onTap = () => Get.to(()=>LoginScreenView()),
                                )
                              ]),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }
}
