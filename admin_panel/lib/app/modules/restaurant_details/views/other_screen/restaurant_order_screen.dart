// ignore_for_file: deprecated_member_use, depend_on_referenced_packages, use_build_context_synchronously

import 'package:admin_panel/app/components/custom_button.dart';
import 'package:admin_panel/app/components/custom_text_form_field.dart';
import 'package:admin_panel/app/components/dialog_box.dart';
import 'package:admin_panel/app/components/network_image_widget.dart';
import 'package:admin_panel/app/constant/constants.dart';
import 'package:admin_panel/app/constant/show_toast.dart';
import 'package:admin_panel/app/models/product_model.dart';
import 'package:admin_panel/app/models/user_model.dart';
import 'package:admin_panel/app/modules/restaurant_details/controllers/restaurant_details_controller.dart';
import 'package:admin_panel/app/routes/app_pages.dart';
import 'package:admin_panel/app/utils/app_colors.dart';
import 'package:admin_panel/app/utils/app_them_data.dart';
import 'package:admin_panel/app/utils/fire_store_utils.dart';
import 'package:admin_panel/app/utils/responsive.dart';
import 'package:admin_panel/widget/common_ui.dart';
import 'package:admin_panel/widget/container_custom.dart';
import 'package:admin_panel/widget/global_widgets.dart';
import 'package:admin_panel/widget/text_widget.dart';
import 'package:admin_panel/widget/web_pagination.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import '../../../../utils/dark_theme_provider.dart';
import 'package:intl/intl.dart';

