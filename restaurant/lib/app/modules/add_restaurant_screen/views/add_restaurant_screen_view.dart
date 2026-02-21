// ignore_for_file: deprecated_member_use, must_be_immutable, depend_on_referenced_packages, use_build_context_synchronously, use_super_parameters

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:restaurant/app/modules/add_restaurant_screen/controllers/add_restaurant_screen_controller.dart';
import 'package:restaurant/app/modules/add_restaurant_screen/views/widget/select_opening_hours_widget.dart';
import 'package:restaurant/app/modules/add_restaurant_screen/views/widget/upload_restaurant_image_widget.dart';
import 'package:restaurant/constant/constant.dart';
import 'package:restaurant/themes/app_theme_data.dart';
import 'package:restaurant/utils/dark_theme_provider.dart';

import 'widget/restaurant_detail_widget.dart';

class AddRestaurantScreenView extends GetView<AddRestaurantScreenController> {
  const AddRestaurantScreenView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetBuilder(
      init: AddRestaurantScreenController(),
      builder: (controller) {
        return Scaffold(
          backgroundColor: themeChange.isDarkTheme() ? AppThemeData.grey1000 : AppThemeData.grey50,
          appBar: AppBar(
            systemOverlayStyle: const SystemUiOverlayStyle(
              statusBarColor: Colors.transparent,
              statusBarIconBrightness: Brightness.dark, // Android → black
              statusBarBrightness: Brightness.light, // iOS → black
            ),
            backgroundColor: Colors.transparent,
            surfaceTintColor: Colors.transparent,
            automaticallyImplyLeading: false,
            leading: GestureDetector(
              onTap: () {
                if (controller.editPage.isEmpty) {
                  if (controller.currentStep.value == 0) {
                    Get.back();
                  } else {
                    controller.previousStep();
                  }
                } else {
                  if (controller.currentStep.value == 1) {
                    controller.previousStep();
                  } else {
                    Get.back();
                  }
                }
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: themeChange.isDarkTheme() ? AppThemeData.grey900 : AppThemeData.grey100,
                  ),
                  child: Icon(
                    Icons.arrow_back_ios_sharp,
                    size: 20,
                    color: themeChange.isDarkTheme() ? AppThemeData.grey100 : AppThemeData.grey900,
                  ),
                ),
              ),
            ),
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
              children: [
                const UploadRestaurantImage(),
                RestaurantDetailWidget(),
                SelectOpeningHoursWidget(),
              ],
            ));
  }
}
