import 'dart:developer' as developer;

import 'package:customer/app/models/booking_model.dart';
import 'package:customer/app/models/driver_user_model.dart';
import 'package:customer/app/models/review_model.dart';
import 'package:customer/utils/fire_store_utils.dart';
import 'package:get/get.dart';


class OrderDetailScreenController extends GetxController {
  RxBool isLoading = true.obs;
  Rx<OrderModel> bookingModel = OrderModel().obs;
  Rx<ReviewModel> reviewModel = ReviewModel().obs;
  Rx<DriverUserModel> driverModel = DriverUserModel().obs;

  @override
  void onInit() {
    getArguments();
    super.onInit();
  }

  Future<void> getArguments() async {
    try {
      dynamic argumentData = Get.arguments;
      if (argumentData != null) {
        bookingModel.value = argumentData["bookingModel"];
        await getDriver();
        await getReview();
      }
    } catch (e, stack) {
      developer.log("Error getting arguments: ", error: e, stackTrace: stack);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> getReview() async {
    try {
      final value = await FireStoreUtils.getRestaurantReview(bookingModel.value.id.toString());
      if (value != null) {
        reviewModel.value = value;
      }
    } catch (e, stack) {
      developer.log("Error getting review: ", error: e, stackTrace: stack);
    }
  }

  Future<void> getDriver() async {
    try {
      final value = await FireStoreUtils.getDriverUserProfile(bookingModel.value.driverId.toString());
      if (value != null) {
        driverModel.value = value;
      }
    } catch (e, stack) {
      developer.log("Error getting driver info: ", error: e, stackTrace: stack);
    }
  }
}
