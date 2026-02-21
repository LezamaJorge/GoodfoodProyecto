// ignore_for_file: deprecated_member_use, depend_on_referenced_packages, use_build_context_synchronously

import 'package:admin_panel/app/components/custom_button.dart';
import 'package:admin_panel/app/components/custom_text_form_field.dart';
import 'package:admin_panel/app/components/dialog_box.dart';
import 'package:admin_panel/app/components/menu_widget.dart';
import 'package:admin_panel/app/constant/constants.dart';
import 'package:admin_panel/app/constant/show_toast.dart';
import 'package:admin_panel/app/models/driver_user_model.dart';
import 'package:admin_panel/app/models/owner_model.dart';
import 'package:admin_panel/app/models/payout_request_model.dart';
import 'package:admin_panel/app/modules/pauout_request/controllers/payout_request_controller.dart';
import 'package:admin_panel/app/utils/app_colors.dart';
import 'package:admin_panel/app/utils/app_them_data.dart';
import 'package:admin_panel/app/utils/dark_theme_provider.dart';
import 'package:admin_panel/app/utils/fire_store_utils.dart';
import 'package:admin_panel/app/utils/responsive.dart';
import 'package:admin_panel/widget/common_ui.dart';
import 'package:admin_panel/widget/container_custom.dart';
import 'package:admin_panel/widget/global_widgets.dart';
import 'package:admin_panel/widget/gradient_text.dart';
import 'package:admin_panel/widget/text_widget.dart';
import 'package:admin_panel/widget/web_pagination.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:intl/intl.dart';
import '../../../routes/app_pages.dart' as routs;

