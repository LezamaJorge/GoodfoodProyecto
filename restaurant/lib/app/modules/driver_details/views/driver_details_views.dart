// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';
import 'package:restaurant/app/modules/add_driver/views/add_driver_views.dart';
import 'package:restaurant/constant/constant.dart';
import 'package:restaurant/constant/show_toast_dialogue.dart';
import '../../../../constant_widgets/custom_dialog_box.dart';
import '../../../../constant_widgets/round_shape_button.dart';
import '../../../../themes/app_fonts.dart';
import '../../../../themes/app_theme_data.dart';
import '../../../../themes/common_ui.dart';
import '../../../../themes/screen_size.dart';
import '../../../../utils/dark_theme_provider.dart';
import '../../../widget/global_widgets.dart';
import '../../../widget/text_widget.dart';
import '../controllers/driver_details_controllers.dart';

class DriverDetailsViews extends GetView<DriverDetailsControllers> {
  const DriverDetailsViews({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetBuilder(
      init: DriverDetailsControllers(),
      builder: (controller) {
        return Scaffold(
          backgroundColor: themeChange.isDarkTheme() ? AppThemeData.darkBackground : AppThemeData.grey50,
          appBar: UiInterface.customAppBar(
            backgroundColor: themeChange.isDarkTheme() ? AppThemeData.darkBackground : AppThemeData.grey50,
            context,
            themeChange,
            "".tr,
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: paddingEdgeInsets(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextCustom(
                    title: "Driver List".tr,
                    fontSize: 28,
                    maxLine: 2,
                    color: themeChange.isDarkTheme() ? AppThemeData.grey100 : AppThemeData.grey1000,
                    fontFamily: FontFamily.bold,
                    textAlign: TextAlign.start,
                  ),
                  2.height,
                  TextCustom(
                    title: "Here you can see all registered drivers and manage their details.".tr,
                    fontSize: 16,
                    maxLine: 2,
                    color: themeChange.isDarkTheme() ? AppThemeData.grey400 : AppThemeData.grey600,
                    fontFamily: FontFamily.regular,
                    textAlign: TextAlign.start,
                  ),
                  spaceH(height: 24),
                  Obx(
                    () {
                      if (controller.isLoading.value) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (controller.driverList.isEmpty) {
                        return const Center(child: Text("No drivers found"));
                      }
                      return ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: controller.driverList.length,
                        itemBuilder: (context, index) {
                          final driver = controller.driverList[index];
                          return Container(
                            margin: const EdgeInsets.symmetric(vertical: 8),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: themeChange.isDarkTheme() ? AppThemeData.grey800 : AppThemeData.grey100,
                            ),
                            padding: const EdgeInsets.all(16),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          "Name : ",
                                          style: TextStyle(
                                            fontFamily: FontFamily.regular,
                                            color: themeChange.isDarkTheme() ? AppThemeData.grey50 : AppThemeData.grey900,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                        Text(
                                          driver.slug.toString(),
                                          style: TextStyle(
                                            fontFamily: FontFamily.regular,
                                            color: themeChange.isDarkTheme() ? AppThemeData.grey400 : AppThemeData.grey500,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          "Email : ",
                                          style: TextStyle(
                                            fontFamily: FontFamily.regular,
                                            color: themeChange.isDarkTheme() ? AppThemeData.grey50 : AppThemeData.grey900,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                        Text(
                                          driver.email.toString(),
                                          style: TextStyle(
                                            fontFamily: FontFamily.regular,
                                            color: themeChange.isDarkTheme() ? AppThemeData.grey400 : AppThemeData.grey500,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          "Phone Number : ",
                                          style: TextStyle(
                                            fontFamily: FontFamily.regular,
                                            color: themeChange.isDarkTheme() ? AppThemeData.grey50 : AppThemeData.grey900,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                        Text(
                                          "${driver.countryCode} ${driver.phoneNumber}",
                                          style: TextStyle(
                                            fontFamily: FontFamily.regular,
                                            color: themeChange.isDarkTheme() ? AppThemeData.grey400 : AppThemeData.grey500,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          "Model Name : ",
                                          style: TextStyle(
                                            fontFamily: FontFamily.regular,
                                            color: themeChange.isDarkTheme() ? AppThemeData.grey50 : AppThemeData.grey900,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                        Text(
                                          driver.driverVehicleDetails!.modelName.toString(),
                                          style: TextStyle(
                                            fontFamily: FontFamily.regular,
                                            color: themeChange.isDarkTheme() ? AppThemeData.grey400 : AppThemeData.grey500,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          "Vehicle Type : ",
                                          style: TextStyle(
                                            fontFamily: FontFamily.regular,
                                            color: themeChange.isDarkTheme() ? AppThemeData.grey50 : AppThemeData.grey900,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                        Text(
                                          driver.driverVehicleDetails!.vehicleTypeName.toString(),
                                          style: TextStyle(
                                            fontFamily: FontFamily.regular,
                                            color: themeChange.isDarkTheme() ? AppThemeData.grey400 : AppThemeData.grey500,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          "Vehicle Number : ",
                                          style: TextStyle(
                                            fontFamily: FontFamily.regular,
                                            color: themeChange.isDarkTheme() ? AppThemeData.grey50 : AppThemeData.grey900,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                        Text(
                                          driver.driverVehicleDetails!.vehicleNumber.toString(),
                                          style: TextStyle(
                                            fontFamily: FontFamily.regular,
                                            color: themeChange.isDarkTheme() ? AppThemeData.grey400 : AppThemeData.grey500,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      margin: paddingEdgeInsets(horizontal: 8, vertical: 8),
                                      padding: paddingEdgeInsets(horizontal: 8, vertical: 4),
                                      decoration: BoxDecoration(
                                          color: themeChange.isDarkTheme() ? AppThemeData.grey900.withOpacity(0.8) : AppThemeData.grey100.withOpacity(0.8),
                                          borderRadius: BorderRadius.circular(5)),
                                      child: TextCustom(
                                        title: driver.status == 'free' ? "Free".tr : "Busy".tr,
                                        color: driver.status == 'free' ? AppThemeData.success300 : AppThemeData.orange300,
                                        fontSize: 12,
                                        fontFamily: FontFamily.bold,
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        GestureDetector(
                                          onTap: () async {
                                            await Get.to(() => AddDriverView(), arguments: {
                                              "driverModel": driver,
                                              'isEditing': true,
                                            });
                                            controller.getData();
                                          },
                                          child: SvgPicture.asset(
                                            "assets/icons/ic_edit_2.svg",
                                            color: AppThemeData.secondary300,
                                          ),
                                        ),
                                        spaceW(width: 12),
                                        GestureDetector(
                                          onTap: () {
                                            showDialog(
                                                context: context,
                                                builder: (BuildContext context) {
                                                  return CustomDialogBox(
                                                    img: Image.asset(
                                                      "assets/animation/am_delete.gif",
                                                      height: 64.h,
                                                      width: 64.w,
                                                    ),
                                                    themeChange: themeChange,
                                                    title: "Driver Delete".tr,
                                                    descriptions: "Are you sure you want to delete your driver account? This action is permanent and cannot be undone.".tr,
                                                    positiveString: "Yes".tr,
                                                    negativeString: "No".tr,
                                                    positiveClick: () async {
                                                      ShowToastDialog.showLoader("Please Wait..".tr);
                                                      controller.deleteUserAccount(driver.driverId.toString());
                                                      ShowToastDialog.closeLoader();
                                                      Navigator.pop(context);
                                                    },
                                                    negativeClick: () {
                                                      Navigator.pop(context);
                                                    },
                                                    positiveButtonColor: AppThemeData.danger300,
                                                    negativeButtonColor: themeChange.isDarkTheme() ? AppThemeData.grey1000 : AppThemeData.grey50,
                                                    positiveButtonTextColor: themeChange.isDarkTheme() ? AppThemeData.grey1000 : AppThemeData.grey50,
                                                    negativeButtonTextColor: themeChange.isDarkTheme() ? AppThemeData.grey100 : AppThemeData.grey900,
                                                    negativeButtonBorderColor: themeChange.isDarkTheme() ? AppThemeData.grey600 : AppThemeData.grey400,
                                                  );
                                                });
                                          },
                                          child: SvgPicture.asset(
                                            "assets/icons/ic_delete.svg",
                                            color: AppThemeData.danger300,
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                )
                              ],
                            ),
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
          bottomNavigationBar: Padding(
            padding: paddingEdgeInsets(vertical: 8),
            child: RoundShapeButton(
              title: "Add".tr,
              buttonColor: AppThemeData.primary300,
              buttonTextColor: AppThemeData.green50,
              onTap: () {
                if (Constant.isSelfDelivery == true && Constant.vendorModel!.isSelfDelivery == true) {
                  Get.to(AddDriverView());
                }else{
                  ShowToastDialog.toast("Delivery feature is disabled");
                }
              },
              size: Size(358.w, ScreenSize.height(6, context)),
            ),
          ),
        );
      },
    );
  }
}
