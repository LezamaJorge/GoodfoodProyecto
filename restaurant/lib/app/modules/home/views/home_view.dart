// ignore_for_file: deprecated_member_use, depend_on_referenced_packages, use_super_parameters

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:restaurant/app/modules/home/views/in_prepare_order_widget.dart';
import 'package:restaurant/app/modules/home/views/new_order_widget.dart';
import 'package:restaurant/app/modules/my_wallet/views/my_wallet_view.dart';
import 'package:restaurant/app/modules/notification_screen/views/notification_screen_view.dart';
import 'package:restaurant/app/widget/global_widgets.dart';
import 'package:restaurant/app/widget/text_widget.dart';
import 'package:restaurant/constant/constant.dart';
import 'package:restaurant/constant/show_toast_dialogue.dart';
import 'package:restaurant/themes/app_fonts.dart';
import 'package:restaurant/themes/app_theme_data.dart';
import 'package:restaurant/themes/responsive.dart';
import 'package:restaurant/utils/dark_theme_provider.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetX<HomeController>(
      init: HomeController(),
      builder: (controller) {
        return Container(
          width: Responsive.width(100, context),
          height: Responsive.height(100, context),
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  stops: const [0.1, 0.3],
                  colors: themeChange.isDarkTheme() ? [const Color(0xff180202), const Color(0xff1C1C22)] : [const Color(0xffFDE7E7), const Color(0xffFFFFFF)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter)),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              systemOverlayStyle: const SystemUiOverlayStyle(
                statusBarColor: Colors.transparent,
                statusBarIconBrightness: Brightness.dark,
                statusBarBrightness: Brightness.light,
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
                GestureDetector(
                  onTap: () {
                    Get.to(() => MyWalletView());
                  },
                  child: Container(
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
                ),
                spaceW(),
                GestureDetector(
                  onTap: () {
                    Get.to(() => NotificationScreenView());
                  },
                  child: Container(
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
                ),
                spaceW()
              ],
            ),
            body: Column(
              children: [
                Obx(
                  () => Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: controller.isLoading.value == true
                        ? Constant.loader()
                        : Constant.ownerModel!.isVerified != true
                            ? Container(
                                height: 68.h,
                                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), color: AppThemeData.secondary50),
                                child: TextCustom(
                                  title: 'Your restaurant account is not verified. Please contact the admin for approval.'.tr,
                                  maxLine: 3,
                                  fontFamily: FontFamily.mediumItalic,
                                  textAlign: TextAlign.left,
                                  color: AppThemeData.secondary300,
                                ),
                              )
                            : Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  TextCustom(title: 'Restaurant Status'.tr, color: themeChange.isDarkTheme() ? AppThemeData.grey300 : AppThemeData.grey700, fontSize: 16),
                                  Switch(
                                    value: controller.restaurantStatus.value,
                                    onChanged: (value) {
                                      if (Constant.ownerModel!.vendorId != null && Constant.ownerModel!.vendorId!.isNotEmpty) {
                                        controller.restaurantStatus.value = value;
                                        controller.isOnlineRestaurant();
                                      } else {
                                        ShowToastDialog.toast('First Add your restaurant to change Status.'.tr);
                                      }
                                    },
                                    activeTrackColor: AppThemeData.primary300,
                                    activeColor: themeChange.isDarkTheme() ? AppThemeData.grey1000 : AppThemeData.grey100,
                                    inactiveTrackColor: themeChange.isDarkTheme() ? AppThemeData.grey500 : AppThemeData.primaryWhite,
                                    inactiveThumbColor: themeChange.isDarkTheme() ? AppThemeData.grey300 : AppThemeData.grey500,
                                    trackOutlineColor: MaterialStateProperty.resolveWith<Color>((states) {
                                      if (!states.contains(MaterialState.selected)) {
                                        return themeChange.isDarkTheme() ? AppThemeData.grey500 : AppThemeData.primaryWhite;
                                      }
                                      return AppThemeData.primary300;
                                    }),
                                  )
                                ],
                              ),
                  ),
                ),
                spaceH(height: 18.h),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Container(
                          padding: EdgeInsetsDirectional.all(6),
                          decoration: BoxDecoration(color: themeChange.isDarkTheme() ? AppThemeData.primary500 : AppThemeData.primary50, borderRadius: BorderRadius.circular(50)),
                          child: TabBar(
                            controller: controller.tabController,
                            isScrollable: false,
                            labelStyle: TextStyle(fontSize: 16, fontFamily: FontFamily.bold, color: AppThemeData.grey50),
                            unselectedLabelStyle:
                                TextStyle(fontSize: 16, fontFamily: FontFamily.medium, color: themeChange.isDarkTheme() ? AppThemeData.grey200 : AppThemeData.grey800),
                            dividerColor: Colors.transparent,
                            indicator: BoxDecoration(
                              color: AppThemeData.primary300,
                              borderRadius: BorderRadius.circular(50),
                            ),
                            indicatorSize: TabBarIndicatorSize.tab,
                            indicatorColor: AppThemeData.primary300,
                            tabs: [
                              Tab(
                                text: 'New orders'.tr,
                              ),
                              Tab(text: 'In Prepare'.tr),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Expanded(
                          child: TabBarView(
                            controller: controller.tabController,
                            children: [NewOrderWidget(), InPrepareOrderWidget()],
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
