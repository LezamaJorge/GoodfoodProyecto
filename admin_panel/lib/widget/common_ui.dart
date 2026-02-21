// ignore_for_file: deprecated_member_use, prefer_typing_uninitialized_variables, must_be_immutable, strict_top_level_inference

import 'dart:convert';

import 'package:admin_panel/app/components/menu_widget.dart';
import 'package:admin_panel/app/components/network_image_widget.dart';
import 'package:admin_panel/app/constant/constants.dart';
import 'package:admin_panel/app/models/language_model.dart';
import 'package:admin_panel/app/modules/dashboard_screen/controllers/dashboard_screen_controller.dart';
import 'package:admin_panel/app/modules/home/controllers/home_controller.dart';
import 'package:admin_panel/app/services/localization_service.dart';
import 'package:admin_panel/app/services/shared_preferences/app_preference.dart';
import 'package:admin_panel/app/utils/app_colors.dart';
import 'package:admin_panel/app/utils/app_them_data.dart';
import 'package:admin_panel/app/utils/dark_theme_provider.dart';
import 'package:admin_panel/app/utils/responsive.dart';
import 'package:admin_panel/widget/container_custom.dart';
import 'package:admin_panel/widget/global_widgets.dart';
import 'package:admin_panel/widget/gradient_text.dart';
import 'package:admin_panel/widget/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import '../app/routes/app_pages.dart';

class LanguagePopUp extends StatelessWidget {
  const LanguagePopUp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetX<DashboardScreenController>(
        init: DashboardScreenController(),
        builder: (controller) {
          return Padding(
            padding: paddingEdgeInsets(),
            child: ContainerBorderCustom(
              color: AppThemeData.lynch500,
              child: PopupMenuButton<LanguageModel>(
                  color: themeChange.isDarkTheme() ? AppThemeData.lynch950 : AppThemeData.lynch25,
                  position: PopupMenuPosition.under,
                  child: SizedBox(
                    width: 120,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        //------------------- for Language Image---------------------
                        // ClipRRect(
                        //     borderRadius: BorderRadius.circular(30), child: Image.network(controller.selectedLanguage.value.image ?? '', height: 25, width: 25, fit: BoxFit.cover)),
                        TextCustom(title: controller.selectedLanguage.value.name ?? '', fontSize: 15, fontFamily: FontFamily.bold),
                        SvgPicture.asset(
                          'assets/icons/ic_down.svg',
                          height: 20,
                          width: 20,
                          fit: BoxFit.cover,
                          color: AppThemeData.lynch500,
                        ),
                      ],
                    ),
                  ),
                  onSelected: (LanguageModel value) {
                    controller.selectedLanguage.value = value;
                    LocalizationService().changeLocale(controller.selectedLanguage.value.code.toString());
                    AppSharedPreference.setString(
                      AppSharedPreference.languageCodeKey,
                      jsonEncode(
                        controller.selectedLanguage.value,
                      ),
                    );
                  },
                  itemBuilder: (BuildContext bc) {
                    return controller.languageList
                        .map((LanguageModel e) => PopupMenuItem<LanguageModel>(
                              height: 30,
                              value: e,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(e.name ?? '', style: TextStyle(color: themeChange.isDarkTheme() ? AppThemeData.primaryWhite : AppThemeData.primaryBlack)),
                                ],
                              ),
                            ))
                        .toList();
                  }),
            ),
          );
        });
  }
}

class ProfilePopUp extends StatelessWidget {
  ProfilePopUp({super.key});

  HomeController homeController = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    return GetX(
        init: DashboardScreenController(),
        builder: (controller) {
          return InkWell(
            onTap: () => Get.toNamed(Routes.ADMIN_PROFILE),
            child: SizedBox(
              width: ResponsiveWidget.isMobile(context) ? 50 : 140,
              child: Row(
                children: [
                  ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: NetworkImageWidget(
                          imageUrl: controller.admin.value.image ?? Constant.userPlaceHolder,
                          height: ResponsiveWidget.isMobile(context) ? 30 : 40,
                          width: ResponsiveWidget.isMobile(context) ? 30 : 40)),
                  if (!ResponsiveWidget.isMobile(context)) spaceW(),
                  if (!ResponsiveWidget.isMobile(context))
                    Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.start, children: [
                      const TextCustom(title: 'Hello', fontSize: 12, fontFamily: FontFamily.bold),
                      TextCustom(title: controller.admin.value.name ?? 'Admin', fontSize: 15, fontFamily: FontFamily.bold, maxLine: 1),
                    ]),
                  if (!ResponsiveWidget.isMobile(context)) spaceW(width: 16),
                ],
              ),
            ),
          );
        });
  }
}

