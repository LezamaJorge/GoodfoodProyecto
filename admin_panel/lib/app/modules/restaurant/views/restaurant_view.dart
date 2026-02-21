// ignore_for_file: deprecated_member_use, depend_on_referenced_packages, use_build_context_synchronously, strict_top_level_inference

import 'dart:io';

import 'package:admin_panel/app/components/custom_button.dart';
import 'package:admin_panel/app/components/custom_text_form_field.dart';
import 'package:admin_panel/app/components/dialog_box.dart';
import 'package:admin_panel/app/components/menu_widget.dart';
import 'package:admin_panel/app/components/network_image_widget.dart';
import 'package:admin_panel/app/constant/constants.dart';
import 'package:admin_panel/app/constant/show_toast.dart';
import 'package:admin_panel/app/models/cuisine_model.dart';
import 'package:admin_panel/app/routes/app_pages.dart';
import 'package:admin_panel/app/utils/app_colors.dart';
import 'package:admin_panel/app/utils/app_them_data.dart';
import 'package:admin_panel/app/utils/dark_theme_provider.dart';
import 'package:admin_panel/app/utils/fire_store_utils.dart';
import 'package:admin_panel/app/utils/responsive.dart';
import 'package:admin_panel/app/utils/utils.dart';
import 'package:admin_panel/widget/common_ui.dart';
import 'package:admin_panel/widget/container_custom.dart';
import 'package:admin_panel/widget/global_widgets.dart';
import 'package:admin_panel/widget/gradient_text.dart';
import 'package:admin_panel/widget/text_widget.dart';
import 'package:admin_panel/widget/web_pagination.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import '../../../models/vendor_model.dart';
import '../controllers/restaurant_controller.dart';
import 'package:intl/intl.dart';

