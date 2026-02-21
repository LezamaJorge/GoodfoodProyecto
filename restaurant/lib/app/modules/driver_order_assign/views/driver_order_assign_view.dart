// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';
import 'package:restaurant/app/models/driver_user_model.dart';
import 'package:restaurant/app/widget/global_widgets.dart';
import 'package:restaurant/app/widget/text_widget.dart';
import 'package:restaurant/constant/show_toast_dialogue.dart';
import 'package:restaurant/constant_widgets/custom_dialog_box.dart';
import 'package:restaurant/constant_widgets/round_shape_button.dart';
import 'package:restaurant/themes/app_theme_data.dart';
import 'package:restaurant/themes/common_ui.dart';
import 'package:restaurant/themes/screen_size.dart';
import 'package:restaurant/utils/dark_theme_provider.dart';

import '../../../../themes/app_fonts.dart';
import '../controllers/driver_order_assign_controller.dart';

class DriverOrderAssignView extends GetView<DriverOrderAssignController> {
  const DriverOrderAssignView({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetBuilder(
      init: DriverOrderAssignController(),
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
                    title: "Assign Driver".tr,
                    fontSize: 28,
                    maxLine: 2,
                    color: themeChange.isDarkTheme() ? AppThemeData.grey100 : AppThemeData.grey1000,
                    fontFamily: FontFamily.bold,
                    textAlign: TextAlign.start,
                  ),
                  2.height,
                  TextCustom(
                    title: "You can assign orders to drivers created by your restaurant. Select the driver of your choice to continue.".tr,
                    fontSize: 16,
                    maxLine: 3,
                    color: themeChange.isDarkTheme() ? AppThemeData.grey400 : AppThemeData.grey600,
                    fontFamily: FontFamily.regular,
                    textAlign: TextAlign.start,
                  ),
                  spaceH(height: 24),
                  TextCustom(
                    title: "Selected Driver".tr,
                    fontSize: 16,
                    maxLine: 1,
                    fontFamily: FontFamily.medium,
                    textAlign: TextAlign.start,
                  ),
                  spaceH(height: 12.h),
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
                        itemCount: controller.driverList.length,
                        itemBuilder: (context, index) {
                          final driver = controller.driverList[index];
                          return Obx(
                            () => RadioGroup<DriverUserModel>(
                              groupValue: controller.driver.value,
                              onChanged: (value) {
                                if (driver.status == 'busy') {
                                  ShowToastDialog.toast("Driver is Busy, Please Select Another Driver.".tr);
                                } else {
                                  controller.driver.value = value!;
                                }
                              },
                              child: RadioListTile<DriverUserModel>(
                                value: driver,
                                controlAffinity: ListTileControlAffinity.trailing,
                                contentPadding: EdgeInsets.zero,
                                activeColor: AppThemeData.primary300,
                                title: Row(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: themeChange.isDarkTheme() ? AppThemeData.grey900 : AppThemeData.grey50,
                                      ),
                                      height: 46.h,
                                      width: 46.w,
                                      child: Center(
                                        child: SizedBox(
                                          height: 18.h,
                                          width: 18.w,
                                          child: SvgPicture.asset(
                                            "assets/icons/ic_selfdelivery.svg",
                                            color: AppThemeData.pending400,
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 12),
                                    Row(
                                      children: [
                                        Text(
                                          driver.fullNameString(),
                                          style: TextStyle(
                                            color: themeChange.isDarkTheme() ? AppThemeData.primaryWhite : AppThemeData.primaryBlack,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        12.width,
                                        Container(
                                          padding: paddingEdgeInsets(horizontal: 8, vertical: 4),
                                          decoration: BoxDecoration(
                                            color: themeChange.isDarkTheme() ? AppThemeData.grey900.withOpacity(0.8) : AppThemeData.grey100.withOpacity(0.8),
                                            borderRadius: BorderRadius.circular(5),
                                          ),
                                          child: TextCustom(
                                            title: driver.status == 'free' ? "Free".tr : "Busy".tr,
                                            color: driver.status == 'free' ? AppThemeData.success300 : AppThemeData.orange300,
                                            fontSize: 12,
                                            fontFamily: FontFamily.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    },
                  )
                ],
              ),
            ),
          ),
          bottomNavigationBar: Padding(
            padding: paddingEdgeInsets(vertical: 8),
            child: Row(
              children: [
                Expanded(
                    child: RoundShapeButton(
                  title: "Cancel".tr,
                  buttonColor: themeChange.isDarkTheme() ? AppThemeData.grey1000 : AppThemeData.grey50,
                  buttonTextColor: themeChange.isDarkTheme() ? AppThemeData.grey100 : AppThemeData.grey900,
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return CustomDialogBox(
                            img: Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: themeChange.isDarkTheme() ? AppThemeData.grey900 : AppThemeData.grey50,
                              ),
                              height: 56.h,
                              width: 56.w,
                              child: Center(
                                child: SizedBox(
                                  height: 22.h,
                                  width: 22.w,
                                  child: SvgPicture.asset(
                                    "assets/icons/ic_selfdelivery.svg",
                                    color: AppThemeData.pending400,
                                  ),
                                ),
                              ),
                            ),
                            themeChange: themeChange,
                            title: "Assign Order".tr,
                            descriptions: "You are not assigning this order to your restaurant's driver. Are you sure you want to assign it to any available free driver?".tr,
                            positiveString: "Yes".tr,
                            negativeString: "No".tr,
                            positiveClick: () async {
                              controller.driverOrderAssign();
                              Get.back();
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
                  size: Size(358.w, ScreenSize.height(6, context)),
                )),
                16.width,
                Expanded(
                  child: RoundShapeButton(
                    title: "Confirm".tr,
                    buttonColor: AppThemeData.primary300,
                    buttonTextColor: themeChange.isDarkTheme() ? AppThemeData.grey1000 : AppThemeData.grey50,
                    onTap: () {
                      if (controller.driver.value.driverId != null && controller.driver.value.driverId!.isNotEmpty) {
                        log("Driver ID: ${controller.driver.value.driverId}");
                        log("Order ID: ${controller.orderModel.value.id}");
                        controller.selectedDriverOrderAssign(controller.orderModel.value.id.toString(), controller.driver.value.driverId.toString());
                      } else {
                        ShowToastDialog.toast("Please First Select the Driver..");
                      }
                      //Get.back();
                    },
                    size: Size(358.w, ScreenSize.height(6, context)),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
