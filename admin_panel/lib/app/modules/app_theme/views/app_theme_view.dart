// ignore_for_file: deprecated_member_use

import 'package:admin_panel/app/components/custom_text_form_field.dart';
import 'package:admin_panel/app/components/dialog_box.dart';
import 'package:admin_panel/app/constant/constants.dart';
import 'package:admin_panel/app/modules/app_theme/controllers/app_theme_controller.dart';
import 'package:admin_panel/app/utils/app_colors.dart';
import 'package:admin_panel/app/utils/app_them_data.dart';
import 'package:admin_panel/app/utils/dark_theme_provider.dart';
import 'package:admin_panel/app/utils/responsive.dart';
import 'package:admin_panel/widget/container_custom.dart';
import 'package:admin_panel/widget/global_widgets.dart';
import 'package:admin_panel/widget/text_widget.dart';
import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../../components/custom_button.dart';
import '../../../routes/app_pages.dart';
import '../../../utils/screen_size.dart';

class AppThemeView extends GetView<AppThemeController> {
  const AppThemeView({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetBuilder<AppThemeController>(
      init: AppThemeController(),
      builder: (controller) {
        return SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Obx(
                () => ContainerCustom(
                  child: controller.isLoading.value
                      ? Padding(
                          padding: paddingEdgeInsets(),
                          child: Constant.loader(),
                        )
                      : ResponsiveWidget.isDesktop(context)
                          ? Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        TextCustom(title: controller.title.value.tr, fontSize: 20, fontFamily: FontFamily.bold),
                                        spaceH(height: 2),
                                        Row(children: [
                                          InkWell(
                                              onTap: () => Get.offAllNamed(Routes.DASHBOARD_SCREEN),
                                              child: TextCustom(title: 'Dashboard'.tr, fontSize: 14, fontFamily: FontFamily.medium, color: AppThemeData.lynch500)),
                                          const TextCustom(title: ' / ', fontSize: 14, fontFamily: FontFamily.medium, color: AppThemeData.lynch500),
                                          TextCustom(title: 'Settings'.tr, fontSize: 14, fontFamily: FontFamily.medium, color: AppThemeData.lynch500),
                                          const TextCustom(title: ' / ', fontSize: 14, fontFamily: FontFamily.medium, color: AppThemeData.lynch500),
                                          TextCustom(title: ' ${controller.title.value.tr} ', fontSize: 14, fontFamily: FontFamily.medium, color: AppThemeData.primary500)
                                        ])
                                      ],
                                    ),
                                  ],
                                ),
                                spaceH(height: 20),
                                Padding(
                                  padding: paddingEdgeInsets(vertical: 24, horizontal: 24),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      TextCustom(
                                        title: "App Name".tr.toUpperCase(),
                                        fontFamily: FontFamily.bold,
                                        fontSize: 20,
                                      ),
                                      spaceH(height: 16),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: CustomTextFormField(
                                                title: "App Name".tr,
                                                // width: 0.35.sw,
                                                hintText: "Enter App Name".tr,
                                                inputFormatters: [
                                                  FilteringTextInputFormatter.allow(RegExp('[a-zA-Z ]')),
                                                ],
                                                prefix: const Icon(
                                                  Icons.drive_file_rename_outline_outlined,
                                                  color: AppThemeData.lynch500,
                                                ),
                                                controller: controller.appNameController.value),
                                          ),
                                          spaceH(height: 16),
                                          const Expanded(child: SizedBox())
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 1,
                                  child: ContainerCustom(
                                    color: themeChange.isDarkTheme() ? AppThemeData.lynch900 : AppThemeData.lynch100,
                                  ),
                                ),
                                Padding(
                                  padding: paddingEdgeInsets(horizontal: 24, vertical: 24),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      TextCustom(
                                        title: "App Theme".tr.toUpperCase(),
                                        fontFamily: FontFamily.bold,
                                        fontSize: 20,
                                      ),
                                      spaceH(height: 16),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: CustomTextFormField(
                                                title: "Customer App Color".tr,
                                                // width: 0.35.sw,
                                                hintText: "Select Customer App Color".tr,
                                                maxLine: 1,
                                                prefix: Padding(
                                                  padding: const EdgeInsets.all(8.0),
                                                  child: InkWell(
                                                      onTap: () async {
                                                        Color newColor = await showColorPickerDialog(
                                                          context,
                                                          controller.customerSelectedColor.value,
                                                          width: 40,
                                                          height: 40,
                                                          spacing: 0,
                                                          runSpacing: 0,
                                                          borderRadius: 0,
                                                          enableOpacity: true,
                                                          showColorCode: true,
                                                          colorCodeHasColor: true,
                                                          enableShadesSelection: false,
                                                          pickersEnabled: <ColorPickerType, bool>{
                                                            ColorPickerType.wheel: true,
                                                          },
                                                          copyPasteBehavior: const ColorPickerCopyPasteBehavior(
                                                            copyButton: true,
                                                            pasteButton: false,
                                                            longPressMenu: false,
                                                          ),
                                                          actionButtons: const ColorPickerActionButtons(
                                                            okButton: true,
                                                            closeButton: true,
                                                            dialogActionButtons: false,
                                                          ),
                                                        );
                                                        controller.customerColourCodeController.value.text = "#${newColor.hex}";
                                                        controller.customerSelectedColor.value = newColor;
                                                      },
                                                      child: Obx(
                                                        () => ClipRRect(
                                                            borderRadius: const BorderRadius.all(Radius.circular(5)),
                                                            child: Container(
                                                              height: 12,
                                                              width: 80,
                                                              color: controller.customerSelectedColor.value,
                                                            )),
                                                      )),
                                                ),
                                                controller: controller.customerColourCodeController.value),
                                          ),
                                          spaceW(width: 16),
                                          Expanded(
                                            child: CustomTextFormField(
                                                title: "Restaurant App Color".tr,
                                                // width: 0.35.sw,
                                                hintText: "Select Restaurant App Color".tr,
                                                maxLine: 1,
                                                prefix: Padding(
                                                  padding: const EdgeInsets.all(8.0),
                                                  child: InkWell(
                                                      onTap: () async {
                                                        Color newColor = await showColorPickerDialog(
                                                          context,
                                                          controller.restaurantSelectedColor.value,
                                                          width: 40,
                                                          height: 40,
                                                          spacing: 0,
                                                          runSpacing: 0,
                                                          borderRadius: 0,
                                                          enableOpacity: true,
                                                          showColorCode: true,
                                                          colorCodeHasColor: true,
                                                          enableShadesSelection: false,
                                                          pickersEnabled: <ColorPickerType, bool>{
                                                            ColorPickerType.wheel: true,
                                                          },
                                                          copyPasteBehavior: const ColorPickerCopyPasteBehavior(
                                                            copyButton: true,
                                                            pasteButton: false,
                                                            longPressMenu: false,
                                                          ),
                                                          actionButtons: const ColorPickerActionButtons(
                                                            okButton: true,
                                                            closeButton: true,
                                                            dialogActionButtons: false,
                                                          ),
                                                        );
                                                        controller.restaurantColourCodeController.value.text = "#${newColor.hex}";
                                                        controller.restaurantSelectedColor.value = newColor;
                                                      },
                                                      child: Obx(
                                                        () => ClipRRect(
                                                            borderRadius: const BorderRadius.all(Radius.circular(5)),
                                                            child: Container(
                                                              height: 12,
                                                              width: 80,
                                                              color: controller.restaurantSelectedColor.value,
                                                            )),
                                                      )),
                                                ),
                                                controller: controller.restaurantColourCodeController.value),
                                          ),
                                          // Expanded(
                                          //   child: CustomTextFormField(
                                          //       title: "App Name".tr,
                                          //       // width: 0.35.sw,
                                          //       hintText: "Enter App Name".tr,
                                          //       inputFormatters: [
                                          //         FilteringTextInputFormatter.allow(RegExp('[a-zA-Z ]')),
                                          //       ],
                                          //       prefix: const Icon(Icons.drive_file_rename_outline_outlined),
                                          //       controller: controller.appNameController.value),
                                          // ),
                                        ],
                                      ),
                                      spaceH(height: 16),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: CustomTextFormField(
                                                title: "Driver App Color".tr,
                                                hintText: "Select Driver App Color".tr,
                                                maxLine: 1,
                                                prefix: Padding(
                                                  padding: const EdgeInsets.all(10.0),
                                                  child: InkWell(
                                                      onTap: () async {
                                                        Color newColor = await showColorPickerDialog(
                                                          context,
                                                          controller.driverSelectedColor.value,
                                                          width: 40,
                                                          height: 40,
                                                          spacing: 0,
                                                          runSpacing: 0,
                                                          borderRadius: 0,
                                                          enableOpacity: true,
                                                          showColorCode: true,
                                                          colorCodeHasColor: true,
                                                          enableShadesSelection: false,
                                                          pickersEnabled: <ColorPickerType, bool>{
                                                            ColorPickerType.wheel: true,
                                                          },
                                                          copyPasteBehavior: const ColorPickerCopyPasteBehavior(
                                                            copyButton: true,
                                                            pasteButton: false,
                                                            longPressMenu: false,
                                                          ),
                                                          actionButtons: const ColorPickerActionButtons(
                                                            okButton: true,
                                                            closeButton: true,
                                                            dialogActionButtons: false,
                                                          ),
                                                        );
                                                        controller.driverColourCodeController.value.text = "#${newColor.hex}";
                                                        controller.driverSelectedColor.value = newColor;
                                                      },
                                                      child: Obx(
                                                        () => ClipRRect(
                                                            borderRadius: const BorderRadius.all(Radius.circular(5)),
                                                            child: Container(
                                                              height: 12,
                                                              width: 80,
                                                              color: controller.driverSelectedColor.value,
                                                            )),
                                                      )),
                                                ),
                                                controller: controller.driverColourCodeController.value),
                                          ),
                                          spaceW(width: 16),
                                          const Expanded(
                                            child: SizedBox(),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  width: ScreenSize.width(100, context),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      // Spacer(),
                                      CustomButtonWidget(
                                        padding: const EdgeInsets.symmetric(horizontal: 22),
                                        title: "Save".tr,
                                        onPress: () async {
                                          if (Constant.isDemo) {
                                            DialogBox.demoDialogBox();
                                          } else {
                                            controller.saveSettingData();
                                          }
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            )
                          : Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        TextCustom(title: controller.title.value.tr, fontSize: 20, fontFamily: FontFamily.bold),
                                        spaceH(height: 2),
                                        Row(children: [
                                          InkWell(
                                              onTap: () => Get.offAllNamed(Routes.DASHBOARD_SCREEN),
                                              child: TextCustom(title: 'Dashboard'.tr, fontSize: 14, fontFamily: FontFamily.medium, color: AppThemeData.lynch500)),
                                          const TextCustom(title: ' / ', fontSize: 14, fontFamily: FontFamily.medium, color: AppThemeData.lynch500),
                                          TextCustom(title: 'Settings'.tr, fontSize: 14, fontFamily: FontFamily.medium, color: AppThemeData.lynch500),
                                          const TextCustom(title: ' / ', fontSize: 14, fontFamily: FontFamily.medium, color: AppThemeData.lynch500),
                                          TextCustom(title: ' ${controller.title.value.tr} ', fontSize: 14, fontFamily: FontFamily.medium, color: AppThemeData.primary500)
                                        ])
                                      ],
                                    ),
                                  ],
                                ),
                                spaceH(height: 20),
                                Padding(
                                  padding: paddingEdgeInsets(horizontal: 24, vertical: 24),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      TextCustom(
                                        title: "App Theme".tr.toUpperCase(),
                                        fontFamily: FontFamily.bold,
                                        fontSize: 20,
                                      ),
                                      spaceH(height: 16),
                                      CustomTextFormField(
                                          title: "App Name".tr,
                                          // width: 0.35.sw,
                                          hintText: "Enter App Name".tr,
                                          inputFormatters: [
                                            FilteringTextInputFormatter.allow(RegExp('[a-zA-Z ]')),
                                          ],
                                          prefix: const Icon(
                                            Icons.drive_file_rename_outline_outlined,
                                            color: AppThemeData.lynch500,
                                          ),
                                          controller: controller.appNameController.value),
                                      spaceH(height: 16),
                                      CustomTextFormField(
                                          title: "Customer App Colors".tr,
                                          // width: 0.35.sw,
                                          hintText: "Select Customer App Color".tr,
                                          maxLine: 1,
                                          prefix: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: InkWell(
                                                onTap: () async {
                                                  Color newColor = await showColorPickerDialog(
                                                    context,
                                                    controller.customerSelectedColor.value,
                                                    width: 40,
                                                    height: 40,
                                                    spacing: 0,
                                                    runSpacing: 0,
                                                    borderRadius: 0,
                                                    enableOpacity: true,
                                                    showColorCode: true,
                                                    colorCodeHasColor: true,
                                                    enableShadesSelection: false,
                                                    pickersEnabled: <ColorPickerType, bool>{
                                                      ColorPickerType.wheel: true,
                                                    },
                                                    copyPasteBehavior: const ColorPickerCopyPasteBehavior(
                                                      copyButton: true,
                                                      pasteButton: false,
                                                      longPressMenu: false,
                                                    ),
                                                    actionButtons: const ColorPickerActionButtons(
                                                      okButton: true,
                                                      closeButton: true,
                                                      dialogActionButtons: false,
                                                    ),
                                                  );
                                                  controller.customerColourCodeController.value.text = "#${newColor.hex}";
                                                  controller.customerSelectedColor.value = newColor;
                                                },
                                                child: Obx(
                                                  () => ClipRRect(
                                                      borderRadius: const BorderRadius.all(Radius.circular(5)),
                                                      child: Container(
                                                        height: 12,
                                                        width: 80,
                                                        color: controller.customerSelectedColor.value,
                                                      )),
                                                )),
                                          ),
                                          controller: controller.customerColourCodeController.value),
                                      spaceH(height: 16),
                                      CustomTextFormField(
                                        title: "Restaurant App Color".tr,
                                        // width: 0.35.sw,
                                        hintText: "Select Restaurant App Color".tr,
                                        maxLine: 1,
                                        prefix: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: InkWell(
                                              onTap: () async {
                                                Color newColor = await showColorPickerDialog(
                                                  context,
                                                  controller.restaurantSelectedColor.value,
                                                  width: 40,
                                                  height: 40,
                                                  spacing: 0,
                                                  runSpacing: 0,
                                                  borderRadius: 0,
                                                  enableOpacity: true,
                                                  showColorCode: true,
                                                  colorCodeHasColor: true,
                                                  enableShadesSelection: false,
                                                  pickersEnabled: <ColorPickerType, bool>{
                                                    ColorPickerType.wheel: true,
                                                  },
                                                  copyPasteBehavior: const ColorPickerCopyPasteBehavior(
                                                    copyButton: true,
                                                    pasteButton: false,
                                                    longPressMenu: false,
                                                  ),
                                                  actionButtons: const ColorPickerActionButtons(
                                                    okButton: true,
                                                    closeButton: true,
                                                    dialogActionButtons: false,
                                                  ),
                                                );
                                                controller.restaurantColourCodeController.value.text = "#${newColor.hex}";
                                                controller.restaurantSelectedColor.value = newColor;
                                              },
                                              child: Obx(
                                                () => ClipRRect(
                                                    borderRadius: const BorderRadius.all(Radius.circular(5)),
                                                    child: Container(
                                                      height: 12,
                                                      width: 80,
                                                      color: controller.restaurantSelectedColor.value,
                                                    )),
                                              )),
                                        ),
                                        controller: controller.restaurantColourCodeController.value,
                                      ),
                                      spaceH(height: 16),
                                      CustomTextFormField(
                                          title: "Driver App Color".tr,
                                          // width: 0.35.sw,
                                          hintText: "Select Driver App Color".tr,
                                          maxLine: 1,
                                          prefix: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: InkWell(
                                                onTap: () async {
                                                  Color newColor = await showColorPickerDialog(
                                                    context,
                                                    controller.driverSelectedColor.value,
                                                    width: 40,
                                                    height: 40,
                                                    spacing: 0,
                                                    runSpacing: 0,
                                                    borderRadius: 0,
                                                    enableOpacity: true,
                                                    showColorCode: true,
                                                    colorCodeHasColor: true,
                                                    enableShadesSelection: false,
                                                    pickersEnabled: <ColorPickerType, bool>{
                                                      ColorPickerType.wheel: true,
                                                    },
                                                    copyPasteBehavior: const ColorPickerCopyPasteBehavior(
                                                      copyButton: true,
                                                      pasteButton: false,
                                                      longPressMenu: false,
                                                    ),
                                                    actionButtons: const ColorPickerActionButtons(
                                                      okButton: true,
                                                      closeButton: true,
                                                      dialogActionButtons: false,
                                                    ),
                                                  );
                                                  controller.driverColourCodeController.value.text = "#${newColor.hex}";
                                                  controller.driverSelectedColor.value = newColor;
                                                },
                                                child: Obx(
                                                  () => ClipRRect(
                                                      borderRadius: const BorderRadius.all(Radius.circular(5)),
                                                      child: Container(
                                                        height: 12,
                                                        width: 80,
                                                        color: controller.driverSelectedColor.value,
                                                      )),
                                                )),
                                          ),
                                          controller: controller.driverColourCodeController.value),
                                    ],
                                  ),
                                ),
                                spaceH(height: 20),
                                SizedBox(
                                  width: ScreenSize.width(100, context),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      // Spacer(),
                                      CustomButtonWidget(
                                        padding: const EdgeInsets.symmetric(horizontal: 22),
                                        title: "Save".tr,
                                        onPress: () async {
                                          if (Constant.isDemo) {
                                            DialogBox.demoDialogBox();
                                          } else {
                                            controller.saveSettingData();
                                          }
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
