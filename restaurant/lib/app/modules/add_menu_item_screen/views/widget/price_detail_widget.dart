// ignore_for_file: must_be_immutable, use_super_parameters

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';
import 'package:restaurant/app/modules/add_menu_item_screen/controllers/add_menu_item_screen_controller.dart';
import 'package:restaurant/app/widget/global_widgets.dart';
import 'package:restaurant/app/widget/text_field_widget.dart';
import 'package:restaurant/app/widget/text_widget.dart';
import 'package:restaurant/constant_widgets/round_shape_button.dart';
import 'package:restaurant/themes/app_fonts.dart';
import 'package:restaurant/themes/app_theme_data.dart';
import 'package:restaurant/utils/dark_theme_provider.dart';

import '../../../../../themes/screen_size.dart';

class PriceDetailWidget extends GetView<AddMenuItemsScreenController> {
  PriceDetailWidget({Key? key}) : super(key: key);

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetX(
      init: AddMenuItemsScreenController(),
      builder: (controller) {
        bool isPriceDetailsButtonEnabled = controller.areAllDetailsFilledOfPriceDetails();
        return Scaffold(
          backgroundColor: Colors.transparent,
          body: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Padding(
                padding: paddingEdgeInsets(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextCustom(
                      title: "Add Price Details".tr,
                      fontSize: 28,
                      maxLine: 2,
                      color: themeChange.isDarkTheme() ? AppThemeData.grey100 : AppThemeData.grey1000,
                      fontFamily: FontFamily.bold,
                      textAlign: TextAlign.start,
                    ),
                    2.height,
                    TextCustom(
                      title: "Provide the details of the new menu item you want to add.".tr,
                      fontSize: 16,
                      maxLine: 2,
                      color: themeChange.isDarkTheme() ? AppThemeData.grey400 : AppThemeData.grey600,
                      fontFamily: FontFamily.regular,
                      textAlign: TextAlign.start,
                    ),
                    spaceH(height: 32),
                    TextCustom(
                      title: "Price Details ".tr,
                      color: themeChange.isDarkTheme() ? AppThemeData.grey100 : AppThemeData.grey900,
                      fontFamily: FontFamily.medium,
                    ),
                    TextFieldWidget(
                      color: themeChange.isDarkTheme() ? AppThemeData.grey900 : AppThemeData.grey100,
                      title: "Price".tr,
                      hintText: "Enter Price".tr,
                      textInputType: TextInputType.number,
                      controller: controller.priceController.value,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      onPress: () {},
                    ),
                    TextFieldWidget(
                      color: themeChange.isDarkTheme() ? AppThemeData.grey900 : AppThemeData.grey100,
                      title: "Max purchase quantity".tr,
                      hintText: "Enter Max purchase quantity".tr,
                      controller: controller.maxQuantityController.value,
                      textInputType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      onPress: () {},
                    ),
                    Row(
                      children: [
                        TextFieldWidget(
                          color: themeChange.isDarkTheme() ? AppThemeData.grey900 : AppThemeData.grey100,
                          title: "Discount".tr,
                          hintText: "Enter Discount".tr,
                          textInputType: TextInputType.number,
                          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                          controller: controller.discountController.value,
                          onPress: () {},
                        ).expand(),
                        spaceW(width: 20),
                        Padding(
                          padding: const EdgeInsets.only(top: 20),
                          child: DropdownButtonFormField(
                            isExpanded: true,
                            onChanged: (value) {
                              controller.selectedDiscountType.value = value!;
                            },
                            initialValue: controller.selectedDiscountType.value.isEmpty ? null : controller.selectedDiscountType.value,
                            items: controller.discountType.map((item) {
                              return DropdownMenuItem<String>(value: item, child: Text(item));
                            }).toList(),
                            validator: (value) => value != null ? null : 'This field required'.tr,
                            icon: Icon(Icons.keyboard_arrow_down_outlined, color: themeChange.isDarkTheme() ? AppThemeData.grey600 : AppThemeData.grey400),
                            borderRadius: BorderRadius.circular(6),
                            dropdownColor: themeChange.isDarkTheme() ? AppThemeData.grey800 : AppThemeData.grey200,
                            focusColor: Colors.transparent,
                            elevation: 0,
                            hint: TextCustom(title: "Discount Type".tr, fontSize: 14, color: themeChange.isDarkTheme() ? AppThemeData.grey200 : AppThemeData.grey800, fontFamily: FontFamily.regular),
                            style: TextStyle(color: themeChange.isDarkTheme() ? AppThemeData.grey200 : AppThemeData.grey800, fontFamily: FontFamily.regular, fontSize: 14),
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
                        ).expand(),
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
              title: "Next".tr,
              buttonColor: isPriceDetailsButtonEnabled
                  ? AppThemeData.primary300
                  : themeChange.isDarkTheme()
                      ? AppThemeData.grey800
                      : AppThemeData.grey200,
              buttonTextColor: isPriceDetailsButtonEnabled ? AppThemeData.grey50 : AppThemeData.grey500,
              onTap: () {
                if (formKey.currentState!.validate()) {
                  if (isPriceDetailsButtonEnabled) {
                    controller.nextStep();
                  }
                }
              },
              size: Size(358.w,ScreenSize.height(6, context)),
            ),
          ),
        );
      },
    );
  }
}
