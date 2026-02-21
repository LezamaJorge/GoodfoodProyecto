// ignore_for_file: deprecated_member_use, must_be_immutable, depend_on_referenced_packages, use_build_context_synchronously, invalid_use_of_protected_member, use_super_parameters

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';
import 'package:restaurant/app/models/variation_model.dart';
import 'package:restaurant/app/modules/add_menu_item_screen/controllers/add_menu_item_screen_controller.dart';
import 'package:restaurant/app/widget/global_widgets.dart';
import 'package:restaurant/app/widget/text_field_widget.dart';
import 'package:restaurant/app/widget/text_widget.dart';
import 'package:restaurant/constant/constant.dart';
import 'package:restaurant/constant/show_toast_dialogue.dart';
import 'package:restaurant/themes/app_fonts.dart';
import 'package:restaurant/themes/app_theme_data.dart';
import 'package:restaurant/utils/dark_theme_provider.dart';

import '../../../../../constant_widgets/round_shape_button.dart';
import '../../../../../themes/screen_size.dart';

class VariationDetailWidget extends GetView<AddMenuItemsScreenController> {
  const VariationDetailWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetX<AddMenuItemsScreenController>(
      init: AddMenuItemsScreenController(),
      builder: (controller) {
        return Scaffold(
          body: SingleChildScrollView(
            child: Padding(
              padding: paddingEdgeInsets(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextCustom(
                    title: "Add Variations Details".tr,
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
                    fontFamily: FontFamily.medium,
                    textAlign: TextAlign.start,
                  ),
                  spaceH(height: 32),
                  if (controller.variationList.isNotEmpty) ...{
                    ListView.builder(
                      shrinkWrap: true,
                      itemCount: controller.variationList.length,
                      itemBuilder: (context, index) {
                        return Container(
                          padding: paddingEdgeInsets(),
                          margin: const EdgeInsets.only(bottom: 16),
                          decoration: BoxDecoration(color: themeChange.isDarkTheme() ? AppThemeData.surface1000 : AppThemeData.surface50, borderRadius: BorderRadius.circular(10)),
                          child: Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    TextCustom(
                                      title: controller.variationList[index].name.toString(),
                                      fontSize: 16,
                                      fontFamily: FontFamily.medium,
                                      color: themeChange.isDarkTheme() ? AppThemeData.grey100 : AppThemeData.grey1000,
                                    ),
                                    Spacer(),
                                    GestureDetector(
                                      onTap: () {
                                        controller.variationNameController.value.text = controller.variationList[index].name.toString();
                                        controller.variationInStock.value = controller.variationList[index].inStock!;
                                        controller.setOptionControllersFromList(controller.variationList[index].optionList!);
                                        controller.variationList.remove(controller.variationList[index]);
                                      },
                                      child: Container(
                                        height: 38.h,
                                        width: 38.w,
                                        padding: paddingEdgeInsets(horizontal: 10, vertical: 10),
                                        decoration: BoxDecoration(color: themeChange.isDarkTheme() ? AppThemeData.secondary600 : AppThemeData.secondary50, shape: BoxShape.circle),
                                        child: SvgPicture.asset(
                                          "assets/icons/ic_edit_2.svg",
                                          color: AppThemeData.secondary300,
                                        ),
                                      ),
                                    ),
                                    spaceW(),
                                    GestureDetector(
                                      onTap: () {
                                        controller.variationList.remove(controller.variationList[index]);
                                      },
                                      child: Container(
                                        height: 38.h,
                                        width: 38.w,
                                        padding: paddingEdgeInsets(horizontal: 10, vertical: 10),
                                        decoration: BoxDecoration(color: themeChange.isDarkTheme() ? AppThemeData.danger600 : AppThemeData.danger50, shape: BoxShape.circle),
                                        child: SvgPicture.asset(
                                          "assets/icons/ic_delete.svg",
                                          color: AppThemeData.danger300,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                ListView.builder(
                                  padding: EdgeInsets.zero,
                                  physics: const NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: controller.variationList[index].optionList!.length,
                                  itemBuilder: (context, i) {
                                    return rowTextWidget(name: controller.variationList[index].optionList![i].name.toString(), value: controller.variationList[index].optionList![i].price.toString());
                                  },
                                ),
                                spaceH(),
                                Row(
                                  children: [
                                    TextCustom(
                                      title: "In Stock".tr,
                                      fontSize: 16,
                                      color: themeChange.isDarkTheme() ? AppThemeData.grey300 : AppThemeData.grey700,
                                    ),
                                    spaceW(),
                                    Obx(
                                      () => SizedBox(
                                        height: 26.h,
                                        child: FittedBox(
                                          child: CupertinoSwitch(
                                            activeColor: AppThemeData.primary300,
                                            value: controller.variationList[index].inStock!,
                                            onChanged: (value) {},
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        );
                      },
                    )
                  },
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextCustom(
                        title: "Variation Details".tr,
                        color: themeChange.isDarkTheme() ? AppThemeData.grey100 : AppThemeData.grey900,
                        fontFamily: FontFamily.medium,
                      ),
                      GestureDetector(
                        onTap: () async {
                          if (controller.variationNameController.value.text.isEmpty) {
                            ShowToastDialog.toast("Variation name is required");
                            return;
                          }
                          if (controller.optionNameController.isEmpty ||
                              controller.optionPriceController.isEmpty ||
                              controller.optionNameController.first.text.isEmpty ||
                              controller.optionPriceController.first.text.isEmpty) {
                            ShowToastDialog.toast("At least one option is required");
                            return;
                          }
                          controller.variationList.value.add(
                              VariationModel(inStock: controller.variationInStock.value, name: controller.variationNameController.value.text, optionList: controller.setOptionListFromController()));
                          controller.update();

                          controller.variationNameController.value.clear();
                          controller.optionPriceController.value = [];
                          controller.optionNameController.value = [];
                          controller.variationInStock.value = true;
                          controller.addOptionController();
                        },
                        child: Row(
                          children: [
                            Icon(
                              Icons.add,
                              color: AppThemeData.primary300,
                            ),
                            spaceW(),
                            TextCustom(
                              title: "Add Variation".tr,
                              color: AppThemeData.primary300,
                              fontSize: 16,
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                  spaceH(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextCustom(
                        title: "In Stock".tr,
                        color: themeChange.isDarkTheme() ? AppThemeData.grey300 : AppThemeData.grey700,
                        fontSize: 16,
                      ),
                      Obx(
                        () => SizedBox(
                          height: 26.h,
                          child: FittedBox(
                            child: CupertinoSwitch(
                              activeColor: AppThemeData.primary300,
                              value: controller.variationInStock.value,
                              onChanged: (value) {
                                controller.variationInStock.value = value;
                              },
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  TextFieldWidget(
                    color: themeChange.isDarkTheme() ? AppThemeData.grey900 : AppThemeData.grey100,
                    title: "Name".tr,
                    hintText: "Enter Name".tr,
                    controller: controller.variationNameController.value,
                    onPress: () {},
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: controller.optionNameController.length,
                    itemBuilder: (context, index) {
                      return Row(
                        children: [
                          TextFieldWidget(
                            color: themeChange.isDarkTheme() ? AppThemeData.grey900 : AppThemeData.grey100,
                            title: "Option Name".tr,
                            hintText: "Enter Option Name".tr,
                            controller: controller.optionNameController[index],
                            onPress: () {},
                          ).expand(flex: 3),
                          spaceW(width: 20),
                          TextFieldWidget(
                            color: themeChange.isDarkTheme() ? AppThemeData.grey900 : AppThemeData.grey100,
                            title: "Price".tr,
                            hintText: "Enter Price".tr,
                            textInputType: TextInputType.number,
                            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                            controller: controller.optionPriceController[index],
                            onPress: () {},
                          ).expand(flex: 2),
                          spaceW(width: 8),
                          index > 0
                              ? GestureDetector(
                                  onTap: () {
                                    controller.removeOptionController();
                                  },
                                  child: Container(
                                    height: 20.h,
                                    width: 20.w,
                                    padding: paddingEdgeInsets(horizontal: 2, vertical: 2),
                                    decoration: BoxDecoration(color: themeChange.isDarkTheme() ? AppThemeData.danger600 : AppThemeData.danger50, shape: BoxShape.circle),
                                    child: SvgPicture.asset(
                                      "assets/icons/ic_delete.svg",
                                      color: AppThemeData.danger300,
                                    ),
                                  ),
                                )
                              : SizedBox(
                                  height: 20.h,
                                  width: 20.w,
                                ),
                        ],
                      );
                    },
                  ),
                  spaceH(),
                  GestureDetector(
                    onTap: () {
                      controller.addOptionController();
                    },
                    child: Row(
                      children: [
                        Icon(
                          Icons.add,
                          color: AppThemeData.primary300,
                        ),
                        spaceW(),
                        TextCustom(
                          title: "Add Another Option".tr,
                          color: AppThemeData.primary300,
                          fontSize: 16,
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          bottomNavigationBar: Padding(
            padding: paddingEdgeInsets(vertical: 8),
            child: RoundShapeButton(
              title: "Next".tr,
              buttonColor: AppThemeData.primary300,
              buttonTextColor: AppThemeData.grey50,
              onTap: () async {
                if (controller.variationNameController.value.text.isNotEmpty) {
                  bool hasValidOption = false;
                  for (int i = 0; i < controller.optionNameController.length; i++) {
                    if (controller.optionNameController[i].text.isNotEmpty && controller.optionPriceController[i].text.isNotEmpty) {
                      hasValidOption = true;
                      break;
                    }
                  }

                  if (!hasValidOption) {
                    ShowToastDialog.toast("Please add at least one option");
                    return;
                  }

                  controller.variationList
                      .add(VariationModel(inStock: controller.variationInStock.value, name: controller.variationNameController.value.text, optionList: controller.setOptionListFromController()));
                  controller.update();
                }
                controller.nextStep();
              },
              size: Size(358.w, ScreenSize.height(6, context)),
            ),
          ),
        );
      },
    );
  }
}

Padding rowTextWidget({required String name, required String value}) {
  final themeChange = Provider.of<DarkThemeProvider>(Get.context!);
  return Padding(
    padding: const EdgeInsets.only(top: 10),
    child: Row(
      children: [
        TextCustom(
          title: name.tr,
          fontSize: 16,
          fontFamily: FontFamily.regular,
          color: themeChange.isDarkTheme() ? AppThemeData.grey50 : AppThemeData.grey1000,
        ),
        const Spacer(),
        TextCustom(
          title: Constant.amountShow(amount: value),
          fontSize: 16,
          fontFamily: FontFamily.regular,
          color: themeChange.isDarkTheme() ? AppThemeData.grey50 : AppThemeData.grey1000,
        ),
      ],
    ),
  );
}
