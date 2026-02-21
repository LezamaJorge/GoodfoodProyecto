// ignore_for_file: depend_on_referenced_packages, use_super_parameters, deprecated_member_use, use_build_context_synchronously

import 'dart:io';

import 'package:admin_panel/app/components/custom_button.dart';
import 'package:admin_panel/app/components/custom_text_form_field.dart';
import 'package:admin_panel/app/components/dialog_box.dart';
import 'package:admin_panel/app/components/menu_widget.dart';
import 'package:admin_panel/app/components/network_image_widget.dart';
import 'package:admin_panel/app/constant/constants.dart';
import 'package:admin_panel/app/constant/show_toast.dart';
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
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import '../../../models/user_model.dart';
import '../../../routes/app_pages.dart';
import '../controllers/customer_screen_controller.dart';

class CustomerScreenView extends GetView<CustomerScreenController> {
  const CustomerScreenView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetX<CustomerScreenController>(
      init: CustomerScreenController(),
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
                                        TextCustom(title: controller.title.value.tr, fontSize: 20, fontFamily: FontFamily.bold),
                                        spaceH(height: 2),
                                        Row(children: [
                                          InkWell(
                                              onTap: () => Get.offAllNamed(Routes.DASHBOARD_SCREEN),
                                              child: TextCustom(title: 'Dashboard'.tr, fontSize: 14, fontFamily: FontFamily.medium, color: AppThemeData.lynch500)),
                                          const TextCustom(title: ' / ', fontSize: 14, fontFamily: FontFamily.medium, color: AppThemeData.lynch500),
                                          TextCustom(title: ' ${controller.title.value.tr} ', fontSize: 14, fontFamily: FontFamily.medium, color: AppThemeData.primary500)
                                        ])
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
                                                      await FireStoreUtils.countStatusWiseCustomer(
                                                        controller.selectedDateRange.value,
                                                      );
                                                      await controller.setPagination(controller.totalItemPerPage.value);
                                                      break;
                                                    case 'Last 6 Months':
                                                      controller.selectedDateRange.value = DateTimeRange(
                                                        start: DateTime(now.year, now.month - 6, now.day),
                                                        end: DateTime(now.year, now.month, now.day, 23, 59, 0, 0),
                                                      );
                                                      await FireStoreUtils.countStatusWiseCustomer(
                                                        controller.selectedDateRange.value,
                                                      );
                                                      // await FireStoreUtils.countStatusWiseBooking(
                                                      //   controller.driverId.value,
                                                      //   controller.selectedOrderStatusForData.value,
                                                      //   controller.selectedDateRange.value,
                                                      // );
                                                      await controller.setPagination(controller.totalItemPerPage.value);
                                                      break;
                                                    case 'Last Year':
                                                      controller.selectedDateRange.value = DateTimeRange(
                                                        start: DateTime(now.year - 1, now.month, now.day),
                                                        end: DateTime(now.year, now.month, now.day, 23, 59, 0, 0),
                                                      );
                                                      await FireStoreUtils.countStatusWiseCustomer(
                                                        controller.selectedDateRange.value,
                                                      );
                                                      // await FireStoreUtils.countStatusWiseBooking(
                                                      //   controller.driverId.value,
                                                      //   controller.selectedOrderStatusForData.value,
                                                      //   controller.selectedDateRange.value,
                                                      // );
                                                      await controller.setPagination(controller.totalItemPerPage.value);
                                                      break;
                                                    case 'Custom':
                                                      // controller.isCustomVisible.value = true;
                                                      // controller.selectedBookingStatus.value = statusType ?? "All";
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
                                                      await FireStoreUtils.countUsers();
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
                                                      value: value,
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
                                            width: 120,
                                            child: Obx(
                                              () => DropdownButtonFormField(
                                                borderRadius: BorderRadius.circular(15),
                                                isExpanded: true,
                                                style: TextStyle(
                                                  fontFamily: FontFamily.medium,
                                                  color: themeChange.isDarkTheme() ? AppThemeData.primaryWhite : AppThemeData.textBlack,
                                                ),
                                                onChanged: (String? searchType) {
                                                  controller.selectedSearchType.value = searchType ?? "Name".tr;
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
                                                      color: themeChange.isDarkTheme() ? AppThemeData.lynch500 : AppThemeData.lynch800,
                                                    ),
                                                  );
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
                                                  await FireStoreUtils.countSearchUsers(controller.searchController.value.text, controller.selectedSearchTypeForData.value);
                                                  controller.setPagination(controller.totalItemPerPage.value);
                                                  controller.isSearchEnable.value = false;
                                                } else {
                                                  controller.searchController.value.text = "";
                                                  controller.getUser();
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
                                                    controller.getUser();
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
                                              title: "+ Add User",
                                              onPress: () {
                                                controller.setDefaultData();
                                                showDialog(context: context, builder: (context) => const AddUser());
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
                                                            title: "Customer Statement Download".tr,
                                                            widgetList: [
                                                              TextCustom(
                                                                title: 'Select Time'.tr,
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
                                                                        value: value,
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
                                                                    hintText: "Select Start & End Date".tr,
                                                                    controller: controller.dateRangeController.value,
                                                                    title: "Start & End Date".tr,
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

                                                              // CustomTextFormField(
                                                              //   readOnly: true,
                                                              //   validator: (value) => value != null && value.isNotEmpty ? null : 'Start & End Date Required'.tr,
                                                              //   hintText: "Select Start & End Date",
                                                              //   controller: controller.dateRangeController.value,
                                                              //   title: "Start & End Date",
                                                              //   onPress: () {
                                                              //     showDateRangePickerForPdf(context);
                                                              //   },
                                                              //   // isReadOnly: true,
                                                              //   suffix: const Icon(
                                                              //     Icons.calendar_month_outlined,
                                                              //     color: AppThemeData.lynch500,
                                                              //     size: 24,
                                                              //   ),
                                                              // )
                                                            ],
                                                            bottomWidgetList: [
                                                              CustomButtonWidget(
                                                                textColor: themeChange.isDarkTheme() ? Colors.white : Colors.black,
                                                                buttonColor: themeChange.isDarkTheme() ? AppThemeData.lynch900 : AppThemeData.lynch100,
                                                                onPress: () {
                                                                  Navigator.pop(context);
                                                                },
                                                                title: "Close".tr,
                                                              ),
                                                              spaceW(),
                                                              Obx(
                                                                () => controller.isHistory.value
                                                                    ? Constant.circularProgressIndicatourLoader()
                                                                    : CustomButtonWidget(
                                                                        onPress: () {
                                                                          if (Constant.isDemo) {
                                                                            DialogBox.demoDialogBox();
                                                                          } else {
                                                                            if (controller.selectedDateOptionForPdf.value == 'Custom' && controller.dateRangeController.value.text.isEmpty) {
                                                                              ShowToastDialog.errorToast("Please select both a start and end date.".tr);
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
                                              )),
                                        ],
                                      )
                                    ],
                                  )
                                : Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
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
                                        ])
                                      ]),
                                      spaceH(),
                                      Row(
                                        children: [
                                          SizedBox(
                                            width: 130,
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
                                                      await FireStoreUtils.countStatusWiseCustomer(
                                                        controller.selectedDateRange.value,
                                                      );
                                                      await controller.setPagination(controller.totalItemPerPage.value);
                                                      break;
                                                    case 'Last 6 Months':
                                                      controller.selectedDateRange.value = DateTimeRange(
                                                        start: DateTime(now.year, now.month - 6, now.day),
                                                        end: DateTime(now.year, now.month, now.day, 23, 59, 0, 0),
                                                      );
                                                      await FireStoreUtils.countStatusWiseCustomer(
                                                        controller.selectedDateRange.value,
                                                      );
                                                      // await FireStoreUtils.countStatusWiseBooking(
                                                      //   controller.driverId.value,
                                                      //   controller.selectedOrderStatusForData.value,
                                                      //   controller.selectedDateRange.value,
                                                      // );
                                                      await controller.setPagination(controller.totalItemPerPage.value);
                                                      break;
                                                    case 'Last Year':
                                                      controller.selectedDateRange.value = DateTimeRange(
                                                        start: DateTime(now.year - 1, now.month, now.day),
                                                        end: DateTime(now.year, now.month, now.day, 23, 59, 0, 0),
                                                      );
                                                      await FireStoreUtils.countStatusWiseCustomer(
                                                        controller.selectedDateRange.value,
                                                      );
                                                      // await FireStoreUtils.countStatusWiseBooking(
                                                      //   controller.driverId.value,
                                                      //   controller.selectedOrderStatusForData.value,
                                                      //   controller.selectedDateRange.value,
                                                      // );
                                                      await controller.setPagination(controller.totalItemPerPage.value);
                                                      break;
                                                    case 'Custom':
                                                      // controller.isCustomVisible.value = true;
                                                      // controller.selectedBookingStatus.value = statusType ?? "All";
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
                                                      await FireStoreUtils.countUsers();
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
                                                      value: value,
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
                                                  controller.selectedSearchType.value = searchType ?? "Name".tr;
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
                                        ],
                                      ),
                                      spaceH(),
                                      SizedBox(
                                        height: 50,
                                        width: MediaQuery.sizeOf(context).width * 0.8,
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
                                              controller.getUser();
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
                                                controller.getUser();
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
                                      spaceH(),
                                      Row(
                                        children: [
                                          NumberOfRowsDropDown(
                                            controller: controller,
                                          ),
                                          CustomButtonWidget(
                                              title: "+ Add User",
                                              onPress: () {
                                                controller.setDefaultData();
                                                showDialog(context: context, builder: (context) => const AddUser());
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
                                                            title: "Customer Statement Download",
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
                                                                        value: value,
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
                                                                () => controller.isHistory.value
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
                                      ),
                                    ],
                                  ),
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
                                    : controller.currentPageUser.isEmpty
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
                                              CommonUI.dataColumnWidget(context, columnTitle: "Profile Image".tr, width: 150),
                                              CommonUI.dataColumnWidget(context, columnTitle: "Name".tr, width: ResponsiveWidget.isMobile(context) ? 150 : MediaQuery.of(context).size.width * 0.15),
                                              CommonUI.dataColumnWidget(context, columnTitle: "Email".tr, width: ResponsiveWidget.isMobile(context) ? 150 : MediaQuery.of(context).size.width * 0.15),
                                              CommonUI.dataColumnWidget(context,
                                                  columnTitle: "Mobile Number".tr, width: ResponsiveWidget.isMobile(context) ? 150 : MediaQuery.of(context).size.width * 0.15),
                                              // CommonUI.dataColumnWidget(context,
                                              //     columnTitle: "Gender".tr, width: ResponsiveWidget.isMobile(context) ? 120 : MediaQuery.of(context).size.width * 0.10),
                                              CommonUI.dataColumnWidget(context, columnTitle: "Created At".tr, width: 220),
                                              CommonUI.dataColumnWidget(context, columnTitle: "Status".tr, width: ResponsiveWidget.isMobile(context) ? 100 : MediaQuery.of(context).size.width * 0.06),
                                              CommonUI.dataColumnWidget(context, columnTitle: "Action".tr, width: ResponsiveWidget.isMobile(context) ? 100 : MediaQuery.of(context).size.width * 0.08)
                                            ],
                                            rows: controller.currentPageUser
                                                .map((userModel) => DataRow(cells: [
                                                      DataCell(
                                                        Container(
                                                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                                                          child: NetworkImageWidget(
                                                            imageUrl: '${userModel.profilePic}',
                                                            height: 37,
                                                            width: 37,
                                                          ),
                                                        ),
                                                      ),
                                                      DataCell(InkWell(
                                                          onTap: () async {
                                                            Get.toNamed('${Routes.CUSTOMER_DETAIL_SCREEN}/${userModel.id}');
                                                          },
                                                          child: TextCustom(title: userModel.fullNameString()))),
                                                      // DataCell(Text(
                                                      //   userModel.fullNameString(),
                                                      //   style: TextStyle(color: Colors.black), // Ensure text is black
                                                      // )),
                                                      // DataCell(TextCustom(title: userModel.email!.isEmpty ? "N/A" : Constant.maskEmail(email: userModel.email.toString()))),
                                                      DataCell(
                                                        TextCustom(
                                                          title: Constant.isDemo == true
                                                              ? Constant.maskEmailNotShow(userModel.email)
                                                              : (userModel.email == null || userModel.email!.isEmpty)
                                                                  ? "N/A"
                                                                  : userModel.email.toString(),
                                                        ),
                                                      ),
                                                      DataCell(TextCustom(
                                                        title: Constant.maskMobileNumber(countryCode: userModel.countryCode.toString(), mobileNumber: userModel.phoneNumber.toString()),
                                                      )),
                                                      // DataCell(TextCustom(title: userModel.gender==null?'N/A':userModel.gender.toString())),
                                                      DataCell(TextCustom(title: userModel.createdAt == null ? '' : Constant.timestampToDateTime(userModel.createdAt!))),
                                                      DataCell(
                                                        Transform.scale(
                                                          scale: 0.8,
                                                          child: CupertinoSwitch(
                                                            activeTrackColor: AppThemeData.primary500,
                                                            value: userModel.isActive ?? false,
                                                            onChanged: (value) async {
                                                              if (Constant.isDemo) {
                                                                DialogBox.demoDialogBox();
                                                              } else {
                                                                userModel.isActive = value;
                                                                await FireStoreUtils.updateUsers(userModel);
                                                                controller.getUser();
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
                                                                Get.toNamed('${Routes.CUSTOMER_DETAIL_SCREEN}/${userModel.id}');
                                                              },
                                                              child: SvgPicture.asset(
                                                                "assets/icons/ic_eye.svg",
                                                                color: AppThemeData.lynch400,
                                                                height: 16,
                                                                width: 16,
                                                              ),
                                                            ),
                                                            spaceW(width: 20),
                                                            InkWell(
                                                              onTap: () {
                                                                showDialog(
                                                                    context: context,
                                                                    builder: (context) => AddUser(
                                                                          userModel: userModel,
                                                                          isEditing: true,
                                                                        ));
                                                                // showGlobalDrawer(duration: const Duration(milliseconds: 200), barrierDismissible: true, context: context, builder: horizontalDrawerBuilder(), direction: AxisDirection.right);
                                                              },
                                                              child: SvgPicture.asset(
                                                                "assets/icons/ic_edit.svg",
                                                                color: themeChange.isDarkTheme() ? AppThemeData.lynch400 : AppThemeData.lynch500,
                                                                height: 16,
                                                                width: 16,
                                                              ),
                                                            ),
                                                            spaceW(width: 20),

                                                            // spaceW(width: 20),
                                                            // InkWell(
                                                            //   onTap: () {
                                                            //     controller.getArgument(userModel);
                                                            //     showGlobalDrawer(
                                                            //         duration: const Duration(milliseconds: 200),
                                                            //         barrierDismissible: true,
                                                            //         context: context,
                                                            //         builder: horizontalDrawerBuilder(),
                                                            //         direction: AxisDirection.right);
                                                            //   },
                                                            //   child: SvgPicture.asset(
                                                            //     "assets/icons/ic_edit.svg",
                                                            //     color: AppThemeData.grey400,
                                                            //     height: 16,
                                                            //     width: 16,
                                                            //   ),
                                                            // ),
                                                            // spaceW(width: 20),
                                                            InkWell(
                                                              onTap: () async {
                                                                if (Constant.isDemo) {
                                                                  DialogBox.demoDialogBox();
                                                                } else {
                                                                  // await controller.removePassengers(userModel);
                                                                  // controller.getUser();
                                                                  bool confirmDelete = await DialogBox.showConfirmationDeleteDialog(context);
                                                                  if (confirmDelete) {
                                                                    await controller.removeCustomers(userModel);
                                                                    controller.getUser();
                                                                  }
                                                                }
                                                              },
                                                              child: SvgPicture.asset(
                                                                "assets/icons/ic_delete.svg",
                                                                //color: AppThemeData.lynch400,
                                                                height: 16,
                                                                width: 16,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      )),
                                                    ]))
                                                .toList()),
                              ),
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

                  await FireStoreUtils.countStatusWiseCustomer(
                    controller.selectedDateRange.value,
                  );
                  await controller.setPagination(controller.totalItemPerPage.value);

                  Navigator.of(context).pop();
                },
                child: Text('clear'.tr)),
            TextButton(
              onPressed: () async {
                await FireStoreUtils.countStatusWiseCustomer(
                  controller.selectedDateRange.value,
                );
                if (controller.startDate != null && controller.endDate != null) {
                  await FireStoreUtils.countStatusWiseCustomer(
                    controller.selectedDateRange.value,
                  );
                  await controller.setPagination(controller.totalItemPerPage.value);
                }
                //   controller.selectedDateRange.value = DateTimeRange(start: controller.startDate!, end: DateTime(controller.endDate!.year, controller.endDate!.month, controller.endDate!.day, 23, 59, 0, 0));
                //   await FireStoreUtils.countStatusWiseOrder(
                //     controller.selectedOrderStatusForData.value,
                //     controller.selectedDateRange.value,
                //   );
                //   await controller.setPagination(controller.totalItemPerPage.value);
                // }
                Navigator.of(context).pop();
              },
              child: Text('OK'.tr),
            ),
          ],
        );
      },
    );
  }
}

