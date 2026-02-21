// ignore_for_file: unnecessary_null_comparison, use_super_parameters

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';
import 'package:restaurant/app/modules/add_menu_item_screen/controllers/add_menu_item_screen_controller.dart';
import 'package:restaurant/app/widget/global_widgets.dart';
import 'package:restaurant/app/widget/text_widget.dart';
import 'package:restaurant/constant/show_toast_dialogue.dart';
import 'package:restaurant/themes/app_fonts.dart';
import 'package:restaurant/themes/app_theme_data.dart';
import 'package:restaurant/utils/dark_theme_provider.dart';

import '../../../../../constant_widgets/round_shape_button.dart';
import '../../../../../themes/screen_size.dart';

class SelectTagWidget extends GetView<AddMenuItemsScreenController> {
  const SelectTagWidget({Key? key}) : super(key: key);

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
                    title: "Select Tags".tr,
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
                    title: "Select Tags".tr,
                    color: themeChange.isDarkTheme() ? AppThemeData.grey100 : AppThemeData.grey900,
                    fontFamily: FontFamily.medium,
                  ),
                  spaceH(height: 12),
                  Wrap(
                    children: List.generate(
                      controller.tagsList.length,
                      (index) {
                        return GestureDetector(
                          onTap: () {
                            controller.selectedTags.value = controller.tagsList[index];
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 8, right: 8),
                            child: Container(
                              decoration: BoxDecoration(
                                  color: controller.selectedTags.value == controller.tagsList[index]
                                      ? AppThemeData.secondary300
                                      : themeChange.isDarkTheme()
                                          ? AppThemeData.grey800
                                          : AppThemeData.grey200,
                                  borderRadius: BorderRadius.circular(30)),
                              padding: paddingEdgeInsets(horizontal: 24, vertical: 12),
                              child: TextCustom(
                                title: controller.tagsList[index],
                                color: controller.selectedTags.value == controller.tagsList[index]
                                    ? AppThemeData.grey50
                                    : themeChange.isDarkTheme()
                                        ? AppThemeData.grey400
                                        : AppThemeData.grey600,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  )
                ],
              ),
            ),
          ),
          bottomNavigationBar: Padding(
            padding: paddingEdgeInsets(vertical: 8),
            child: RoundShapeButton(
              title: "Save".tr,
              buttonColor: AppThemeData.primary300,
              buttonTextColor: AppThemeData.grey50,
              onTap: () async {
                if (controller.selectedTags != null || controller.selectedTags.isNotEmpty) {
                  controller.saveData();
                } else {
                  ShowToastDialog.toast('Select at least one tag to proceed.'.tr);
                }
              },
              size: Size(358.w, ScreenSize.height(6, context)),
            ),
          ),
        );
      },
    );
  }
}
