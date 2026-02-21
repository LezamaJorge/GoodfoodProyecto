import 'dart:developer' as developer;

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:restaurant/app/models/owner_model.dart';
import 'package:restaurant/constant/constant.dart';
import 'package:restaurant/constant/show_toast_dialogue.dart';
import 'package:restaurant/utils/fire_store_utils.dart';

import '../../../models/vendor_model.dart';

class ProfileScreenController extends GetxController {
  Rx<OwnerModel> ownerModel = OwnerModel().obs;
  Rx<VendorModel> vendorModel = VendorModel().obs;
  RxBool isSelfDelivery = false.obs;

  @override
  void onInit() {
    getData();
    super.onInit();
  }

  Future<void> getData() async {
    try {
      ownerModel.value = Constant.ownerModel!;
      vendorModel.value = Constant.vendorModel!;
      isSelfDelivery.value = Constant.vendorModel?.isSelfDelivery ?? false;
      update();
    } catch (e, stack) {
      if (kDebugMode) {
        developer.log('Error fetching owner data: $e', error: e, stackTrace: stack);
      }
    }
  }

  Future<void> isSelfDeliveryRestaurant() async {
    try {
      Constant.vendorModel?.isSelfDelivery = isSelfDelivery.value;
      await FireStoreUtils.updateRestaurant(Constant.vendorModel!);
      developer.log("Self delivery status updated to: ${isSelfDelivery.value}");
    } catch (e, stack) {
      developer.log(
        'Error updating self delivery status: ',
        error: e,
        stackTrace: stack,
      );
      ShowToastDialog.toast("Failed to update status.".tr);
    }
  }
}