class CommonUI {
  static AppBar appBarCustom({Widget? title = const SizedBox(), List<Widget>? actions = const [], required DarkThemeProvider themeChange, required GlobalKey<ScaffoldState> scaffoldKey}) {
    return AppBar(
      elevation: 0.0,
      toolbarHeight: 70,
      automaticallyImplyLeading: false,
      backgroundColor: themeChange.isDarkTheme() ? AppThemeData.primaryBlack : AppThemeData.primaryWhite,
      leadingWidth: 200,
      title: title,
      leading: GestureDetector(
        onTap: () {
          scaffoldKey.currentState?.openDrawer();
        },
        child: Center(
          child: Row(
            children: [
              Expanded(
                child: SizedBox(
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
            ],
          ),
        ),
      ),
      actions: actions! +
          [
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
                // decoration: BoxDecoration(color: themeChange.isDarkTheme()?AppThemeData.lynch950:AppThemeData.lynch50),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  // decoration: BoxDecoration(color: themeChange.isDarkTheme()?AppThemeData.lynch950:AppThemeData.lynch50),
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
            ),
            spaceW(),
            const LanguagePopUp(),
            spaceW(),
            ProfilePopUp()
          ],
    );
  }

  static Drawer drawerCustom({required DarkThemeProvider themeChange, required GlobalKey<ScaffoldState> scaffoldKey}) {
    return Drawer(
      key: scaffoldKey,
      width: 270,
      backgroundColor: themeChange.isDarkTheme() ? AppThemeData.primaryBlack : AppThemeData.primaryWhite,
      child: const MenuWidget(),
    );
  }

  static DataColumn dataColumnWidget(BuildContext context, {String columnName = 'Na', required String columnTitle, required double width}) {
    return DataColumn(
        label: SizedBox(
      width: width,
      child: TextCustom(
        title: columnTitle,
        fontFamily: FontFamily.bold,
        maxLine: 2,
      ),
    ));
  }
}

class NumberOfRowsDropDown extends StatelessWidget {
  final controller;

  const NumberOfRowsDropDown({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
        // if (!ResponsiveWidget.isMobile(context)) spaceW(),
        // Constant.DefaultInputDecoration(context)
        SizedBox(
          width: 100,
          height: 40,
          child: DropdownButtonFormField<String>(
            borderRadius: BorderRadius.circular(15),
            isExpanded: true,
            style: TextStyle(
              fontFamily: FontFamily.medium,
              color: themeChange.isDarkTheme() ? AppThemeData.primaryWhite : AppThemeData.textBlack,
            ),
            value: controller.totalItemPerPage.value,
            hint: TextCustom(title: 'Select'.tr),
            onChanged: (String? newValue) {
              controller.setPagination(newValue!);
              log('select value of drop down $newValue');
            },
            decoration: InputDecoration(
                iconColor: AppThemeData.primary500,
                isDense: true,
                filled: true,
                fillColor: themeChange.isDarkTheme() ? AppThemeData.lynch950 : AppThemeData.lynch50,
                contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
                disabledBorder: OutlineInputBorder(
                  borderRadius: const BorderRadius.all(Radius.circular(4)),
                  borderSide: BorderSide(color: themeChange.isDarkTheme() ? AppThemeData.lynch900 : AppThemeData.lynch100),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: const BorderRadius.all(Radius.circular(4)),
                  borderSide: BorderSide(color: themeChange.isDarkTheme() ? AppThemeData.lynch900 : AppThemeData.lynch100),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: const BorderRadius.all(Radius.circular(4)),
                  borderSide: BorderSide(color: themeChange.isDarkTheme() ? AppThemeData.lynch900 : AppThemeData.lynch100),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: const BorderRadius.all(Radius.circular(4)),
                  borderSide: BorderSide(color: themeChange.isDarkTheme() ? AppThemeData.lynch900 : AppThemeData.lynch100),
                ),
                border: OutlineInputBorder(
                  borderRadius: const BorderRadius.all(Radius.circular(4)),
                  borderSide: BorderSide(color: themeChange.isDarkTheme() ? AppThemeData.lynch900 : AppThemeData.lynch100),
                ),
                hintText: "Select".tr,
                hintStyle: TextStyle(
                    color: themeChange.isDarkTheme() ? AppThemeData.lynch900 : AppThemeData.lynch100, fontSize: 14, fontWeight: FontWeight.w500, fontFamily: FontFamily.medium)),
            items: Constant.numOfPageIemList.map<DropdownMenuItem<String>>((value) {
              return DropdownMenuItem<String>(
                value: value,
                child: TextCustom(
                  title: value,
                  fontFamily: FontFamily.medium,
                  color: themeChange.isDarkTheme() ? AppThemeData.lynch500 : AppThemeData.lynch800,
                ),
              );
            }).toList(),
          ),
        ),
        spaceW(),
      ]),
    );
  }
}

class CustomDialog extends StatelessWidget {
  final double? width;
  String? title = "";
  final controller;
  List<Widget>? widgetList = <Widget>[];
  List<Widget>? bottomWidgetList = <Widget>[];

