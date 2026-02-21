// ignore_for_file: deprecated_member_use, depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:restaurant/app/modules/dashboard_screen/controllers/dashboard_screen_controller.dart';
import 'package:restaurant/constant/constant.dart';
import 'package:restaurant/themes/app_fonts.dart';
import 'package:restaurant/themes/app_theme_data.dart';
import 'package:restaurant/utils/dark_theme_provider.dart';

class DashboardScreenView extends GetView<DashboardScreenController> {
  const DashboardScreenView({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetBuilder<DashboardScreenController>(
      init: DashboardScreenController(),
      builder: (controller) {
        return Scaffold(
          body: Obx(() => controller.pageList[controller.selectedIndex.value]),
          floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
          bottomNavigationBar: Obx(() => BottomNavigationBar(
                  elevation: 0,
                  type: BottomNavigationBarType.fixed,
                  currentIndex: controller.selectedIndex.value,
                  onTap: (int index) {
                    if (Constant.ownerModel?.isVerified == true) {
                      controller.selectedIndex.value = index;
                    }
                  },
                  backgroundColor: themeChange.isDarkTheme() ? AppThemeData.grey1000 : AppThemeData.grey50,
                  selectedItemColor: AppThemeData.primary300,
                  selectedIconTheme: IconThemeData(color: AppThemeData.primary300),
                  selectedLabelStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                  showSelectedLabels: true,
                  showUnselectedLabels: true,
                  unselectedIconTheme: IconThemeData(color: AppThemeData.grey500),
                  unselectedItemColor: AppThemeData.grey500,
                  unselectedLabelStyle: TextStyle(fontSize: 12, fontFamily: FontFamily.regular),
                  items: [
                    BottomNavigationBarItem(
                      icon: SvgPicture.asset(
                        "assets/icons/ic_home.svg",
                        color: controller.selectedIndex.value == 0 ? AppThemeData.primary300 : AppThemeData.grey500,
                        width: 20,
                        height: 20,
                      ),
                      label: "Home".tr,
                    ),
                    BottomNavigationBarItem(
                        icon: SvgPicture.asset(
                          "assets/icons/ic_statistic.svg",
                          color: controller.selectedIndex.value == 1 ? AppThemeData.primary300 : AppThemeData.grey500,
                          width: 20,
                          height: 20,
                        ),
                        label: "Statistic".tr),
                    BottomNavigationBarItem(
                        icon: SvgPicture.asset(
                          "assets/icons/ic_restaurant.svg",
                          color: controller.selectedIndex.value == 2 ? AppThemeData.primary300 : AppThemeData.grey500,
                          width: 20,
                          height: 20,
                        ),
                        label: "Restaurant".tr),
                    BottomNavigationBarItem(
                        icon: SvgPicture.asset(
                          "assets/icons/ic_menu.svg",
                          color: controller.selectedIndex.value == 3 ? AppThemeData.primary300 : AppThemeData.grey500,
                          width: 20,
                          height: 20,
                        ),
                        label: "Menu".tr),
                    BottomNavigationBarItem(
                        icon: SvgPicture.asset(
                          "assets/icons/ic_profile.svg",
                          color: controller.selectedIndex.value == 4 ? AppThemeData.primary300 : AppThemeData.grey500,
                          width: 20,
                          height: 20,
                        ),
                        label: "Profile".tr)
                  ])),
        );
      },
    );
  }
}