class PayoutRequestView extends GetView<PayoutRequestController> {
  const PayoutRequestView({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetX<PayoutRequestController>(
      init: PayoutRequestController(),
      builder: (controller) {
        return Scaffold(
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
            width: 270,
            backgroundColor: themeChange.isDarkTheme() ? AppThemeData.primaryBlack : AppThemeData.primaryWhite,
            child: const MenuWidget(),
          ),
          backgroundColor: themeChange.isDarkTheme() ? AppThemeData.lynch950 : AppThemeData.lynch50,
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
                          child: Column( children: [
                            if (ResponsiveWidget.isDesktop(context))
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                    TextCustom(title: controller.title.value.tr, fontSize: 20, fontFamily: FontFamily.bold),
                                    spaceH(height: 2),
                                    Row(children: [
                                      InkWell(onTap: () => Get.offAllNamed(routs.Routes.DASHBOARD_SCREEN), child: TextCustom(title: 'Dashboard'.tr, fontSize: 14, fontFamily: FontFamily.medium, color: AppThemeData.lynch500)),
                                      const TextCustom(title: ' / ', fontSize: 14, fontFamily: FontFamily.medium, color: AppThemeData.lynch500),
                                      TextCustom(title: ' ${controller.title.value.tr} ', fontSize: 14, fontFamily: FontFamily.medium, color: AppThemeData.primary500)
                                    ])
                                  ]),
                                  const Spacer(),
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
                                            hint: TextCustom(title: 'Payment Status'.tr),
                                            onChanged: (String? taxType) {
                                              controller.selectedType.value = taxType ?? "All";
                                              controller.getFilterPayoutRequest();
                                            },
                                            value: controller.selectedType.value,
                                            items: controller.payoutType.map<DropdownMenuItem<String>>((String value) {
                                              return DropdownMenuItem(
                                                value: value.tr,
                                                child: TextCustom(
                                                  title: value.tr,
                                                  fontFamily: FontFamily.regular,
                                                  fontSize: 16,
                                                  color: themeChange.isDarkTheme() ? AppThemeData.lynch500 : AppThemeData.primaryBlack,
                                                ),
                                              );
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
                                            onChanged: (String? statusType) async {
                                              final now = DateTime.now();
                                              controller.selectedDateOption.value = statusType ?? "All";
                                              switch (statusType) {
                                                case 'Last Month':
                                                  controller.selectedDateRange.value = DateTimeRange(
                                                    start: now.subtract(const Duration(days: 30)),
                                                    end: DateTime(now.year, now.month, now.day, 23, 59, 0, 0),
                                                  );
                                                  controller.getFilterPayoutRequest();
                                                  break;
                                                case 'Last 6 Months':
                                                  controller.selectedDateRange.value = DateTimeRange(
                                                    start: DateTime(now.year, now.month - 6, now.day),
                                                    end: DateTime(now.year, now.month, now.day, 23, 59, 0, 0),
                                                  );
                                                  controller.getFilterPayoutRequest();
                                                  break;
                                                case 'Last Year':
                                                  controller.selectedDateRange.value = DateTimeRange(
                                                    start: DateTime(now.year - 1, now.month, now.day),
                                                    end: DateTime(now.year, now.month, now.day, 23, 59, 0, 0),
                                                  );
                                                  controller.getFilterPayoutRequest();
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
                                                  controller.getFilterPayoutRequest();

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
                                                    title: value.tr,
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
                                            hint: TextCustom(title: 'Payment Status'.tr),
                                            onChanged: (String? taxType) {
                                              controller.selectedPayoutStatus.value = taxType ?? "All";
                                              controller.getFilterPayoutRequest();
                                            },
                                            value: controller.selectedPayoutStatus.value,
                                            items: controller.payoutStatus.map<DropdownMenuItem<String>>((String value) {
                                              return DropdownMenuItem(
                                                value: value.tr,
                                                child: TextCustom(
                                                  title: value.tr,
                                                  fontFamily: FontFamily.regular,
                                                  fontSize: 16,
                                                  color: themeChange.isDarkTheme() ? AppThemeData.lynch500 : AppThemeData.primaryBlack,
                                                ),
                                              );
                                            }).toList(),
                                            decoration: Constant.DefaultInputDecoration(context),
                                          ),
                                        ),
                                      ),
                                      spaceW(),
                                      NumberOfRowsDropDown(controller: controller),
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
                                                        title: "PayoutRequest Statement Download".tr,
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
                                                                    value: value.tr,
                                                                    child: TextCustom(
                                                                      title: value.tr,
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
                                                          spaceH(),
                                                          Row(
                                                            children: [
                                                              Column(
                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                children: [
                                                                  TextCustom(
                                                                    title: 'Select Type'.tr,
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
                                                                        hint: TextCustom(title: 'Payment Status'.tr),
                                                                        onChanged: (String? taxType) {
                                                                          controller.selectedTypeForStatement.value = taxType ?? "All";
                                                                        },
                                                                        value: controller.selectedTypeForStatement.value,
                                                                        items: controller.payoutType.map<DropdownMenuItem<String>>((String value) {
                                                                          return DropdownMenuItem(
                                                                            value: value.tr,
                                                                            child: TextCustom(
                                                                              title: value.tr,
                                                                              fontFamily: FontFamily.regular,
                                                                              fontSize: 16,
                                                                              color: themeChange.isDarkTheme() ? AppThemeData.lynch500 : AppThemeData.primaryBlack,
                                                                            ),
                                                                          );
                                                                        }).toList(),
                                                                        decoration: Constant.DefaultInputDecoration(context),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                              spaceW(),
                                                              Column(
                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                children: [
                                                                  TextCustom(
                                                                    title: 'Select Status'.tr,
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
                                                                        hint: TextCustom(title: 'Payment Status'.tr),
                                                                        onChanged: (String? taxType) {
                                                                          controller.selectedPayoutStatusForStatement.value = taxType ?? "All";
                                                                        },
                                                                        value: controller.selectedPayoutStatusForStatement.value,
                                                                        items: controller.payoutStatus.map<DropdownMenuItem<String>>((String value) {
                                                                          return DropdownMenuItem(
                                                                            value: value.tr,
                                                                            child: TextCustom(
                                                                              title: value.tr,
                                                                              fontFamily: FontFamily.regular,
                                                                              fontSize: 16,
                                                                              color: themeChange.isDarkTheme() ? AppThemeData.lynch500 : AppThemeData.primaryBlack,
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
                                                          ),
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
                                                            () => controller.isHistoryDownload.value
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
                                  ),
                                ],
                              )
                            else
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                    TextCustom(title: controller.title.value.tr, fontSize: 20, fontFamily: FontFamily.bold),
                                    spaceH(height: 2),
                                    Row(children: [
                                      InkWell(onTap: () => Get.offAllNamed(routs.Routes.DASHBOARD_SCREEN), child: TextCustom(title: 'Dashboard'.tr, fontSize: 14, fontFamily: FontFamily.medium, color: AppThemeData.lynch500)),
                                      const TextCustom(title: ' / ', fontSize: 14, fontFamily: FontFamily.medium, color: AppThemeData.lynch500),
                                      TextCustom(title: ' ${controller.title.value.tr} ', fontSize: 14, fontFamily: FontFamily.medium, color: AppThemeData.primary500)
                                    ])
                                  ]),
                                  spaceH(height: 16),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
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
                                            hint: TextCustom(title: 'Payment Status'.tr),
                                            onChanged: (String? taxType) {
                                              controller.selectedType.value = taxType ?? "All";
                                              controller.getFilterPayoutRequest();
                                            },
                                            value: controller.selectedType.value,
                                            items: controller.payoutType.map<DropdownMenuItem<String>>((String value) {
                                              return DropdownMenuItem(
                                                value: value.tr,
                                                child: TextCustom(
                                                  title: value.tr,
                                                  fontFamily: FontFamily.regular,
                                                  fontSize: 16,
                                                  color: themeChange.isDarkTheme() ? AppThemeData.lynch500 : AppThemeData.primaryBlack,
                                                ),
                                              );
                                            }).toList(),
                                            decoration: Constant.DefaultInputDecoration(context),
                                          ),
                                        ),
                                      ),
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
                                                      controller.getFilterPayoutRequest();
                                                      break;
                                                    case 'Last 6 Months':
                                                      controller.selectedDateRange.value = DateTimeRange(
                                                        start: DateTime(now.year, now.month - 6, now.day),
                                                        end: DateTime(now.year, now.month, now.day, 23, 59, 0, 0),
                                                      );
                                                      controller.getFilterPayoutRequest();
                                                      break;
                                                    case 'Last Year':
                                                      controller.selectedDateRange.value = DateTimeRange(
                                                        start: DateTime(now.year - 1, now.month, now.day),
                                                        end: DateTime(now.year, now.month, now.day, 23, 59, 0, 0),
                                                      );
                                                      controller.getFilterPayoutRequest();
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
                                                      controller.getFilterPayoutRequest();

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
                                                        title: value.tr,
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
                                                hint: TextCustom(title: 'Payment Status'.tr),
                                                onChanged: (String? taxType) {
                                                  controller.selectedPayoutStatus.value = taxType ?? "All";
                                                  controller.getFilterPayoutRequest();
                                                },
                                                value: controller.selectedPayoutStatus.value,
                                                items: controller.payoutStatus.map<DropdownMenuItem<String>>((String value) {
                                                  return DropdownMenuItem(
                                                    value: value.tr,
                                                    child: TextCustom(
                                                      title: value.tr,
                                                      fontFamily: FontFamily.regular,
                                                      fontSize: 16,
                                                      color: themeChange.isDarkTheme() ? AppThemeData.lynch500 : AppThemeData.primaryBlack,
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
                                      Row(
                                        children: [
                                          NumberOfRowsDropDown(controller: controller),
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
                                                            title: "PayoutRequest Statement Download".tr,
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
                                                                        value: value.tr,
                                                                        child: TextCustom(
                                                                          title: value.tr,
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
                                                              spaceH(),
                                                              Row(
                                                                children: [
                                                                  Column(
                                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                                    children: [
                                                                      TextCustom(
                                                                        title: 'Select Type'.tr,
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
                                                                            hint: TextCustom(title: 'Payment Status'.tr),
                                                                            onChanged: (String? taxType) {
                                                                              controller.selectedTypeForStatement.value = taxType ?? "All";
                                                                            },
                                                                            value: controller.selectedTypeForStatement.value,
                                                                            items: controller.payoutType.map<DropdownMenuItem<String>>((String value) {
                                                                              return DropdownMenuItem(
                                                                                value: value.tr,
                                                                                child: TextCustom(
                                                                                  title: value.tr,
                                                                                  fontFamily: FontFamily.regular,
                                                                                  fontSize: 16,
                                                                                  color: themeChange.isDarkTheme() ? AppThemeData.lynch500 : AppThemeData.primaryBlack,
                                                                                ),
                                                                              );
                                                                            }).toList(),
                                                                            decoration: Constant.DefaultInputDecoration(context),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                  spaceW(),
                                                                  Column(
                                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                                    children: [
                                                                      TextCustom(
                                                                        title: 'Select Status'.tr,
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
                                                                            hint: TextCustom(title: 'Payment Status'.tr),
                                                                            onChanged: (String? taxType) {
                                                                              controller.selectedPayoutStatusForStatement.value = taxType ?? "All";
                                                                            },
                                                                            value: controller.selectedPayoutStatusForStatement.value,
                                                                            items: controller.payoutStatus.map<DropdownMenuItem<String>>((String value) {
                                                                              return DropdownMenuItem(
                                                                                value: value.tr,
                                                                                child: TextCustom(
                                                                                  title: value.tr,
                                                                                  fontFamily: FontFamily.regular,
                                                                                  fontSize: 16,
                                                                                  color: themeChange.isDarkTheme() ? AppThemeData.lynch500 : AppThemeData.primaryBlack,
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
                                                              ),
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
                                                                () => controller.isHistoryDownload.value
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
                                                                            // if (controller.dateRangeController.value.text.isNotEmpty) {
                                                                            //   // controller.downloadOrdersPdf();
                                                                            //   Navigator.pop(context);
                                                                            // } else {
                                                                            //   ShowToastDialog.successToast("Please Select the Date..");
                                                                            // }
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
                                    : controller.currentPayoutRequest.isEmpty
                                        ? TextCustom(title: "No Data available".tr.tr)
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
                                              // CommonUI.dataColumnWidget(context, columnTitle: "DriverId", width:  ResponsiveWidget.isMobile(context) ?  150  :MediaQuery.of(context).size.width * 0.10 ),
                                              CommonUI.dataColumnWidget(context, columnTitle: "Amount".tr, width: ResponsiveWidget.isMobile(context) ? 150 : MediaQuery.of(context).size.width * 0.06),
                                              CommonUI.dataColumnWidget(context, columnTitle: "Name".tr, width: ResponsiveWidget.isMobile(context) ? 150 : MediaQuery.of(context).size.width * 0.06),
                                              CommonUI.dataColumnWidget(context, columnTitle: "Email".tr, width: ResponsiveWidget.isMobile(context) ? 150 : MediaQuery.of(context).size.width * 0.06),
                                              CommonUI.dataColumnWidget(context, columnTitle: "Phone Number".tr, width: ResponsiveWidget.isMobile(context) ? 150 : MediaQuery.of(context).size.width * 0.06),
                                              CommonUI.dataColumnWidget(context, columnTitle: "Note".tr, width: ResponsiveWidget.isMobile(context) ? 150 : MediaQuery.of(context).size.width * 0.13),
                                              CommonUI.dataColumnWidget(context, columnTitle: "Payment Date".tr, width: ResponsiveWidget.isMobile(context) ? 220 : MediaQuery.of(context).size.width * 0.12),
                                              CommonUI.dataColumnWidget(context, columnTitle: "Payment Status".tr, width: ResponsiveWidget.isMobile(context) ? 220 : MediaQuery.of(context).size.width * 0.08),
                                              // CommonUI.dataColumnWidget(context, columnTitle: "PaymentDate", width: ResponsiveWidget.isMobile(context) ? 140 :MediaQuery.of(context).size.width * 0.10),
                                              CommonUI.dataColumnWidget(
                                                context,
                                                columnTitle: "Action".tr,
                                                width: ResponsiveWidget.isMobile(context) ? 100 : MediaQuery.of(context).size.width * 0.08,
                                              ),
                                            ],
                                            rows: controller.currentPayoutRequest
                                                .map(
                                                  (payoutRequestModel) => DataRow(
                                                    cells: [
                                                      // DataCell(
                                                      //   TextCustom(
                                                      //     title: payoutRequestModel.driverId.toString(),
                                                      //   ),
                                                      // ),
                                                      DataCell(
                                                        TextCustom(title: payoutRequestModel.amount.toString()),
                                                      ),
                                                      DataCell(
                                                        payoutRequestModel.type == 'restaurant'
                                                            ? FutureBuilder(
                                                                future: FireStoreUtils.getOwnerByOwnerId(payoutRequestModel.ownerId.toString()),
                                                                builder: (context, snapshot) {
                                                                  if (!snapshot.hasData) {
                                                                    return Container();
                                                                  }
                                                                  OwnerModel owner = snapshot.data ?? OwnerModel();
                                                                  return Container(
                                                                    alignment: Alignment.centerLeft,
                                                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                                                                    child: TextCustom(
                                                                      title: owner.firstName!.isEmpty
                                                                          ? "N/A"
                                                                          : owner.firstName.toString() == "Unknown ${payoutRequestModel.type}"
                                                                              ? "User Deleted"
                                                                              : owner.firstName.toString(),
                                                                    ),
                                                                  );
                                                                })
                                                            : FutureBuilder<DriverUserModel?>(
                                                                future: FireStoreUtils.getDriverByDriverID(payoutRequestModel.ownerId.toString()), // async work
                                                                builder: (BuildContext context, AsyncSnapshot<DriverUserModel?> snapshot) {
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
                                                                        DriverUserModel driverUserModel = snapshot.data!;
                                                                        return Container(
                                                                          alignment: Alignment.centerLeft,
                                                                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                                                                          child: TextCustom(
                                                                            title: (driverUserModel.firstName!.trim().isEmpty || driverUserModel.firstName == '')
                                                                                ? "N/A"
                                                                                : driverUserModel.firstName.toString() == "Unknown ${payoutRequestModel.type}"
                                                                                    ? "User Deleted"
                                                                                    : driverUserModel.firstName.toString(),
                                                                          ),
                                                                        );
                                                                      }
                                                                  }
                                                                }),
                                                      ),
                                                      DataCell(
                                                        payoutRequestModel.type == 'restaurant'
                                                            ? FutureBuilder(
                                                                future: FireStoreUtils.getOwnerByOwnerId(payoutRequestModel.ownerId.toString()),
                                                                builder: (context, snapshot) {
                                                                  if (snapshot.connectionState == ConnectionState.waiting) {
                                                                    return const TextShimmer(); // Show a placeholder while loading
                                                                  }

                                                                  if (snapshot.hasError) {
                                                                    return Container(
                                                                      alignment: Alignment.centerLeft,
                                                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                                                                      child: const TextCustom(
                                                                        title: 'Error fetching data',
                                                                      ),
                                                                    );
                                                                  }

                                                                  if (!snapshot.hasData || snapshot.data == null) {
                                                                    return Container(
                                                                      alignment: Alignment.centerLeft,
                                                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                                                                      child: const TextCustom(
                                                                        title: 'N/A',
                                                                      ),
                                                                    );
                                                                  }

                                                                  OwnerModel owner = snapshot.data as OwnerModel;
                                                                  String email = (owner.email == null || owner.email!.isEmpty) ? 'N/A' : owner.email!;
                                                                  return Container(
                                                                    alignment: Alignment.centerLeft,
                                                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                                                                    child: TextCustom(
                                                                      title: email,
                                                                    ),
                                                                  );
                                                                },
                                                              )
                                                            : FutureBuilder<DriverUserModel?>(
                                                                future: FireStoreUtils.getDriverByDriverID(payoutRequestModel.ownerId.toString()), // async work
                                                                builder: (BuildContext context, AsyncSnapshot<DriverUserModel?> snapshot) {
                                                                  switch (snapshot.connectionState) {
                                                                    case ConnectionState.waiting:
                                                                      // return Center(child: Constant.loader());
                                                                      return const TextShimmer();
                                                                    default:
                                                                      if (snapshot.hasError) {
                                                                        return TextCustom(
                                                                          title: 'Error: ${snapshot.error}',
                                                                        );
                                                                      } else if (snapshot.hasData && snapshot.data != null) {
                                                                        DriverUserModel driverUserModel = snapshot.data!;
                                                                        return Container(
                                                                          alignment: Alignment.centerLeft,
                                                                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                                                                          child: TextCustom(
                                                                            title: driverUserModel.email == null || driverUserModel.email!.isEmpty ? 'N/A' : driverUserModel.email!,
                                                                          ),
                                                                        );
                                                                      } else {
                                                                        return const TextCustom(
                                                                          title: 'N/A',
                                                                        );
                                                                      }
                                                                  }
                                                                }),
                                                      ),
                                                      DataCell(
                                                        payoutRequestModel.type == 'restaurant'
                                                            ? FutureBuilder(
                                                                future: FireStoreUtils.getOwnerByOwnerId(payoutRequestModel.ownerId.toString()),
                                                                builder: (context, snapshot) {
                                                                  if (snapshot.connectionState == ConnectionState.waiting) {
                                                                    return const TextShimmer(); // Show a placeholder while loading
                                                                  }
                                                                  if (snapshot.hasError) {
                                                                    return Container(
                                                                      alignment: Alignment.centerLeft,
                                                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                                                                      child: const TextCustom(
                                                                        title: 'Error fetching data',
                                                                      ),
                                                                    );
                                                                  }

                                                                  if (!snapshot.hasData || snapshot.data == null) {
                                                                    return Container(
                                                                      alignment: Alignment.centerLeft,
                                                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                                                                      child: const TextCustom(
                                                                        title: 'N/A',
                                                                      ),
                                                                    );
                                                                  }
                                                                  OwnerModel owner = snapshot.data as OwnerModel;
                                                                  String email = (owner.phoneNumber == null || owner.phoneNumber!.isEmpty) ? 'N/A' : "${owner.countryCode} ${owner.phoneNumber!}";
                                                                  return Container(
                                                                    alignment: Alignment.centerLeft,
                                                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                                                                    child: TextCustom(
                                                                      title: email,
                                                                    ),
                                                                  );
                                                                },
                                                              )
                                                            : FutureBuilder<DriverUserModel?>(
                                                                future: FireStoreUtils.getDriverByDriverID(payoutRequestModel.ownerId.toString()), // async work
                                                                builder: (BuildContext context, AsyncSnapshot<DriverUserModel?> snapshot) {
                                                                  switch (snapshot.connectionState) {
                                                                    case ConnectionState.waiting:
                                                                      // return Center(child: Constant.loader());
                                                                      return const TextShimmer();
                                                                    default:
                                                                      if (snapshot.hasError) {
                                                                        return TextCustom(
                                                                          title: 'Error: ${snapshot.error}',
                                                                        );
                                                                      } else if (snapshot.hasData && snapshot.data != null) {
                                                                        DriverUserModel driverUserModel = snapshot.data!;
                                                                        return Container(
                                                                          alignment: Alignment.centerLeft,
                                                                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                                                                          child: TextCustom(
                                                                            title: driverUserModel.phoneNumber == null || driverUserModel.phoneNumber!.isEmpty ? 'N/A' : "${driverUserModel.countryCode} ${driverUserModel.phoneNumber!}",
                                                                          ),
                                                                        );
                                                                      } else {
                                                                        return const TextCustom(
                                                                          title: 'N/A',
                                                                        );
                                                                      }
                                                                  }
                                                                }),
                                                      ),

                                                      DataCell(
                                                        TextCustom(title: payoutRequestModel.note == "" || payoutRequestModel.note!.isEmpty ? "N/A" : payoutRequestModel.note.toString()),
                                                      ),
                                                      DataCell(
                                                        TextCustom(title: payoutRequestModel.paymentDate == null ? 'N/A' : Constant.timestampToDate(payoutRequestModel.paymentDate!)),
                                                      ),
                                                      DataCell(
                                                        Constant.paymentStatusText(context, payoutRequestModel.paymentStatus.toString()),
                                                      ),
                                                      DataCell(
                                                        Container(
                                                          alignment: Alignment.center,
                                                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                                                          child: Row(
                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                            children: [
                                                              payoutRequestModel.paymentStatus == "Pending"
                                                                  ? CustomButtonWidget(
                                                                      width: ResponsiveWidget.isMobile(context) ? 80 : MediaQuery.of(context).size.width * 0.07,
                                                                      textColor: AppThemeData.primaryWhite,
                                                                      padding: const EdgeInsets.symmetric(horizontal: 22),
                                                                      title: "Allow".tr,
                                                                      // borderRadius: 14,
                                                                      onPress: () async {
                                                                        controller.userSelectedPaymentStatus.value = payoutRequestModel.paymentStatus.toString();
                                                                        payoutRequestModel.adminNote == null ? controller.adminNoteController.value.text = "" : controller.adminNoteController.value.text = payoutRequestModel.adminNote.toString();
                                                                        payoutRequestModel.paymentId == null ? controller.paymentIdController.value.text = "" : controller.paymentIdController.value.text = payoutRequestModel.paymentId.toString();
                                                                        showDialog(
                                                                          context: context,
                                                                          builder: (context) => PayoutRequestDialog(
                                                                            payoutRequest: payoutRequestModel,
                                                                          ),
                                                                        );
                                                                      },
                                                                    )
                                                                  : TextCustom(title: 'Payment ${payoutRequestModel.paymentStatus.toString()}'),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                )
                                                .toList()),
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
                                  )
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
                  controller.selectedDateRangeForPdf.value = DateTimeRange(start: DateTime(DateTime.now().year, DateTime.january, 1), end: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, 23, 59, 0, 0));
                  Navigator.of(context).pop();
                },
                child: const Text('clear')),
            TextButton(
              onPressed: () async {
                if (controller.startDateForPdf != null && controller.endDateForPdf != null) {
                  controller.selectedDateRangeForPdf.value = DateTimeRange(start: controller.startDateForPdf!, end: DateTime(controller.endDateForPdf!.year, controller.endDateForPdf!.month, controller.endDateForPdf!.day, 23, 59, 0, 0));
                  controller.dateRangeController.value.text = "${DateFormat('dd/MM/yyyy').format(controller.selectedDateRangeForPdf.value.start)} to ${DateFormat('dd/MM/yyyy').format(controller.selectedDateRangeForPdf.value.end)}";
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
                  controller.selectedDateRange.value = DateTimeRange(start: controller.startDate!, end: DateTime(controller.endDate!.year, controller.endDate!.month, controller.endDate!.day, 23, 59, 0, 0));
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
                  await FireStoreUtils.countDriversWithMonth(
                    controller.selectedDateRange.value,
                  );
                  controller.setPagination(controller.totalItemPerPage.value);

                  Navigator.of(context).pop();
                },
                child: Text('clear'.tr)),
            TextButton(
              onPressed: () async {
                await FireStoreUtils.countDriversWithMonth(
                  controller.selectedDateRange.value,
                );
                if (controller.startDate != null && controller.endDate != null) {
                  await FireStoreUtils.countDriversWithMonth(
                    controller.selectedDateRange.value,
                  );
                  controller.setPagination(controller.totalItemPerPage.value);
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
}

class PayoutRequestDialog extends StatelessWidget {
  final WithdrawModel payoutRequest;

  const PayoutRequestDialog({super.key, required this.payoutRequest});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetX<PayoutRequestController>(
      init: PayoutRequestController(),
      builder: (controller) {
        return CustomDialog(
          title: controller.title.value.tr,
          widgetList: [
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                spaceH(),
                ContainerCustom(
                  padding: const EdgeInsets.all(0),
                  borderColor: themeChange.isDarkTheme() ? AppThemeData.lynch900 : AppThemeData.lynch100,
                  child: Column(
                    children: [
                      Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                          child: !ResponsiveWidget.isDesktop(context)
                              ? Column(
                                  children: [
                                    TextCustom(
                                      title: 'Payment ID'.tr,
                                      maxLine: 3,
                                    ),
                                    SizedBox(
                                      width: MediaQuery.sizeOf(context).width * 0.6,
                                      child: TextCustom(
                                        maxLine: 3,
                                        title: payoutRequest.id ?? 'N/A',
                                      ),
                                    ),
                                  ],
                                )
                              : Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    TextCustom(
                                      title: 'Payment ID'.tr,
                                      maxLine: 3,
                                    ),
                                    TextCustom(
                                      maxLine: 3,
                                      title: payoutRequest.id ?? 'N/A',
                                    ),
                                  ],
                                )),
                      // spaceH(),
                      SizedBox(
                        height: 1,
                        child: ContainerCustom(
                          padding: const EdgeInsets.all(0),
                          color: themeChange.isDarkTheme() ? AppThemeData.lynch900 : AppThemeData.lynch100,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            TextCustom(
                              title: 'Holder Name'.tr,
                            ),
                            TextCustom(
                              title: (payoutRequest.bankDetails!.holderName ?? 'N/A').toString(),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(
                        height: 1,
                        child: ContainerCustom(
                          padding: const EdgeInsets.all(0),
                          color: themeChange.isDarkTheme() ? AppThemeData.lynch900 : AppThemeData.lynch100,
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            TextCustom(
                              title: 'Account Number'.tr,
                            ),
                            TextCustom(title: (payoutRequest.bankDetails!.accountNumber ?? 'N/A').toString()),
                          ],
                        ),
                      ),

                      SizedBox(
                        height: 1,
                        child: ContainerCustom(
                          padding: const EdgeInsets.all(0),
                          color: themeChange.isDarkTheme() ? AppThemeData.lynch900 : AppThemeData.lynch100,
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            TextCustom(
                              title: 'Bank Name'.tr,
                            ),
                            TextCustom(title: (payoutRequest.bankDetails!.bankName ?? 'N/A').toString()),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 1,
                        child: ContainerCustom(
                          padding: const EdgeInsets.all(0),
                          color: themeChange.isDarkTheme() ? AppThemeData.lynch900 : AppThemeData.lynch100,
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            TextCustom(
                              title: 'Swift Code'.tr,
                            ),
                            TextCustom(title: (payoutRequest.bankDetails!.swiftCode ?? 'N/A').toString()),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 1,
                        child: ContainerCustom(
                          padding: const EdgeInsets.all(0),
                          color: themeChange.isDarkTheme() ? AppThemeData.lynch900 : AppThemeData.lynch100,
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            TextCustom(
                              title: 'Branch City'.tr,
                            ),
                            TextCustom(title: (payoutRequest.bankDetails!.branchCity ?? 'N/A').toString()),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 1,
                        child: ContainerCustom(
                          padding: const EdgeInsets.all(0),
                          color: themeChange.isDarkTheme() ? AppThemeData.lynch900 : AppThemeData.lynch100,
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            TextCustom(
                              title: 'Branch Country'.tr,
                            ),
                            TextCustom(title: (payoutRequest.bankDetails!.branchCountry ?? 'N/A').toString()),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                spaceH(),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextCustom(
                            maxLine: 1,
                            title: "Payment Status".tr,
                            fontFamily: FontFamily.medium,
                            fontSize: 14,
                          ),
                          spaceH(),
                          Obx(
                            () => DropdownButtonFormField(
                              isExpanded: true,
                              style: TextStyle(
                                fontFamily: FontFamily.medium,
                                color: themeChange.isDarkTheme() ? AppThemeData.textBlack : AppThemeData.textGrey,
                              ),
                              hint: TextCustom(title: 'Payment Status'.tr, fontFamily: FontFamily.regular, fontSize: 14),
                              onChanged: (String? taxType) {
                                controller.userSelectedPaymentStatus.value = taxType ?? "Pending";
                              },
                              value: controller.userSelectedPaymentStatus.value,
                              items: controller.paymentStatusType.map<DropdownMenuItem<String>>((String value) {
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
                        ],
                      ),
                    ),
                    Expanded(
                      child: Container(),
                    ),
                  ],
                ),
                10.height,
                CustomTextFormField(
                  hintText: 'Enter Payment Id'.tr,
                  controller: controller.paymentIdController.value,
                  title: 'Payment Id'.tr,
                  maxLine: 1,
                ),
                10.height,
                CustomTextFormField(
                  hintText: 'Enter note'.tr,
                  controller: controller.adminNoteController.value,
                  title: 'Note'.tr,
                  maxLine: 2,
                ),
              ],
            ),
            spaceH(),
          ],
          bottomWidgetList: [
            CustomButtonWidget(
              title: "Close".tr,
              buttonColor: themeChange.isDarkTheme() ? AppThemeData.lynch500 : AppThemeData.lynch500,
              onPress: () {
                // controller.setDefaultData();
                Navigator.pop(context);
              },
            ),
            spaceW(),
            CustomButtonWidget(
              // borderRadius: 12,
              title: "Save".tr,
              textColor: AppThemeData.primaryWhite,
              // buttonColor: AppColors.green500,
              onPress: () async {
                if (Constant.isDemo) {
                  DialogBox.demoDialogBox();
                } else {
                  payoutRequest.paymentStatus = controller.userSelectedPaymentStatus.value;
                  payoutRequest.adminNote = controller.adminNoteController.value.text;
                  payoutRequest.paymentId = controller.paymentIdController.value.text;
                  payoutRequest.paymentDate = Timestamp.now();
                  if (controller.userSelectedPaymentStatus.value == "Rejected") {
                    if (controller.adminNoteController.value.text.isEmpty || controller.adminNoteController.value.text == "") {
                      return ShowToastDialog.errorToast("Please Enter Rejected Note".tr);
                    }
                    Navigator.pop(context);
                    await FireStoreUtils.updatePayoutRequest(payoutRequest);
                    controller.getPayoutRequest();
                    return;
                  }
                  Navigator.pop(context);
                  await FireStoreUtils.updatePayoutRequest(payoutRequest);
                  controller.getPayoutRequest();
                }
              },
            ),
          ],
          controller: controller,
        );
      },
    );
  }
}
