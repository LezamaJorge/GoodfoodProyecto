// ignore_for_file: deprecated_member_use, depend_on_referenced_packages, use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:restaurant/app/modules/add_restaurant_screen/views/widget/upload_document.dart';
import 'package:restaurant/app/modules/all_orders/views/all_orders_view.dart';
import 'package:restaurant/app/modules/driver_details/views/driver_details_views.dart';
import 'package:restaurant/app/modules/edit_profile_screen/views/edit_profile_screen_view.dart';
import 'package:restaurant/app/modules/language_screen/views/language_screen_view.dart';
import 'package:restaurant/app/modules/login_screen/views/login_screen_view.dart';
import 'package:restaurant/app/modules/my_bank/views/my_bank_view.dart';
import 'package:restaurant/app/modules/my_wallet/views/my_wallet_view.dart';
import 'package:restaurant/app/modules/notification_screen/views/notification_screen_view.dart';
import 'package:restaurant/app/modules/privacy_policy_screen/views/privacy_policy_screen_view.dart';
import 'package:restaurant/app/modules/profile_screen/controllers/profile_screen_controller.dart';
import 'package:restaurant/app/modules/statement_screen/views/statement_view.dart';
import 'package:restaurant/app/widget/global_widgets.dart';
import 'package:restaurant/app/widget/network_image_widget.dart';
import 'package:restaurant/app/widget/text_widget.dart';
import 'package:restaurant/constant/constant.dart';
import 'package:restaurant/constant_widgets/custom_dialog_box.dart';
import 'package:restaurant/constant_widgets/round_shape_button.dart';
import 'package:restaurant/themes/app_fonts.dart';
import 'package:restaurant/themes/app_theme_data.dart';
import 'package:restaurant/themes/responsive.dart';
import 'package:restaurant/themes/screen_size.dart';
import 'package:restaurant/utils/dark_theme_provider.dart';

import '../../../../constant/show_toast_dialogue.dart';

