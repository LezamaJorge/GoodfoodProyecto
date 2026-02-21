import 'dart:developer' as developer;

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:restaurant/app/models/order_model.dart';
import 'package:restaurant/constant/collection_name.dart';
import 'package:restaurant/constant/constant.dart';
import 'package:restaurant/constant/order_status.dart';
import 'package:restaurant/utils/fire_store_utils.dart';

import '../../../../constant/show_toast_dialogue.dart';

class AllOrdersController extends GetxController {
  Rx<GlobalKey<FormState>> formKey = GlobalKey<FormState>().obs;

  RxBool isLoading = true.obs;
  RxBool isDatePickerEnable = true.obs;

  RxList<String> tagsList = <String>[
    "Completed",
    "Rejected",
    "Cancelled",
  ].obs;
  RxString selectedTags = "Completed".obs;

  RxList<OrderModel> filterOrderList = <OrderModel>[].obs;
  RxList<OrderModel> bookedOrderList = <OrderModel>[].obs;
  RxList<OrderModel> rejectedOrderList = <OrderModel>[].obs;
  RxList<OrderModel> completedOrderList = <OrderModel>[].obs;
  RxList<OrderModel> cancelledOrderList = <OrderModel>[].obs;

  Rx<DateTimeRange> selectedDateRange =
      (DateTimeRange(start: DateTime(DateTime.now().year, DateTime.january, 1), end: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, 23, 59, 0, 0))).obs;
  DateTime? startDate;
  DateTime? endDate;

  @override
  void onInit() {
    clearOrderLists();
    getOrdersData('All', selectedDateRange.value);
    super.onInit();
  }

  void clearOrderLists() {
    try {
      filterOrderList.clear();
      bookedOrderList.clear();
      rejectedOrderList.clear();
      completedOrderList.clear();
      cancelledOrderList.clear();
    } catch (e,stack) {
      developer.log("Error clearing order lists: $e", error: e, stackTrace: stack);
    }
  }

  Future<void> getOrdersData(String status, DateTimeRange? dateTimeRange) async {
    isLoading.value = true;

    try {
      var query = FireStoreUtils.fireStore.collection(CollectionName.orders).where('vendorId', isEqualTo: Constant.vendorModel!.id);

      if (status != 'All' && dateTimeRange != null) {
        query = query.where(
          'createdAt',
          isGreaterThanOrEqualTo: dateTimeRange.start,
          isLessThan: dateTimeRange.end,
        );
      }

      if (status == 'All') {
        query = query.orderBy('createdAt', descending: true);
      }

      var snapshot = await query.get();

      for (var doc in snapshot.docs) {
        OrderModel booking = OrderModel.fromJson(doc.data());

        switch (booking.orderStatus) {
          case OrderStatus.orderCancel:
            cancelledOrderList.add(booking);
            break;
          case OrderStatus.orderRejected:
            rejectedOrderList.add(booking);
            break;
          case OrderStatus.orderComplete:
            completedOrderList.add(booking);
            filterOrderList.add(booking);
            break;
          default:
            break;
        }
      }
    } catch (e,stack) {
      developer.log("Error fetching orders: $e", error: e, stackTrace: stack);
      ShowToastDialog.toast("Failed to fetch orders.".tr);
    } finally {
      isLoading.value = false;
    }
  }
}
