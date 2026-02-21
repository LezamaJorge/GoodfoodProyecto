// ignore_for_file: must_be_immutable, deprecated_member_use

import 'package:admin_panel/app/components/menu_widget.dart';
import 'package:admin_panel/app/constant/constants.dart';
import 'package:admin_panel/app/modules/admin_profile/widget/change_password_widget.dart';
import 'package:admin_panel/app/modules/admin_profile/widget/profile_widget.dart';
import 'package:admin_panel/app/utils/app_colors.dart';
import 'package:admin_panel/app/utils/app_them_data.dart';
import 'package:admin_panel/app/utils/dark_theme_provider.dart';
import 'package:admin_panel/app/utils/responsive.dart';
import 'package:admin_panel/widget/common_ui.dart';
import 'package:admin_panel/widget/global_widgets.dart';
import 'package:admin_panel/widget/gradient_text.dart';
import 'package:admin_panel/widget/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../controllers/admin_profile_controller.dart';

class AdminProfileView extends GetView<AdminProfileController> {
  // String? screenName = "Profile".tr;
  const AdminProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetBuilder(
      init: AdminProfileController(),
      builder: (controller) {
        return Scaffold(
            backgroundColor: themeChange.isDarkTheme() ? AppThemeData.lynch950 : AppThemeData.lynch50,
            appBar: AppBar(
              elevation: 0.0,
              toolbarHeight: 70,
              automaticallyImplyLeading: false,
              backgroundColor: themeChange.isDarkTheme() ? AppThemeData.primaryBlack : AppThemeData.primaryWhite,
              leadingWidth: 200,
              // title: title,
              leading: Builder(
                builder: (BuildContext context) {
                  return GestureDetector(
                    onTap: () {
                      if (!ResponsiveWidget.isDesktop(context)) {
                        Scaffold.of(context).openDrawer();
                      }
                    },
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: !ResponsiveWidget.isDesktop(context)
                          ? Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: Icon(
                                Icons.menu,
                                size: 30,
                                color: themeChange.isDarkTheme() ? AppThemeData.primary500 : AppThemeData.primary500,
                              ),
                            )
                          : SizedBox(
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
                                  GradientText(
                                    TextCustom(
                                      title: '${Constant.appName}',
                                      color: AppThemeData.primary500,
                                      fontSize: 25,
                                      fontFamily: FontFamily.titleBold,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    gradient: AppThemeData.primaryGradient,
                                  ),
                                ],
                              ),
                            ),
                    ),
                  );
                },
              ),
              actions: [
                InkWell(
                  onTap: () {
                    if (themeChange.darkTheme == 1) {
                      themeChange.darkTheme = 0;
                    } else if (themeChange.darkTheme == 0) {
                      themeChange.darkTheme = 1;
                    } else if (themeChange.darkTheme == 2) {
                      themeChange.darkTheme = 0;
                    } else {
                      themeChange.darkTheme = 2;
                    }
                  },
                  child: themeChange.isDarkTheme()
                      ? SvgPicture.asset(
                          "assets/icons/ic_sun.svg",
                          color: themeChange.isDarkTheme() ? AppThemeData.lynch200 : AppThemeData.lynch800,
                          height: 20,
                          width: 20,
                        )
                      : SvgPicture.asset(
                          "assets/icons/ic_moon.svg",
                          color: themeChange.isDarkTheme() ? AppThemeData.lynch200 : AppThemeData.lynch800,
                          height: 20,
                          width: 20,
                        ),
                ),
                spaceW(),
                const LanguagePopUp(),
                spaceW(),
                ProfilePopUp()
              ],
            ),
            drawer: Drawer(
              width: 270,
              backgroundColor: themeChange.isDarkTheme() ? AppThemeData.primaryBlack : AppThemeData.primaryWhite,
              child: const MenuWidget(),
            ),
            body: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (ResponsiveWidget.isDesktop(context)) ...{const MenuWidget()},
                Expanded(
                  child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: !ResponsiveWidget.isMobile(context)
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(color: themeChange.isDarkTheme() ? AppThemeData.red950 : AppThemeData.red100, borderRadius: BorderRadius.circular(12)),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const TextCustom(
                                        title: "Notes: ",
                                        fontFamily: FontFamily.bold,
                                        fontSize: 16,
                                      ),
                                      spaceH(height: 12),
                                      const TextCustom(
                                        title:
                                            "1. If you want to Update email, we’ll send a verification link to your new email address. Your email will only be updated after you verify through that link.",
                                        fontFamily: FontFamily.medium,
                                        fontSize: 14,
                                        color: AppThemeData.red500,
                                      ),
                                      spaceH(height: 6),
                                      const TextCustom(
                                        title: "2. If you want to Update password, We'll send a password reset link to your email address. Click the link to securely set a new password.",
                                        fontFamily: FontFamily.medium,
                                        fontSize: 14,
                                        color: AppThemeData.red500,
                                      ),
                                    ],
                                  ),
                                ),
                                spaceH(height: 24),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                        child: ProfileWidget(
                                      adminProfileController: controller,
                                    )),
                                    spaceW(width: 24),
                                    Expanded(
                                        child: ChangePasswordWidget(
                                      adminProfileController: controller,
                                    )),
                                  ],
                                ),
                              ],
                            )
                          : SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(color: themeChange.isDarkTheme() ? AppThemeData.red950 : AppThemeData.red100, borderRadius: BorderRadius.circular(12)),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const TextCustom(
                                          title: "Notes: ",
                                          fontFamily: FontFamily.bold,
                                          fontSize: 16,
                                        ),
                                        spaceH(height: 12),
                                        const TextCustom(
                                          title:
                                          "1. If you want to Update email, we’ll send a verification link to your new email address. Your email will only be updated after you verify through that link.",
                                          fontFamily: FontFamily.medium,
                                          fontSize: 14,
                                          color: AppThemeData.red500,
                                          maxLine: 3,
                                        ),
                                        spaceH(height: 6),
                                        const TextCustom(
                                          title: "2. If you want to Update password, We'll send a password reset link to your email address. Click the link to securely set a new password.",
                                          fontFamily: FontFamily.medium,
                                          fontSize: 14,
                                          color: AppThemeData.red500,
                                          maxLine: 3,
                                        ),
                                      ],
                                    ),
                                  ),
                                  ProfileWidget(
                                    adminProfileController: controller,
                                  ),
                                  spaceH(height: 24),
                                  ChangePasswordWidget(
                                    adminProfileController: controller,
                                  ),
                                ],
                              ),
                            )),
                ),
              ],
            ));
      },
    );
  }
}
