// ignore_for_file: deprecated_member_use

import 'package:admin_panel/app/components/custom_button.dart';
import 'package:admin_panel/app/components/custom_text_form_field.dart';
import 'package:admin_panel/app/components/dialog_box.dart';
import 'package:admin_panel/app/constant/constants.dart';
import 'package:admin_panel/app/constant/show_toast.dart';
import 'package:admin_panel/app/modules/tax/controllers/tax_controller.dart';
import 'package:admin_panel/app/routes/app_pages.dart';
import 'package:admin_panel/app/utils/app_colors.dart';
import 'package:admin_panel/app/utils/app_them_data.dart';
import 'package:admin_panel/app/utils/country_list.dart';
import 'package:admin_panel/app/utils/dark_theme_provider.dart';
import 'package:admin_panel/app/utils/fire_store_utils.dart';
import 'package:admin_panel/app/utils/responsive.dart';
import 'package:admin_panel/widget/common_ui.dart';
import 'package:admin_panel/widget/container_custom.dart';
import 'package:admin_panel/widget/global_widgets.dart';
import 'package:admin_panel/widget/text_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class TaxView extends GetView {
  const TaxView({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetBuilder<TaxController>(
      init: TaxController(),
      builder: (controller) {
        return Obx(
          () => SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ContainerCustom(
                    child: Column(children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          ResponsiveWidget.isDesktop(context)
                              ? Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    TextCustom(title: controller.title.value, fontSize: 20, fontFamily: FontFamily.bold),
                                    spaceH(height: 2),
                                    Row(children: [
                                      InkWell(
                                          onTap: () => Get.offAllNamed(Routes.DASHBOARD_SCREEN),
                                          child: TextCustom(
                                              title: 'Dashboard'.tr,
                                              fontSize: 14,
                                              fontFamily: FontFamily.medium,
                                              color: AppThemeData.lynch500)),
                                      const TextCustom(
                                          title: ' / ', fontSize: 14, fontFamily: FontFamily.medium, color: AppThemeData.lynch500),
                                      TextCustom(
                                          title: 'Settings'.tr, fontSize: 14, fontFamily: FontFamily.medium, color: AppThemeData.lynch500),
                                      const TextCustom(
                                          title: ' / ', fontSize: 14, fontFamily: FontFamily.medium, color: AppThemeData.lynch500),
                                      TextCustom(
                                          title: ' ${controller.title.value} ',
                                          fontSize: 14,
                                          fontFamily: FontFamily.medium,
                                          color: AppThemeData.primary500)
                                    ])
                                  ],
                                )
                              : TextCustom(
                                  title: ' ${controller.title.value} ',
                                  fontSize: 14,
                                  fontFamily: FontFamily.medium,
                                  color: AppThemeData.primaryBlack),
                          CustomButtonWidget(
                            padding: const EdgeInsets.symmetric(horizontal: 22),
                            title: "+ Add Tax".tr,
                            onPress: () {
                              controller.setDefaultData();
                              showDialog(context: context, builder: (context) => const TaxDialog());
                            },
                          ),
                        ],
                      ),
                      spaceH(height: 20),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: controller.taxList.isEmpty
                              ? Padding(
                            padding: paddingEdgeInsets(),
                            child: Constant.loader(),
                          )
                              : DataTable(
                              horizontalMargin: 20,
                              columnSpacing: 30,
                              dataRowMaxHeight: 65,
                              headingRowHeight: 65,
                              border: TableBorder.all(
                                color: themeChange.isDarkTheme() ? AppThemeData.lynch900 : AppThemeData.lynch100,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              headingRowColor: WidgetStateColor.resolveWith((states) => themeChange.isDarkTheme() ? AppThemeData.lynch900 : AppThemeData.lynch100),
                              columns: [
                                CommonUI.dataColumnWidget(context, columnTitle: "Id".tr, width: ResponsiveWidget.isMobile(context) ? 10 : MediaQuery.of(context).size.width * 0.01),
                                CommonUI.dataColumnWidget(context,
                                    columnTitle: "Name".tr, width: ResponsiveWidget.isMobile(context) ? 120 : MediaQuery.of(context).size.width * 0.12),
                                CommonUI.dataColumnWidget(context,
                                    columnTitle: "Tax Amount".tr, width: ResponsiveWidget.isMobile(context) ? 100 : MediaQuery.of(context).size.width * 0.10),
                                CommonUI.dataColumnWidget(context,
                                    columnTitle: "Country".tr, width: ResponsiveWidget.isMobile(context) ? 80 : MediaQuery.of(context).size.width * 0.08),
                                CommonUI.dataColumnWidget(context,
                                    columnTitle: "Type".tr, width: ResponsiveWidget.isMobile(context) ? 60 : MediaQuery.of(context).size.width * 0.06),
                                CommonUI.dataColumnWidget(context,
                                    columnTitle: "Status".tr, width: ResponsiveWidget.isMobile(context) ? 50 : MediaQuery.of(context).size.width * 0.05),
                                CommonUI.dataColumnWidget(context,
                                    columnTitle: "Actions".tr, width: ResponsiveWidget.isMobile(context) ? 70 : MediaQuery.of(context).size.width * 0.07),
                              ],
                              rows: controller.taxList
                                  .map((taxModel) => DataRow(cells: [
                                DataCell(TextCustom(title: "${controller.taxList.indexWhere((element) => element == taxModel) + 1}")),
                                DataCell(TextCustom(title: "${taxModel.name}")),
                                DataCell(
                                  TextCustom(
                                    title: Constant.amountShow(amount: taxModel.value.toString()),
                                  ),
                                ),
                                DataCell(TextCustom(title: "${taxModel.country}")),
                                DataCell(TextCustom(title: taxModel.isFix! ? "Fix" : "Percentage")),
                                DataCell(
                                  Transform.scale(
                                    scale: 0.8,
                                    child: CupertinoSwitch(
                                      activeColor: AppThemeData.primary500,
                                      value: taxModel.active!,
                                      onChanged: (value) async {
                                        if (Constant.isDemo) {
                                          DialogBox.demoDialogBox();
                                        } else {
                                          taxModel.active = value;
                                          await FireStoreUtils.updateTax(taxModel);
                                          controller.getData();
                                        }
                                      },
                                    ),
                                  ),
                                ),
                                DataCell(
                                  Container(
                                    alignment: Alignment.center,
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            controller.isEditing.value = true;
                                            controller.taxModel.value.id = taxModel.id;
                                            controller.isActive.value = taxModel.active!;
                                            controller.selectedCountry.value = taxModel.country!;
                                            controller.selectedTaxType.value = taxModel.isFix == true ? "Fix" : "Percentage";
                                            controller.taxNameController.value.text = taxModel.name!;
                                            controller.taxAmountController.value.text = taxModel.value!;
                                            showDialog(context: context, builder: (context) => const TaxDialog());
                                          },
                                          child: SvgPicture.asset(
                                            "assets/icons/ic_edit.svg",
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
                                              bool confirmDelete = await DialogBox.showConfirmationDeleteDialog(context);
                                              if (confirmDelete) {
                                                await controller.removeTax(taxModel);
                                                controller.getData();
                                              }
                                            }
                                          },
                                          child: SvgPicture.asset(
                                            "assets/icons/ic_delete.svg",
                                            color: AppThemeData.lynch400,
                                            height: 16,
                                            width: 16,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ]))
                                  .toList()),
                        ),
                      ),
                      spaceH(),
                    ]),
                  )
                ]),
          ),
        );
      },
    );
  }
}

