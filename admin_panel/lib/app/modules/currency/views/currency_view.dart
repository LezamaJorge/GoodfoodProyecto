// ignore_for_file: deprecated_member_use

import 'package:admin_panel/app/components/custom_button.dart';
import 'package:admin_panel/app/components/custom_text_form_field.dart';
import 'package:admin_panel/app/components/dialog_box.dart';
import 'package:admin_panel/app/constant/constants.dart';
import 'package:admin_panel/app/constant/show_toast.dart';
import 'package:admin_panel/app/utils/app_colors.dart';
import 'package:admin_panel/app/utils/app_them_data.dart';
import 'package:admin_panel/app/utils/dark_theme_provider.dart';
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

import '../../../routes/app_pages.dart';
import '../../../utils/fire_store_utils.dart';
import '../controllers/currency_controller.dart';

class CurrencyView extends GetView<CurrencyController> {
  const CurrencyView({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetBuilder<CurrencyController>(
      init: CurrencyController(),
      builder: (controller) {
        return Obx(
          () => SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(mainAxisSize: MainAxisSize.min, mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.start, children: [
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
                                      child: TextCustom(title: 'Dashboard'.tr, fontSize: 14, fontFamily: FontFamily.medium, color: AppThemeData.lynch500)),
                                  const TextCustom(title: ' / ', fontSize: 14, fontFamily: FontFamily.medium, color: AppThemeData.lynch500),
                                  TextCustom(title: 'Settings'.tr, fontSize: 14, fontFamily: FontFamily.medium, color: AppThemeData.lynch500),
                                  const TextCustom(title: ' / ', fontSize: 14, fontFamily: FontFamily.medium, color: AppThemeData.lynch500),
                                  TextCustom(title: ' ${controller.title.value} ', fontSize: 14, fontFamily: FontFamily.medium, color: AppThemeData.primary500)
                                ])
                              ],
                            )
                          : TextCustom(title: ' ${controller.title.value} ', fontSize: 14, fontFamily: FontFamily.medium, color: AppThemeData.primaryBlack),
                      CustomButtonWidget(
                        padding: const EdgeInsets.symmetric(horizontal: 22),
                        title: " + Add Currency".tr,
                        onPress: () {
                          showDialog(context: context, builder: (context) => const CurrencyDialog());
                        },
                      ),
                    ],
                  ),
                  spaceH(height: 20),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: controller.currencyList.isEmpty
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
                            headingRowColor:
                                WidgetStateColor.resolveWith((states) => themeChange.isDarkTheme() ? AppThemeData.lynch900 : AppThemeData.lynch100),
                            columns: [
                              CommonUI.dataColumnWidget(context,
                                  columnTitle: "Id".tr, width: ResponsiveWidget.isMobile(context) ? 15 : MediaQuery.of(context).size.width * 0.18),
                              CommonUI.dataColumnWidget(context,
                                  columnTitle: "Name".tr, width: ResponsiveWidget.isMobile(context) ? 120 : MediaQuery.of(context).size.width * 0.22),
                              CommonUI.dataColumnWidget(context,
                                  columnTitle: "Symbol".tr, width: ResponsiveWidget.isMobile(context) ? 100 : MediaQuery.of(context).size.width * 0.22),
                              CommonUI.dataColumnWidget(context,
                                  columnTitle: "Symbol Side".tr, width: ResponsiveWidget.isMobile(context) ? 80 : MediaQuery.of(context).size.width * 0.22),
                              CommonUI.dataColumnWidget(context,
                                  columnTitle: "Status".tr, width: ResponsiveWidget.isMobile(context) ? 50 : MediaQuery.of(context).size.width * 0.20),
                              CommonUI.dataColumnWidget(context,
                                  columnTitle: "Actions".tr, width: ResponsiveWidget.isMobile(context) ? 70 : MediaQuery.of(context).size.width * 0.18),
                            ],
                            rows: controller.currencyList
                                .map((currencyModel) => DataRow(cells: [
                                      DataCell(TextCustom(title: "${controller.currencyList.indexWhere((element) => element == currencyModel) + 1}")),
                                      DataCell(TextCustom(title: "${currencyModel.name}")),
                                      DataCell(TextCustom(title: "${currencyModel.symbol}")),
                                      DataCell(TextCustom(title: currencyModel.symbolAtRight == true ? 'Right' : 'Left')),
                                      DataCell(Transform.scale(
                                        scale: 0.8,
                                        child: CupertinoSwitch(
                                          activeTrackColor: AppThemeData.primary500,
                                          value: currencyModel.active!,
                                          onChanged: (value) async {
                                            if (Constant.isDemo) {
                                              DialogBox.demoDialogBox();
                                            } else {
                                              if (value) {
                                                await controller.disableAllCurrencies();
                                                currencyModel.active = true;
                                                await FireStoreUtils.updateCurrency(currencyModel);

                                              } else {
                                                bool otherActiveCurrencies = controller.currencyList.any((currency) => currency.active!);

                                                if (otherActiveCurrencies) {
                                                  currencyModel.active = false;
                                                  await FireStoreUtils.updateCurrency(currencyModel);

                                                } else {
                                                  ShowToastDialog.errorToast(" At least one active currency must be available.".tr);
                                                  return;
                                                }
                                              }
                                              controller.getData();
                                              // currencyModel.active = value;
                                              // await FireStoreUtils.updateCurrency(currencyModel);
                                              // controller.getData();
                                            }
                                          },
                                        ),
                                      )),
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
                                                  controller.currencyModel.value.id = currencyModel.id;
                                                  controller.currencyModel.value.createdAt = currencyModel.createdAt;
                                                  controller.isActive.value = currencyModel.active!;
                                                  controller.nameController.value.text = currencyModel.name!;
                                                  controller.codeController.value.text = currencyModel.code!;
                                                  controller.symbolController.value.text = currencyModel.symbol!;
                                                  controller.decimalDigitsController.value.text = currencyModel.decimalDigits!.toString();
                                                  controller.symbolAt.value = currencyModel.symbolAtRight == true ? SymbolAt.symbolAtRight : SymbolAt.symbolAtLeft;
                                                  showDialog(context: context, builder: (context) => const CurrencyDialog());
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
                                                    // controller.removeCurrency(currencyModel);
                                                    // controller.getData();
                                                    bool confirmDelete = await DialogBox.showConfirmationDeleteDialog(context);
                                                    if (confirmDelete) {
                                                      await controller.removeCurrency(currencyModel);
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

class CurrencyDialog extends StatelessWidget {
  const CurrencyDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);

    return GetX<CurrencyController>(
      init: CurrencyController(),
      builder: (controller) {
        return CustomDialog(
          title: controller.title.value,
          widgetList: [
            Row(
              children: [
                Expanded(child: CustomTextFormField(hintText: 'Enter Currency Name'.tr, controller: controller.nameController.value, title: 'Currency Name *'.tr)),
                spaceW(width: 24),
                Expanded(
                    child: CustomTextFormField(hintText: 'Enter decimal point'.tr, controller: controller.decimalDigitsController.value, title: 'Decimal Point *'.tr)),
              ],
            ),
            spaceH(),
            Row(
              children: [
                Expanded(child: CustomTextFormField(hintText: 'Enter Currency symbol'.tr, controller: controller.symbolController.value, title: 'Currency Symbol *'.tr)),
                spaceW(width: 24),
                Expanded(child: CustomTextFormField(hintText: 'Enter Code'.tr, controller: controller.codeController.value, title: 'Code *'.tr)),
              ],
            ),
            spaceH(),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextCustom(
                        title: 'Status'.tr,
                        fontSize: 12,
                      ),
                      spaceH(),
                      Obx(
                        () => Transform.scale(
                          scale: 0.8,
                          child: CupertinoSwitch(
                            activeTrackColor: AppThemeData.primary500,
                            value: controller.isActive.value,
                            onChanged: (value) {
                              controller.isActive.value = value;
                            },
                          ),
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
                        title: 'Symbol At'.tr,
                        fontSize: 12,
                      ),
                      spaceH(),
                      FittedBox(
                        child: Row(
                          children: [
                            Row(
                              children: [
                                Radio(
                                  value: SymbolAt.symbolAtLeft.obs,
                                  groupValue: controller.symbolAt.value,
                                  onChanged: (value) {
                                    controller.symbolAt.value = SymbolAt.symbolAtLeft;
                                  },
                                  activeColor: AppThemeData.primary500,
                                ),
                                Text("Left".tr,
                                    style: const TextStyle(
                                      fontFamily: FontFamily.regular,
                                      fontSize: 14,
                                      color: AppThemeData.textGrey,
                                    ))
                              ],
                            ),
                            Row(
                              children: [
                                Radio(
                                  value: SymbolAt.symbolAtRight.obs,
                                  groupValue: controller.symbolAt.value,
                                  onChanged: (value) {
                                    controller.symbolAt.value = SymbolAt.symbolAtRight;
                                  },
                                  activeColor: AppThemeData.primary500,
                                ),
                                Text("Right".tr,
                                    style: const TextStyle(
                                      fontFamily: FontFamily.regular,
                                      fontSize: 14,
                                      color: AppThemeData.textGrey,
                                    ))
                              ],
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
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
                      if (controller.nameController.value.text != "" &&
                          controller.decimalDigitsController.value.text != "" &&
                          controller.symbolController.value.text != "" &&
                          controller.codeController.value.text != "") {
                        controller.isEditing.value ? controller.updateCurrency() : controller.addCurrency();
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
      },
    );
  }
}

enum SymbolAt { symbolAtRight, symbolAtLeft }
