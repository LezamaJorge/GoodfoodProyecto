// ignore_for_file: depend_on_referenced_packages, deprecated_member_use

import 'package:admin_panel/app/constant/constants.dart';

import 'package:admin_panel/app/modules/setting_screen/controllers/setting_screen_controller.dart';
import 'package:admin_panel/app/routes/app_pages.dart';
import 'package:admin_panel/app/utils/app_colors.dart';
import 'package:admin_panel/app/utils/app_them_data.dart';
import 'package:admin_panel/app/utils/dark_theme_provider.dart';
import 'package:admin_panel/app/utils/responsive.dart';

import 'package:admin_panel/widget/container_custom.dart';
import 'package:admin_panel/widget/global_widgets.dart';
import 'package:admin_panel/widget/text_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class MenuWidget extends StatelessWidget {
  const MenuWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    SettingScreenController settingScreenController = Get.put(SettingScreenController());

    return Container(
      color: themeChange.isDarkTheme() ? AppThemeData.primaryBlack : AppThemeData.primaryWhite,
      width: 270,
      height: 1.sh,
      child: Column(
        children: [
          if (!ResponsiveWidget.isDesktop(context)) ...{
            InkWell(
              onTap: () {
                Get.offAllNamed(Routes.DASHBOARD_SCREEN);
              },
              child: Center(
                child: Row(
                  children: [
                    Expanded(
                      child: Center(
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
              ),
            ),
            14.height,
            Divider(color: themeChange.isDarkTheme() ? AppThemeData.lynch900 : AppThemeData.lynch100),
          },
          Expanded(
            child: SingleChildScrollView(
              child: MouseRegion(
                cursor: SystemMouseCursors.text,
                child: Column(
                  children: <Widget>[
                    ListItem(
                      buttonTitle: "Dashboard".tr,
                      icon: "assets/new_icon/ic_home.svg",
                      onPress: () {
                        Get.offAllNamed(Routes.DASHBOARD_SCREEN);
                      },
                      isSelected: Get.currentRoute == Routes.DASHBOARD_SCREEN,
                      themeChange: themeChange,
                    ),
                    ListItem(
                      buttonTitle: "Orders".tr,
                      icon: "assets/new_icon/ic_notepad.svg",
                      onPress: () {
                        Get.offAllNamed(Routes.ORDERS);
                      },
                      isSelected: Get.currentRoute == Routes.ORDERS,
                      themeChange: themeChange,
                    ),
                    ListItem(
                      buttonTitle: "Customers".tr,
                      icon: "assets/new_icon/ic_users.svg",
                      onPress: () {
                        Get.offAllNamed(Routes.CUSTOMER_SCREEN);
                      },
                      isSelected: Get.currentRoute == Routes.CUSTOMER_SCREEN,
                      themeChange: themeChange,
                    ),
                    ListTile(
                        title: TextCustom(
                      title: "Menu Management".tr,
                      fontSize: 14,
                      color: AppThemeData.lynch500,
                    )),
                    ListItem(
                      buttonTitle: "Foods".tr,
                      icon: "assets/new_icon/ic_scroll.svg",
                      onPress: () {
                        Get.offAllNamed(Routes.FOODS);
                      },
                      isSelected: Get.currentRoute == Routes.FOODS,
                      themeChange: themeChange,
                    ),
                    ExpansionTileItem(
                      title: 'Categories'.tr,
                      titleColor: (Get.currentRoute == Routes.CATEGORY || Get.currentRoute == Routes.SUB_CATEGORY) ? AppThemeData.primary500 : AppThemeData.primary500,
                      isSelected: (Get.currentRoute == Routes.CATEGORY || Get.currentRoute == Routes.SUB_CATEGORY),
                      icon: "assets/new_icon/ic_category.svg",
                      iconColor: (Get.currentRoute == Routes.CATEGORY || Get.currentRoute == Routes.SUB_CATEGORY) ? AppThemeData.primary500 : AppThemeData.primary500,
                      themeChange: themeChange,
                      children: [
                        ListItem(
                          buttonTitle: "Categories".tr,
                          // icon: "assets/new_icon/ic_category.svg",
                          onPress: () {
                            Get.offAllNamed(Routes.CATEGORY);
                          },
                          isSelected: Get.currentRoute == Routes.CATEGORY,
                          themeChange: themeChange,
                        ),
                        ListItem(
                          buttonTitle: "Sub Categories".tr,
                          // icon: "assets/new_icon/ic_category.svg",
                          onPress: () {
                            Get.offAllNamed(Routes.SUB_CATEGORY);
                          },
                          isSelected: Get.currentRoute == Routes.SUB_CATEGORY,
                          themeChange: themeChange,
                        ),
                      ],
                    ),
                    ListTile(
                        title: TextCustom(
                      title: "Restaurant Management".tr,
                      fontSize: 14,
                      color: AppThemeData.lynch500,
                    )),
                    ListItem(
                      onPress: () async {
                        Get.toNamed(Routes.CUISINE);
                      },
                      buttonTitle: 'Cuisine'.tr,
                      icon: "assets/new_icon/ic_callBell.svg",
                      isSelected: Get.currentRoute == Routes.CUISINE,
                      themeChange: themeChange,
                    ),
                    ListItem(
                      onPress: () async {
                        Get.toNamed(Routes.OWNER);
                      },
                      buttonTitle: 'Owner'.tr,
                      icon: "assets/icons/ic_owner.svg",
                      isSelected: Get.currentRoute == Routes.OWNER,
                      themeChange: themeChange,
                    ),
                    ExpansionTileItem(
                      title: 'Restaurant'.tr,
                      titleColor: (Get.currentRoute == Routes.RESTAURANT || Get.currentRoute == Routes.NEW_RESTAURANT_JOIN_REQUEST) ? AppThemeData.primary500 : AppThemeData.primary500,
                      isSelected: (Get.currentRoute == Routes.RESTAURANT || Get.currentRoute == Routes.NEW_RESTAURANT_JOIN_REQUEST),
                      icon: "assets/new_icon/ic_forkKnife.svg",
                      iconColor: (Get.currentRoute == Routes.RESTAURANT || Get.currentRoute == Routes.NEW_RESTAURANT_JOIN_REQUEST) ? AppThemeData.primary500 : AppThemeData.primary500,
                      themeChange: themeChange,
                      children: [
                        ListItem(
                          onPress: () async {
                            Get.toNamed(Routes.RESTAURANT);
                          },
                          buttonTitle: 'Restaurant'.tr,
                          // icon: "assets/new_icon/ic_forkKnife.svg",
                          isSelected: Get.currentRoute == Routes.RESTAURANT,
                          themeChange: themeChange,
                        ),
                        ListItem(
                          onPress: () async {
                            Get.toNamed(Routes.NEW_RESTAURANT_JOIN_REQUEST);
                          },
                          buttonTitle: 'New Restaurant Join Request'.tr,
                          // icon: "assets/new_icon/ic_sealCheck.svg",
                          isSelected: Get.currentRoute == Routes.NEW_RESTAURANT_JOIN_REQUEST,
                          themeChange: themeChange,
                        ),
                      ],
                    ),
                    ListTile(
                        title: TextCustom(
                      title: "Delivery Boy Management".tr,
                      fontSize: 14,
                      color: AppThemeData.lynch500,
                    )),
                    ExpansionTileItem(
                      title: 'Delivery Boy'.tr,
                      titleColor: (Get.currentRoute == Routes.DELIVERY_BOY || Get.currentRoute == Routes.VERIFY_USER_SCREEN) ? AppThemeData.primary500 : AppThemeData.primary500,
                      isSelected: (Get.currentRoute == Routes.DELIVERY_BOY || Get.currentRoute == Routes.VERIFY_USER_SCREEN),
                      icon: "assets/new_icon/ic_userCircle.svg",
                      iconColor: (Get.currentRoute == Routes.DELIVERY_BOY || Get.currentRoute == Routes.VERIFY_USER_SCREEN) ? AppThemeData.primary500 : AppThemeData.primary500,
                      themeChange: themeChange,
                      children: [
                        ListItem(
                          onPress: () async {
                            Get.toNamed(Routes.DELIVERY_BOY);
                          },
                          buttonTitle: 'Delivery Boy'.tr,
                          // icon: "assets/new_icon/ic_userCircle.svg",
                          isSelected: Get.currentRoute == Routes.DELIVERY_BOY,
                          themeChange: themeChange,
                        ),
                        ListItem(
                          onPress: () async {
                            Get.toNamed(Routes.VERIFY_USER_SCREEN);
                          },
                          buttonTitle: 'Verify Delivery Boy'.tr,
                          // icon: "assets/new_icon/ic_sealCheck.svg",
                          isSelected: Get.currentRoute == Routes.VERIFY_USER_SCREEN,
                          themeChange: themeChange,
                        ),
                      ],
                    ),
                    ListTile(
                        title: TextCustom(
                      title: "Service Management".tr,
                      fontSize: 14,
                      color: AppThemeData.lynch500,
                    )),
                    ListItem(
                      buttonTitle: 'Payout Request'.tr,
                      icon: "assets/icons/ic_roud_doller.svg",
                      onPress: () {
                        Get.toNamed(Routes.PAYOUT_REQUEST_SCREEN);
                      },
                      isSelected: Get.currentRoute == Routes.PAYOUT_REQUEST_SCREEN,
                      themeChange: themeChange,
                    ),
                    ListItem(
                      onPress: () async {
                        Get.toNamed(Routes.BANNER_SCREEN);
                      },
                      buttonTitle: 'Banner'.tr,
                      icon: "assets/new_icon/ic_newspaper.svg",
                      isSelected: Get.currentRoute == Routes.BANNER_SCREEN,
                      themeChange: themeChange,
                    ),
                    ListItem(
                      onPress: () async {
                        Get.toNamed(Routes.DOCUMENT_SCREEN);
                      },
                      buttonTitle: 'Documents'.tr,
                      icon: "assets/new_icon/ic_fileText.svg",
                      isSelected: Get.currentRoute == Routes.DOCUMENT_SCREEN,
                      themeChange: themeChange,
                    ),
                    ExpansionTileItem(
                      title: 'Offer'.tr,
                      titleColor: (Get.currentRoute == Routes.COUPON || Get.currentRoute == Routes.RESTAURANT_OFFER_SCREEN) ? AppThemeData.primary500 : AppThemeData.primary500,
                      isSelected: (Get.currentRoute == Routes.COUPON || Get.currentRoute == Routes.RESTAURANT_OFFER_SCREEN),
                      icon: "assets/icons/ic_coupon.svg",
                      iconColor: (Get.currentRoute == Routes.COUPON || Get.currentRoute == Routes.RESTAURANT_OFFER_SCREEN) ? AppThemeData.primary500 : AppThemeData.primary500,
                      themeChange: themeChange,
                      children: [
                        ListItem(
                          onPress: () async {
                            Get.toNamed(Routes.RESTAURANT_OFFER_SCREEN);
                          },
                          buttonTitle: 'Restaurant Offer'.tr,
                          // icon: "assets/new_icon/ic_newspaper.svg",
                          isSelected: Get.currentRoute == Routes.RESTAURANT_OFFER_SCREEN,
                          themeChange: themeChange,
                        ),
                        ListItem(
                          onPress: () async {
                            Get.toNamed(Routes.COUPON);
                          },
                          buttonTitle: 'Coupon'.tr,
                          // icon: "assets/icons/ic_coupon.svg",
                          isSelected: Get.currentRoute == Routes.COUPON,
                          themeChange: themeChange,
                        ),
                      ],
                    ),
                    ListTile(
                        title: TextCustom(
                      title: "Onboarding Management".tr,
                      fontSize: 14,
                      color: AppThemeData.lynch500,
                    )),
                    ListItem(
                      buttonTitle: 'Onboarding Screens'.tr,
                      icon: "assets/icons/ic_roud_doller.svg",
                      onPress: () {
                        Get.toNamed(Routes.ADD_ONBOARDING);
                      },
                      isSelected: Get.currentRoute == Routes.ADD_ONBOARDING,
                      themeChange: themeChange,
                    ),
                    ListTile(
                        title: TextCustom(
                      title: "System Management".tr,
                      fontSize: 14,
                      color: AppThemeData.lynch500,
                    )),
                    ListItem(
                      buttonTitle: 'Finance Settings'.tr,
                      icon: "assets/icons/ic_roud_doller.svg",
                      onPress: () {
                        Get.toNamed(Routes.FINANCE_SETTING_SCREEN);
                      },
                      isSelected: Get.currentRoute == Routes.FINANCE_SETTING_SCREEN,
                      themeChange: themeChange,
                    ),
                    ListItem(
                      buttonTitle: 'Policy Settings'.tr,
                      icon: "assets/icons/ic_privacy_policy.svg",
                      onPress: () {
                        Get.toNamed(Routes.POLICY_SETTING_SCREEN);
                      },
                      isSelected: Get.currentRoute == Routes.POLICY_SETTING_SCREEN,
                      themeChange: themeChange,
                    ),
                    // ListItem(
                    //   buttonTitle: 'Settings'.tr,
                    //   icon: "assets/icons/ic_settings.svg",
                    //   onPress: () {
                    //     Get.toNamed(Routes.SETTING_SCREEN);
                    //   },
                    //   isSelected: Get.currentRoute == Routes.SETTING_SCREEN,
                    //   themeChange: themeChange,
                    // ),
                    ExpansionTileItem(
                      title: 'Settings'.tr,
                      titleColor: (Get.currentRoute == Routes.SETTING_SCREEN) ? AppThemeData.primary500 : AppThemeData.primary500,
                      isSelected: (Get.currentRoute == Routes.SETTING_SCREEN),
                      icon: "assets/icons/ic_settings.svg",
                      iconColor: (Get.currentRoute == Routes.SETTING_SCREEN) ? AppThemeData.primary500 : AppThemeData.primary500,
                      themeChange: themeChange,
                      children: [
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const BouncingScrollPhysics(),
                          itemCount: settingScreenController.settingsAllPage.length,
                          itemBuilder: (context, index) {
                            final currentRoute = Get.currentRoute;
                            final item = settingScreenController.settingsAllPage[index];
                            return Obx(() {
                              final selectedTitle = settingScreenController.selectSettingWidget.value.title;
                              bool isSelected = currentRoute == Routes.SETTING_SCREEN && selectedTitle != null && selectedTitle.isNotEmpty && selectedTitle[0] == item.title![0];

                              return InkWell(
                                onTap: () {
                                  settingScreenController.settingsAllPage[index].selectIndex = 0;
                                  settingScreenController.selectSettingWidget.value = item;
                                  settingScreenController.update();
                                  Get.toNamed(Routes.SETTING_SCREEN);
                                },
                                child: ContainerCustom(
                                  radius: 12,
                                  color: isSelected ? (themeChange.isDarkTheme() ? AppThemeData.lynch900 : AppThemeData.lynch100) : null,
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: TextCustom(
                                          title: item.title?[0].tr ?? '',
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            });
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          LogoutListItem(
            buttonTitle: 'Log out'.tr,
            icon: "assets/icons/ic_exit.svg",
            onPress: () {
              showDialog<bool>(
                context: Get.context!,
                builder: (context) => AlertDialog(
                  title: Text(
                    'Logout?'.tr,
                    style: const TextStyle(fontFamily: FontFamily.medium, fontSize: 18, color: AppThemeData.lynch950, fontWeight: FontWeight.w600),
                  ),
                  content: Text(
                    'Are you sure you want to logout?'.tr,
                    style: const TextStyle(fontFamily: FontFamily.medium, fontSize: 16, color: AppThemeData.textGrey, fontWeight: FontWeight.w400),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Get.back(),
                      child: Text(
                        'Cancel'.tr,
                        style: const TextStyle(fontFamily: FontFamily.medium, fontSize: 14, color: AppThemeData.textBlack, fontWeight: FontWeight.w600),
                      ),
                    ),
                    TextButton(
                      onPressed: () async {
                        await FirebaseAuth.instance.signOut();
                        Get.offAllNamed(Routes.LOGIN_PAGE);
                      },
                      child: Text(
                        'Log out'.tr,
                        style: const TextStyle(fontFamily: FontFamily.medium, fontSize: 14, color: AppThemeData.red800, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
              );
            },
            textColor: AppThemeData.red600,
            iconColor: AppThemeData.red600,
            buttonColor: themeChange.isDarkTheme() ? AppThemeData.primaryBlack : AppThemeData.primaryWhite,
          ),
        ],
      ),
    );
  }
}

class LogoutListItem extends StatelessWidget {
  final Color? buttonColor;
  final Color? textColor;
  final Color? iconColor;
  final String? buttonTitle;
  final String? icon;
  final VoidCallback? onPress;

  const LogoutListItem({
    super.key,
    this.buttonColor,
    this.iconColor,
    this.textColor,
    this.buttonTitle,
    this.icon,
    this.onPress,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 3),
      decoration: BoxDecoration(
        // borderRadius: BorderRadius.only(topLeft: Radius.circular(20),bottomLeft: Radius.circular(20)),
        color: buttonColor,
        boxShadow: [
          BoxShadow(color: AppThemeData.black07, offset: textColor == AppThemeData.black07 ? const Offset(4, 0) : const Offset(0, 0)),
        ],
      ),
      child: ListTile(
        minLeadingWidth: 20,
        onTap: onPress,
        title: Text(
          buttonTitle!,
          style: TextStyle(
            fontFamily: FontFamily.bold,
            fontSize: 15,
            color: textColor,
          ),
        ),
        leading: (icon != null)
            ? Padding(
                padding: const EdgeInsets.all(8.0),
                child: SvgPicture.asset(
                  icon!,
                  color: iconColor,
                  height: 16,
                  width: 16,
                ),
              )
            : null,
      ),
    );
  }
}

class ListItem extends StatelessWidget {
  final String? buttonTitle;
  final String? icon;
  final VoidCallback? onPress;
  final bool? isSelected;
  final DarkThemeProvider themeChange;

  const ListItem({super.key, this.buttonTitle, this.icon, this.onPress, this.isSelected, required this.themeChange});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 3),
      decoration: isSelected == true
          ? BoxDecoration(
              // borderRadius: BorderRadius.only(topLeft: Radius.circular(20),bottomLeft: Radius.circular(20)),
              color: themeChange.isDarkTheme() ? AppThemeData.primaryBlack : AppThemeData.primaryWhite,
              boxShadow: const [
                BoxShadow(color: AppThemeData.primary500, offset: Offset(4, 0)),
              ],
            )
          : BoxDecoration(
              // borderRadius: BorderRadius.only(topLeft: Radius.circular(20),bottomLeft: Radius.circular(20)),
              color: themeChange.isDarkTheme() ? AppThemeData.primaryBlack : AppThemeData.primaryWhite,
            ),
      child: ListTile(
        minLeadingWidth: 20,
        onTap: onPress,
        title: Text(
          buttonTitle!,
          style: TextStyle(
            fontFamily: FontFamily.medium,
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: isSelected == true
                ? AppThemeData.primary500
                : themeChange.isDarkTheme()
                    ? AppThemeData.lynch100
                    : AppThemeData.lynch900,
          ),
        ),
        leading: (icon != null)
            ? Padding(
                padding: const EdgeInsets.all(8.0),
                child: SvgPicture.asset(
                  icon!,
                  colorFilter: ColorFilter.mode(
                      isSelected == true
                          ? AppThemeData.primary500
                          : themeChange.isDarkTheme()
                              ? AppThemeData.lynch100
                              : AppThemeData.lynch900,
                      BlendMode.srcIn),
                  height: 20,
                  width: 20,
                ),
              )
            : null,
      ),
    );
  }
}

class ExpansionTileItem extends StatelessWidget {
  final String? title;
  final String? icon;
  final List<Widget>? children;
  final bool? isSelected;
  final DarkThemeProvider themeChange;

  const ExpansionTileItem({super.key, this.title, this.icon, this.children, this.isSelected, required this.themeChange, required titleColor, required iconColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: isSelected == true
          ? BoxDecoration(
              // borderRadius: BorderRadius.only(topLeft: Radius.circular(20),bottomLeft: Radius.circular(20)),
              color: themeChange.isDarkTheme() ? AppThemeData.primaryBlack : AppThemeData.primaryWhite,
              boxShadow: const [
                BoxShadow(color: AppThemeData.primary500, offset: Offset(4, 0)),
              ],
            )
          : BoxDecoration(
              // borderRadius: BorderRadius.only(topLeft: Radius.circular(20),bottomLeft: Radius.circular(20)),
              color: themeChange.isDarkTheme() ? AppThemeData.primaryBlack : AppThemeData.primaryWhite,
            ),
      child: ListTileTheme(
        minLeadingWidth: 20,
        child: ExpansionTile(
          shape: const Border(),
          title: Text(
            title!,
            style: TextStyle(
              fontFamily: FontFamily.regular,
              fontSize: 15,
              color: isSelected == true
                  ? themeChange.isDarkTheme()
                      ? AppThemeData.lynch25
                      : AppThemeData.primary500
                  : themeChange.isDarkTheme()
                      ? AppThemeData.lynch25
                      : AppThemeData.lynch950,
            ),
          ),
          initiallyExpanded: false,
          childrenPadding: const EdgeInsets.only(left: 60, top: 0, bottom: 0, right: 0),
          backgroundColor: Colors.transparent,
          // collapsedIconColor: AppColors.darkGrey04,
          iconColor: AppThemeData.lynch400,
          leading: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SvgPicture.asset(
              icon!,
              color: isSelected == true
                  ? AppThemeData.primary500
                  : themeChange.isDarkTheme()
                      ? AppThemeData.lynch25
                      : AppThemeData.lynch950,
              height: 18,
              width: 18,
            ),
          ),
          children: children!.toList(),
        ),
      ),
    );
  }
}
