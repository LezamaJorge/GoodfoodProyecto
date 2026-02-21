
import 'dart:developer' as developer;

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:restaurant/app/models/order_model.dart';
import 'package:restaurant/utils/fire_store_utils.dart';

class OrderScreenController extends GetxController {
  RxBool restaurantStatus = true.obs;
  RxList<String> tagsList = <String>[
    "Preparing",
    "Ready",
    "Pickup",
  ].obs;
  RxString selectedTags = "Preparing".obs;
  RxBool isLoading = true.obs;

  RxList<OrderModel> bookedOrderList = <OrderModel>[].obs;
  var minutes = 15.obs;

  @override
  void onInit() {
    getArgument();
    super.onInit();
  }

  Future<void> updateOrder(OrderModel bookingOrder) async {
    try {
      await FireStoreUtils.updateOrder(bookingOrder);
    } catch (e,stack) {
      if (kDebugMode) {
        developer.log(
          'Error updating order: $e',
          error: e,
          stackTrace: stack,
        );
      }
    }
  }

  Future<void> getArgument() async {
    isLoading.value = true;
    try {
      dynamic argumentData = Get.arguments;
      if (argumentData != null) {
        bookedOrderList.value = argumentData['bookedOrderList'];
      }
    } catch (e,stack) {
      if (kDebugMode) {
        developer.log(
          'Error getting arguments: $e',
          error: e,
          stackTrace: stack,
        );
      }
    } finally {
      isLoading.value = false;
    }
  }
}
