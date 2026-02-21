// ignore_for_file: deprecated_member_use

import 'package:admin_panel/app/constant/show_toast.dart';
import 'package:admin_panel/app/models/constant_model.dart';
import 'package:admin_panel/app/utils/app_colors.dart';
import 'package:admin_panel/app/utils/fire_store_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class AppThemeController extends GetxController {
  Rx<TextEditingController> appNameController = TextEditingController().obs;
  Rx<TextEditingController> customerColourCodeController = TextEditingController().obs;
  Rx<TextEditingController> restaurantColourCodeController = TextEditingController().obs;
  Rx<TextEditingController> driverColourCodeController = TextEditingController().obs;

  Rx<Color> customerSelectedColor = AppThemeData.primary500.obs;
  Rx<Color> driverSelectedColor = const Color(0xff04BF55).obs;
  Rx<Color> restaurantSelectedColor = const Color(0xffF24A4A).obs;

  Rx<ConstantModel> constantModel = ConstantModel().obs;

  RxString title = "App Theme".tr.obs;

  RxBool isLoading = false.obs;

  @override
  void onInit() {
    getData();
    super.onInit();
  }

  Future<void> getData() async {
    isLoading(true);
    await getSettingData();
    isLoading(false);
  }

  Future<void> getSettingData() async {
    await FireStoreUtils.getGeneralSetting().then((value) {
      if (value != null) {
        constantModel.value = value;
        customerColourCodeController.value.text = constantModel.value.customerAppColor!;
        restaurantColourCodeController.value.text = constantModel.value.restaurantAppColor!;
        driverColourCodeController.value.text = constantModel.value.driverAppColor!;
        appNameController.value.text = constantModel.value.appName!;
        customerSelectedColor.value = HexColor.fromHex(customerColourCodeController.value.text);
        restaurantSelectedColor.value = HexColor.fromHex(restaurantColourCodeController.value.text);
        driverSelectedColor.value = HexColor.fromHex(driverColourCodeController.value.text);
      }
    });
  }

  dynamic saveSettingData() {
    if (appNameController.value.text.isEmpty || appNameController.value.text == "") {
      return ShowToastDialog.errorToast(" App name is required.".tr);
    } else if (customerColourCodeController.value.text.isEmpty || customerColourCodeController.value.text == "") {
      return ShowToastDialog.errorToast("Please select your app’s primary colors".tr);
    } else if (restaurantColourCodeController.value.text.isEmpty || restaurantColourCodeController.value.text == "") {
      return ShowToastDialog.errorToast("Please choose colors for the restaurant app.".tr);
    } else if (driverColourCodeController.value.text.isEmpty || driverColourCodeController.value.text == "") {
      return ShowToastDialog.errorToast("Please choose colors for the driver app.".tr);
    } else {
      constantModel.value.appName = appNameController.value.text;
      constantModel.value.customerAppColor = customerColourCodeController.value.text;
      constantModel.value.restaurantAppColor = restaurantColourCodeController.value.text;
      constantModel.value.driverAppColor = driverColourCodeController.value.text;

      FireStoreUtils.setGeneralSetting(constantModel.value);
      ShowToastDialog.successToast(' Information saved successfully.'.tr);
    }
  }
}

extension HexColor on Color {
  static Color fromHex(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }

  String toHex({bool leadingHashSign = true}) => '${leadingHashSign ? '#' : ''}'
      '${alpha.toRadixString(16).padLeft(2, '0')}'
      '${red.toRadixString(16).padLeft(2, '0')}'
      '${green.toRadixString(16).padLeft(2, '0')}'
      '${blue.toRadixString(16).padLeft(2, '0')}';
}