class TaxDialog extends StatelessWidget {
  const TaxDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetX<TaxController>(
        init: TaxController(),
        builder: (controller) {
          return CustomDialog(
            title: controller.title.value,
            widgetList: [
              Row(
                children: [
                  Expanded(child: CustomTextFormField(hintText: 'Enter Tax Name'.tr, controller: controller.taxNameController.value, title: 'Tax Name *'.tr)),
                  spaceW(width: 24),
                  Expanded(child: CustomTextFormField(hintText: 'Enter Tax Amount'.tr, controller: controller.taxAmountController.value, title: 'Tax Amount *'.tr)),
                ],
              ),
              spaceH(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextCustom(
                          title: 'Tax Type *'.tr,
                          fontSize: 12,
                        ),
                        spaceH(height: 10),
                        Obx(
                              () => DropdownButtonFormField(
                            isExpanded: true,
                            style: TextStyle(
                              fontFamily: FontFamily.medium,
                              color: themeChange.isDarkTheme() ? AppThemeData.primaryWhite : AppThemeData.textBlack,
                            ),
                            hint: TextCustom(title: 'Select Tax Type'.tr),
                            onChanged: (String? taxType) {
                              controller.selectedTaxType.value = taxType ?? "Fix";
                            },
                            value: controller.selectedTaxType.value,
                            items: controller.taxType.map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem(
                                value: value,
                                child: Text(
                                  value,
                                  style: TextStyle(
                                    fontFamily: FontFamily.regular,
                                    fontSize: 16,
                                    color: themeChange.isDarkTheme() ? AppThemeData.lynch200 : AppThemeData.lynch800,
                                  ),
                                ),
                              );
                            }).toList(),
                            decoration: Constant.DefaultInputDecoration(context),
                          ),
                        ),
                      ],
                    ),
                  ),
                  spaceW(width: 24),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextCustom(
                          title: 'Country *'.tr,
                          fontSize: 12,
                        ),
                        spaceH(height: 10),
                        Obx(
                              () => DropdownButtonFormField(
                            isExpanded: true,
                            style: TextStyle(
                              fontFamily: FontFamily.medium,
                              color: themeChange.isDarkTheme() ? AppThemeData.primaryWhite : AppThemeData.textBlack,
                            ),
                            hint: TextCustom(title: 'Select Tax Country'.tr),
                            onChanged: (String? taxType) {
                              controller.selectedCountry.value = taxType ?? "India";
                            },
                            value: controller.selectedCountry.value,
                            items: countryList.map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem(
                                value: value,
                                child: Text(
                                  value,
                                  style: TextStyle(
                                    fontFamily: FontFamily.regular,
                                    fontSize: 16,
                                   color: themeChange.isDarkTheme() ? AppThemeData.lynch200 : AppThemeData.lynch800
                                  ),
                                ),
                              );
                            }).toList(),
                            decoration: Constant.DefaultInputDecoration(context),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              spaceH(height: 26),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextCustom(
                        title: 'Status'.tr,
                        fontSize: 12,
                      ),
                      spaceH(height: 6),
                      Obx(
                            () => Transform.scale(
                          scale: 0.8,
                          child: CupertinoSwitch(
                            activeColor: AppThemeData.primary500,
                            value: controller.isActive.value,
                            onChanged: (value) {
                              controller.isActive.value = value;
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
            bottomWidgetList: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  CustomButtonWidget(
                    title: "Close".tr,
                    buttonColor: themeChange.isDarkTheme() ? AppThemeData.lynch700 : AppThemeData.lynch400,
                    onPress: () {
                      controller.setDefaultData();

                      Navigator.pop(context);
                    },
                  ),
                  spaceW(),
                  CustomButtonWidget(
                    title: "Save".tr,
                    onPress: () {
                      if (Constant.isDemo) {
                        DialogBox.demoDialogBox();
                      } else {
                        if (controller.taxNameController.value.text != "" && controller.taxAmountController.value.text != "") {
                          controller.isEditing.value ? controller.updateTax() : controller.addTax();
                          controller.setDefaultData();
                          Navigator.pop(context);
                        } else {
                          ShowToastDialog.errorToast("All fields are required.".tr);
                        }
                      }
                    },
                  ),
                ],
              ),
            ],
            controller: controller,
          );
        });
  }
}