  CustomDialog({super.key, this.controller, this.widgetList, this.bottomWidgetList, this.title, this.width});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return Dialog(
      backgroundColor: themeChange.isDarkTheme() ? AppThemeData.lynch950 : AppThemeData.lynch50,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8.0))),
      alignment: Alignment.topCenter,
      // title: const TextCustom(title: 'Item Categories', fontSize: 18),
      child: SizedBox(
        width: width ?? 600,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(topLeft: Radius.circular(8.0), topRight: Radius.circular(8.0)),
                      color: themeChange.isDarkTheme() ? AppThemeData.lynch900 : AppThemeData.lynch100,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextCustom(title: '$title', fontSize: 18),
                        InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Icon(
                            Icons.close,
                            color: themeChange.isDarkTheme() ? AppThemeData.primaryWhite : AppThemeData.primaryBlack,
                            size: 25,
                          ),
                        )
                      ],
                    )).expand(),
              ],
            ),
            Flexible(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: widgetList! + [spaceH(), Row(mainAxisAlignment: MainAxisAlignment.end, children: bottomWidgetList!)],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

InputDecoration defaultInputDecorationForSearchDropDown(BuildContext context) {
  final themeChange = Provider.of<DarkThemeProvider>(context);
  return InputDecoration(
      iconColor: AppThemeData.primary500,
      isDense: true,
      filled: true,
      fillColor: themeChange.isDarkTheme() ? AppThemeData.lynch950 : AppThemeData.lynch50,
      contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
      disabledBorder: OutlineInputBorder(
        borderRadius: const BorderRadius.all(Radius.circular(4)),
        borderSide: BorderSide(color: themeChange.isDarkTheme() ? AppThemeData.lynch900 : AppThemeData.lynch100),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: const BorderRadius.all(Radius.circular(4)),
        borderSide: BorderSide(color: themeChange.isDarkTheme() ? AppThemeData.lynch900 : AppThemeData.lynch100),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: const BorderRadius.all(Radius.circular(4)),
        borderSide: BorderSide(color: themeChange.isDarkTheme() ? AppThemeData.lynch900 : AppThemeData.lynch100),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: const BorderRadius.all(Radius.circular(4)),
        borderSide: BorderSide(color: themeChange.isDarkTheme() ? AppThemeData.lynch900 : AppThemeData.lynch100),
      ),
      border: OutlineInputBorder(
        borderRadius: const BorderRadius.all(Radius.circular(4)),
        borderSide: BorderSide(color: themeChange.isDarkTheme() ? AppThemeData.lynch900 : AppThemeData.lynch100),
      ),
      hintText: "".tr,
      hintStyle:
          TextStyle(color: themeChange.isDarkTheme() ? AppThemeData.lynch500 : AppThemeData.lynch100, fontSize: 14, fontWeight: FontWeight.w500, fontFamily: FontFamily.medium));
  // return InputDecoration(
  //     iconColor: AppThemeData.primaryBlack,
  //     isDense: true,
  //     filled: true,
  //     fillColor: themeChange.isDarkTheme() ? AppThemeData.lynch950 : AppThemeData.lynch100,
  //     contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
  //     disabledBorder:  OutlineInputBorder(
  //       borderRadius: const BorderRadius.all(Radius.circular(8)),
  //       borderSide: BorderSide( color: themeChange.isDarkTheme() ? AppThemeData.lynch950 : AppThemeData.lynch100,),
  //     ),
  //     focusedBorder:  OutlineInputBorder(
  //       borderRadius: const BorderRadius.all(Radius.circular(8)),
  //       borderSide: BorderSide( color: themeChange.isDarkTheme() ? AppThemeData.lynch950 : AppThemeData.lynch100,),
  //     ),
  //     enabledBorder:  OutlineInputBorder(
  //       borderRadius: const BorderRadius.all(Radius.circular(8)),
  //       borderSide: BorderSide( color: themeChange.isDarkTheme() ? AppThemeData.lynch950 : AppThemeData.lynch100,),
  //     ),
  //     errorBorder:  OutlineInputBorder(
  //       borderRadius: const BorderRadius.all(Radius.circular(8)),
  //       borderSide: BorderSide( color: themeChange.isDarkTheme() ? AppThemeData.lynch950 : AppThemeData.lynch100,),
  //     ),
  //     border:  OutlineInputBorder(
  //       borderRadius: const BorderRadius.all(Radius.circular(8)),
  //       borderSide: BorderSide( color: themeChange.isDarkTheme() ? AppThemeData.lynch950 : AppThemeData.lynch100,),
  //     ),
  //     hintStyle: TextStyle(
  //         fontSize: 14, color: themeChange.isDarkTheme() ? AppThemeData.lynch400 : AppThemeData.lynch950, fontWeight: FontWeight.w500, fontFamily: FontFamily.medium)

  // );
}

class TextShimmer extends StatelessWidget {
  final double height;
  final double width;
  final BorderRadius? borderRadius;

  const TextShimmer({
    super.key,
    this.height = 20,
    this.width = 100,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return Shimmer.fromColors(
      baseColor: themeChange.isDarkTheme() ? AppThemeData.lynch800 : AppThemeData.lynch200,
      highlightColor: themeChange.isDarkTheme() ? AppThemeData.lynch900 : AppThemeData.lynch100,
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          color: AppThemeData.lynch200,
          borderRadius: borderRadius ?? BorderRadius.circular(4),
        ),
      ),
    );
  }
}