void viewURLImage(String image) {
  showDialog(
    context: Get.context!,
    builder: (BuildContext context) {
      return Dialog(
        backgroundColor: Colors.transparent,
        child: SizedBox(
          height: 400,
          width: 300,
          child: Stack(
            alignment: Alignment.center,
            children: [
              NetworkImageWidget(
                borderRadius: 10,
                height: 400,
                width: 300,
                imageUrl: image,
                fit: BoxFit.cover,
              ),
              Align(
                alignment: Alignment.topRight,
                child: InkWell(
                  onTap: () {
                    Get.back();
                  },
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    margin: const EdgeInsets.all(10),
                    decoration: const BoxDecoration(shape: BoxShape.circle, color: AppThemeData.lynch500),
                    child: const Icon(Icons.close),
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

class AddUser extends StatelessWidget {
  final UserModel? userModel;
  final bool isEditing;

  const AddUser({super.key, this.userModel, this.isEditing = false});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    final controller = Get.put(CustomerScreenController());
    if (isEditing == true && userModel != null) {
      controller.getArgument(userModel!);
    }
    return GetX<CustomerScreenController>(builder: (_) {
      return CustomDialog(
        title: controller.isEditing.value == true ? "Edit User".tr : "Add User".tr,
        width: ResponsiveWidget.isDesktop(context) ? MediaQuery.of(context).size.width * .6 : MediaQuery.of(context).size.width * .8,
        widgetList: [
          spaceH(height: 24),
          Center(
            child: controller.isEditing.value == true
                ? InkWell(
                    onTap: () async {
                      if (Constant.isDemo) {
                        DialogBox.demoDialogBox();
                      } else {
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
                          controller.imageController.value.text = img.name;
                          controller.imagePath.value = imageFile;
                          controller.mimeType.value = "${img.mimeType}";
                        }
                      }
                    },
                    child: DottedBorder(
                      options: RoundedRectDottedBorderOptions(
                        dashPattern: const [6, 6, 6, 6],
                        color: themeChange.isDarkTheme() ? AppThemeData.lynch700 : AppThemeData.lynch300,
                        radius: const Radius.circular(12),
                      ),
                      child: Container(
                          height: 124.h,
                          width: 333.h,
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(12)),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: NetworkImageWidget(
                              imageUrl: controller.imagePath.value.path.isEmpty ? controller.imageURL.value : controller.imagePath.value.path,
                              height: 124.h,
                              fit: BoxFit.contain,
                            ),
                          )),
                    ),
                  )
                : InkWell(
                    onTap: () async {
                      if (Constant.isDemo) {
                        DialogBox.demoDialogBox();
                      } else {
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
                          controller.imageController.value.text = img.name;
                          controller.imagePath.value = imageFile;
                          controller.mimeType.value = "${img.mimeType}";
                        }
                      }
                    },
                    child: DottedBorder(
                      options: RoundedRectDottedBorderOptions(
                        dashPattern: const [6, 6, 6, 6],
                        color: themeChange.isDarkTheme() ? AppThemeData.lynch700 : AppThemeData.lynch300,
                        radius: const Radius.circular(12),
                      ),
                      child: Container(
                          height: 124.h,
                          width: 333.h,
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(12)),
                          ),
                          child: controller.imagePath.value.path.isNotEmpty
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: CachedNetworkImage(
                                    imageUrl: controller.imagePath.value.path,
                                    height: 124.h,
                                    fit: BoxFit.contain,
                                  ),
                                )
                              : Padding(
                                  padding: paddingEdgeInsets(),
                                  child: Center(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        SvgPicture.asset(
                                          "assets/icons/ic_upload.svg",
                                          color: AppThemeData.lynch500,
                                        ),
                                        spaceH(height: 16),
                                        TextCustom(
                                          title: "Upload the Customer Profile".tr,
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
                                )),
                    ),
                  ),
          ),
          spaceH(height: 16),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomTextFormField(hintText: "Enter First Name".tr, title: "First Name".tr, controller: controller.firstNameController.value).expand(),
              spaceW(width: 20),
              CustomTextFormField(hintText: "Enter Last Name".tr, title: "Last Name".tr, controller: controller.lastNameController.value).expand(),
            ],
          ),
          spaceH(height: 16),
          Row(
            children: [
              MobileNumberTextField(
                controller: controller.phoneNumberController.value,
                countryCode: controller.countryCode.value,
                onPress: () {},
                title: "Phone Number".tr,
                readOnly: controller.isEditing.value == true ? true : false,
              ).expand(),
              spaceW(width: 20),
              CustomTextFormField(
                hintText: "Enter Address".tr,
                title: "Address".tr,
                controller: controller.addressController.value,
                readOnly: controller.isEditing.value == true ? true : false,
                onPress: () async {
                  await Utils.showPlacePicker(context);
                },
              ).expand()
            ],
          ),
          spaceH(height: 16),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomTextFormField(
                hintText: "Enter Email".tr,
                title: "Email".tr,
                controller: controller.emailController.value,
                validator: (value) => Constant.validateEmail(value),
                readOnly: controller.isEditing.value == true ? true : false,
              ).expand(),
              spaceW(width: 20),
              Visibility(
                visible: !controller.isEditing.value,
                child: CustomTextFormField(
                  hintText: "Enter Password".tr,
                  title: "Password".tr,
                  readOnly: controller.isEditing.value == true ? true : false,
                  controller: controller.passwordController.value,
                  validator: (value) => Constant.validatePassword(value),
                  obscureText: controller.isPasswordVisible.value,
                  suffix: Icon(
                    controller.isPasswordVisible.value ? Icons.visibility_off : Icons.visibility,
                    color: AppThemeData.gallery500,
                  ).onTap(() {
                    controller.isPasswordVisible.value = !controller.isPasswordVisible.value;
                  }),
                ).expand(),
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
                if (controller.firstNameController.value.text.isEmpty) {
                  ShowToastDialog.errorToast("Please Enter First Name..");
                } else if (controller.lastNameController.value.text.isEmpty) {
                  ShowToastDialog.errorToast("Please Enter Last Name..");
                } else if (controller.isEditing.value != true && controller.phoneNumberController.value.text.isEmpty) {
                  ShowToastDialog.errorToast("Please Enter Phone Number..");
                } else if (controller.addressController.value.text.isEmpty) {
                  ShowToastDialog.errorToast("Please Enter Address..");
                } else if (controller.isEditing.value != true && controller.emailController.value.text.isEmpty) {
                  ShowToastDialog.errorToast("Please Enter Email..");
                } else if (controller.isEditing.value != true && controller.passwordController.value.text.isEmpty) {
                  ShowToastDialog.errorToast("Please Enter Password..");
                } else {
                  Navigator.pop(context);
                  controller.isEditing.value == true ? controller.updateUser() : controller.addUser();
                }
              }
            },
          ),
        ],
      );
    });
  }
}
