// ignore_for_file: depend_on_referenced_packages

import 'package:customer/app/models/bank_detail_model.dart';
import 'package:customer/app/modules/add_bank/views/add_bank_view.dart';
import 'package:customer/app/modules/my_banks/controllers/my_banks_controller.dart';
import 'package:customer/app/widget/global_widgets.dart';
import 'package:customer/app/widget/text_widget.dart';
import 'package:customer/constant/constant.dart';
import 'package:customer/constant_widgets/top_widget.dart';
import 'package:customer/themes/app_fonts.dart';
import 'package:customer/themes/app_theme_data.dart';
import 'package:customer/themes/common_ui.dart';
import 'package:customer/utils/dark_theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MyBanksView extends GetView {
  const MyBanksView({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetX<MyBanksController>(
        init: MyBanksController(),
        builder: (controller) {
          return Scaffold(
            appBar: UiInterface.customAppBar(context, themeChange, "", backgroundColor: Colors.transparent),
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
              child: Column(
                children: [
                  buildTopWidget(context, "My Bank".tr, "View and manage your linked bank accounts for withdrawals and transactions.".tr),
                  spaceH(height: 24),
                  Container(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: themeChange.isDarkTheme() ? AppThemeData.surface1000 : AppThemeData.surface50),
                    child: Column(
                      children: [
                        GestureDetector(
                          onTap: () {},
                          child: Row(
                            children: [
                              SvgPicture.asset(
                                "assets/icons/ic_add.svg",
                                height: 24,
                              ),
                              spaceW(width: 12),
                              GestureDetector(
                                onTap: () {
                                  controller.setDefault();
                                  Get.to(const AddBankView());
                                },
                                child: TextCustom(
                                  title: "Add New Bank".tr,
                                  fontSize: 16,
                                  fontFamily: FontFamily.medium,
                                  color: AppThemeData.orange300,
                                ),
                              ),
                            ],
                          ),
                        ),
                        spaceH(height: 16),
                        controller.isLoading.value
                            ? Constant.loader()
                            : controller.bankDetailsList.isEmpty
                                ? const Padding(
                                    padding: EdgeInsets.only(bottom: 16),
                                    child: TextCustom(
                                      title: "No Data Available",
                                    ),
                                  )
                                : ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: controller.bankDetailsList.length,
                                    itemBuilder: (context, index) {
                                      BankDetailsModel bankDetailsModel = controller.bankDetailsList[index];
                                      return Padding(
                                        padding: const EdgeInsets.only(bottom: 16),
                                        child: Row(
                                          children: [
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  TextCustom(
                                                    title: bankDetailsModel.bankName.toString(),
                                                    fontSize: 16,
                                                    fontFamily: FontFamily.medium,
                                                    color: themeChange.isDarkTheme() ? AppThemeData.grey50 : AppThemeData.grey1000,
                                                  ),
                                                  IntrinsicHeight(
                                                    child: Row(
                                                      children: [
                                                        TextCustom(
                                                          title: bankDetailsModel.holderName.toString(),
                                                          fontSize: 14,
                                                          fontFamily: FontFamily.regular,
                                                          color: themeChange.isDarkTheme() ? AppThemeData.grey400 : AppThemeData.grey600,
                                                        ),
                                                        Padding(
                                                          padding: const EdgeInsets.symmetric(horizontal: 8),
                                                          child: VerticalDivider(
                                                            thickness: 1,
                                                            indent: 4,
                                                            endIndent: 4,
                                                            color: themeChange.isDarkTheme() ? AppThemeData.grey700 : AppThemeData.grey300,
                                                          ),
                                                        ),
                                                        TextCustom(
                                                          title: bankDetailsModel.accountNumber.toString(),
                                                          fontSize: 14,
                                                          fontFamily: FontFamily.regular,
                                                          color: themeChange.isDarkTheme() ? AppThemeData.grey400 : AppThemeData.grey600,
                                                        ),
                                                      ],
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                            spaceW(width: 8),
                                            Align(
                                              alignment: Alignment.topRight,
                                              child: PopupMenuButton(
                                                padding: EdgeInsets.zero,
                                                icon: const Icon(Icons.more_vert),
                                                offset: const Offset(-15, 35),
                                                itemBuilder: (BuildContext context) {
                                                  return [
                                                    PopupMenuItem<String>(
                                                      height: 30,
                                                      value: "Edit".tr,
                                                      child: Row(
                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          Text(
                                                            "Edit".tr,
                                                            style: TextStyle(
                                                              fontFamily: FontFamily.regular,
                                                              color: themeChange.isDarkTheme()
                                                                  ? AppThemeData.primaryWhite
                                                                  : AppThemeData.primaryBlack,
                                                              fontSize: 14,
                                                              fontWeight: FontWeight.w400,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    PopupMenuItem<String>(
                                                      height: 30,
                                                      value: "Delete".tr,
                                                      child: Row(
                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          Text(
                                                            "Delete".tr,
                                                            style: TextStyle(
                                                              fontFamily: FontFamily.regular,
                                                              color: themeChange.isDarkTheme()
                                                                  ? AppThemeData.primaryWhite
                                                                  : AppThemeData.primaryBlack,
                                                              fontSize: 14,
                                                              fontWeight: FontWeight.w400,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    )
                                                  ];
                                                },
                                                onSelected: (value) {
                                                  if (value == "Edit") {
                                                    controller.editingId.value = bankDetailsModel.id.toString();
                                                    controller.bankHolderNameController.value.text = bankDetailsModel.holderName.toString();
                                                    controller.bankAccountNumberController.value.text =
                                                        bankDetailsModel.accountNumber.toString();
                                                    controller.swiftCodeController.value.text = bankDetailsModel.swiftCode.toString();
                                                    controller.ifscCodeController.value.text = bankDetailsModel.ifscCode.toString();
                                                    controller.bankNameController.value.text = bankDetailsModel.bankName.toString();
                                                    controller.bankBranchCityController.value.text = bankDetailsModel.branchCity.toString();
                                                    controller.bankBranchCountryController.value.text =
                                                        bankDetailsModel.branchCountry.toString();
                                                    Get.to(const AddBankView());
                                                  } else {
                                                    controller.deleteBankDetails(controller.bankDetailsList[index]);
                                                  }
                                                },

                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    })
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
        });
  }
}
