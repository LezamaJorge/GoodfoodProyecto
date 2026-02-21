// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';
import 'package:restaurant/app/modules/add_driver/controllers/add_driver_controllers.dart';
import 'package:restaurant/app/widget/global_widgets.dart';
import 'package:restaurant/app/widget/text_field_widget.dart';
import 'package:restaurant/app/widget/text_widget.dart';
import 'package:restaurant/themes/app_theme_data.dart';
import 'package:restaurant/themes/common_ui.dart';
import 'package:restaurant/utils/dark_theme_provider.dart';
import '../../../../constant/constant.dart';
import '../../../../constant_widgets/round_shape_button.dart';
import '../../../../themes/app_fonts.dart';
import '../../../../themes/screen_size.dart';

class AddDriverView extends GetView<AddDriverController> {
  const AddDriverView({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetX(
      init: AddDriverController(),
      builder: (controller) {
        bool allField = controller.checkIfFieldsAreFilled();
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
                  Obx(() {
                    final isEdit = controller.driverModel.value.driverId != null && controller.driverModel.value.driverId!.isNotEmpty;
                    return TextCustom(
                      title: isEdit ? "Edit Driver Basic Details".tr : "Enter Driver Basic Details".tr,
                      fontSize: 28,
                      maxLine: 2,
                      color: themeChange.isDarkTheme() ? AppThemeData.grey100 : AppThemeData.grey1000,
                      fontFamily: FontFamily.bold,
                      textAlign: TextAlign.start,
                    );
                  }),
                  2.height,
                  Obx(() {
                    final isEdit = controller.driverModel.value.driverId != null && controller.driverModel.value.driverId!.isNotEmpty;
                    return TextCustom(
                      title: isEdit
                          ? "Update the driver details below to keep the profile information accurate.".tr
                          : "Please provide your basic details to complete your driver profile and get started.".tr,
                      fontSize: 16,
                      maxLine: 2,
                      color: themeChange.isDarkTheme() ? AppThemeData.grey400 : AppThemeData.grey600,
                      fontFamily: FontFamily.regular,
                      textAlign: TextAlign.start,
                    );
                  }),
                  spaceH(height: 24),
                  TextFieldWidget(
                    title: "First Name".tr,
                    hintText: "Enter First Name".tr,
                    validator: (value) => value != null && value.isNotEmpty ? null : 'This field required'.tr,
                    controller: controller.firstNameController.value,
                    onPress: () {},
                  ),
                  TextFieldWidget(
                    title: "Last Name".tr,
                    hintText: "Enter Last Name".tr,
                    validator: (value) => value != null && value.isNotEmpty ? null : 'This field required'.tr,
                    controller: controller.lastNameController.value,
                    onPress: () {},
                  ),
                  MobileNumberTextField(
                    controller: controller.mobileNumberController.value,
                    countryCode: controller.countryCode.value!,
                    onPress: () {},
                    title: "Mobile Number",
                  ),
                  TextFieldWidget(
                    title: "Email".tr,
                    hintText: "Enter Email".tr,
                    validator: (value) => value != null && value.isNotEmpty ? null : 'This field required'.tr,
                    controller: controller.emailController.value,
                    onPress: () {},
                    readOnly: controller.driverModel.value.driverId != null && controller.driverModel.value.driverId!.isNotEmpty,
                  ),
                  Obx(() {
                    final isEdit = controller.driverModel.value.driverId != null && controller.driverModel.value.driverId!.isNotEmpty;
                    if (isEdit) {
                      return const SizedBox();
                    }
                    return Column(
                      children: [
                        TextFieldWidget(
                          title: "Password".tr,
                          hintText: "Enter Password".tr,
                          validator: (value) => Constant.validatePassword(value),
                          controller: controller.passwordController.value,
                          obscureText: controller.isPasswordVisible.value,
                          suffix: SvgPicture.asset(
                            controller.isPasswordVisible.value ? "assets/icons/ic_hide_password.svg" : "assets/icons/ic_show_password.svg",
                            color: themeChange.isDarkTheme() ? AppThemeData.grey200 : AppThemeData.grey800,
                          ).onTap(() {
                            controller.isPasswordVisible.value = !controller.isPasswordVisible.value;
                          }),
                          onPress: () {},
                        ),
                        TextFieldWidget(
                          title: "Confirm Password".tr,
                          hintText: "Enter Confirm Password".tr,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Confirm password is required.".tr;
                            }
                            if (value != controller.passwordController.value.text) {
                              return "Passwords do not match.".tr;
                            }
                            return null;
                          },
                          controller: controller.confirmPasswordController.value,
                          obscureText: controller.isConfPasswordVisible.value,
                          suffix: SvgPicture.asset(
                            controller.isConfPasswordVisible.value ? "assets/icons/ic_hide_password.svg" : "assets/icons/ic_show_password.svg",
                            color: themeChange.isDarkTheme() ? AppThemeData.grey200 : AppThemeData.grey800,
                          ).onTap(() {
                            controller.isConfPasswordVisible.value = !controller.isConfPasswordVisible.value;
                          }),
                          onPress: () {},
                        ),
                      ],
                    );
                  }),
                  TextFieldWidget(
                    color: themeChange.isDarkTheme() ? AppThemeData.grey900 : AppThemeData.grey100,
                    title: "Bike Model Name".tr,
                    hintText: "Enter Bike Model Name".tr,
                    controller: controller.vehicleNameController.value,
                    onPress: () {},
                  ),
                  TextFieldWidget(
                    color: themeChange.isDarkTheme() ? AppThemeData.grey900 : AppThemeData.grey100,
                    title: "Vehicle Number".tr,
                    hintText: "Enter Vehicle Number".tr,
                    controller: controller.vehicleNumberController.value,
                    onPress: () {},
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            Radio(
                              value: VehicleType.bike.obs,
                              groupValue: controller.vehicleType.value,
                              onChanged: (value) {
                                controller.vehicleType.value = VehicleType.bike;
                              },
                              activeColor: AppThemeData.primary300,
                            ),
                            TextCustom(
                              title: "Bike".tr,
                              fontSize: 16,
                              color: themeChange.isDarkTheme() ? AppThemeData.grey400 : AppThemeData.grey600,
                            )
                          ],
                        ),
                      ),
                      Expanded(
                        child: Row(
                          children: [
                            Radio(
                              value: VehicleType.scooter.obs,
                              groupValue: controller.vehicleType.value,
                              onChanged: (value) {
                                controller.vehicleType.value = VehicleType.scooter;
                              },
                              activeColor: AppThemeData.primary300,
                            ),
                            TextCustom(
                              title: "Scooter".tr,
                              fontSize: 16,
                              color: themeChange.isDarkTheme() ? AppThemeData.grey400 : AppThemeData.grey600,
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          bottomNavigationBar: Padding(
            padding: paddingEdgeInsets(vertical: 8),
            child: RoundShapeButton(
              title: controller.isEditing.value ? "Update".tr : "Save".tr,
              buttonColor: (controller.isEditing.value || allField)
                  ? AppThemeData.primary300
                  : themeChange.isDarkTheme()
                      ? AppThemeData.grey800
                      : AppThemeData.grey200,
              buttonTextColor: (controller.isEditing.value || allField) ? AppThemeData.grey50 : AppThemeData.grey500,
              onTap: () {
                controller.saveData();
              },
              size: Size(358.w, ScreenSize.height(6, context)),
            ),
          ),
        );
      },
    );
  }
}
