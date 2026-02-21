import 'package:customer/app/modules/my_banks/controllers/my_banks_controller.dart';
import 'package:customer/app/widget/global_widgets.dart';
import 'package:customer/app/widget/text_field_widget.dart';
import 'package:customer/app/widget/text_widget.dart';
import 'package:customer/constant_widgets/login_dialog.dart';
import 'package:customer/constant_widgets/round_shape_button.dart';
import 'package:customer/themes/app_fonts.dart';
import 'package:customer/themes/app_theme_data.dart';
import 'package:customer/themes/common_ui.dart';
import 'package:customer/utils/dark_theme_provider.dart';
import 'package:customer/utils/fire_store_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../../../themes/screen_size.dart';

class AddBankView extends GetView {
  const AddBankView({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetBuilder(
      init: MyBanksController(),
      builder: (controller) {
        return Scaffold(
            backgroundColor: themeChange.isDarkTheme() ? AppThemeData.grey1000 : AppThemeData.grey50,
            appBar: UiInterface.customAppBar(context, themeChange, "", backgroundColor: Colors.transparent),
            bottomNavigationBar: Padding(
              padding: paddingEdgeInsets(horizontal: 16, vertical: 8),
              child: RoundShapeButton(
                title: "Add Bank".tr,
                buttonColor: AppThemeData.orange300,
                buttonTextColor: themeChange.isDarkTheme() ? AppThemeData.primaryBlack : AppThemeData.primaryWhite,
                onTap: () async {
                  if (FireStoreUtils.getCurrentUid() != null) {
                    if (controller.formKey.value.currentState!.validate()) {
                      if (controller.editingId.value != "") {
                        controller.updateBankDetail();
                      } else {
                        controller.setBankDetails();
                      }
                    }
                  } else {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return Dialog(
                            child: LoginDialog(),
                          );
                        });
                  }
                },
                size: Size(390.w, ScreenSize.height(6, context)),
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
                        controller: controller.bankHolderNameController.value,
                        hintText: "Enter Bank Holder Name".tr,
                        title: "Bank Holder Name".tr,
                        enable: true,
                        textInputType: TextInputType.text,
                        validator: (value) => value != null && value.isNotEmpty ? null : 'This field required'.tr,
                      ),
                      TextFieldWidget(
                        onPress: () {},
                        controller: controller.bankAccountNumberController.value,
                        hintText: "Enter bank account number".tr,
                        title: "Bank Account Number".tr,
                        enable: true,
                        textInputType: TextInputType.text,
                        validator: (value) => value != null && value.isNotEmpty ? null : 'This field required'.tr,
                      ),
                      TextFieldWidget(
                        onPress: () {},
                        controller: controller.swiftCodeController.value,
                        hintText: "Enter Swift Code".tr,
                        title: "Swift Code".tr,
                        enable: true,
                        textInputType: TextInputType.text,
                        validator: (value) => value != null && value.isNotEmpty ? null : 'This field required'.tr,
                      ),
                      TextFieldWidget(
                        onPress: () {},
                        controller: controller.ifscCodeController.value,
                        hintText: "Enter IFSC Code".tr,
                        title: "IFSC Code".tr,
                        enable: true,
                        textInputType: TextInputType.text,
                        validator: (value) => value != null && value.isNotEmpty ? null : 'This field required'.tr,
                      ),
                      TextFieldWidget(
                        onPress: () {},
                        controller: controller.bankNameController.value,
                        hintText: "Enter Bank Name".tr,
                        title: "Bank Name".tr,
                        enable: true,
                        textInputType: TextInputType.text,
                        validator: (value) => value != null && value.isNotEmpty ? null : 'This field required'.tr,
                      ),
                      TextFieldWidget(
                        onPress: () {},
                        controller: controller.bankBranchCityController.value,
                        hintText: "Enter Bank Branch City".tr,
                        title: "Bank Branch City".tr,
                        enable: true,
                        textInputType: TextInputType.text,
                        validator: (value) => value != null && value.isNotEmpty ? null : 'This field required'.tr,
                      ),
                      TextFieldWidget(
                        onPress: () {},
                        controller: controller.bankBranchCountryController.value,
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
