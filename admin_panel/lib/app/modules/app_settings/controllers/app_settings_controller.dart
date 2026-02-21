// ignore_for_file: deprecated_member_use

import 'dart:developer';

import 'package:admin_panel/app/constant/collection_name.dart';
import 'package:admin_panel/app/constant/constants.dart';
import 'package:admin_panel/app/constant/show_toast.dart';
import 'package:admin_panel/app/models/admin_commission_model.dart';
import 'package:admin_panel/app/models/constant_model.dart';
import 'package:admin_panel/app/models/driver_delivery_charge_model.dart';
import 'package:admin_panel/app/models/global_value_model.dart';
import 'package:admin_panel/app/utils/fire_store_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppSettingsController extends GetxController {
  Rx<TextEditingController> adminCommissionController = TextEditingController().obs;
  Rx<TextEditingController> referralAmountController = TextEditingController().obs;
  Rx<TextEditingController> mapRadiusController = TextEditingController().obs;
  Rx<TextEditingController> globalDriverLocationUpdateController = TextEditingController().obs;

  // Rx<TextEditingController> selectedDistanceTypeController = TextEditingController().obs;

  Rx<TextEditingController> globalRadiusController = TextEditingController().obs;
  Rx<TextEditingController> minimumDepositController = TextEditingController().obs;
  Rx<TextEditingController> minimumWithdrawalController = TextEditingController().obs;
  Rx<TextEditingController> driverPerKmChargeController = TextEditingController().obs;
  Rx<TextEditingController> secondsForOrderCancelController = TextEditingController().obs;

  Rx<TextEditingController> farePerKmController = TextEditingController().obs;
  Rx<TextEditingController> minimumChargeWithinKmController = TextEditingController().obs;
  Rx<TextEditingController> fareMinimumChargeController = TextEditingController().obs;

  // Rx<TextEditingController> restaurantGlobalLocationUpdateController = TextEditingController().obs;
  Rx<TextEditingController> restaurantGlobalRadiusController = TextEditingController().obs;

  // Rx<TextEditingController> restaurantSelectedDistanceTypeController = TextEditingController().obs;

  Rx<AdminCommission> adminCommissionModel = AdminCommission().obs;
  Rx<ConstantModel> constantModel = ConstantModel().obs;
  Rx<GlobalValueModel> globalValueModel = GlobalValueModel().obs;

  Rx<Status> isActive = Status.active.obs;
  Rx<Status> isGstActive = Status.active.obs;
  Rx<Status> isVendorActive = Status.active.obs;
  Rx<Status> isDriverActive = Status.active.obs;
  Rx<Status> isSelfDeliveryActive = Status.active.obs;

  List<String> adminCommissionType = ["Fix", "Percentage"];
  RxString selectedAdminCommissionType = "Fix".obs;

  List<String> distanceType = ["Km", "Miles "];
  RxString selectedDistanceType = "Km".obs;

  RxString title = "App Settings".tr.obs;

  RxBool isLoading = false.obs;

  @override
  void onInit() {
    getData();
    super.onInit();
  }

  Future<void> getData() async {
    isLoading(true);
    await getAdminCommissionData();
    await getSettingData();
    await getGlobalValueSetting();
    isLoading(false);
  }

  Future<void> getAdminCommissionData() async {
    await FireStoreUtils.getAdminCommission().then((value) {
      if (value != null) {
        adminCommissionModel.value = value;
        adminCommissionController.value.text = adminCommissionModel.value.value!;
        selectedAdminCommissionType.value = adminCommissionModel.value.isFix == true ? "Fix" : "Percentage";
        isActive.value = adminCommissionModel.value.active == true ? Status.active : Status.inactive;
      }
    });
  }

  Future<void> getSettingData() async {
    await FireStoreUtils.getGeneralSetting().then((value) {
      if (value != null) {
        constantModel.value = value;
        minimumDepositController.value.text = constantModel.value.minimumAmountDeposit!;
        minimumWithdrawalController.value.text = constantModel.value.minimumAmountWithdraw!;
        secondsForOrderCancelController.value.text = constantModel.value.secondsForOrderCancel!;
        isVendorActive.value = constantModel.value.isVendorDocumentVerification == true ? Status.active : Status.inactive;
        isDriverActive.value = constantModel.value.isDriverDocumentVerification == true ? Status.active : Status.inactive;
        isSelfDeliveryActive.value = constantModel.value.isSelfDelivery == true ? Status.active : Status.inactive;
      }
    });
  }

  Future<void> getGlobalValueSetting() async {
    await FireStoreUtils.getGlobalValueSetting().then((value) {
      if (value != null) {
        globalValueModel.value = value;
        log("________ ${value.toJson()}");
        selectedDistanceType.value = globalValueModel.value.distanceType!;
        globalDriverLocationUpdateController.value.text = globalValueModel.value.driverLocationUpdate!;
        globalRadiusController.value.text = globalValueModel.value.radius!;
        restaurantGlobalRadiusController.value.text = globalValueModel.value.restaurantRadius!;
        farePerKmController.value.text = globalValueModel.value.deliveryCharge!.farPerKm!;
        minimumChargeWithinKmController.value.text = globalValueModel.value.deliveryCharge!.minimumChargeWithinKm!;
        fareMinimumChargeController.value.text = globalValueModel.value.deliveryCharge!.fareMinimumCharge!;
        // restaurantGlobalLocationUpdateController.value.text = globalValueModel.value.restaurantLocationUpdate!;
        // restaurantSelectedDistanceTypeController.value.text = globalValueModel.value.restaurantDistanceType!;
      }
    });
  }

  dynamic saveSettingData() async {
    if (selectedAdminCommissionType.isEmpty) {
      return ShowToastDialog.errorToast("  Missing information. Please complete all required fields.".tr);
    } else if (adminCommissionController.value.text.isEmpty || adminCommissionController.value.text == "") {
      return ShowToastDialog.errorToast(" Please Add Admin Commission".tr);
    } else if (minimumDepositController.value.text.isEmpty || minimumDepositController.value.text == "") {
      return ShowToastDialog.errorToast(" Please Add Deposit".tr);
    } else if (minimumWithdrawalController.value.text.isEmpty || minimumWithdrawalController.value.text == "") {
      return ShowToastDialog.errorToast(" Please Add Withdrawal Amount".tr);
    } else if (farePerKmController.value.text.isEmpty || farePerKmController.value.text == "") {
      return ShowToastDialog.errorToast(" Please Add Fare Per Km".tr);
    } else if (minimumChargeWithinKmController.value.text.isEmpty || minimumChargeWithinKmController.value.text == "") {
      return ShowToastDialog.errorToast(" Please Add MinimumWithin Km".tr);
    } else if (fareMinimumChargeController.value.text.isEmpty || fareMinimumChargeController.value.text == "") {
      return ShowToastDialog.errorToast(" Please Add Fare MinimumCharge".tr);
    } else if (secondsForOrderCancelController.value.text.isEmpty || secondsForOrderCancelController.value.text == "") {
      return ShowToastDialog.errorToast(" Please Add Seconds for ride Cancellation  ".tr);
    }
    Constant.waitingLoader();
    try {
      adminCommissionModel.value.active = isActive.value == Status.inactive ? false : true;
      adminCommissionModel.value.isFix = selectedAdminCommissionType.value == "Fix" ? true : false;
      adminCommissionModel.value.value = adminCommissionController.value.text;

      constantModel.value.minimumAmountWithdraw = minimumWithdrawalController.value.text;
      constantModel.value.minimumAmountDeposit = minimumDepositController.value.text;
      constantModel.value.secondsForOrderCancel = secondsForOrderCancelController.value.text;
      constantModel.value.isVendorDocumentVerification = isVendorActive.value == Status.inactive ? false : true;
      constantModel.value.isDriverDocumentVerification = isDriverActive.value == Status.inactive ? false : true;
      constantModel.value.isSelfDelivery = isSelfDeliveryActive.value == Status.inactive ? false : true;

      globalValueModel.value.driverLocationUpdate = globalDriverLocationUpdateController.value.text;
      globalValueModel.value.distanceType = selectedDistanceType.value;
      globalValueModel.value.radius = globalRadiusController.value.text;
      globalValueModel.value.deliveryCharge = DriverDeliveryChargeModel(
        fareMinimumCharge: fareMinimumChargeController.value.text,
        farPerKm: farePerKmController.value.text,
        minimumChargeWithinKm: minimumChargeWithinKmController.value.text,
      );
      globalValueModel.value.restaurantRadius = restaurantGlobalRadiusController.value.text;

      if (isVendorActive.value == Status.active) {
        var snapshot = await FireStoreUtils.fireStore.collection(CollectionName.owner).get();
        var batch = FireStoreUtils.fireStore.batch();

        for (var owner in snapshot.docs) {
          batch.update(owner.reference, {
            "isVerified": false,
            "verifyDocument": [],
          });
        }

        // ✅ Commit all updates in one go
        await batch.commit();
      }

      await FireStoreUtils.setAdminCommission(adminCommissionModel.value);
      await FireStoreUtils.setGeneralSetting(constantModel.value);
      await FireStoreUtils.setGlobalValueSetting(globalValueModel.value);

      ShowToastDialog.successToast('Information saved successfully.'.tr);
      Get.back();
    } catch (e) {
      ShowToastDialog.errorToast("Something went wrong: $e");
    } finally {
      ShowToastDialog.closeLoader();
    }
  }
}
