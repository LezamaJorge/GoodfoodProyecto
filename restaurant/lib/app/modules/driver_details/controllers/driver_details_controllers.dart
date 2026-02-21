import 'dart:developer' as developer;

import 'package:cloud_functions/cloud_functions.dart';
import 'package:get/get.dart';
import 'package:restaurant/app/models/driver_user_model.dart';
import 'package:restaurant/constant/constant.dart';
import 'package:restaurant/constant/show_toast_dialogue.dart';
import 'package:restaurant/utils/fire_store_utils.dart';


class DriverDetailsControllers extends GetxController {
  RxList<DriverUserModel> driverList = <DriverUserModel>[].obs;
  Rx<DriverUserModel> driverModel = DriverUserModel().obs;
  RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    getData();
  }

  Future<void> getData() async {
    try {
      isLoading.value = true;
      await FireStoreUtils.getDriverByVendorId(Constant.vendorModel!.id.toString()).then(
        (value) {
          driverList.value = value!;
          developer.log("_________________ driver ${driverList.length}");
        },
      );
    } catch (e, stack) {
      developer.log('Error fetching drivers:', error: e, stackTrace: stack);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteUserAccount(String driverId) async {
    try {
      developer.log("🗑️ Deleting driver with ID: $driverId");
      final callable = FirebaseFunctions.instance.httpsCallable('deleteDriverAccount');
      final result = await callable.call({'driverId': driverId});
      final success = result.data['success'] == true;
      if (success) {
        ShowToastDialog.toast("Driver deleted successfully");
        await getData();
      } else {
        ShowToastDialog.toast("Failed to delete driver");
      }
    } catch (e, st) {
      developer.log("❌ Error deleting driver: $e", stackTrace: st);
      ShowToastDialog.toast("Failed to delete driver");
    }
  }
}
