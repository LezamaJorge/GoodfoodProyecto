import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:restaurant/app/modules/my_bank/controllers/my_bank_controller.dart';
import 'package:restaurant/app/widget/global_widgets.dart';
import 'package:restaurant/app/widget/text_field_widget.dart';
import 'package:restaurant/app/widget/text_widget.dart';
import 'package:restaurant/constant_widgets/round_shape_button.dart';
import 'package:restaurant/themes/app_fonts.dart';
import 'package:restaurant/themes/app_theme_data.dart';
import 'package:restaurant/themes/common_ui.dart';
import 'package:restaurant/utils/dark_theme_provider.dart';

import '../../../../themes/screen_size.dart';

class AddBankView extends GetView<MyBankController> {
  const AddBankView({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetBuilder(
      init: MyBankController(),
      builder: (controller) {
        return Scaffold(
            backgroundColor: themeChange.isDarkTheme() ? AppThemeData.grey1000 : AppThemeData.grey50,
            appBar: UiInterface.customAppBar(
              context,
              themeChange,
              "",
            ),
            bottomNavigationBar: Padding(
              padding: paddingEdgeInsets(horizontal: 16,vertical: 8),
              child: RoundShapeButton(
                title: "Add Bank".tr,
                buttonColor: AppThemeData.primary300,
                buttonTextColor: themeChange.isDarkTheme() ? AppThemeData.primaryBlack : AppThemeData.primaryWhite,
                onTap: () async {
                  if (controller.formKey.value.currentState!.validate()) {
                    if (controller.editingId.value != "") {
                      controller.updateBankDetail();
                    } else {
                      controller.setBankDetails();
                    }
                    controller.getData();
                    Get.back();
                  }
                },
                size: Size(358.w, ScreenSize.height(6, context)),
              ),
            ),
            body: Padding(
              padding: const EdgeInsets.only(right: 20, left: 20),
              child: SingleChildScrollView(
                child: Form(
                  key: controller.formKey.value,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextCustom(
                        title: "Add Bank Account".tr,
                        fontSize: 28,
                        maxLine: 2,
                        color: themeChange.isDarkTheme() ? AppThemeData.grey100 : AppThemeData.grey1000,
                        fontFamily: FontFamily.bold,
                        textAlign: TextAlign.start,
                      ),
                      spaceH(height: 2),
                      TextCustom(
                        title: "Provide your bank details to enable withdrawals and payments.".tr,
                        fontSize: 16,
                        maxLine: 2,
                        color: themeChange.isDarkTheme() ? AppThemeData.grey400 : AppThemeData.grey600,
                        fontFamily: FontFamily.regular,
                        textAlign: TextAlign.start,
                      ),
                      spaceH(height: 16),

                      TextFieldWidget(
                        onPress: () {},
                        controller: controller.bankHolderNameController,
                        hintText: "Enter Bank Holder Name".tr,
                        title: "Bank Holder Name".tr,
                        enable: true,
                        textInputType: TextInputType.text,
                        validator: (value) => value != null && value.isNotEmpty ? null : 'This field required'.tr,
                      ),
                      TextFieldWidget(
                        onPress: () {},
                        controller: controller.bankAccountNumberController,
                        hintText: "Enter bank account number".tr,
                        title: "Bank Account Number".tr,
                        enable: true,
                        textInputType: TextInputType.text,
                        validator: (value) => value != null && value.isNotEmpty ? null : 'This field required'.tr,
                      ),
                      TextFieldWidget(
                        onPress: () {},
                        controller: controller.swiftCodeController,
                        hintText: "Enter Swift Code".tr,
                        title: "Swift Code".tr,
                        enable: true,
                        textInputType: TextInputType.text,
                        validator: (value) => value != null && value.isNotEmpty ? null : 'This field required'.tr,
                      ),
                      TextFieldWidget(
                        onPress: () {},
                        controller: controller.ifscCodeController,
                        hintText: "Enter IFSC Code".tr,
                        title: "IFSC Code".tr,
                        enable: true,
                        textInputType: TextInputType.text,
                        validator: (value) => value != null && value.isNotEmpty ? null : 'This field required'.tr,
                      ),
                      TextFieldWidget(
                        onPress: () {},
                        controller: controller.bankNameController,
                        hintText: "Enter Bank Name".tr,
                        title: "Bank Name".tr,
                        enable: true,
                        textInputType: TextInputType.text,
                        validator: (value) => value != null && value.isNotEmpty ? null : 'This field required'.tr,
                      ),
                      TextFieldWidget(
                        onPress: () {},
                        controller: controller.bankBranchCityController,
                        hintText: "Enter Bank Branch City".tr,
                        title: "Bank Branch City".tr,
                        enable: true,
                        textInputType: TextInputType.text,
                        validator: (value) => value != null && value.isNotEmpty ? null : 'This field required'.tr,
                      ),
                      TextFieldWidget(
                        onPress: () {},
                        controller: controller.bankBranchCountryController,
                        hintText: "Enter Bank Branch Country".tr,
                        title: "Bank Branch Country".tr,
                        enable: true,
                        textInputType: TextInputType.text,
                        validator: (value) => value != null && value.isNotEmpty ? null : 'This field required'.tr,
                      ),
                    ],
                  ),
                ),
              ),
            ));
      },
    );
  }
}