class RestaurantOrderScreen extends GetView<RestaurantDetailsController> {
  const RestaurantOrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetX<RestaurantDetailsController>(
        init: RestaurantDetailsController(),
        builder: (controller) {
          final themeChange = Provider.of<DarkThemeProvider>(context);
          return Scaffold(
              backgroundColor: themeChange.isDarkTheme() ? AppThemeData.lynch950 : AppThemeData.lynch50,
              body: SingleChildScrollView(
                child: ContainerCustom(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      spaceH(height: 16),
                      ResponsiveWidget.isDesktop(context)
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                  TextCustom(title: controller.orderTitle.value, fontSize: 20, fontFamily: FontFamily.bold),
                                  spaceH(height: 2),
                                  Row(children: [
                                    InkWell(
                                        onTap: () => Get.offAllNamed(Routes.DASHBOARD_SCREEN),
                                        child: TextCustom(title: 'Dashboard'.tr, fontSize: 14, fontFamily: FontFamily.medium, color: AppThemeData.lynch500)),
                                    const TextCustom(title: ' / ', fontSize: 14, fontFamily: FontFamily.medium, color: AppThemeData.lynch500),
                                    TextCustom(title: ' ${controller.orderTitle.value} ', fontSize: 14, fontFamily: FontFamily.medium, color: AppThemeData.primary500)
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
                                                await FireStoreUtils.countStatusWiseOrderRestaurant(
                                                    controller.selectedOrderStatusForData.value, controller.selectedDateRange.value, controller.restaurantModel.value.id.toString());
                                                await controller.setPagination(controller.totalItemPerPage.value);
                                                break;
                                              case 'Last 6 Months':
                                                controller.selectedDateRange.value = DateTimeRange(
                                                  start: DateTime(now.year, now.month - 6, now.day),
                                                  end: DateTime(now.year, now.month, now.day, 23, 59, 0, 0),
                                                );
                                                await FireStoreUtils.countStatusWiseOrderRestaurant(
                                                    controller.selectedOrderStatusForData.value, controller.selectedDateRange.value, controller.restaurantModel.value.id.toString());
                                                await controller.setPagination(controller.totalItemPerPage.value);
                                                break;
                                              case 'Last Year':
                                                controller.selectedDateRange.value = DateTimeRange(
                                                  start: DateTime(now.year - 1, now.month, now.day),
                                                  end: DateTime(now.year, now.month, now.day, 23, 59, 0, 0),
                                                );
                                                await FireStoreUtils.countStatusWiseOrderRestaurant(
                                                    controller.selectedOrderStatusForData.value, controller.selectedDateRange.value, controller.restaurantModel.value.id.toString());
                                                await controller.setPagination(controller.totalItemPerPage.value);
                                                break;
                                              case 'Custom':
                                                // controller.isCustomVisible.value = true;
                                                // controller.selectedBookingStatus.value = statusType ?? "All";
                                                showDateRangePicker(context);
                                                break;
                                              case 'All':
                                              // await FireStoreUtils.countStatusWiseOrderRestaurant(controller.selectedOrderStatusForData.value,
                                              //     controller.selectedDateRange.value, controller.restaurantModel.value.id.toString());
                                              // await controller.setPagination(controller.totalItemPerPage.value);
                                              default:
                                                // No specific filter, maybe assign null or a full year
                                                await FireStoreUtils.countStatusWiseOrderRestaurant(
                                                    controller.selectedOrderStatusForData.value, controller.selectedDateRange.value, controller.restaurantModel.value.id.toString());
                                                await controller.setPagination(controller.totalItemPerPage.value);
                                                break;
                                            }
                                            // controller.isCustomVisible.value = statusType == 'Custom';
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
                                      width: 120,
                                      child: Obx(
                                        () => DropdownButtonFormField(
                                          borderRadius: BorderRadius.circular(15),
                                          isExpanded: true,
                                          style: TextStyle(
                                            fontFamily: FontFamily.medium,
                                            color: themeChange.isDarkTheme() ? AppThemeData.textBlack : AppThemeData.textGrey,
                                          ),
                                          onChanged: (String? statusType) {
                                            controller.selectedOrderStatus.value = statusType ?? "All";
                                            controller.getOrderDataByOrderStatus();
                                          },
                                          value: controller.selectedOrderStatus.value,
                                          items: controller.orderStatus.map<DropdownMenuItem<String>>((String value) {
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
                                    spaceW(),
                                    NumberOfRowsDropDown(
                                      controller: controller,
                                    ),
                                    spaceW(),
                                    ContainerCustom(
                                        padding: paddingEdgeInsets(horizontal: 0, vertical: 0),
                                        color: AppThemeData.primary500,
                                        child: IconButton(
                                          onPressed: () {
                                            controller.dateRangeController.value.text = "";
                                            showDialog(
                                                context: context,
                                                builder: (context) => CustomDialog(
                                                      controller: controller,
                                                      title: "Restaurant Orders Statement Download",
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
                                                                controller.selectedDateOption.value = statusType ?? "All";

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
                                                        spaceH(),
                                                        Column(
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          children: [
                                                            const TextCustom(
                                                              title: 'Booking Status',
                                                              fontFamily: FontFamily.regular,
                                                              fontSize: 16,
                                                            ),
                                                            spaceH(),
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
                                                                  onChanged: (String? statusType) {
                                                                    controller.selectedFilterBookingStatus.value = statusType ?? "All";
                                                                    // controller.getBookingDataByBookingStatus();
                                                                  },
                                                                  value: controller.selectedFilterBookingStatus.value,
                                                                  items: controller.orderStatus.map<DropdownMenuItem<String>>((String value) {
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
                                                          ],
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
                                                                      if (controller.selectedDateOption.value == 'Custom' && controller.dateRangeController.value.text.isEmpty) {
                                                                        ShowToastDialog.errorToast("Please select both a start and end date.");
                                                                        return;
                                                                      }
                                                                      controller.downloadCabBookingPdf(context);
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
                                  TextCustom(title: controller.orderTitle.value, fontSize: 20, fontFamily: FontFamily.bold),
                                  spaceH(height: 2),
                                  Row(children: [
                                    InkWell(
                                        onTap: () => Get.offAllNamed(Routes.DASHBOARD_SCREEN),
                                        child: TextCustom(title: 'Dashboard'.tr, fontSize: 14, fontFamily: FontFamily.medium, color: AppThemeData.lynch500)),
                                    const TextCustom(title: ' / ', fontSize: 14, fontFamily: FontFamily.medium, color: AppThemeData.lynch500),
                                    TextCustom(title: ' ${controller.orderTitle.value} ', fontSize: 14, fontFamily: FontFamily.medium, color: AppThemeData.primary500)
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
                                                await FireStoreUtils.countStatusWiseOrderRestaurant(
                                                    controller.selectedOrderStatusForData.value, controller.selectedDateRange.value, controller.restaurantModel.value.id.toString());
                                                await controller.setPagination(controller.totalItemPerPage.value);
                                                break;
                                              case 'Last 6 Months':
                                                controller.selectedDateRange.value = DateTimeRange(
                                                  start: DateTime(now.year, now.month - 6, now.day),
                                                  end: DateTime(now.year, now.month, now.day, 23, 59, 0, 0),
                                                );
                                                await FireStoreUtils.countStatusWiseOrderRestaurant(
                                                    controller.selectedOrderStatusForData.value, controller.selectedDateRange.value, controller.restaurantModel.value.id.toString());
                                                await controller.setPagination(controller.totalItemPerPage.value);
                                                break;
                                              case 'Last Year':
                                                controller.selectedDateRange.value = DateTimeRange(
                                                  start: DateTime(now.year - 1, now.month, now.day),
                                                  end: DateTime(now.year, now.month, now.day, 23, 59, 0, 0),
                                                );
                                                await FireStoreUtils.countStatusWiseOrderRestaurant(
                                                    controller.selectedOrderStatusForData.value, controller.selectedDateRange.value, controller.restaurantModel.value.id.toString());
                                                await controller.setPagination(controller.totalItemPerPage.value);
                                                break;
                                              case 'Custom':
                                                // controller.isCustomVisible.value = true;
                                                // controller.selectedBookingStatus.value = statusType ?? "All";
                                                showDateRangePicker(context);
                                                break;
                                              case 'All':
                                              // await FireStoreUtils.countStatusWiseOrderRestaurant(controller.selectedOrderStatusForData.value,
                                              //     controller.selectedDateRange.value, controller.restaurantModel.value.id.toString());
                                              // await controller.setPagination(controller.totalItemPerPage.value);
                                              default:
                                                // No specific filter, maybe assign null or a full year
                                                await FireStoreUtils.countStatusWiseOrderRestaurant(
                                                    controller.selectedOrderStatusForData.value, controller.selectedDateRange.value, controller.restaurantModel.value.id.toString());
                                                await controller.setPagination(controller.totalItemPerPage.value);
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
                                      width: 120,
                                      child: Obx(
                                        () => DropdownButtonFormField(
                                          borderRadius: BorderRadius.circular(15),
                                          isExpanded: true,
                                          style: TextStyle(
                                            fontFamily: FontFamily.medium,
                                            color: themeChange.isDarkTheme() ? AppThemeData.textBlack : AppThemeData.textGrey,
                                          ),
                                          onChanged: (String? statusType) {
                                            controller.selectedOrderStatus.value = statusType ?? "All";
                                            controller.getOrderDataByOrderStatus();
                                          },
                                          value: controller.selectedOrderStatus.value,
                                          items: controller.orderStatus.map<DropdownMenuItem<String>>((String value) {
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
                                    spaceW(),
                                    NumberOfRowsDropDown(
                                      controller: controller,
                                    ),
                                    spaceW(),
                                    ContainerCustom(
                                        padding: paddingEdgeInsets(horizontal: 0, vertical: 0),
                                        color: AppThemeData.primary500,
                                        child: IconButton(
                                          onPressed: () {
                                            controller.dateRangeController.value.text = "";
                                            showDialog(
                                                context: context,
                                                builder: (context) => CustomDialog(
                                                      controller: controller,
                                                      title: "Restaurant Orders Statement Download",
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
                                                                controller.selectedDateOption.value = statusType ?? "All";

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
                                                        spaceH(),
                                                        Column(
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          children: [
                                                            const TextCustom(
                                                              title: 'Booking Status',
                                                              fontFamily: FontFamily.regular,
                                                              fontSize: 16,
                                                            ),
                                                            spaceH(),
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
                                                                  onChanged: (String? statusType) {
                                                                    controller.selectedFilterBookingStatus.value = statusType ?? "All";
                                                                    // controller.getBookingDataByBookingStatus();
                                                                  },
                                                                  value: controller.selectedFilterBookingStatus.value,
                                                                  items: controller.orderStatus.map<DropdownMenuItem<String>>((String value) {
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
                                                          ],
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
                                                                      if (controller.selectedDateOption.value == 'Custom' && controller.dateRangeController.value.text.isEmpty) {
                                                                        ShowToastDialog.errorToast("Please select both a start and end date.");
                                                                        return;
                                                                      }
                                                                      controller.downloadCabBookingPdf(context);
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
                      spaceH(height: 16),
                      controller.isLoading.value
                          ? Padding(
                              padding: paddingEdgeInsets(),
                              child: Constant.loader(),
                            )
                          : SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: controller.currentPageBooking.isEmpty
                                    ? TextCustom(title: "No Data available".tr)
                                    : DataTable(
                                        horizontalMargin: 20,
                                        columnSpacing: 30,
                                        dataRowMaxHeight: 80,
                                        headingRowHeight: 65,
                                        border: TableBorder.all(
                                          color: themeChange.isDarkTheme() ? AppThemeData.lynch800 : AppThemeData.lynch100,
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        headingRowColor: WidgetStateColor.resolveWith((states) => themeChange.isDarkTheme() ? AppThemeData.lynch800 : AppThemeData.lynch100),
                                        columns: [
                                          CommonUI.dataColumnWidget(context, columnTitle: "Order Id".tr, width: 150),
                                          CommonUI.dataColumnWidget(context,
                                              columnTitle: "Customer Name".tr, width: ResponsiveWidget.isMobile(context) ? 150 : MediaQuery.of(context).size.width * 0.15),
                                          CommonUI.dataColumnWidget(context, columnTitle: "Items".tr, width: ResponsiveWidget.isMobile(context) ? 300 : MediaQuery.of(context).size.width * 0.20),
                                          CommonUI.dataColumnWidget(context, columnTitle: "Date".tr, width: ResponsiveWidget.isMobile(context) ? 220 : MediaQuery.of(context).size.width * 0.17),
                                          CommonUI.dataColumnWidget(context,
                                              columnTitle: "Booking Status".tr, width: ResponsiveWidget.isMobile(context) ? 220 : MediaQuery.of(context).size.width * 0.07),
                                          CommonUI.dataColumnWidget(context,
                                              columnTitle: "Payment Type".tr, width: ResponsiveWidget.isMobile(context) ? 220 : MediaQuery.of(context).size.width * 0.10),
                                          CommonUI.dataColumnWidget(context,
                                              columnTitle: "Payment Status".tr, width: ResponsiveWidget.isMobile(context) ? 220 : MediaQuery.of(context).size.width * 0.07),
                                          CommonUI.dataColumnWidget(context, columnTitle: "Total".tr, width: 140),
                                          // CommonUI.dataColumnWidget(context,
                                          //     columnTitle: "Status", width: ResponsiveWidget.isMobile(context) ? 100 : MediaQuery.of(context).size.width * 0.10),
                                          CommonUI.dataColumnWidget(
                                            context,
                                            columnTitle: "Action".tr,
                                            width: 100,
                                          ),
                                        ],
                                        rows: controller.currentPageBooking
                                            .map((orderModel) => DataRow(cells: [
                                                  DataCell(
                                                    TextCustom(
                                                      title: orderModel.id!.isEmpty ? "N/A".tr : "#${orderModel.id!.substring(0, 4)}",
                                                    ),
                                                  ),
                                                  DataCell(
                                                    FutureBuilder<UserModel?>(
                                                        future: FireStoreUtils.getUserByUserID(orderModel.customerId.toString()),
                                                        // async work
                                                        builder: (BuildContext context, AsyncSnapshot<UserModel?> snapshot) {
                                                          switch (snapshot.connectionState) {
                                                            case ConnectionState.waiting:
                                                              // return Center(child: Constant.loader());
                                                              return const TextShimmer();
                                                            default:
                                                              if (snapshot.hasError) {
                                                                return TextCustom(
                                                                  title: 'Error: ${snapshot.error}',
                                                                );
                                                              } else {
                                                                UserModel userModel = snapshot.data!;
                                                                return Container(
                                                                  alignment: Alignment.centerLeft,
                                                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                                                                  child: TextCustom(
                                                                    title: userModel.firstName!.isEmpty
                                                                        ? "N/A".tr
                                                                        : userModel.firstName.toString() == "Unknown User"
                                                                            ? "User Deleted".tr
                                                                            : userModel.firstName.toString(),
                                                                  ),
                                                                );
                                                              }
                                                          }
                                                        }),
                                                  ),
                                                  DataCell(SizedBox(
                                                    width: ResponsiveWidget.isMobile(context) ? 300 : MediaQuery.of(context).size.width * 0.20,
                                                    child: Padding(
                                                      padding: const EdgeInsets.symmetric(vertical: 10),
                                                      child: ListView.builder(
                                                          shrinkWrap: true,
                                                          // physics: NeverScrollableScrollPhysics(),
                                                          primary: true,
                                                          itemCount: orderModel.items!.length,
                                                          itemBuilder: (context, index) {
                                                            return Column(
                                                              children: [
                                                                Row(
                                                                  children: [
                                                                    FutureBuilder(
                                                                        future: FireStoreUtils.getProductByProductId(orderModel.items![index].productId.toString()),
                                                                        builder: (context, snapshot) {
                                                                          if (!snapshot.hasData) {
                                                                            return Container();
                                                                          }
                                                                          ProductModel product = snapshot.data ?? ProductModel();
                                                                          return NetworkImageWidget(
                                                                            imageUrl: product.productImage.toString(),
                                                                            height: 24,
                                                                            width: 24,
                                                                            borderRadius: 0,
                                                                          );
                                                                        }),
                                                                    8.width,
                                                                    TextCustom(title: orderModel.items![index].productName.toString()),
                                                                  ],
                                                                ),
                                                                if (index != orderModel.items!.length - 1) 10.height,
                                                              ],
                                                            );
                                                          }),
                                                    ),
                                                  )),
                                                  DataCell(TextCustom(title: orderModel.createdAt == null ? '' : Constant.timestampToDateTime(orderModel.createdAt!))),
                                                  DataCell(
                                                    // e.bookingStatus.toString()
                                                    Constant.bookingStatusText(context, orderModel.orderStatus.toString()),
                                                  ),
                                                  DataCell(TextCustom(title: orderModel.paymentType.toString())),
                                                  DataCell(Container(
                                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                                                    decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(12),
                                                      color: orderModel.paymentStatus == true
                                                          ? themeChange.isDarkTheme()
                                                              ? AppThemeData.success600
                                                              : AppThemeData.success50
                                                          : themeChange.isDarkTheme()
                                                              ? AppThemeData.danger600
                                                              : AppThemeData.danger50,
                                                    ),
                                                    child: TextCustom(
                                                      title: orderModel.paymentStatus == true ? "Paid".tr : "Unpaid".tr,
                                                      color: orderModel.paymentStatus == true ? AppThemeData.success300 : AppThemeData.danger300,
                                                    ),
                                                  )),
                                                  // DataCell(TextCustom(title: Constant.amountShow(amount: bookingModel.subTotal))),
                                                  DataCell(TextCustom(title: Constant.amountShow(amount: orderModel.totalAmount))),
                                                  DataCell(
                                                    Container(
                                                      alignment: Alignment.center,
                                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                                                      child: Row(
                                                        children: [
                                                          InkWell(
                                                            onTap: () async {
                                                              Get.toNamed("${Routes.ORDER_DETAIL_SCREEN}/${orderModel.id}");
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
                                                            onTap: () async {
                                                              if (Constant.isDemo) {
                                                                DialogBox.demoDialogBox();
                                                              } else {
                                                                // await controller.removeBooking(bookingModel);
                                                                // controller.getBookings();
                                                                bool confirmDelete = await DialogBox.showConfirmationDeleteDialog(context);
                                                                if (confirmDelete) {
                                                                  await controller.removeOrder(orderModel);
                                                                  controller.getOrders();
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
                                                    ),
                                                  ),
                                                ]))
                                            .toList(),
                                      ),
                              ),
                            ),
                      spaceH(),
                      ResponsiveWidget.isMobile(context)
                          ? SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Visibility(
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
                                  ),
                                ],
                              ),
                            ),
                    ],
                  ),
                ),
              ));
        });
  }

  Future<void> showDateRangePicker(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        RestaurantDetailsController controller = Get.put(RestaurantDetailsController());
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
                }
              },
            ),
          ),
          actions: <Widget>[
            ElevatedButton(
                onPressed: () {
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
                  controller.selectedOrderStatus.value = "All";
                  controller.getOrderDataByOrderStatus();
                  Navigator.of(context).pop();
                },
                child: const Text('clear')),
            TextButton(
              onPressed: () async {
                if (controller.startDate != null && controller.endDate != null) {
                  controller.selectedDateRange.value =
                      DateTimeRange(start: controller.startDate!, end: DateTime(controller.endDate!.year, controller.endDate!.month, controller.endDate!.day, 23, 59, 0, 0));
                  await FireStoreUtils.countStatusWiseOrderRestaurant(controller.selectedOrderStatusForData.value, controller.selectedDateRange.value, controller.restaurantModel.value.id.toString());
                  await controller.setPagination(controller.totalItemPerPage.value);
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
