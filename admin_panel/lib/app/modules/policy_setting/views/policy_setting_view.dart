// ignore_for_file: deprecated_member_use

import 'package:admin_panel/app/components/menu_widget.dart';
import 'package:admin_panel/app/constant/constants.dart';
import 'package:admin_panel/app/modules/policy_setting/controllers/privacy_policy_controller.dart';
import 'package:admin_panel/app/modules/policy_setting/views/other_screen/about_app_view.dart';
import 'package:admin_panel/app/modules/policy_setting/views/other_screen/privacy_policy_view.dart';
import 'package:admin_panel/app/modules/policy_setting/views/other_screen/terms_conditions_view.dart';
import 'package:admin_panel/app/routes/app_pages.dart';
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

class PolicySettingView extends GetView<PrivacyPolicyController> {
  const PolicySettingView({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    final isDarkTheme = themeChange.isDarkTheme();
    final isDesktop = ResponsiveWidget.isDesktop(context);

    return GetBuilder<PrivacyPolicyController>(
      init: PrivacyPolicyController(),
      builder: (controller) {
        return Scaffold(
          backgroundColor: isDarkTheme ? AppThemeData.lynch950 : AppThemeData.lynch50,
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
                      height: 45,
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
                child: Container(
                  padding: const EdgeInsets.all(8),
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
              ),
              spaceW(),
              const LanguagePopUp(),
              spaceW(),
              ProfilePopUp()
            ],
          ),
          drawer: Drawer(
            // key: scaffoldKey,
            width: 270,
            backgroundColor: themeChange.isDarkTheme() ? AppThemeData.primaryBlack : AppThemeData.primaryWhite,
            child: const MenuWidget(),
          ),
          body: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (isDesktop) const MenuWidget(),
              Expanded(
                child: Padding(
                  padding: paddingEdgeInsets(),
                  child: DefaultTabController(
                    length: 3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildTabHeader(controller.title.value, isDarkTheme, context),
                        const SizedBox(height: 24),
                        Expanded(
                          child: TabBarView(
                            physics: const NeverScrollableScrollPhysics(),
                            children: [
                              AboutAppView(),
                               PrivacyPolicyView(),
                               TermsConditionsView(),
                              // CurrencyView(),
                              // RestaurantItemsScreen(),
                              // RestaurantReviewScreen(),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTabHeader(String title, bool isDarkTheme, BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(18, 16, 16, 0),
      decoration: BoxDecoration(
        color: isDarkTheme ? AppThemeData.primaryBlack : AppThemeData.primaryWhite,
        borderRadius: const BorderRadius.only(topLeft: Radius.circular(10)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextCustom(
            title: title.tr,
            fontSize: 20,
            fontFamily: FontFamily.bold,
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              _buildBreadcrumbLink('Dashboard', Routes.DASHBOARD_SCREEN),
              const Text(' / ', style: TextStyle(color: AppThemeData.lynch500)),
              // _buildBreadcrumbLink('Restaurant', null),
              // const Text(' / ', style: TextStyle(color: AppThemeData.lynch500)),
              Text(
                title.tr,
                style: const TextStyle(color: AppThemeData.primary500),
              ),
            ],
          ),
          const SizedBox(height: 20),
          TabBar(
            indicatorColor: AppThemeData.primary500,
            unselectedLabelColor: isDarkTheme ? AppThemeData.lynch400 : AppThemeData.lynch500,
            labelColor: AppThemeData.primary500,
            automaticIndicatorColorAdjustment: true,
            dividerHeight: 2,

            labelPadding:  const EdgeInsets.symmetric(horizontal: 8.0),
            tabs:  [
              Tab(text: "About App".tr),
              Tab(text: "Privacy Policy".tr),
              Tab(text: "Terms & Conditions".tr),
              // Tab(text: "Items"),
              // Tab(text: "Reviews"),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBreadcrumbLink(String text, String? route) {
    return InkWell(
      onTap: route != null ? () => Get.offAllNamed(route) : null,
      child: TextCustom(
        title: text.tr,
        fontSize: 14,
        fontFamily: FontFamily.medium,
        color: AppThemeData.lynch500,
      ),
    );
  }
}


