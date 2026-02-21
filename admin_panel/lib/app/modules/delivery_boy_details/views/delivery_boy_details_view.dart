// ignore_for_file: deprecated_member_use

import 'package:admin_panel/app/components/menu_widget.dart';
import 'package:admin_panel/app/constant/constants.dart';
import 'package:admin_panel/app/modules/delivery_boy_details/controllers/delivery_boy_details_controller.dart';
import 'package:admin_panel/app/modules/delivery_boy_details/views/other_screen/delivery_boy_details_screen.dart';
import 'package:admin_panel/app/modules/delivery_boy_details/views/other_screen/delivery_boy_order_screen.dart';
import 'package:admin_panel/app/modules/delivery_boy_details/views/other_screen/delivery_boy_wallet_screen.dart';
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

class DeliveryBoyDetailsView extends GetView {
  const DeliveryBoyDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetBuilder<DeliveryBoyDetailsController>(
        init: DeliveryBoyDetailsController(),
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
                if (ResponsiveWidget.isDesktop(context)) ...{const MenuWidget()},
                Expanded(
                  child: Padding(
                      padding: paddingEdgeInsets(),
                      child: DefaultTabController(
                          length: 3,
                          child: Column(mainAxisSize: MainAxisSize.min, mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.start, children: [
                            Container(
                              padding: const EdgeInsets.fromLTRB(18, 16, 16, 0),
                              decoration: BoxDecoration(
                                  color: themeChange.isDarkTheme() ? AppThemeData.primaryBlack : AppThemeData.primaryWhite, borderRadius: const BorderRadius.only(topLeft: Radius.circular(10))),
                              child: Column(
                                children: [
                                  ResponsiveWidget.isDesktop(context)
                                      ? Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          mainAxisSize: MainAxisSize.max,
                                          children: [
                                            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                              TextCustom(title: controller.title.value, fontSize: 20, fontFamily: FontFamily.bold),
                                              spaceH(height: 2),
                                              Row(children: [
                                                InkWell(
                                                    onTap: () => Get.offAllNamed(Routes.DASHBOARD_SCREEN),
                                                    child: TextCustom(title: 'Dashboard'.tr, fontSize: 14, fontFamily: FontFamily.medium, color: AppThemeData.lynch500)),
                                                const TextCustom(title: ' / ', fontSize: 14, fontFamily: FontFamily.medium, color: AppThemeData.lynch500),
                                                InkWell(
                                                    onTap: () => Get.offAllNamed(Routes.DELIVERY_BOY),
                                                    child: TextCustom(title: 'Delivery Boy'.tr, fontSize: 14, fontFamily: FontFamily.medium, color: AppThemeData.lynch500)),
                                                const TextCustom(title: ' / ', fontSize: 14, fontFamily: FontFamily.medium, color: AppThemeData.lynch500),
                                                TextCustom(title: ' ${controller.title.value} ', fontSize: 14, fontFamily: FontFamily.medium, color: AppThemeData.primary500)
                                              ])
                                            ]),
                                          ],
                                        )
                                      : Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            TextCustom(title: controller.title.value, fontSize: 20, fontFamily: FontFamily.bold),
                                            spaceH(height: 2),
                                            Row(
                                              children: [
                                                InkWell(
                                                    onTap: () => Get.offAllNamed(Routes.DASHBOARD_SCREEN),
                                                    child: TextCustom(title: 'Dashboard'.tr, fontSize: 14, fontFamily: FontFamily.medium, color: AppThemeData.lynch500)),
                                                const TextCustom(title: ' / ', fontSize: 14, fontFamily: FontFamily.medium, color: AppThemeData.lynch500),
                                                InkWell(
                                                    onTap: () => Get.offAllNamed(Routes.DELIVERY_BOY),
                                                    child: TextCustom(title: 'Delivery Boy'.tr, fontSize: 14, fontFamily: FontFamily.medium, color: AppThemeData.lynch500)),
                                                const TextCustom(title: ' / ', fontSize: 14, fontFamily: FontFamily.medium, color: AppThemeData.lynch500),
                                                TextCustom(title: ' ${controller.title.value} ', fontSize: 14, fontFamily: FontFamily.medium, color: AppThemeData.primary500)
                                              ],
                                            )
                                          ],
                                        ),
                                  spaceH(height: 20),
                                  TabBar(
                                    indicatorColor: AppThemeData.primary500,
                                    unselectedLabelColor: themeChange.isDarkTheme() ? AppThemeData.lynch400 : AppThemeData.lynch500,
                                    labelColor: AppThemeData.primary500,
                                    tabs: [
                                      Tab(text: "Details".tr),
                                      Tab(text: "Orders".tr),
                                      Tab(text: "Transaction".tr),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            spaceH(height: 24),
                            const Expanded(
                              child: TabBarView(
                                physics: NeverScrollableScrollPhysics(),
                                children: [
                                  DeliveryBoyDetailsScreen(),
                                  DeliveryBoyOrderScreen(),
                                  DeliveryBoyWalletScreen(),
                                ],
                              ),
                            ),
                          ]))),
                ),
              ],
            ),
          );
        });
  }

  Padding detailsWidget(String title, String data, themeChange) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TextCustom(
            title: title.tr,
            fontSize: 14,
            fontFamily: FontFamily.regular,
            color: themeChange.isDarkTheme() ? AppThemeData.lynch400 : AppThemeData.lynch500,
          ),
          TextCustom(
            title: data.tr,
            fontSize: 14,
            fontFamily: FontFamily.medium,
            color: themeChange.isDarkTheme() ? AppThemeData.lynch25 : AppThemeData.lynch950,
          ),
        ],
      ),
    );
  }
}
