// ignore_for_file: deprecated_member_use

import 'package:admin_panel/app/components/menu_widget.dart';
import 'package:admin_panel/app/constant/constants.dart';
import 'package:admin_panel/app/utils/app_colors.dart';
import 'package:admin_panel/app/utils/app_them_data.dart';
import 'package:admin_panel/app/utils/dark_theme_provider.dart';
import 'package:admin_panel/app/utils/responsive.dart';
import 'package:admin_panel/widget/common_ui.dart';
import 'package:admin_panel/widget/container_custom.dart';
import 'package:admin_panel/widget/global_widgets.dart';
import 'package:admin_panel/widget/gradient_text.dart';
import 'package:admin_panel/widget/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../controllers/setting_screen_controller.dart';

class SettingScreenView extends GetView<SettingScreenController> {
  const SettingScreenView({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetBuilder<SettingScreenController>(
        init: SettingScreenController(),
        builder: (controller) {
          return ResponsiveWidget(
            mobile: Scaffold(
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
                    child:  Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(color: themeChange.isDarkTheme()?AppThemeData.lynch950:AppThemeData.lynch50),
                      child: themeChange.isDarkTheme()
                          ? SvgPicture.asset(
                        "assets/icons/ic_sun.svg",
                        color:  themeChange.isDarkTheme()?AppThemeData.lynch200:AppThemeData.lynch800,
                        height: 20,
                        width: 20,
                      )
                          : SvgPicture.asset(
                        "assets/icons/ic_moon.svg",
                        color:  themeChange.isDarkTheme()?AppThemeData.lynch200:AppThemeData.lynch800,
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
              body: SingleChildScrollView(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Padding(
                    padding: paddingEdgeInsets(),
                    child: Center(
                      child: ContainerCustom(
                        color: AppThemeData.primary500,
                        padding: const EdgeInsets.all(0),
                        radius: 4,
                        child: ExpansionTile(
                            shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8))),
                            backgroundColor: AppThemeData.primary500,
                            iconColor: AppThemeData.lynch900,
                            title: TextCustom(title: 'Settings Menu'.tr),
                            children: controller.settingsAllPage
                                .map((e) => InkWell(
                                      onTap: () {
                                        e.selectIndex = 0;
                                        controller.selectSettingWidget.value = e;
                                        controller.update();
                                      },
                                      child: ContainerCustom(
                                        radius: 0,
                                        color: controller.selectSettingWidget.value.title![0] == e.title![0]
                                            ? themeChange.isDarkTheme()
                                                ? AppThemeData.lynch900
                                                : AppThemeData.lynch100
                                            : null,
                                        child: Row(children: [
                                          SvgPicture.asset(e.icon ?? '',
                                              height: 20, width: 20, color: themeChange.isDarkTheme() ? AppThemeData.lynch100 : AppThemeData.lynch900),
                                          spaceW(width: 15),
                                          Expanded(child: TextCustom(title: e.title?[0].tr ?? ''))
                                        ]),
                                      ),
                                    ))
                                .toList()),
                      ),
                    ),
                  ),
                  spaceH(height: 20),
                  Padding(
                    padding: paddingEdgeInsets(),
                    child: GetBuilder(
                        init: SettingScreenController(),
                        builder: (controller) {
                          return controller.selectSettingWidget.value.widget![controller.selectSettingWidget.value.selectIndex!];
                        }),
                  )
                ]),
              ),
            ),
            tablet: Scaffold(
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
                      decoration: BoxDecoration(color: themeChange.isDarkTheme()?AppThemeData.lynch950:AppThemeData.lynch50),
                      child: themeChange.isDarkTheme()
                          ? SvgPicture.asset(
                        "assets/icons/ic_sun.svg",
                        color:  themeChange.isDarkTheme()?AppThemeData.lynch200:AppThemeData.lynch800,
                        height: 20,
                        width: 20,
                      )
                          : SvgPicture.asset(
                        "assets/icons/ic_moon.svg",
                        color:  themeChange.isDarkTheme()?AppThemeData.lynch200:AppThemeData.lynch800,
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
              body: SingleChildScrollView(
                child: Padding(
                    padding: paddingEdgeInsets(),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Expanded(
                              flex: 1,
                              child: ContainerCustom(
                                radius: 12,
                                child: ListView.separated(
                                    shrinkWrap: true,
                                    itemCount: controller.settingsAllPage.length,
                                    separatorBuilder: (itemBuilder, index) {
                                      return divider(context, height: 1);
                                    },
                                    itemBuilder: (itemBuilder, index) {
                                      return InkWell(
                                        onTap: () {
                                          controller.settingsAllPage[index].selectIndex = 0;
                                          controller.selectSettingWidget.value = controller.settingsAllPage[index];
                                          controller.update();
                                        },
                                        child: ContainerCustom(
                                          radius: 2,
                                          color: controller.selectSettingWidget.value.title![0] == controller.settingsAllPage[index].title![0]
                                              ? themeChange.isDarkTheme()
                                                  ? AppThemeData.lynch900
                                                  : AppThemeData.lynch100
                                              : null,
                                          child: Row(children: [
                                            SvgPicture.asset(controller.settingsAllPage[index].icon ?? '',
                                                height: 20, width: 20, color: themeChange.isDarkTheme() ? AppThemeData.lynch100 : AppThemeData.lynch900),
                                            spaceW(width: 15),
                                            Expanded(child: TextCustom(title: controller.settingsAllPage[index].title?[0].tr ?? ''))
                                          ]),
                                        ),
                                      );
                                    }),
                              )),
                          spaceW(width: 20),
                          Expanded(flex: 3, child: controller.selectSettingWidget.value.widget![controller.selectSettingWidget.value.selectIndex!]),
                        ])
                      ],
                    )),
              ),
            ),
            desktop: Scaffold(
              backgroundColor: themeChange.isDarkTheme() ? AppThemeData.lynch950 : AppThemeData.lynch50,
              appBar: CommonUI.appBarCustom(themeChange: themeChange, scaffoldKey: controller.scaffoldKeysDrawer),
              body: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (ResponsiveWidget.isDesktop(context)) ...{const MenuWidget()},
                  Expanded(
                    child: Padding(
                      padding: paddingEdgeInsets(),
                      child: ContainerCustom(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Row(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
                                SizedBox(
                                  width: 200,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      TextCustom(
                                        title: 'Settings'.tr,
                                        fontFamily: FontFamily.bold,
                                        fontSize: 20,
                                      ),
                                      spaceH(height: 16),
                                      SizedBox(
                                        height: MediaQuery.of(context).size.height - 200,
                                        child: ListView.builder(
                                            shrinkWrap: true,
                                            physics: const BouncingScrollPhysics(),
                                            itemCount: controller.settingsAllPage.length,
                                            itemBuilder: (itemBuilder, index) {
                                              return InkWell(
                                                onTap: () {
                                                  controller.settingsAllPage[index].selectIndex = 0;
                                                  controller.selectSettingWidget.value = controller.settingsAllPage[index];
                                                  controller.update();
                                                },
                                                child: ContainerCustom(
                                                  radius: 12,
                                                  color: controller.selectSettingWidget.value.title![0] == controller.settingsAllPage[index].title![0]
                                                      ? themeChange.isDarkTheme()
                                                          ? AppThemeData.lynch900
                                                          : AppThemeData.lynch100
                                                      : null,
                                                  child: Row(children: [
                                                    SvgPicture.asset(controller.settingsAllPage[index].icon ?? '',
                                                        height: 20, width: 20, color: themeChange.isDarkTheme() ? AppThemeData.lynch100 : AppThemeData.lynch900),
                                                    spaceW(width: 15),
                                                    Expanded(child: TextCustom(title: controller.settingsAllPage[index].title?[0].tr ?? ''))
                                                  ]),
                                                ),
                                              );
                                            }),
                                      ),
                                    ],
                                  ),
                                ),
                                spaceW(width: 20),
                                Expanded(child: controller.selectSettingWidget.value.widget![controller.selectSettingWidget.value.selectIndex!]),
                              ]),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }
}
