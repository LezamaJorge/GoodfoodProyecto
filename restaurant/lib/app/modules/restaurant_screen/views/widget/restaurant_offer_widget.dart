// ignore_for_file: must_be_immutable, use_super_parameters

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';
import 'package:restaurant/app/modules/restaurant_screen/controllers/restaurant_screen_controller.dart';
import 'package:restaurant/app/widget/global_widgets.dart';
import 'package:restaurant/app/widget/text_field_widget.dart';
import 'package:restaurant/app/widget/text_widget.dart';
import 'package:restaurant/constant_widgets/round_shape_button.dart';
import 'package:restaurant/themes/app_fonts.dart';
import 'package:restaurant/themes/app_theme_data.dart';
import 'package:restaurant/themes/screen_size.dart';
import 'package:restaurant/utils/dark_theme_provider.dart';

class RestaurantOfferWidget extends GetView<RestaurantScreenController> {
  RestaurantOfferWidget({super.key});

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);

    return GetX(
      init: RestaurantScreenController(),
      builder: (controller) {
        return Scaffold(
          backgroundColor: themeChange.isDarkTheme() ? AppThemeData.grey1000 : AppThemeData.grey50,
          appBar: AppBar(
            systemOverlayStyle: const SystemUiOverlayStyle(
              statusBarColor: Colors.transparent,
              statusBarIconBrightness: Brightness.dark, // Android → black
              statusBarBrightness: Brightness.light,    // iOS → black
            ),
            backgroundColor: Colors.transparent,
            surfaceTintColor: Colors.transparent,
            automaticallyImplyLeading: false,
            leading: GestureDetector(
              onTap: () {
                Get.back();
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: themeChange.isDarkTheme() ? AppThemeData.grey900 : AppThemeData.grey100,
                  ),
                  child: Icon(
                    Icons.arrow_back_ios_sharp,
                    size: 20,
                    color: themeChange.isDarkTheme() ? AppThemeData.grey100 : AppThemeData.grey900,
                  ),
                ),
              ),
            ),
          ),
          body: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Padding(
                padding: paddingEdgeInsets(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextCustom(
                      title: "Add The Restaurant Offer".tr,
                      fontSize: 28,
                      maxLine: 2,
                      color: themeChange.isDarkTheme() ? AppThemeData.grey100 : AppThemeData.grey1000,
                      fontFamily: FontFamily.bold,
                      textAlign: TextAlign.start,
                    ),
                    2.height,
                    TextCustom(
                      title: "Provide essential details such as name, address, type, and cuisine to set up your restaurant profile.".tr,
                      fontSize: 16,
                      maxLine: 2,
                      color: themeChange.isDarkTheme() ? AppThemeData.grey400 : AppThemeData.grey600,
                      fontFamily: FontFamily.regular,
                      textAlign: TextAlign.start,
                    ),
                    spaceH(height: 20),
                    TextFieldWidget(
                      color: themeChange.isDarkTheme() ? AppThemeData.grey900 : AppThemeData.grey100,
                      title: "Coupon Title".tr,
                      hintText: "Enter Coupon Title".tr,
                      controller: controller.couponTitleController.value,
                      onPress: () {},
                    ),
                    TextFieldWidget(
                      color: themeChange.isDarkTheme() ? AppThemeData.grey900 : AppThemeData.grey100,
                      title: "Enter Coupon Code".tr,
                      hintText: "Enter Coupon Code".tr,
                      controller: controller.couponCodeController.value,
                      onPress: () {},
                    ),
                    TextFieldWidget(
                      color: themeChange.isDarkTheme() ? AppThemeData.grey900 : AppThemeData.grey100,
                      title: "Enter Minimum Amount".tr,
                      hintText: "Enter Minimum Amount".tr,
                      controller: controller.couponMinAmountController.value,
                      onPress: () {},
                      textInputType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    ),
                    TextFieldWidget(
                      color: themeChange.isDarkTheme() ? AppThemeData.grey900 : AppThemeData.grey100,
                      title: "Enter Discount Amount".tr,
                      hintText: "Enter Discount Amount".tr,
                      controller: controller.couponDiscountAmountController.value,
                      onPress: () {},
                      textInputType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
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
                                title: "Commission Type".tr,
                                fontFamily: FontFamily.medium,
                                fontSize: 14,
                              ),
                              spaceH(),
                              Obx(
                                () => DropdownButtonFormField(
                                  isExpanded: true,
                                  style: TextStyle(
                                    fontFamily: FontFamily.medium,
                                    color: themeChange.isDarkTheme() ? AppThemeData.primaryWhite : AppThemeData.textBlack,
                                  ),
                                  hint: TextCustom(title: 'Select Commission Type'.tr),
                                  onChanged: (String? taxType) {
                                    controller.selectedAdminCommissionType.value = taxType ?? "Fix";
                                  },
                                  initialValue: controller.selectedAdminCommissionType.value,
                                  items: controller.adminCommissionType.map<DropdownMenuItem<String>>((String value) {
                                    return DropdownMenuItem(
                                      value: value,
                                      child: TextCustom(
                                        title: value.tr,
                                        fontFamily: FontFamily.regular,
                                        fontSize: 16,
                                        color: themeChange.isDarkTheme() ? AppThemeData.grey500 : AppThemeData.grey800,
                                      ),
                                    );
                                  }).toList(),
                                  decoration: InputDecoration(
                                    errorStyle: const TextStyle(fontFamily: FontFamily.regular),
                                    isDense: true,
                                    filled: true,
                                    fillColor: themeChange.isDarkTheme() ? AppThemeData.grey900 : AppThemeData.grey50,
                                    contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide(color: themeChange.isDarkTheme() ? AppThemeData.grey600 : AppThemeData.grey400, width: 1),
                                    ),
                                    disabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide(color: themeChange.isDarkTheme() ? AppThemeData.grey600 : AppThemeData.grey400, width: 1),
                                    ),
                                    focusedErrorBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide(color: themeChange.isDarkTheme() ? AppThemeData.grey600 : AppThemeData.grey400, width: 1),
                                    ),
                                    errorBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: const BorderSide(color: AppThemeData.danger300, width: 1),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide(color: themeChange.isDarkTheme() ? AppThemeData.grey600 : AppThemeData.grey400, width: 1),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide(color: AppThemeData.primary300, width: 1),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        spaceW(),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TextCustom(
                                maxLine: 1,
                                title: "Coupon Type".tr,
                                fontFamily: FontFamily.medium,
                                fontSize: 14,
                              ),
                              spaceH(),
                              Obx(
                                () => DropdownButtonFormField(
                                  borderRadius: BorderRadius.circular(15),
                                  isExpanded: true,
                                  style: TextStyle(
                                    fontFamily: FontFamily.medium,
                                    color: themeChange.isDarkTheme() ? AppThemeData.primaryWhite : AppThemeData.textBlack,
                                  ),
                                  hint: TextCustom(title: 'Select Coupon Type'.tr),
                                  onChanged: (String? couponType) {
                                    controller.couponPrivateType.value = couponType ?? "Public";
                                  },
                                  initialValue: controller.couponPrivateType.value,
                                  items: controller.couponType.map<DropdownMenuItem<String>>((String value) {
                                    return DropdownMenuItem(
                                      value: value,
                                      child: TextCustom(
                                        title: value.tr,
                                        color: themeChange.isDarkTheme() ? AppThemeData.grey500 : AppThemeData.grey800,
                                        fontSize: 16,
                                      ),
                                    );
                                  }).toList(),
                                  decoration: InputDecoration(
                                    errorStyle: const TextStyle(fontFamily: FontFamily.regular),
                                    isDense: true,
                                    filled: true,
                                    fillColor: themeChange.isDarkTheme() ? AppThemeData.grey900 : AppThemeData.grey50,
                                    contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide(color: themeChange.isDarkTheme() ? AppThemeData.grey600 : AppThemeData.grey400, width: 1),
                                    ),
                                    disabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide(color: themeChange.isDarkTheme() ? AppThemeData.grey600 : AppThemeData.grey400, width: 1),
                                    ),
                                    focusedErrorBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide(color: themeChange.isDarkTheme() ? AppThemeData.grey600 : AppThemeData.grey400, width: 1),
                                    ),
                                    errorBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: const BorderSide(color: AppThemeData.danger300, width: 1),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide(color: themeChange.isDarkTheme() ? AppThemeData.grey600 : AppThemeData.grey400, width: 1),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide(color: AppThemeData.primary300, width: 1),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              spaceH(),
                              TextCustom(
                                title: 'Select coupon expire date'.tr,
                                fontFamily: FontFamily.medium,
                                fontSize: 14,
                              ),
                              spaceH(),
                              GestureDetector(
                                onTap: () {
                                  controller.selectDate(context);
                                },
                                child:
                                Container(
                                    height: 50,
                                    alignment: Alignment.centerLeft,
                                    padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                                    width: ScreenSize.width(100, context),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: themeChange.isDarkTheme() ? AppThemeData.primaryBlack : AppThemeData.primaryWhite,
                                        border: Border.all(color: themeChange.isDarkTheme() ? AppThemeData.grey600 : AppThemeData.grey400, width: 1)),
                                    child: Obx( ()=>
                                       TextCustom(
                                        title: controller.expireDateController.value.text.isEmpty ? 'Select coupon expire date'.tr : controller.expireDateController.value.text,
                                        fontSize: 14,
                                        color: themeChange.isDarkTheme() ? AppThemeData.grey200 : AppThemeData.grey800,
                                        textAlign: TextAlign.start,
                                      ),
                                    ),
                                  ),),
                              spaceH(),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        TextCustom(
                                          title: 'Status'.tr,
                                          fontFamily: FontFamily.medium,
                                          fontSize: 14,
                                        ),
                                        spaceH(height: 0),
                                        Transform.scale(
                                          scale: 0.8,
                                          child: CupertinoSwitch(
                                            activeTrackColor: AppThemeData.primary300,
                                            value: controller.isActive.value,
                                            onChanged: (value) {
                                              controller.isActive.value = value;
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          bottomNavigationBar: Padding(
            padding: paddingEdgeInsets(vertical: 8),
            child: RoundShapeButton(
              title: controller.isEditing.value == true ? 'Update Restaurant Offer'.tr : "Save Restaurant Offer".tr,
              buttonColor: AppThemeData.primary300,
              buttonTextColor: AppThemeData.primaryWhite,
              onTap: () {
                controller.isEditing.value == true ? controller.updateCoupon() : controller.addCoupon();
              },
              size: Size(358.w, ScreenSize.height(6, context)),
            ),
          ),
        );
      },
    );
  }
}
