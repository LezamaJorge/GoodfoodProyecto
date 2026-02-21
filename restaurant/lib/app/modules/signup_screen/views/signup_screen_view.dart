// ignore_for_file: must_be_immutable, use_super_parameters, depend_on_referenced_packages, deprecated_member_use

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';
import 'package:restaurant/app/modules/login_screen/views/login_screen_view.dart';
import 'package:restaurant/app/widget/global_widgets.dart';
import 'package:restaurant/app/widget/text_field_widget.dart';
import 'package:restaurant/constant/constant.dart';
import 'package:restaurant/constant/show_toast_dialogue.dart';
import 'package:restaurant/constant_widgets/round_shape_button.dart';
import 'package:restaurant/themes/app_fonts.dart';
import 'package:restaurant/themes/app_theme_data.dart';
import 'package:restaurant/utils/dark_theme_provider.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../themes/screen_size.dart';
import '../controllers/signup_screen_controller.dart';

class SignupScreenView extends GetView<SignupScreenController> {
  SignupScreenView({super.key});
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetBuilder(
      init: SignupScreenController(),
      builder: (controller) {
        controller.firstNameController.value.addListener(() => controller.checkFieldsFilled());
        controller.lastNameController.value.addListener(() => controller.checkFieldsFilled());
        controller.mobileNumberController.value.addListener(() => controller.checkFieldsFilled());
        controller.emailController.value.addListener(() => controller.checkFieldsFilled());
        controller.passwordController.value.addListener(() => controller.checkFieldsFilled());
        controller.confirmPasswordController.value.addListener(() => controller.checkFieldsFilled());

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
                child: Stack(
              children: [
                Padding(
                  padding: paddingEdgeInsets(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      buildTopWidget(context),
                      buildEmailPasswordWidget(context),
                      34.height,
                      Obx(
                        () => Row(
                          children: [
                            Expanded(
                              child: RoundShapeButton(
                                title: "Save and Continue".tr,
                                buttonColor: controller.isFirstButtonEnabled.value
                                    ? AppThemeData.primary300
                                    : themeChange.isDarkTheme()
                                        ? AppThemeData.grey800
                                        : AppThemeData.grey200,
                                buttonTextColor: controller.isFirstButtonEnabled.value
                                    ? themeChange.isDarkTheme()
                                        ? AppThemeData.grey1000
                                        : AppThemeData.grey50
                                    : AppThemeData.grey500,
                                onTap: () async {
                                  if (formKey.currentState!.validate()) {
                                    if (controller.loginType.value == Constant.emailLoginType) {
                                      if (controller.passwordController.value.text == controller.confirmPasswordController.value.text) {
                                        await controller.signUp();
                                      } else {
                                        ShowToastDialog.toast('Passwords do not match. Please Enter Same Password.'.tr);
                                      }
                                    } else {
                                      controller.saveData();
                                    }
                                  } else {
                                    ShowToastDialog.toast('Please fill in all required fields.'.tr);
                                  }
                                },
                                size: Size(358.w, ScreenSize.height(6, context)),
                              ),
                            ),
                          ],
                        ),
                      ),
                      spaceH(height: 20),
                    ],
                  ),
                ),
              ],
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
                          recognizer: TapGestureRecognizer()..onTap = () => Get.to(() => LoginScreenView()),
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
              "Enter Basic Details".tr,
              style: TextStyle(
                fontFamily: FontFamily.bold,
                fontSize: 24,
                color: themeChange.isDarkTheme() ? AppThemeData.grey50 : AppThemeData.grey900,
              ),
            ),
            Text(
              "Please enter your basic details to set up your profile.".tr,
              style: TextStyle(
                fontSize: 14,
                fontFamily: FontFamily.regular,
                color: themeChange.isDarkTheme() ? AppThemeData.grey50 : AppThemeData.grey900,
              ),
              textAlign: TextAlign.center,
            ),
            24.height,
          ],
        ),
      );
    } catch (e) {
      return const SizedBox(
        child: Text(
          "Error loading header",
          style: TextStyle(color: Colors.red),
        ),
      );
    }
  }

  Column buildEmailPasswordWidget(BuildContext context) {
    try {
      final themeChange = Provider.of<DarkThemeProvider>(context);
      return Column(
        children: [
          TextFieldWidget(
            title: "First Name".tr,
            hintText: "Enter First Name".tr,
            validator: (value) => value != null && value.isNotEmpty ? null : 'This field required'.tr,
            controller: controller.firstNameController.value,
            onPress: () {},
          ),
          TextFieldWidget(
            title: "Last Name".tr,
            hintText: "Enter Last Name".tr,
            validator: (value) => value != null && value.isNotEmpty ? null : 'This field required'.tr,
            controller: controller.lastNameController.value,
            onPress: () {},
          ),
          MobileNumberTextField(
            controller: controller.mobileNumberController.value,
            countryCode: controller.countryCode.value!,
            onPress: () {},
            title: "Mobile Number",
            readOnly: controller.ownerModel.value.loginType == Constant.phoneLoginType,
          ),
          Obx(
            () => Column(
              children: [
                TextFieldWidget(
                  title: "Email".tr,
                  hintText: "Enter Email".tr,
                  validator: (value) => Constant.validateEmail(value),
                  controller: controller.emailController.value,
                  onPress: () {},
                  readOnly: (controller.ownerModel.value.loginType == Constant.googleLoginType || controller.ownerModel.value.loginType == Constant.appleLoginType),
                ),
              ],
            ),
          ),
          if (controller.loginType.value == Constant.emailLoginType)
            Obx(() => Column(
                  children: [
                    TextFieldWidget(
                      title: "Password".tr,
                      hintText: "Enter Password".tr,
                      validator: (value) => Constant.validatePassword(value),
                      controller: controller.passwordController.value,
                      obscureText: controller.isPasswordVisible.value,
                      suffix: SvgPicture.asset(
                        controller.isPasswordVisible.value ? "assets/icons/ic_hide_password.svg" : "assets/icons/ic_show_password.svg",
                        color: themeChange.isDarkTheme() ? AppThemeData.grey200 : AppThemeData.grey800,
                      ).onTap(() {
                        controller.isPasswordVisible.value = !controller.isPasswordVisible.value;
                      }),
                      onPress: () {},
                    ),
                    Obx(() => TextFieldWidget(
                          title: "Confirm Password".tr,
                          hintText: "Enter Confirm Password".tr,
                          validator: (value) => Constant.validatePassword(value),
                          controller: controller.confirmPasswordController.value,
                          obscureText: controller.isPasswordVisible.value,
                          suffix: SvgPicture.asset(
                            controller.isPasswordVisible.value ? "assets/icons/ic_hide_password.svg" : "assets/icons/ic_show_password.svg",
                            color: themeChange.isDarkTheme() ? AppThemeData.grey200 : AppThemeData.grey800,
                          ).onTap(() {
                            controller.isPasswordVisible.value = !controller.isPasswordVisible.value;
                          }),
                          onPress: () {},
                        )),
                  ],
                )),
        ],
      );
    } catch (e) {
      return Column(
        children: const [
          Text(
            "Failed to load email/password fields",
            style: TextStyle(color: Colors.red),
          )
        ],
      );
    }
  }
}