class RestaurantView extends GetView<RestaurantController> {
  const RestaurantView({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetX<RestaurantController>(
      init: RestaurantController(),
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
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      child: Column(mainAxisSize: MainAxisSize.min, mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.start, children: [
                        ContainerCustom(
                          child: Column(children: [
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
                                          TextCustom(title: ' ${controller.title.value} ', fontSize: 14, fontFamily: FontFamily.medium, color: AppThemeData.primary500)
                                        ]),
                                      ]),
                                      spaceH(),
                                      Row(
                                        children: [
                                          SizedBox(
                                            width: 120,
                                            child: Obx(
                                              () => DropdownButtonFormField(
                                                borderRadius: BorderRadius.circular(15),
                                                isExpanded: true,
                                                style: TextStyle(
                                                  fontFamily: FontFamily.medium,
                                                  color: themeChange.isDarkTheme() ? AppThemeData.textBlack : AppThemeData.textGrey,
                                                ),
                                                onChanged: (String? statusType) async {
                                                  final now = DateTime.now();
                                                  controller.selectedDateOption.value = statusType ?? "All";
                                                  switch (statusType) {
                                                    case 'Last Month':
                                                      controller.selectedDateRange.value = DateTimeRange(
                                                        start: now.subtract(const Duration(days: 30)),
                                                        end: DateTime(now.year, now.month, now.day, 23, 59, 0, 0),
                                                      );
                                                      await FireStoreUtils.countRestaurantsWithMonth(
                                                        controller.selectedDateRange.value,
                                                      );
                                                      await controller.setPagination(controller.totalItemPerPage.value);
                                                      break;
                                                    case 'Last 6 Months':
                                                      controller.selectedDateRange.value = DateTimeRange(
                                                        start: DateTime(now.year, now.month - 6, now.day),
                                                        end: DateTime(now.year, now.month, now.day, 23, 59, 0, 0),
                                                      );
                                                      await FireStoreUtils.countRestaurantsWithMonth(
                                                        controller.selectedDateRange.value,
                                                      );

                                                      await controller.setPagination(controller.totalItemPerPage.value);
                                                      break;
                                                    case 'Last Year':
                                                      controller.selectedDateRange.value = DateTimeRange(
                                                        start: DateTime(now.year - 1, now.month, now.day),
                                                        end: DateTime(now.year, now.month, now.day, 23, 59, 0, 0),
                                                      );
                                                      await FireStoreUtils.countRestaurantsWithMonth(
                                                        controller.selectedDateRange.value,
                                                      );

                                                      await controller.setPagination(controller.totalItemPerPage.value);
                                                      break;
                                                    case 'Custom':
                                                      showDateRangePicker(context);
                                                      break;
                                                    case 'All':
                                                      controller.selectedDateRange.value = DateTimeRange(
                                                        start: DateTime(
                                                          DateTime.now().year,
                                                          DateTime.now().month - 5, // Subtract 5 months
                                                          1, // Start of the month
                                                        ),
                                                        end: DateTime(
                                                          DateTime.now().year,
                                                          DateTime.now().month,
                                                          DateTime.now().day,
                                                          23,
                                                          59,
                                                          59,
                                                          999, // End of the day
                                                        ),
                                                      );
                                                      await FireStoreUtils.countRestaurants();
                                                      await controller.setPagination(controller.totalItemPerPage.value);

                                                    default:
                                                      controller.selectedDateRange.value = DateTimeRange(
                                                        start: DateTime(now.year, 1, 1),
                                                        end: DateTime(now.year, now.month, now.day, 23, 59, 0, 0),
                                                      );
                                                      break;
                                                  }
                                                },
                                                value: controller.selectedDateOption.value,
                                                items: controller.dateOption.map<DropdownMenuItem<String>>((String value) {
                                                  return DropdownMenuItem(
                                                      value: value.tr,
                                                      child: TextCustom(
                                                        title: value,
                                                        fontFamily: FontFamily.regular,
                                                        fontSize: 16,
                                                        color: themeChange.isDarkTheme() ? AppThemeData.lynch500 : AppThemeData.lynch800,
                                                      ));
                                                }).toList(),
                                                decoration: Constant.DefaultInputDecoration(context),
                                              ),
                                            ),
                                          ),
                                          spaceW(),
                                          SizedBox(
                                            width: ResponsiveWidget.isDesktop(context) ? MediaQuery.of(context).size.width * 0.15 : 200,
                                            child: CustomTextFormField(
                                              hintText: "Search here".tr,
                                              controller: controller.searchController.value,
                                              onFieldSubmitted: (value) async {
                                                if (controller.isSearchEnable.value) {
                                                  await FireStoreUtils.countSearchRestaurant(controller.searchController.value.text, controller.selectedSearchTypeForData.value);
                                                  controller.setPagination(controller.totalItemPerPage.value);
                                                  controller.isSearchEnable.value = false;
                                                } else {
                                                  controller.searchController.value.text = "";
                                                  controller.getRestaurant();
                                                  controller.isSearchEnable.value = true;
                                                }
                                              },
                                              suffix: IconButton(
                                                onPressed: () async {
                                                  if (controller.isSearchEnable.value) {
                                                    await FireStoreUtils.countSearchRestaurant(controller.searchController.value.text, controller.selectedSearchTypeForData.value);
                                                    controller.setPagination(controller.totalItemPerPage.value);
                                                    controller.isSearchEnable.value = false;
                                                  } else {
                                                    controller.searchController.value.text = "";
                                                    controller.getRestaurant();
                                                    controller.isSearchEnable.value = true;
                                                  }
                                                },
                                                icon: Icon(
                                                  controller.isSearchEnable.value ? Icons.search : Icons.clear,
                                                ),
                                              ),
                                              title: '',
                                            ),
                                          ),
                                          spaceW(),
                                          NumberOfRowsDropDown(
                                            controller: controller,
                                          ),
                                          CustomButtonWidget(
                                              title: "+ Add Restaurant",
                                              onPress: () {
                                                controller.setDefaultData();
                                                showDialog(context: context, builder: (context) => const AddRestaurant());
                                              }),
                                          spaceW(),
                                          ContainerCustom(
                                              padding: paddingEdgeInsets(horizontal: 0, vertical: 0),
                                              color: AppThemeData.primary500,
                                              child: IconButton(
                                                onPressed: () {
                                                  controller.dateRangeController.value.text = "";
                                                  controller.selectedDateOptionForPdf.value = "All";
                                                  showDialog(
                                                      context: context,
                                                      builder: (context) => CustomDialog(
                                                            controller: controller,
                                                            title: "Restaurant Statement Download",
                                                            widgetList: [
                                                              const TextCustom(
                                                                title: 'Select Time',
                                                                fontFamily: FontFamily.regular,
                                                                fontSize: 16,
                                                              ),
                                                              spaceH(),
                                                              SizedBox(
                                                                width: 200,
                                                                child: Obx(
                                                                  () => DropdownButtonFormField(
                                                                    borderRadius: BorderRadius.circular(15),
                                                                    isExpanded: true,
                                                                    style: TextStyle(
                                                                      fontFamily: FontFamily.medium,
                                                                      color: themeChange.isDarkTheme() ? AppThemeData.textBlack : AppThemeData.textGrey,
                                                                    ),
                                                                    onChanged: (String? statusType) {
                                                                      final now = DateTime.now();
                                                                      controller.selectedDateOptionForPdf.value = statusType ?? "All";
                                                                      switch (statusType) {
                                                                        case 'Last Month':
                                                                          controller.selectedDateRangeForPdf.value = DateTimeRange(
                                                                            start: now.subtract(const Duration(days: 30)),
                                                                            end: DateTime(now.year, now.month, now.day, 23, 59, 0, 0),
                                                                          );
                                                                          break;
                                                                        case 'Last 6 Months':
                                                                          controller.selectedDateRangeForPdf.value = DateTimeRange(
                                                                            start: DateTime(now.year, now.month - 6, now.day),
                                                                            end: DateTime(now.year, now.month, now.day, 23, 59, 0, 0),
                                                                          );
                                                                          break;
                                                                        case 'Last Year':
                                                                          controller.selectedDateRangeForPdf.value = DateTimeRange(
                                                                            start: DateTime(now.year - 1, now.month, now.day),
                                                                            end: DateTime(now.year, now.month, now.day, 23, 59, 0, 0),
                                                                          );
                                                                          break;
                                                                        case 'Custom':
                                                                          controller.isCustomVisible.value = true;
                                                                          break;
                                                                        case 'All':
                                                                        default:
                                                                          // No specific filter, maybe assign null or a full year
                                                                          controller.selectedDateRangeForPdf.value = DateTimeRange(
                                                                            start: DateTime(now.year, 1, 1),
                                                                            end: DateTime(now.year, now.month, now.day, 23, 59, 0, 0),
                                                                          );
                                                                          break;
                                                                      }

                                                                      controller.isCustomVisible.value = statusType == 'Custom';
                                                                    },
                                                                    value: controller.selectedDateOptionForPdf.value,
                                                                    items: controller.dateOption.map<DropdownMenuItem<String>>((String value) {
                                                                      return DropdownMenuItem(
                                                                        value: value.tr,
                                                                        child: TextCustom(
                                                                          title: value,
                                                                          fontFamily: FontFamily.regular,
                                                                          fontSize: 16,
                                                                          color: themeChange.isDarkTheme() ? AppThemeData.lynch500 : AppThemeData.lynch800,
                                                                        ),
                                                                      );
                                                                    }).toList(),
                                                                    decoration: Constant.DefaultInputDecoration(context),
                                                                  ),
                                                                ),
                                                              ),
                                                              spaceH(),
                                                              Obx(
                                                                () => Visibility(
                                                                  visible: controller.isCustomVisible.value,
                                                                  child: CustomTextFormField(
                                                                    validator: (value) => value != null && value.isNotEmpty ? null : 'Start & End Date Required'.tr,
                                                                    hintText: "Select Start & End Date",
                                                                    controller: controller.dateRangeController.value,
                                                                    title: "Start & End Date",
                                                                    onPress: () {
                                                                      showDateRangePickerForPdf(context);
                                                                    },
                                                                    // isReadOnly: true,
                                                                    suffix: const Icon(
                                                                      Icons.calendar_month_outlined,
                                                                      color: AppThemeData.lynch500,
                                                                      size: 24,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                            bottomWidgetList: [
                                                              CustomButtonWidget(
                                                                textColor: themeChange.isDarkTheme() ? Colors.white : Colors.black,
                                                                buttonColor: themeChange.isDarkTheme() ? AppThemeData.lynch900 : AppThemeData.lynch100,
                                                                onPress: () {
                                                                  Navigator.pop(context);
                                                                },
                                                                title: "Close",
                                                              ),
                                                              spaceW(),
                                                              Obx(
                                                                () => controller.isHistoryDownload.value
                                                                    ? Constant.circularProgressIndicatourLoader()
                                                                    : CustomButtonWidget(
                                                                        onPress: () {
                                                                          if (Constant.isDemo) {
                                                                            DialogBox.demoDialogBox();
                                                                          } else {
                                                                            if (controller.selectedDateOptionForPdf.value == 'Custom' && controller.dateRangeController.value.text.isEmpty) {
                                                                              ShowToastDialog.errorToast("Please select both a start and end date.");
                                                                              return;
                                                                            } else {
                                                                              controller.downloadOrdersPdf(context);
                                                                            }
                                                                          }
                                                                        },
                                                                        title: "Download".tr,
                                                                      ),
                                                              ),
                                                            ],
                                                          ));
                                                },
                                                icon: SvgPicture.asset(
                                                  "assets/icons/ic_download.svg",
                                                  color: AppThemeData.primaryWhite,
                                                  height: 24,
                                                  width: 24,
                                                ),
                                              ))
                                        ],
                                      ),
                                      // spaceH(),
                                    ],
                                  )
                                : Column(mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.start, children: [
                                    Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                      TextCustom(title: controller.title.value, fontSize: 20, fontFamily: FontFamily.bold),
                                      spaceH(height: 2),
                                      Row(children: [
                                        InkWell(
                                            onTap: () => Get.offAllNamed(Routes.DASHBOARD_SCREEN),
                                            child: TextCustom(title: 'Dashboard'.tr, fontSize: 14, fontFamily: FontFamily.medium, color: AppThemeData.lynch500)),
                                        const TextCustom(title: ' / ', fontSize: 14, fontFamily: FontFamily.medium, color: AppThemeData.lynch500),
                                        TextCustom(title: ' ${controller.title.value} ', fontSize: 14, fontFamily: FontFamily.medium, color: AppThemeData.primary500)
                                      ])
                                    ]),
                                    spaceH(),
                                    Row(
                                      children: [
                                        SizedBox(
                                          width: MediaQuery.sizeOf(context).width * 0.3,
                                          child: Obx(
                                            () => DropdownButtonFormField(
                                              borderRadius: BorderRadius.circular(15),
                                              isExpanded: true,
                                              style: TextStyle(
                                                fontFamily: FontFamily.medium,
                                                color: themeChange.isDarkTheme() ? AppThemeData.primaryWhite : AppThemeData.textBlack,
                                              ),
                                              onChanged: (String? searchType) {
                                                controller.selectedSearchType.value = searchType ?? "Name";
                                                controller.getSearchType();
                                              },
                                              value: controller.selectedSearchType.value,
                                              items: controller.searchType.map<DropdownMenuItem<String>>((String value) {
                                                return DropdownMenuItem(
                                                  value: value,
                                                  child: TextCustom(
                                                    title: value,
                                                    fontFamily: FontFamily.regular,
                                                    fontSize: 16,
                                                  ),
                                                );
                                              }).toList(),
                                              decoration: Constant.DefaultInputDecoration(context),
                                            ),
                                          ),
                                        ),
                                        spaceW(),
                                        Expanded(
                                          child: CustomTextFormField(
                                            hintText: "Search here".tr,
                                            controller: controller.searchController.value,
                                            onFieldSubmitted: (value) async {
                                              if (controller.isSearchEnable.value) {
                                                await FireStoreUtils.countSearchUsers(controller.searchController.value.text, controller.selectedSearchTypeForData.value);
                                                controller.setPagination(controller.totalItemPerPage.value);
                                                controller.isSearchEnable.value = false;
                                              } else {
                                                controller.searchController.value.text = "";
                                                controller.getRestaurant();
                                                controller.isSearchEnable.value = true;
                                              }
                                            },
                                            suffix: IconButton(
                                              onPressed: () async {
                                                if (controller.isSearchEnable.value) {
                                                  await FireStoreUtils.countSearchUsers(controller.searchController.value.text, controller.selectedSearchTypeForData.value);
                                                  controller.setPagination(controller.totalItemPerPage.value);
                                                  controller.isSearchEnable.value = false;
                                                } else {
                                                  controller.searchController.value.text = "";
                                                  controller.getRestaurant();
                                                  controller.isSearchEnable.value = true;
                                                }
                                              },
                                              icon: Icon(
                                                controller.isSearchEnable.value ? Icons.search : Icons.clear,
                                              ),
                                            ),
                                            title: '',
                                          ),
                                        ),
                                      ],
                                    ),
                                    spaceH(),
                                    Row(
                                      children: [
                                        SizedBox(
                                          width: 110,
                                          child: Obx(
                                            () => DropdownButtonFormField(
                                              borderRadius: BorderRadius.circular(15),
                                              isExpanded: true,
                                              style: TextStyle(
                                                fontFamily: FontFamily.medium,
                                                color: themeChange.isDarkTheme() ? AppThemeData.textBlack : AppThemeData.textGrey,
                                              ),
                                              onChanged: (String? statusType) async {
                                                final now = DateTime.now();
                                                controller.selectedDateOption.value = statusType ?? "All";
                                                switch (statusType) {
                                                  case 'Last Month':
                                                    controller.selectedDateRange.value = DateTimeRange(
                                                      start: now.subtract(const Duration(days: 30)),
                                                      end: DateTime(now.year, now.month, now.day, 23, 59, 0, 0),
                                                    );
                                                    await FireStoreUtils.countRestaurantsWithMonth(
                                                      controller.selectedDateRange.value,
                                                    );
                                                    await controller.setPagination(controller.totalItemPerPage.value);
                                                    break;
                                                  case 'Last 6 Months':
                                                    controller.selectedDateRange.value = DateTimeRange(
                                                      start: DateTime(now.year, now.month - 6, now.day),
                                                      end: DateTime(now.year, now.month, now.day, 23, 59, 0, 0),
                                                    );
                                                    await FireStoreUtils.countRestaurantsWithMonth(
                                                      controller.selectedDateRange.value,
                                                    );

                                                    await controller.setPagination(controller.totalItemPerPage.value);
                                                    break;
                                                  case 'Last Year':
                                                    controller.selectedDateRange.value = DateTimeRange(
                                                      start: DateTime(now.year - 1, now.month, now.day),
                                                      end: DateTime(now.year, now.month, now.day, 23, 59, 0, 0),
                                                    );
                                                    await FireStoreUtils.countRestaurantsWithMonth(
                                                      controller.selectedDateRange.value,
                                                    );

                                                    await controller.setPagination(controller.totalItemPerPage.value);
                                                    break;
                                                  case 'Custom':
                                                    showDateRangePicker(context);
                                                    break;
                                                  case 'All':
                                                    controller.selectedDateRange.value = DateTimeRange(
                                                      start: DateTime(
                                                        DateTime.now().year,
                                                        DateTime.now().month - 5, // Subtract 5 months
                                                        1, // Start of the month
                                                      ),
                                                      end: DateTime(
                                                        DateTime.now().year,
                                                        DateTime.now().month,
                                                        DateTime.now().day,
                                                        23,
                                                        59,
                                                        59,
                                                        999, // End of the day
                                                      ),
                                                    );
                                                    await FireStoreUtils.countRestaurants();
                                                    await controller.setPagination(controller.totalItemPerPage.value);

                                                  default:
                                                    // No specific filter, maybe assign null or a full year
                                                    controller.selectedDateRange.value = DateTimeRange(
                                                      start: DateTime(now.year, 1, 1),
                                                      end: DateTime(now.year, now.month, now.day, 23, 59, 0, 0),
                                                    );
                                                    break;
                                                }
                                              },
                                              value: controller.selectedDateOption.value,
                                              items: controller.dateOption.map<DropdownMenuItem<String>>((String value) {
                                                return DropdownMenuItem(
                                                    value: value.tr,
                                                    child: TextCustom(
                                                      title: value,
                                                      fontFamily: FontFamily.regular,
                                                      fontSize: 16,
                                                      color: themeChange.isDarkTheme() ? AppThemeData.lynch500 : AppThemeData.lynch800,
                                                    ));
                                              }).toList(),
                                              decoration: Constant.DefaultInputDecoration(context),
                                            ),
                                          ),
                                        ),
                                        spaceW(),
                                        NumberOfRowsDropDown(
                                          controller: controller,
                                        ),
                                        CustomButtonWidget(
                                            title: "+ Add Restaurant",
                                            onPress: () {
                                              controller.setDefaultData();
                                              showDialog(context: context, builder: (context) => const AddRestaurant());
                                            }),
                                        spaceW(),
                                        ContainerCustom(
                                            padding: paddingEdgeInsets(horizontal: 0, vertical: 0),
                                            color: AppThemeData.primary500,
                                            child: IconButton(
                                              onPressed: () {
                                                controller.dateRangeController.value.text = "";
                                                controller.selectedDateOptionForPdf.value = "All";
                                                showDialog(
                                                    context: context,
                                                    builder: (context) => CustomDialog(
                                                          controller: controller,
                                                          title: "Restaurant Statement Download",
                                                          widgetList: [
                                                            const TextCustom(
                                                              title: 'Select Time',
                                                              fontFamily: FontFamily.regular,
                                                              fontSize: 16,
                                                            ),
                                                            spaceH(),
                                                            SizedBox(
                                                              width: 200,
                                                              child: Obx(
                                                                () => DropdownButtonFormField(
                                                                  borderRadius: BorderRadius.circular(15),
                                                                  isExpanded: true,
                                                                  style: TextStyle(
                                                                    fontFamily: FontFamily.medium,
                                                                    color: themeChange.isDarkTheme() ? AppThemeData.textBlack : AppThemeData.textGrey,
                                                                  ),
                                                                  onChanged: (String? statusType) {
                                                                    // controller.selectedDateOption.value = statusType ?? "All";
                                                                    // if (statusType == 'Custom') {
                                                                    //   controller.isCustomVisible.value = true;
                                                                    // } else {
                                                                    //   controller.isCustomVisible.value = false;
                                                                    // }
                                                                    // controller.getBookingDataByBookingStatus();
                                                                    final now = DateTime.now();
                                                                    controller.selectedDateOptionForPdf.value = statusType ?? "All";
                                                                    switch (statusType) {
                                                                      case 'Last Month':
                                                                        controller.selectedDateRangeForPdf.value = DateTimeRange(
                                                                          start: now.subtract(const Duration(days: 30)),
                                                                          end: DateTime(now.year, now.month, now.day, 23, 59, 0, 0),
                                                                        );
                                                                        break;
                                                                      case 'Last 6 Months':
                                                                        controller.selectedDateRangeForPdf.value = DateTimeRange(
                                                                          start: DateTime(now.year, now.month - 6, now.day),
                                                                          end: DateTime(now.year, now.month, now.day, 23, 59, 0, 0),
                                                                        );
                                                                        break;
                                                                      case 'Last Year':
                                                                        controller.selectedDateRangeForPdf.value = DateTimeRange(
                                                                          start: DateTime(now.year - 1, now.month, now.day),
                                                                          end: DateTime(now.year, now.month, now.day, 23, 59, 0, 0),
                                                                        );
                                                                        break;
                                                                      case 'Custom':
                                                                        controller.isCustomVisible.value = true;
                                                                        break;
                                                                      case 'All':
                                                                      default:
                                                                        // No specific filter, maybe assign null or a full year
                                                                        controller.selectedDateRangeForPdf.value = DateTimeRange(
                                                                          start: DateTime(now.year, 1, 1),
                                                                          end: DateTime(now.year, now.month, now.day, 23, 59, 0, 0),
                                                                        );
                                                                        break;
                                                                    }

                                                                    controller.isCustomVisible.value = statusType == 'Custom';
                                                                  },
                                                                  value: controller.selectedDateOptionForPdf.value,
                                                                  items: controller.dateOption.map<DropdownMenuItem<String>>((String value) {
                                                                    return DropdownMenuItem(
                                                                      value: value.tr,
                                                                      child: TextCustom(
                                                                        title: value,
                                                                        fontFamily: FontFamily.regular,
                                                                        fontSize: 16,
                                                                        color: themeChange.isDarkTheme() ? AppThemeData.lynch500 : AppThemeData.lynch800,
                                                                      ),
                                                                    );
                                                                  }).toList(),
                                                                  decoration: Constant.DefaultInputDecoration(context),
                                                                ),
                                                              ),
                                                            ),
                                                            spaceH(),
                                                            Obx(
                                                              () => Visibility(
                                                                visible: controller.isCustomVisible.value,
                                                                child: CustomTextFormField(
                                                                  validator: (value) => value != null && value.isNotEmpty ? null : 'Start & End Date Required'.tr,
                                                                  hintText: "Select Start & End Date",
                                                                  controller: controller.dateRangeController.value,
                                                                  title: "Start & End Date",
                                                                  onPress: () {
                                                                    showDateRangePickerForPdf(context);
                                                                  },
                                                                  // isReadOnly: true,
                                                                  suffix: const Icon(
                                                                    Icons.calendar_month_outlined,
                                                                    color: AppThemeData.lynch500,
                                                                    size: 24,
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                          bottomWidgetList: [
                                                            CustomButtonWidget(
                                                              textColor: themeChange.isDarkTheme() ? Colors.white : Colors.black,
                                                              buttonColor: themeChange.isDarkTheme() ? AppThemeData.lynch900 : AppThemeData.lynch100,
                                                              onPress: () {
                                                                Navigator.pop(context);
                                                              },
                                                              title: "Close",
                                                            ),
                                                            spaceW(),
                                                            Obx(
                                                              () => controller.isHistoryDownload.value
                                                                  ? Constant.circularProgressIndicatourLoader()
                                                                  : CustomButtonWidget(
                                                                      onPress: () {
                                                                        if (Constant.isDemo) {
                                                                          DialogBox.demoDialogBox();
                                                                        } else {
                                                                          if (controller.selectedDateOptionForPdf.value == 'Custom' && controller.dateRangeController.value.text.isEmpty) {
                                                                            ShowToastDialog.errorToast("Please select both a start and end date.");
                                                                            return;
                                                                          } else {
                                                                            controller.downloadOrdersPdf(context);
                                                                          }
                                                                          // Add your download logic here
                                                                        }
                                                                      },
                                                                      title: "Download".tr,
                                                                    ),
                                                            ),
                                                          ],
                                                        ));
                                              },
                                              icon: SvgPicture.asset(
                                                "assets/icons/ic_download.svg",
                                                color: AppThemeData.primaryWhite,
                                                height: 24,
                                                width: 24,
                                              ),
                                            )),
                                      ],
                                    )
                                  ]),
                            spaceH(height: 20),
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: controller.isLoading.value
                                      ? Padding(
                                          padding: paddingEdgeInsets(),
                                          child: Constant.loader(),
                                        )
                                      : controller.currentPageRestaurantList.isEmpty
                                          ? TextCustom(title: "No Data available".tr)
                                          : DataTable(
                                              horizontalMargin: 20,
                                              columnSpacing: 30,
                                              dataRowMaxHeight: 65,
                                              headingRowHeight: 65,
                                              border: TableBorder.all(
                                                color: themeChange.isDarkTheme() ? AppThemeData.lynch800 : AppThemeData.lynch100,
                                                borderRadius: BorderRadius.circular(12),
                                              ),
                                              headingRowColor: WidgetStateColor.resolveWith((states) => themeChange.isDarkTheme() ? AppThemeData.lynch800 : AppThemeData.lynch100),
                                              columns: [
                                                CommonUI.dataColumnWidget(context, columnTitle: "Name".tr, width: 150),
                                                CommonUI.dataColumnWidget(context,
                                                    columnTitle: "Owner Name".tr, width: ResponsiveWidget.isMobile(context) ? 150 : MediaQuery.of(context).size.width * 0.15),
                                                CommonUI.dataColumnWidget(context,
                                                    columnTitle: "Created At".tr, width: ResponsiveWidget.isMobile(context) ? 150 : MediaQuery.of(context).size.width * 0.15),
                                                CommonUI.dataColumnWidget(context,
                                                    columnTitle: "Cuisine".tr, width: ResponsiveWidget.isMobile(context) ? 150 : MediaQuery.of(context).size.width * 0.12),
                                                CommonUI.dataColumnWidget(context,
                                                    columnTitle: "Status".tr, width: ResponsiveWidget.isMobile(context) ? 100 : MediaQuery.of(context).size.width * 0.06),
                                                CommonUI.dataColumnWidget(context, columnTitle: "Action".tr, width: ResponsiveWidget.isMobile(context) ? 100 : MediaQuery.of(context).size.width * 0.10)
                                              ],
                                              rows: controller.currentPageRestaurantList
                                                  .map((restaurantModel) => DataRow(cells: [
                                                        DataCell(Row(
                                                          children: [
                                                            NetworkImageWidget(
                                                              imageUrl: restaurantModel.coverImage.toString(),
                                                              height: 35,
                                                              width: 35,
                                                            ),
                                                            spaceW(width: 8),
                                                            InkWell(
                                                              onTap: () async {
                                                                Get.toNamed("${Routes.RESTAURANT_DETAILS}/${restaurantModel.id}");
                                                              },
                                                              child: TextCustom(
                                                                title: restaurantModel.vendorName.toString(),
                                                                fontSize: 14,
                                                                fontFamily: FontFamily.regular,
                                                              ),
                                                            ),
                                                          ],
                                                        )),
                                                        DataCell(TextCustom(
                                                          title: restaurantModel.ownerFullName.toString(),
                                                          fontSize: 14,
                                                          fontFamily: FontFamily.regular,
                                                        )),
                                                        DataCell(
                                                          TextCustom(
                                                            title: Constant.timestampToDate(restaurantModel.createdAt!),
                                                            fontSize: 14,
                                                            fontFamily: FontFamily.regular,
                                                          ),
                                                        ),
                                                        DataCell(
                                                          TextCustom(
                                                            title: restaurantModel.cuisineName.toString(),
                                                            fontSize: 14,
                                                            fontFamily: FontFamily.regular,
                                                          ),
                                                        ),
                                                        DataCell(
                                                          Transform.scale(
                                                            scale: 0.8,
                                                            child: CupertinoSwitch(
                                                              activeTrackColor: AppThemeData.primary500,
                                                              value: restaurantModel.active ?? false,
                                                              onChanged: (value) async {
                                                                if (Constant.isDemo) {
                                                                  DialogBox.demoDialogBox();
                                                                } else {
                                                                  restaurantModel.active = value;
                                                                  await FireStoreUtils.updateNewRestaurant(restaurantModel);
                                                                  controller.getRestaurant();
                                                                }
                                                              },
                                                            ),
                                                          ),
                                                        ),
                                                        DataCell(Container(
                                                          alignment: Alignment.center,
                                                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                                                          child: Row(
                                                            mainAxisAlignment: MainAxisAlignment.start,
                                                            children: [
                                                              InkWell(
                                                                onTap: () async {
                                                                  Get.toNamed("${Routes.RESTAURANT_DETAILS}/${restaurantModel.id}");
                                                                },
                                                                child: SvgPicture.asset(
                                                                  "assets/icons/ic_eye.svg",
                                                                  color: themeChange.isDarkTheme() ? AppThemeData.lynch400 : AppThemeData.lynch500,
                                                                  height: 16,
                                                                  width: 16,
                                                                ),
                                                              ),
                                                              spaceW(width: 20),
                                                              InkWell(
                                                                onTap: () {
                                                                  //controller.getArgument(controller.restaurantModel.value);
                                                                  showDialog(
                                                                      context: context,
                                                                      builder: (context) => AddRestaurant(
                                                                            vendorModel: restaurantModel,
                                                                            isEditing: true,
                                                                          ));
                                                                  // showGlobalDrawer(duration: const Duration(milliseconds: 200), barrierDismissible: true, context: context, builder: updateRestaurantDrawer(), direction: AxisDirection.right);
                                                                },
                                                                child: SvgPicture.asset(
                                                                  "assets/icons/ic_edit.svg",
                                                                  color: themeChange.isDarkTheme() ? AppThemeData.lynch400 : AppThemeData.lynch500,
                                                                  height: 16,
                                                                  width: 16,
                                                                ),
                                                              ),
                                                              spaceW(width: 20),
                                                              InkWell(
                                                                onTap: () async {
                                                                  if (Constant.isDemo) {
                                                                    DialogBox.demoDialogBox();
                                                                  } else {
                                                                    // await controller.removePassengers(userModel);
                                                                    // controller.getUser();
                                                                    bool confirmDelete = await DialogBox.showConfirmationDeleteDialog(context);
                                                                    if (confirmDelete) {
                                                                      await controller.removeRestaurant(restaurantModel);
                                                                      controller.getRestaurant();
                                                                    }
                                                                  }
                                                                },
                                                                child: SvgPicture.asset(
                                                                  "assets/icons/ic_delete.svg",
                                                                  height: 16,
                                                                  width: 16,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        )),
                                                      ]))
                                                  .toList())),
                            ),
                            spaceH(),
                            ResponsiveWidget.isMobile(context)
                                ? Visibility(
                                    visible: controller.totalPage.value > 1,
                                    child: SingleChildScrollView(
                                      // Wrap the Row with SingleChildScrollView
                                      scrollDirection: Axis.horizontal, // Enable horizontal scrolling
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: [
                                          WebPagination(
                                            currentPage: controller.currentPage.value,
                                            totalPage: controller.totalPage.value,
                                            displayItemCount: controller.pageValue("5"),
                                            onPageChanged: (page) {
                                              controller.currentPage.value = page;
                                              controller.setPagination(controller.totalItemPerPage.value);
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                : Visibility(
                                    visible: controller.totalPage.value > 1,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Align(
                                          alignment: Alignment.centerRight,
                                          child: WebPagination(
                                              currentPage: controller.currentPage.value,
                                              totalPage: controller.totalPage.value,
                                              displayItemCount: controller.pageValue("5"),
                                              onPageChanged: (page) {
                                                controller.currentPage.value = page;
                                                controller.setPagination(controller.totalItemPerPage.value);
                                              }),
                                        )
                                      ],
                                    ),
                                  ),
                          ]),
                        )
                      ]),
                    )),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> showDateRangePicker(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Select Date'.tr),
          content: SizedBox(
            height: 300,
            width: 300,
            child: SfDateRangePicker(
              initialDisplayDate: DateTime.now(),
              maxDate: DateTime.now(),
              selectionMode: DateRangePickerSelectionMode.range,
              onSelectionChanged: (DateRangePickerSelectionChangedArgs args) async {
                if (args.value is PickerDateRange) {
                  controller.startDate = (args.value as PickerDateRange).startDate;
                  controller.endDate = (args.value as PickerDateRange).endDate;
                  controller.selectedDateRange.value =
                      DateTimeRange(start: controller.startDate!, end: DateTime(controller.endDate!.year, controller.endDate!.month, controller.endDate!.day, 23, 59, 0, 0));
                }
              },
            ),
          ),
          actions: <Widget>[
            ElevatedButton(
                onPressed: () async {
                  controller.selectedDateRange.value = DateTimeRange(
                    start: DateTime(
                      DateTime.now().year,
                      DateTime.now().month - 5, // Subtract 5 months
                      1, // Start of the month
                    ),
                    end: DateTime(
                      DateTime.now().year,
                      DateTime.now().month,
                      DateTime.now().day,
                      23,
                      59,
                      59,
                      999, // End of the day
                    ),
                  );
                  await FireStoreUtils.countRestaurantsWithMonth(
                    controller.selectedDateRange.value,
                  );
                  await controller.setPagination(controller.totalItemPerPage.value);

                  Navigator.of(context).pop();
                },
                child: Text('clear'.tr)),
            TextButton(
              onPressed: () async {
                await FireStoreUtils.countRestaurantsWithMonth(
                  controller.selectedDateRange.value,
                );
                if (controller.startDate != null && controller.endDate != null) {
                  await FireStoreUtils.countRestaurantsWithMonth(
                    controller.selectedDateRange.value,
                  );
                  await controller.setPagination(controller.totalItemPerPage.value);
                }
                Navigator.of(context).pop();
              },
              child: Text('OK'.tr),
            ),
          ],
        );
      },
    );
  }

  Future<void> showDateRangePickerForPdf(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select Date'),
          content: SizedBox(
            height: 300,
            width: 300,
            child: SfDateRangePicker(
              initialDisplayDate: DateTime.now(),
              maxDate: DateTime.now(),
              selectionMode: DateRangePickerSelectionMode.range,
              onSelectionChanged: (DateRangePickerSelectionChangedArgs args) async {
                if (args.value is PickerDateRange) {
                  controller.startDateForPdf = (args.value as PickerDateRange).startDate;
                  controller.endDateForPdf = (args.value as PickerDateRange).endDate;
                }
              },
            ),
          ),
          actions: <Widget>[
            ElevatedButton(
                onPressed: () {
                  controller.selectedDateRangeForPdf.value =
                      DateTimeRange(start: DateTime(DateTime.now().year, DateTime.january, 1), end: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, 23, 59, 0, 0));
                  Navigator.of(context).pop();
                },
                child: const Text('clear')),
            TextButton(
              onPressed: () async {
                if (controller.startDateForPdf != null && controller.endDateForPdf != null) {
                  controller.selectedDateRangeForPdf.value =
                      DateTimeRange(start: controller.startDateForPdf!, end: DateTime(controller.endDateForPdf!.year, controller.endDateForPdf!.month, controller.endDateForPdf!.day, 23, 59, 0, 0));
                  controller.dateRangeController.value.text =
                      "${DateFormat('dd/MM/yyyy').format(controller.selectedDateRangeForPdf.value.start)} to ${DateFormat('dd/MM/yyyy').format(controller.selectedDateRangeForPdf.value.end)}";
                }
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}

class AddRestaurant extends StatelessWidget {
  final VendorModel? vendorModel;
  final bool isEditing;

  const AddRestaurant({super.key, this.vendorModel, this.isEditing = false});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    final controller = Get.put(RestaurantController());
    if (isEditing == true && vendorModel != null) {
      controller.getArgument(vendorModel!);
    }
    return GetX<RestaurantController>(
      builder: (_) {
        return CustomDialog(
          title: controller.isEditing.value == true ? 'Edit Restaurant'.tr : 'Add Restaurant'.tr,
          width: ResponsiveWidget.isDesktop(context) ? MediaQuery.of(context).size.width * .6 : MediaQuery.of(context).size.width * .8,
          widgetList: [
            Row(
              children: [
                SvgPicture.asset("assets/new_icon/ic_user_fill.svg", color: themeChange.isDarkTheme() ? AppThemeData.primaryWhite : AppThemeData.primaryBlack),
                spaceW(width: 8),
                const TextCustom(
                  title: "Owner Details",
                  fontSize: 16,
                  fontFamily: FontFamily.medium,
                ),
              ],
            ),
            spaceH(height: 16),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomTextFormField(hintText: "Enter First Name", title: "First Name", controller: controller.ownerFirstNameController.value).expand(),
                spaceW(width: 20),
                CustomTextFormField(hintText: "Enter Last Name", title: "Last Name", controller: controller.ownerLastNameController.value).expand(),
              ],
            ),
            spaceH(height: 16),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomTextFormField(
                  hintText: "Enter Email",
                  title: "Email".tr,
                  controller: controller.ownerEmailController.value,
                  validator: (value) => Constant.validateEmail(value),
                  readOnly: controller.isEditing.value,
                ).expand(),
                spaceW(width: 20),
                controller.isEditing.value
                    ? MobileNumberTextField(
                        controller: controller.ownerMobileNumberController.value,
                        countryCode: controller.countryCode.value,
                        onPress: () {},
                        title: "Phone Number".tr,
                        readOnly: controller.isEditing.value,
                      ).expand()
                    : CustomTextFormField(
                        hintText: "Enter Password",
                        title: "Password".tr,
                        readOnly: controller.isEditing.value,
                        controller: controller.ownerPasswordController.value,
                        validator: (value) => Constant.validatePassword(value),
                        obscureText: controller.isPasswordVisible.value,
                        suffix: Icon(
                          controller.isPasswordVisible.value ? Icons.visibility_off : Icons.visibility,
                          color: AppThemeData.gallery500,
                        ).onTap(() {
                          controller.isPasswordVisible.value = !controller.isPasswordVisible.value;
                        }),
                      ).expand(),
              ],
            ),
            spaceH(height: 16),
            if (!controller.isEditing.value)
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  MobileNumberTextField(
                    controller: controller.ownerMobileNumberController.value,
                    countryCode: controller.countryCode.value,
                    onPress: () {},
                    title: "Phone Number".tr,
                    readOnly: controller.isEditing.value,
                  ).expand(),
                  spaceW(width: 20),
                  const SizedBox().expand(),
                ],
              ),
            spaceH(height: 24),
            Row(
              children: [
                SvgPicture.asset("assets/new_icon/ic_homeline.svg", color: themeChange.isDarkTheme() ? AppThemeData.primaryWhite : AppThemeData.primaryBlack),
                spaceW(width: 8),
                const TextCustom(title: "Restaurant Details", fontSize: 16, fontFamily: FontFamily.medium),
              ],
            ),
            spaceH(height: 16),
            Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextCustom(
                      title: "Cover Image".tr,
                      fontSize: 14,
                    ),
                    spaceH(height: 8),
                    InkWell(
                      onTap: () async {
                        ImagePicker picker = ImagePicker();
                        final img = await picker.pickImage(source: ImageSource.gallery, imageQuality: 80);
                        if (img != null) {
                          final allowedExtensions = ['jpg', 'jpeg', 'png'];
                          String fileExtension = img.name.split('.').last.toLowerCase();

                          if (!allowedExtensions.contains(fileExtension)) {
                            ShowToastDialog.errorToast("Invalid file type. Please select a .jpg, .jpeg, or .png image.".tr);
                            return;
                          }
                          File imageFile = File(img.path);
                          controller.restaurantCoverImageController.value.text = img.name;
                          controller.restaurantCoverImage.value = imageFile;
                          controller.mimeType.value = "${img.mimeType}";
                          // controller.isImageUpdated.value = true;
                        }
                      },
                      child: DottedBorder(
                        options: RoundedRectDottedBorderOptions(
                          dashPattern: const [6, 6, 6, 6],
                          color: themeChange.isDarkTheme() ? AppThemeData.lynch700 : AppThemeData.lynch300,
                          radius: const Radius.circular(12),
                        ),
                        child: controller.isEditing.value == true
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: CachedNetworkImage(
                                  imageUrl: controller.restaurantCoverImage.value.path.isEmpty ? controller.restaurantCoverImageURL.value : controller.restaurantCoverImage.value.path,
                                  height: 174.h,
                                  width: double.infinity,
                                  fit: BoxFit.contain,
                                ),
                              )
                            : controller.restaurantCoverImage.value.path.isEmpty
                                ? Container(
                                    height: 174.h,
                                    width: double.infinity,
                                    decoration: const BoxDecoration(
                                      borderRadius: BorderRadius.all(Radius.circular(12)),
                                    ),
                                    child: Padding(
                                      padding: paddingEdgeInsets(),
                                      child: Center(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            SvgPicture.asset(
                                              "assets/icons/ic_upload.svg",
                                              color: AppThemeData.lynch500,
                                            ),
                                            spaceH(height: 16),
                                            TextCustom(
                                              title: "Upload the restaurant cover image".tr,
                                              maxLine: 2,
                                              color: themeChange.isDarkTheme() ? AppThemeData.primaryWhite : AppThemeData.primaryBlack,
                                              fontFamily: FontFamily.regular,
                                            ),
                                            TextCustom(
                                              title: "image must be a .jpg, .jpeg".tr,
                                              maxLine: 1,
                                              fontSize: 12,
                                              color: AppThemeData.secondary300,
                                              fontFamily: FontFamily.light,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  )
                                : ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: NetworkImageWidget(
                                      imageUrl: controller.restaurantCoverImage.value.path.toString(),
                                      fit: BoxFit.contain,
                                      height: 174.h,
                                      width: double.infinity,
                                    )),
                      ),
                    ),
                  ],
                ).expand(),
                spaceW(width: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextCustom(
                      title: "Restaurant Logo".tr,
                      fontSize: 14,
                    ),
                    spaceH(height: 8),
                    InkWell(
                      onTap: () async {
                        ImagePicker picker = ImagePicker();
                        final img = await picker.pickImage(source: ImageSource.gallery, imageQuality: 80);
                        if (img != null) {
                          final allowedExtensions = ['jpg', 'jpeg', 'png'];
                          String fileExtension = img.name.split('.').last.toLowerCase();

                          if (!allowedExtensions.contains(fileExtension)) {
                            ShowToastDialog.errorToast("Invalid file type. Please select a .jpg, .jpeg, or .png image.".tr);
                            return;
                          }

                          File imageFile = File(img.path);
                          controller.restaurantLogoController.value.text = img.name;
                          controller.restaurantLogo.value = imageFile;
                          controller.mimeType.value = "${img.mimeType}";
                          // controller.isImageUpdated.value = true;
                        }
                      },
                      child: DottedBorder(
                        options: RoundedRectDottedBorderOptions(
                          dashPattern: const [6, 6, 6, 6],
                          color: themeChange.isDarkTheme() ? AppThemeData.lynch700 : AppThemeData.lynch300,
                          radius: const Radius.circular(12),
                        ),
                        child: controller.isEditing.value == true
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: CachedNetworkImage(
                                  imageUrl: controller.restaurantLogo.value.path.isEmpty ? controller.restaurantLogoURL.value : controller.restaurantLogo.value.path,
                                  height: 174.h,
                                  width: double.infinity,
                                  fit: BoxFit.contain,
                                ),
                              )
                            : controller.restaurantLogo.value.path.isEmpty
                                ? Container(
                                    height: 174.h,
                                    width: double.infinity,
                                    decoration: const BoxDecoration(
                                      borderRadius: BorderRadius.all(Radius.circular(12)),
                                      // color: themeChange.isDarkTheme() ? AppThemeData.surface1000 : AppThemeData.surface50,
                                    ),
                                    child: Padding(
                                      padding: paddingEdgeInsets(),
                                      child: Center(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            SvgPicture.asset(
                                              "assets/icons/ic_upload.svg",
                                              color: AppThemeData.lynch500,
                                            ),
                                            spaceH(height: 16),
                                            TextCustom(
                                              title: "Upload the restaurant logo".tr,
                                              maxLine: 2,
                                              color: themeChange.isDarkTheme() ? AppThemeData.primaryWhite : AppThemeData.primaryBlack,
                                              fontFamily: FontFamily.regular,
                                            ),
                                            TextCustom(
                                              title: "image must be a .jpg, .jpeg".tr,
                                              maxLine: 1,
                                              fontSize: 12,
                                              color: AppThemeData.secondary300,
                                              fontFamily: FontFamily.light,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  )
                                : ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: NetworkImageWidget(
                                      imageUrl: controller.restaurantLogo.value.path.toString(),
                                      fit: BoxFit.contain,
                                      height: 174.h,
                                      width: double.infinity,
                                    )),
                      ),
                    ),
                  ],
                ).expand(),
              ],
            ),
            spaceH(height: 16),
            Row(
              children: [
                CustomTextFormField(hintText: "Enter Restaurant Name", title: "Restaurant Name".tr, controller: controller.restaurantNameController.value).expand(),
                spaceW(width: 20),
                CustomTextFormField(
                  hintText: "Enter Restaurant Address",
                  title: "Restaurant Address".tr,
                  controller: controller.restaurantAddressController.value,
                  onPress: () async {
                    await Utils.showPlacePicker(context);
                  },
                  readOnly: true,
                ).expand()
              ],
            ),
            spaceH(height: 16),
            Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextCustom(
                      title: 'Cuisine'.tr,
                      fontSize: 14,
                    ),
                    spaceH(height: 10),
                    DropdownButtonFormField(
                      isExpanded: true,
                      onChanged: (value) {
                        controller.selectedCuisine.value = value!;
                      },
                      value: controller.selectedCuisine.value.id == null ? null : controller.selectedCuisine.value,
                      items: controller.cuisineList.map((item) {
                        return DropdownMenuItem<CuisineModel>(
                          value: item,
                          child: Text(
                            item.cuisineName.toString(),
                            style: TextStyle(
                              fontFamily: FontFamily.regular,
                              fontSize: 14,
                              color: themeChange.isDarkTheme() ? AppThemeData.lynch200 : AppThemeData.lynch800,
                            ),
                          ),
                        );
                      }).toList(),
                      validator: (value) => value != null ? null : 'This field required'.tr,
                      icon: const Icon(Icons.keyboard_arrow_down_outlined),
                      focusColor: Colors.transparent,
                      elevation: 0,
                      hint: TextCustom(title: "Select Cuisine".tr, fontSize: 14, fontFamily: FontFamily.regular),
                      dropdownColor: themeChange.isDarkTheme() ? AppThemeData.lynch800 : AppThemeData.lynch200,
                      decoration: Constant.DefaultInputDecoration(context),
                    ),
                  ],
                ).expand(),
                spaceW(width: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextCustom(
                      title: 'Restaurant Type'.tr,
                      fontSize: 14,
                    ),
                    spaceH(height: 10),
                    DropdownButtonFormField(
                      isExpanded: true,
                      style: TextStyle(
                        fontFamily: FontFamily.medium,
                        color: themeChange.isDarkTheme() ? AppThemeData.primaryWhite : AppThemeData.textBlack,
                      ),
                      hint: TextCustom(title: 'Select Restaurant Type'.tr, fontSize: 14, fontFamily: FontFamily.regular),
                      onChanged: (String? taxType) {
                        controller.selectedRestaurantType.value = taxType ?? "Veg";
                      },
                      value: controller.selectedRestaurantType.value.isEmpty ? null : controller.selectedRestaurantType.value,
                      icon: const Icon(Icons.keyboard_arrow_down_outlined),
                      items: controller.restaurantType.map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem(
                          value: value,
                          child: Text(
                            value,
                            style: TextStyle(
                              fontFamily: FontFamily.regular,
                              fontSize: 14,
                              color: themeChange.isDarkTheme() ? AppThemeData.lynch200 : AppThemeData.lynch800,
                            ),
                          ),
                        );
                      }).toList(),
                      dropdownColor: themeChange.isDarkTheme() ? AppThemeData.lynch800 : AppThemeData.lynch200,
                      decoration: Constant.DefaultInputDecoration(context),
                    ),
                  ],
                ).expand()
              ],
            ),
            spaceH(height: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const TextCustom(
                  title: 'Opening Hours',
                  fontSize: 14,
                ),
                spaceH(height: 4),
                ListView.builder(
                  itemCount: 7,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    final firstIndex = index * 2;
                    final secondIndex = firstIndex + 1;
                    return Row(
                      children: [Expanded(child: _buildDayColumn(context, firstIndex)), spaceW(width: 20), Expanded(child: secondIndex < 7 ? _buildDayColumn(context, secondIndex) : const SizedBox())],
                    );
                  },
                ),
              ],
            ),
          ],
          bottomWidgetList: [
            CustomButtonWidget(
              title: "Close".tr,
              buttonColor: themeChange.isDarkTheme() ? AppThemeData.lynch700 : AppThemeData.lynch400,
              onPress: () {
                Navigator.pop(context);
              },
            ),
            spaceW(),
            CustomButtonWidget(
              title: "Save".tr,
              buttonColor: AppThemeData.primary500,
              onPress: () {
                if (Constant.isDemo) {
                  DialogBox.demoDialogBox();
                } else {
                  if (controller.ownerFirstNameController.value.text.isEmpty) {
                    ShowToastDialog.errorToast("Please Enter Owner's First name..".tr);
                  } else if (controller.ownerLastNameController.value.text.isEmpty) {
                    ShowToastDialog.errorToast("Please Enter Owner's Last name..".tr);
                  } else if (controller.isEditing.value != true && controller.ownerEmailController.value.text.isEmpty) {
                    ShowToastDialog.errorToast("Please Enter Email..".tr);
                  } else if (controller.isEditing.value != true && controller.ownerMobileNumberController.value.text.isEmpty) {
                    ShowToastDialog.errorToast("Please Enter Mobile Number..".tr);
                  } else if (controller.isEditing.value != true && controller.ownerPasswordController.value.text.isEmpty) {
                    ShowToastDialog.errorToast("Please Enter Password..".tr);
                  } else if (controller.selectedCuisine.value.id!.isEmpty) {
                    ShowToastDialog.errorToast("Please Select Cuisine..".tr);
                  } else if (controller.selectedRestaurantType.value.isEmpty) {
                    ShowToastDialog.errorToast("Please Select Restaurant Type".tr);
                  } else if (controller.restaurantLogo.value.path.isEmpty && controller.restaurantLogoURL.value.isEmpty) {
                    ShowToastDialog.errorToast("Please Add Restaurant Logo..".tr);
                  } else if (controller.restaurantCoverImage.value.path.isEmpty && controller.restaurantCoverImageURL.value.isEmpty) {
                    ShowToastDialog.errorToast("Please Add Restaurant Cover Image..".tr);
                  } else if (controller.restaurantAddressController.value.text.isEmpty) {
                    ShowToastDialog.errorToast("Please Enter Restaurant Address..".tr);
                  } else if (controller.restaurantNameController.value.text.isEmpty) {
                    ShowToastDialog.errorToast("Please Enter Restaurant Name..".tr);
                  } else if (controller.openingHoursList.any((hour) => hour.isOpen != true)) {
                    ShowToastDialog.errorToast("Please Enter Opening hours..".tr);
                  } else {
                    Navigator.pop(context);
                    controller.isEditing.value ? controller.updateOwner() : controller.addOwner();
                  }
                }
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildDayColumn(BuildContext context, int index) {
    final controller = Get.find<RestaurantController>();
    if (index >= 7) return const SizedBox();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextCustom(
              title: controller.getWeekDay(index),
              fontSize: 16,
              fontFamily: FontFamily.medium,
              color: AppThemeData.lynch500,
            ),
            Obx(
              () => Transform.scale(
                scale: 0.7,
                child: CupertinoSwitch(
                  activeTrackColor: AppThemeData.primary500,
                  value: controller.daySwitches[index].value,
                  onChanged: (value) {
                    controller.toggleDaySwitch(index);
                  },
                ),
              ),
            ),
          ],
        ),
        Row(
          children: [
            Expanded(
              child: InkWell(
                onTap: () async {
                  if (controller.daySwitches[index].value) {
                    await controller.selectOpeningHour(index);
                    controller.openingHoursController[index].text = controller.openingHours[index].value.format(context).toString();
                  } else {
                    ShowToastDialog.errorToast("Please on the switch for pick time".tr);
                  }
                },
                child: CustomTextFormField(
                  hintText: "00 : 00 AM",
                  title: "Opening Hours".tr,
                  enable: false,
                  controller: controller.openingHoursController[index],
                  validator: (value) => controller.daySwitches[index].value
                      ? (value?.isNotEmpty ?? false)
                          ? null
                          : 'This field required'.tr
                      : null,
                  suffix: Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: SvgPicture.asset(
                      "assets/icons/ic_clock2.svg",
                      color: AppThemeData.lynch500,
                      height: 14,
                      width: 14,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: InkWell(
                onTap: () async {
                  if (controller.daySwitches[index].value) {
                    await controller.selectClosingHour(index);
                    controller.closingHoursController[index].text = controller.closingHours[index].value.format(context).toString();
                  } else {
                    ShowToastDialog.errorToast("Please on the switch for pick time".tr);
                  }
                },
                child: CustomTextFormField(
                  hintText: "00 : 00 PM",
                  title: "Closing Hours".tr,
                  enable: false,
                  controller: controller.closingHoursController[index],
                  validator: (value) => controller.daySwitches[index].value
                      ? (value?.isNotEmpty ?? false)
                          ? null
                          : 'This field required'.tr
                      : null,
                  suffix: Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: SvgPicture.asset(
                      "assets/icons/ic_clock2.svg",
                      color: AppThemeData.lynch500,
                      // width: 14,
                      // height: 14,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        spaceH(height: 10),
      ],
    );
  }
}