class ProfileScreenView extends StatelessWidget {
  const ProfileScreenView({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetX(
        autoRemove: false,
        init: ProfileScreenController(),
        builder: (controller) {
          return Container(
            width: Responsive.width(100, context),
            height: Responsive.height(100, context),
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    stops: const [0.1, 0.3],
                    colors: themeChange.isDarkTheme() ? [Color(0xff180202), Color(0xff1C1C22)] : [Color(0xffFDE7E7), Color(0xffFAFAFA)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter)),
            child: Scaffold(
              backgroundColor: Colors.transparent,
              appBar: AppBar(
                systemOverlayStyle: const SystemUiOverlayStyle(
                  statusBarColor: Colors.transparent,
                  statusBarIconBrightness: Brightness.dark, // Android → black
                  statusBarBrightness: Brightness.light, // iOS → black
                ),
                backgroundColor: Colors.transparent,
                forceMaterialTransparency: true,
                centerTitle: false,
                title: TextCustom(
                  title: "My Profile".tr,
                  fontSize: 28,
                  maxLine: 2,
                  color: themeChange.isDarkTheme() ? AppThemeData.grey100 : AppThemeData.grey1000,
                  fontFamily: FontFamily.bold,
                  textAlign: TextAlign.start,
                ),
              ),
              body: SingleChildScrollView(
                child: Padding(
                  padding: paddingEdgeInsets(vertical: 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextCustom(
                        title: "Manage your personal information and settings here.".tr,
                        fontSize: 16,
                        maxLine: 2,
                        color: themeChange.isDarkTheme() ? AppThemeData.grey400 : AppThemeData.grey600,
                        fontFamily: FontFamily.regular,
                        textAlign: TextAlign.start,
                      ),
                      spaceH(height: 32),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Obx(
                            () => NetworkImageWidget(
                              imageUrl: controller.ownerModel.value.profileImage.toString(),
                              height: 116.w,
                              width: 116.w,
                              borderRadius: 200,
                              fit: BoxFit.cover,
                              isProfile: true,
                            ),
                          ),
                          spaceW(width: 28.w),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Obx(
                                () => SizedBox(
                                  width: ScreenSize.width(50, context),
                                  child: TextCustom(
                                    title: controller.ownerModel.value.fullNameString(),
                                    fontFamily: FontFamily.bold,
                                    fontSize: 18,
                                    textAlign: TextAlign.start,
                                    color: themeChange.isDarkTheme() ? AppThemeData.grey100 : AppThemeData.grey900,
                                  ),
                                ),
                              ),
                              SizedBox(
                                  width: ScreenSize.width(50, context),
                                  child: TextCustom(
                                    title: controller.ownerModel.value.email.toString(),
                                    fontSize: 14,
                                    fontFamily: FontFamily.light,
                                    textAlign: TextAlign.start,
                                    color: themeChange.isDarkTheme() ? AppThemeData.grey400 : AppThemeData.grey600,
                                  ),
                                ),

                              spaceH(height: 24.h),
                              RoundShapeButton(
                                titleWidget: TextCustom(
                                  title: "Edit Profile".tr,
                                  fontSize: 14,
                                  color: themeChange.isDarkTheme() ? AppThemeData.grey50 : AppThemeData.grey50,
                                ),
                                title: "",
                                buttonColor: AppThemeData.primary300,
                                buttonTextColor: themeChange.isDarkTheme() ? AppThemeData.grey1000 : AppThemeData.grey50,
                                onTap: () {
                                  Get.to(() => EditProfileScreenView());
                                },
                                size: Size(140.w, 42.h),
                              ),
                            ],
                          ),
                        ],
                      ),
                      labelWidget(name: "Services".tr),
                      Constant.isSelfDelivery == true
                          ? Padding(
                              padding: paddingEdgeInsets(horizontal: 0, vertical: 4),
                              child: Row(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: themeChange.isDarkTheme() ? AppThemeData.grey900 : AppThemeData.grey50,
                                    ),
                                    height: 46.h,
                                    width: 46.w,
                                    child: Center(
                                      child: SizedBox(
                                        height: 18.h,
                                        width: 18.w,
                                        child: SvgPicture.asset(
                                          "assets/icons/ic_selfdelivery.svg",
                                          color: AppThemeData.pending400,
                                        ),
                                      ),
                                    ),
                                  ),
                                  spaceW(),
                                  TextCustom(
                                    title: "SelfDelivery".tr,
                                    fontSize: 16,
                                    fontFamily: FontFamily.bold,
                                    color: themeChange.isDarkTheme() ? AppThemeData.grey50 : AppThemeData.grey1000,
                                  ),
                                  const Spacer(),
                                  SizedBox(
                                    height: 26.h,
                                    child: FittedBox(
                                      child: CupertinoSwitch(
                                        activeTrackColor: AppThemeData.primary300,
                                        value: controller.isSelfDelivery.value,
                                        onChanged: (value) {
                                          if (Constant.vendorModel != null) {
                                            controller.isSelfDelivery.value = value;
                                            controller.isSelfDeliveryRestaurant();
                                          } else {
                                            ShowToastDialog.toast('First Add your restaurant to change Status.'.tr);
                                          }
                                        },
                                        //   activeColor: themeChange.isDarkTheme() ? AppThemeData.grey1000 : AppThemeData.grey100,
                                        //   inactiveTrackColor: themeChange.isDarkTheme() ? AppThemeData.grey500 : AppThemeData.primaryWhite,
                                        //   inactiveThumbColor: themeChange.isDarkTheme() ? AppThemeData.grey300 : AppThemeData.grey500,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : SizedBox(),
                      (Constant.isSelfDelivery == true && controller.vendorModel.value.isSelfDelivery == true)
                          ? GestureDetector(
                              child: rowWidget(name: "Drivers", icon: "assets/icons/ic_bank.svg"),
                              onTap: () {
                                Get.to(() => DriverDetailsViews());
                              },
                            )
                          : SizedBox(),
                      InkWell(
                        child: rowWidget(name: "My Wallet", icon: "assets/icons/ic_wallet_2.svg"),
                        onTap: () {
                          Get.to(() => MyWalletView());
                        },
                      ),
                      GestureDetector(
                        child: rowWidget(name: "My bank", icon: "assets/icons/ic_bank.svg"),
                        onTap: () {
                          Get.to(() => MyBankView());
                        },
                      ),
                      if (Constant.isDocumentVerificationEnable == true)
                        GestureDetector(
                          child: rowWidget(name: "Document".tr, icon: "assets/icons/ic_document.svg", iconColor: AppThemeData.success300),
                          onTap: () {
                            Get.to(() => UploadDocumentView());
                          },
                        ),
                      GestureDetector(
                        child: rowWidget(name: "All Orders", icon: "assets/icons/ic_order.svg", iconColor: AppThemeData.info300),
                        onTap: () {
                          Get.to(() => AllOrdersView());
                        },
                      ),
                      GestureDetector(
                        child: rowWidget(name: "Notifications", icon: "assets/icons/ic_bell_2.svg"),
                        onTap: () {
                          Get.to(() => NotificationScreenView());
                        },
                      ),
                      GestureDetector(
                        child: rowWidget(name: "Order Statement".tr, icon: "assets/icons/ic_downlod.svg", iconColor: AppThemeData.accent300),
                        onTap: () {
                          Get.to(() => StatementView());
                        },
                      ),
                      labelWidget(name: "About".tr),
                      GestureDetector(
                        onTap: () {
                          Get.to(() => PrivacyPolicyScreenView(title: "Privacy & Policy".tr, htmlData: Constant.privacyPolicy));
                        },
                        child: rowWidget(name: "Privacy & Policy", icon: "assets/icons/ic_privacy_policy.svg"),
                      ),
                      GestureDetector(
                        onTap: () {
                          Get.to(() => PrivacyPolicyScreenView(title: "AboutApp".tr, htmlData: Constant.aboutApp));
                        },
                        child: rowWidget(name: "AboutApp".tr, icon: "assets/icons/ic_about_app.svg"),
                      ),
                      GestureDetector(
                        onTap: () {
                          Get.to(() => PrivacyPolicyScreenView(title: "Terms & Condition".tr, htmlData: Constant.termsAndConditions));
                        },
                        child: rowWidget(name: "Terms & Condition".tr, icon: "assets/icons/ic_term_condition.svg"),
                      ),
                      labelWidget(name: "App Settings".tr),
                      Padding(
                        padding: paddingEdgeInsets(horizontal: 0, vertical: 4),
                        child: Row(
                          children: [
                            Container(
                              decoration: BoxDecoration(shape: BoxShape.circle, color: themeChange.isDarkTheme() ? AppThemeData.grey900 : AppThemeData.grey50),
                              height: 46.h,
                              width: 46.w,
                              child: Center(
                                child: SizedBox(
                                  height: 18.h,
                                  width: 18.w,
                                  child: SvgPicture.asset("assets/icons/ic_theme.svg"),
                                ),
                              ),
                            ),
                            spaceW(),
                            TextCustom(
                              title: "Dark Mode".tr,
                              fontSize: 16,
                              fontFamily: FontFamily.bold,
                              color: themeChange.isDarkTheme() ? AppThemeData.grey50 : AppThemeData.grey1000,
                            ),
                            Spacer(),
                            SizedBox(
                              height: 26.h,
                              child: FittedBox(
                                child: CupertinoSwitch(
                                  activeTrackColor: AppThemeData.primary300,
                                  value: themeChange.isDarkTheme() ? false : true,
                                  onChanged: (value) {
                                    themeChange.darkTheme = value ? 1 : 0;
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Get.to(() => LanguageScreenView());
                        },
                        child: rowWidget(name: "Language".tr, icon: "assets/icons/ic_language.svg"),
                      ),
                      GestureDetector(
                        onTap: () {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return CustomDialogBox(
                                  themeChange: themeChange,
                                  title: "Logout".tr,
                                  descriptions: "Logging out will require you to sign in again to access your account.".tr,
                                  positiveString: "Log out".tr,
                                  negativeString: "Cancel".tr,
                                  positiveClick: () async {
                                    await FirebaseAuth.instance.signOut();
                                    Constant.ownerModel = null;
                                    Constant.vendorModel = null;
                                    Navigator.pop(context);
                                    Get.offAll(LoginScreenView());
                                  },
                                  negativeClick: () {
                                    Navigator.pop(context);
                                  },
                                  img: Image.asset(
                                    "assets/animation/exit.gif",
                                    height: 64.h,
                                    width: 64.w,
                                  ),
                                  positiveButtonColor: AppThemeData.primary300,
                                  positiveButtonTextColor: themeChange.isDarkTheme() ? AppThemeData.grey1000 : AppThemeData.grey50,
                                  negativeButtonColor: themeChange.isDarkTheme() ? AppThemeData.grey1000 : AppThemeData.grey50,
                                  negativeButtonTextColor: themeChange.isDarkTheme() ? AppThemeData.grey100 : AppThemeData.grey900,
                                  negativeButtonBorderColor: themeChange.isDarkTheme() ? AppThemeData.grey600 : AppThemeData.grey400,
                                );
                              });
                        },
                        child: rowWidget(name: "Logout".tr, icon: "assets/icons/ic_exit.svg", textColor: AppThemeData.danger300),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }
}

Padding labelWidget({required String name}) {
  try {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12, top: 20),
      child: TextCustom(
        title: name.tr,
        fontSize: 16,
        fontFamily: FontFamily.medium,
      ),
    );
  } catch (e) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12, top: 20),
      child: Text(
        'Label Error',
        style: TextStyle(fontSize: 16, color: Colors.red),
      ),
    );
  }
}

Padding rowWidget({
  required String name,
  required String icon,
  Color? iconColor,
  Color? textColor,
}) {
  try {
    final themeChange = Provider.of<DarkThemeProvider>(Get.context!);

    return Padding(
      padding: paddingEdgeInsets(horizontal: 0, vertical: 4),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: themeChange.isDarkTheme() ? AppThemeData.grey900 : AppThemeData.grey50,
            ),
            height: 46.h,
            width: 46.w,
            child: Center(
              child: SizedBox(
                height: 18.h,
                width: 18.w,
                child: SvgPicture.asset(icon, color: iconColor),
              ),
            ),
          ),
          spaceW(),
          TextCustom(
            title: name.tr,
            fontSize: 16,
            fontFamily: FontFamily.bold,
            color: textColor ?? (themeChange.isDarkTheme() ? AppThemeData.grey50 : AppThemeData.grey1000),
          ),
          const Spacer(),
          const Icon(
            Icons.arrow_forward_ios_rounded,
            color: AppThemeData.grey500,
            size: 15,
          )
        ],
      ),
    );
  } catch (e) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: const [
          Icon(Icons.error, color: Colors.red),
          SizedBox(width: 8),
          Text(
            'Error loading row',
            style: TextStyle(color: Colors.red),
          ),
        ],
      ),
    );
  }
}
