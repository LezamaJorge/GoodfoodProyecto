// ignore_for_file: deprecated_member_use, must_be_immutable, depend_on_referenced_packages, use_build_context_synchronously, use_super_parameters

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:restaurant/app/modules/add_menu_item_screen/controllers/add_menu_item_screen_controller.dart';
import 'package:restaurant/app/modules/add_menu_item_screen/views/widget/addons_detail_widget.dart';
import 'package:restaurant/app/modules/add_menu_item_screen/views/widget/item_detail_widget.dart';
import 'package:restaurant/app/modules/add_menu_item_screen/views/widget/price_detail_widget.dart';
import 'package:restaurant/app/modules/add_menu_item_screen/views/widget/select_tag_widget.dart';
import 'package:restaurant/app/widget/global_widgets.dart';
import 'package:restaurant/app/widget/text_widget.dart';
import 'package:restaurant/constant/constant.dart';
import 'package:restaurant/themes/app_fonts.dart';
import 'package:restaurant/themes/app_theme_data.dart';
import 'package:restaurant/utils/dark_theme_provider.dart';

import 'widget/variation_detail_widget.dart';

class AddMenuItemsScreenView extends GetView<AddMenuItemsScreenController> {
  const AddMenuItemsScreenView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetBuilder(
      init: AddMenuItemsScreenController(),
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
            leading: InkWell(
              onTap: () {
                if (controller.currentStep.value == 0) {
                  Get.back();
                } else {
                  controller.previousStep();
                }
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: themeChange.isDarkTheme() ? AppThemeData.grey900 : AppThemeData.grey100,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10,right: 12,top: 10,bottom: 10),
                    child: Icon(
                      Icons.arrow_back_ios_rounded,
                      size: 20,
                      color: themeChange.isDarkTheme() ? AppThemeData.grey100 : AppThemeData.grey900,
                    ),
                  ),
                ),
              ),
            ),
            actions: [
              Obx(
                () => Row(
                  children: [
                    TextCustom(
                      title: "0${controller.currentStep.value + 1}",
                      fontFamily: FontFamily.bold,
                      fontSize: 16,
                      color: AppThemeData.primary300,
                    ),
                    const TextCustom(
                      title: "/05",
                      color: AppThemeData.grey500,
                    ),
                  ],
                ),
              ),
              spaceW(width: 16)
            ],
          ),
          body: Obx(() => stepper(context)),
        );
      },
    );
  }

  Widget stepper(BuildContext context) {
    return controller.isLoading.value
        ? Center(child: Constant.loader())
        : Obx(() => IndexedStack(
              index: controller.currentStep.value,
              children: [ItemDetailWidget(), PriceDetailWidget(), AddonsDetailWidget(), VariationDetailWidget(), SelectTagWidget()],
            ));
  }
}
