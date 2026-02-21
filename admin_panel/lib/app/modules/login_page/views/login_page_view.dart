// ignore_for_file: strict_top_level_inference

import 'package:admin_panel/app/components/custom_button.dart';
import 'package:admin_panel/app/components/custom_text_form_field.dart';
import 'package:admin_panel/app/constant/constants.dart';
import 'package:admin_panel/app/constant/show_toast.dart';
import 'package:admin_panel/app/utils/app_colors.dart';
import 'package:admin_panel/app/utils/app_them_data.dart';
import 'package:admin_panel/app/utils/dark_theme_provider.dart';
import 'package:admin_panel/app/utils/responsive.dart';
import 'package:admin_panel/widget/global_widgets.dart';
import 'package:admin_panel/widget/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';
import '../controllers/login_page_controller.dart';
import 'widget/top_widget.dart';

class LoginPageView extends GetView<LoginPageController> {
  const LoginPageView({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);

    return ResponsiveWidget(
      mobile: Scaffold(
        backgroundColor: themeChange.isDarkTheme() ? AppThemeData.primaryBlack : AppThemeData.primaryWhite,
        body: Center(
            child: SingleChildScrollView(
          child: Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width * 0.9,
              color: themeChange.isDarkTheme() ? AppThemeData.primaryBlack : AppThemeData.primaryWhite,
              child: Stack(
                alignment: Alignment.topCenter,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      30.height,
                      buildTopWidget(context, 'Unlock Your Admin Dashboard'.tr, 'Manage orders, restaurants, and deliveries seamlessly.'.tr, AppThemeData.primary500),
                      32.height,
                      CustomTextFormField(
                        title: "".tr,
                        hintText: "Enter your email".tr,
                        controller: controller.emailController,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return ("Please enter your email".tr);
                          }
                          // reg expression for email validatio
                          if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]").hasMatch(value)) {
                            return ("Please enter a valid email".tr);
                          }
                          return null;
                        },
                      ),
                      16.height,
                      CustomTextFormField(
                        title: "".tr,
                        hintText: "Enter your password".tr,
                        controller: controller.passwordController,
                        suffix: InkWell(
                            onTap: () {
                              controller.isPasswordVisible.value = !controller.isPasswordVisible.value;
                            },
                            child: Icon(
                              controller.isPasswordVisible.value ? Icons.visibility_off : Icons.visibility,
                              color: AppThemeData.gallery500,
                            )),
                        obscureText: controller.isPasswordVisible.value,
                        validator: (value) {
                          RegExp regex = RegExp(r'^.{6,}$');
                          if (value!.isEmpty) {
                            return ("Please enter your password".tr);
                          }
                          if (!regex.hasMatch(value)) {
                            return ("Enter valid password(Min. 6 Character)".tr);
                          }
                          return null;
                        },
                      ),
                      spaceH(height: 52.h),
                      CustomButtonWidget(
                        // height: MediaQuery.of(context).size.height * 0.05,
                        padding: const EdgeInsets.symmetric(horizontal: 22),
                        title: "LOGIN".tr,
                        buttonColor: AppThemeData.primary500,
                        textColor: themeChange.isDarkTheme() ? AppThemeData.primaryBlack : AppThemeData.primaryWhite,
                        onPress: () async {
                          if (controller.emailController.value.text.isEmpty || controller.passwordController.value.text.isEmpty) {
                            ShowToastDialog.errorToast("Please enter valid information.".tr);
                            return;
                          } else {
                            await controller.checkAndLoginOrCreateAdmin();
                          }
                        },
                      ),
                      30.height,
                      loginCredential(themeChange),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: paddingEdgeInsets(horizontal: 0, vertical: 32),
                        child: SizedBox(
                          height: 50,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Image.asset(
                                "assets/image/logo.png",
                                height: 34,
                              ),
                              spaceW(),
                              TextCustom(
                                title: '${Constant.appName}',
                                color: AppThemeData.primary500,
                                fontSize: 25,
                                fontFamily: FontFamily.titleBold,
                                fontWeight: FontWeight.w600,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              )),
        )),
      ),
      desktop: Scaffold(
        backgroundColor: themeChange.isDarkTheme() ? AppThemeData.primaryBlack : AppThemeData.primaryWhite,
        body: Center(
            child: Container(
          color: themeChange.isDarkTheme() ? AppThemeData.primaryBlack : AppThemeData.primaryWhite,
          child: Row(
            children: [
              Expanded(
                flex: 5,
                child: SizedBox(
                  height: double.infinity,
                  width: MediaQuery.of(context).size.width * 0.68,
                  child: Container(
                    decoration: const BoxDecoration(
                        color: Color(0xFFfff8f0),
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: AssetImage('assets/image/login_bg.png'),
                        )),
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Stack(
                  alignment: Alignment.topCenter,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.20,
                      // color: Colors.pink,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          30.height,
                          buildTopWidget(context, 'Unlock Your Admin Dashboard'.tr, 'Manage orders, restaurants, and deliveries seamlessly.'.tr, AppThemeData.primary500),
                          32.height,
                          CustomTextFormField(
                            title: "".tr,
                            hintText: "Enter your email".tr,
                            controller: controller.emailController,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return ("Please enter your email".tr);
                              }
                              // reg expression for email validatio
                              if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]").hasMatch(value)) {
                                return ("Please enter a valid email".tr);
                              }
                              return null;
                            },
                          ),
                          16.height,
                          Obx(
                            () => CustomTextFormField(
                              title: "".tr,
                              hintText: "Enter your password".tr,
                              controller: controller.passwordController,
                              obscureText: controller.isPasswordVisible.value,
                              validator: (value) {
                                RegExp regex = RegExp(r'^.{6,}$');
                                if (value!.isEmpty) {
                                  return ("Please enter your password".tr);
                                }
                                if (!regex.hasMatch(value)) {
                                  return ("Enter valid password(Min. 6 Character)".tr);
                                }
                                return null;
                              },
                              suffix: InkWell(
                                  onTap: () {
                                    controller.isPasswordVisible.value = !controller.isPasswordVisible.value;
                                  },
                                  child: Icon(
                                    controller.isPasswordVisible.value ? Icons.visibility_off : Icons.visibility,
                                    color: AppThemeData.gallery500,
                                  )),
                            ),
                          ),
                          spaceH(height: 52.h),
                          CustomButtonWidget(
                            // height: MediaQuery.of(context).size.height * 0.05,
                            padding: const EdgeInsets.symmetric(horizontal: 22),
                            title: "LOGIN".tr,
                            buttonColor: AppThemeData.primary500,
                            textColor: themeChange.isDarkTheme() ? AppThemeData.primaryBlack : AppThemeData.primaryWhite,
                            onPress: () async {
                              if (controller.emailController.value.text.isEmpty || controller.passwordController.value.text.isEmpty) {
                                ShowToastDialog.errorToast("Please enter valid information.".tr);
                                return;
                              } else {
                                await controller.checkAndLoginOrCreateAdmin();
                              }
                            },
                          ),
                          30.height,
                          loginCredential(themeChange),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: paddingEdgeInsets(horizontal: 32, vertical: 32),
                          child: SizedBox(
                            height: 50,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Image.asset(
                                  "assets/image/logo.png",
                                  height: 34,
                                ),
                                spaceW(),
                                TextCustom(
                                  title: '${Constant.appName}',
                                  color: AppThemeData.primary500,
                                  fontSize: 25,
                                  fontFamily: FontFamily.titleBold,
                                  fontWeight: FontWeight.w600,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        )),
      ),
      tablet: Scaffold(
        backgroundColor: themeChange.isDarkTheme() ? AppThemeData.primaryBlack : AppThemeData.primaryWhite,
        body: Center(
            child: Container(
          color: themeChange.isDarkTheme() ? AppThemeData.primaryBlack : AppThemeData.primaryWhite,
          child: Row(
            children: [
              SizedBox(
                height: double.infinity,
                width: MediaQuery.of(context).size.width * 0.56,
                child: Container(
                  decoration: const BoxDecoration(
                      color: Color(0xFFfff8f0),
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: AssetImage('assets/image/login_bg.png'),
                      )),
                ),
              ),
              const Spacer(),
              SizedBox(
                  width: MediaQuery.of(context).size.width * 0.35,
                  child: Stack(
                    alignment: Alignment.topCenter,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          30.height,
                          buildTopWidget(context, 'Unlock Your Admin Dashboard', 'Manage orders, restaurants, and deliveries seamlessly.', AppThemeData.primary500),
                          32.height,
                          CustomTextFormField(
                            title: "".tr,
                            hintText: "Enter your email".tr,
                            controller: controller.emailController,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return ("Please enter your email".tr);
                              }
                              // reg expression for email validatio
                              if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]").hasMatch(value)) {
                                return ("Please enter a valid email".tr);
                              }
                              return null;
                            },
                          ),
                          16.height,
                          Obx(
                            () => CustomTextFormField(
                              title: "".tr,
                              hintText: "Enter your password".tr,
                              controller: controller.passwordController,
                              obscureText: controller.isPasswordVisible.value,
                              validator: (value) {
                                RegExp regex = RegExp(r'^.{6,}$');
                                if (value!.isEmpty) {
                                  return ("Please enter your password".tr);
                                }
                                if (!regex.hasMatch(value)) {
                                  return ("Enter valid password(Min. 6 Character)".tr);
                                }
                                return null;
                              },
                              suffix: InkWell(
                                  onTap: () {
                                    controller.isPasswordVisible.value = !controller.isPasswordVisible.value;
                                  },
                                  child: Icon(
                                    controller.isPasswordVisible.value ? Icons.visibility_off : Icons.visibility,
                                    color: AppThemeData.gallery500,
                                  )),
                            ),
                          ),
                          spaceH(height: 52.h),
                          CustomButtonWidget(
                            // height: MediaQuery.of(context).size.height * 0.05,
                            padding: const EdgeInsets.symmetric(horizontal: 22),
                            title: "LOGIN".tr,
                            buttonColor: AppThemeData.primary500,
                            textColor: themeChange.isDarkTheme() ? AppThemeData.primaryBlack : AppThemeData.primaryWhite,
                            onPress: () async {
                              if (controller.emailController.value.text.isEmpty || controller.passwordController.value.text.isEmpty) {
                                ShowToastDialog.errorToast("Please enter valid information.".tr);
                                return;
                              } else {
                                await controller.checkAndLoginOrCreateAdmin();
                              }
                            },
                          ),
                          30.height,
                          loginCredential(themeChange),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Padding(
                            padding: paddingEdgeInsets(vertical: 32),
                            child: SizedBox(
                              height: 50,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    "assets/image/logo.png",
                                    height: 34,
                                  ),
                                  spaceW(),
                                  TextCustom(
                                    title: '${Constant.appName}',
                                    color: AppThemeData.primary500,
                                    fontSize: 25,
                                    fontFamily: FontFamily.titleBold,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  )),
              const Spacer(),
            ],
          ),
        )),
      ),
    );
  }

  SizedBox loginCredential(themeChange) {
    return SizedBox(
      child: Container(
        decoration: BoxDecoration(color: themeChange.isDarkTheme() ? AppThemeData.lynch950 : AppThemeData.lynch50, borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextCustom(
                title: "Credentials : ".tr,
                fontSize: 14,
                fontFamily: FontFamily.medium,
                color: themeChange.isDarkTheme() ? AppThemeData.primaryWhite : AppThemeData.primaryBlack,
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Email : admin@go4food.com",
                          style: TextStyle(
                            fontFamily: FontFamily.medium,
                            fontSize: 14,
                            color: themeChange.isDarkTheme() ? AppThemeData.primaryWhite : AppThemeData.primaryBlack,
                          ),
                        ),
                        Text(
                          "Password : 123456",
                          style: TextStyle(
                            fontFamily: FontFamily.medium,
                            fontSize: 14,
                            color: themeChange.isDarkTheme() ? AppThemeData.primaryWhite : AppThemeData.primaryBlack,
                          ),
                        ),
                      ],
                    ),
                  ),
                  InkWell(
                      onTap: () async {
                        controller.emailController.text = "admin@go4food.com";
                        controller.passwordController.text = "123456";
                      },
                      child: Icon(
                        Icons.copy,
                        color: themeChange.isDarkTheme() ? AppThemeData.primaryWhite : AppThemeData.primaryBlack,
                        size: 14,
                      ))
                ],
              ),

            ],
          ),
        ),
      ),
    );
  }
}
