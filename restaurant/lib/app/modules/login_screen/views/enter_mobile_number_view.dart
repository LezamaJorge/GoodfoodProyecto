// ignore_for_file: deprecated_member_use, must_be_immutable, depend_on_referenced_packages, use_super_parameters

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:restaurant/app/modules/landing_screen/views/landing_screen_view.dart';
import 'package:restaurant/app/modules/login_screen/controllers/login_screen_controller.dart';
import 'package:restaurant/app/widget/global_widgets.dart';
import 'package:restaurant/app/widget/text_field_widget.dart';
import 'package:restaurant/constant/show_toast_dialogue.dart';
import 'package:restaurant/constant_widgets/round_shape_button.dart';
import 'package:restaurant/themes/app_fonts.dart';
import 'package:restaurant/themes/app_theme_data.dart';
import 'package:restaurant/utils/dark_theme_provider.dart';

import '../../../../themes/screen_size.dart';

class EnterMobileNumberScreenView extends GetView<LoginScreenController> {
  EnterMobileNumberScreenView({super.key});

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetBuilder(
      init: LoginScreenController(),
      builder: (controller) {
        controller.mobileNumberController.value.addListener(() => controller.checkFieldsFilled());
        return Scaffold(
          appBar: AppBar(
            systemOverlayStyle: const SystemUiOverlayStyle(
              statusBarColor: Colors.transparent,
              statusBarIconBrightness: Brightness.dark, // Android → black
              statusBarBrightness: Brightness.light,    // iOS → black
            ),
            backgroundColor: Colors.transparent,
            leading: GestureDetector(
              onTap: () {
                Get.back();
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: themeChange.isDarkTheme() ? AppThemeData.grey900 : AppThemeData.grey100,
                  ),
                  child: Icon(
                    Icons.arrow_back_ios_sharp,
                    size: 20,
                    color: themeChange.isDarkTheme() ? AppThemeData.grey100 : AppThemeData.grey900,
                  ),
                ),
              ),
            ),
          ),
          backgroundColor: themeChange.isDarkTheme() ? AppThemeData.grey1000 : AppThemeData.grey50,
          body: Form(
            key: formKey,
            child: SingleChildScrollView(
                child: Padding(
              padding: paddingEdgeInsets(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  buildTopWidget(context),
                  buildMobileNumberWidget(context),
                  spaceH(height: 130.h),
                  Obx(
                    () => Row(
                      children: [
                        Expanded(
                          child: RoundShapeButton(
                            title: "Get OTP".tr,
                            buttonColor: controller.isMobileNumberButtonEnabled.value
                                ? AppThemeData.primary300
                                : themeChange.isDarkTheme()
                                    ? AppThemeData.grey800
                                    : AppThemeData.grey200,
                            buttonTextColor: controller.isMobileNumberButtonEnabled.value
                                ? themeChange.isDarkTheme()
                                    ? AppThemeData.grey1000
                                    : AppThemeData.grey50
                                : AppThemeData.grey500,
                            onTap: () {
                              if (controller.mobileNumberController.value.text.isNotEmpty) {
                                controller.sendCode();
                              } else {
                                ShowToastDialog.toast('Invalid phone number. Please enter a valid number.'.tr);
                              }
                            },
                            size: Size(358.w, ScreenSize.height(6, context)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )),
          ),
          bottomNavigationBar: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                RichText(
                  text: TextSpan(
                      text: 'Already have an account? '.tr,
                      style: TextStyle(fontSize: 16, color: themeChange.isDarkTheme() ? AppThemeData.grey200 : AppThemeData.grey800, fontFamily: FontFamily.regular),
                      children: [
                        TextSpan(
                          text: 'Log in'.tr,
                          style: TextStyle(fontSize: 16, color: AppThemeData.primary300, fontFamily: FontFamily.medium, decoration: TextDecoration.underline),
                          recognizer: TapGestureRecognizer()..onTap = () => Get.to(() => LandingScreenView()),
                        )
                      ]),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  SizedBox buildTopWidget(BuildContext context) {
    try {
      final themeChange = Provider.of<DarkThemeProvider>(context);
      return SizedBox(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Enter Your Mobile Number".tr,
              style: TextStyle(
                fontFamily: FontFamily.bold,
                fontSize: 28,
                color: themeChange.isDarkTheme() ? AppThemeData.grey50 : AppThemeData.grey1000,
              ),
            ),
            Text(
              "Provide your mobile number for order updates.".tr,
              style: TextStyle(
                fontSize: 16,
                fontFamily: FontFamily.regular,
                color: themeChange.isDarkTheme() ? AppThemeData.grey400 : AppThemeData.grey600,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    } catch (e) {
      return const SizedBox.shrink();
    }
  }

  MobileNumberTextField buildMobileNumberWidget(BuildContext context) {
    try {
      return MobileNumberTextField(
        controller: controller.mobileNumberController.value,
        countryCode: controller.countryCode.value!,
        onPress: () {},
        title: "Mobile Number",
      );
    } catch (e) {
      return MobileNumberTextField(
        controller: TextEditingController(),
        countryCode: '+91',
        onPress: () {},
        title: "Mobile Number",
      );
    }
  }
}
