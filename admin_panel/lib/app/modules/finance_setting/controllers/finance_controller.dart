// ignore_for_file: non_constant_identifier_names, depend_on_referenced_packages

import 'dart:developer';

import 'package:admin_panel/app/constant/collection_name.dart';
import 'package:admin_panel/app/constant/constants.dart';
import 'package:admin_panel/app/constant/order_status.dart';
import 'package:admin_panel/app/constant/show_toast.dart';
import 'package:admin_panel/app/models/order_model.dart';
import 'package:admin_panel/app/models/vendor_model.dart';
import 'package:admin_panel/app/utils/fire_store_utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FinanceSettingController extends GetxController {
  RxString title = "Finance Settings".tr.obs;
  RxBool isLoading = true.obs;
  DateTime? startDate;
  DateTime? endDate;
  Rx<VendorModel> restaurantModel = VendorModel().obs;
  RxList<OrderModel> OrdersList = <OrderModel>[].obs;

  RxInt todayService = 87.obs;
  RxInt totalService = 08.obs;
  RxInt totalUser = 70.obs;
  RxInt totalCab = 30.obs;
  RxInt todayTotalEarnings = 80.obs;
  RxInt totalEarnings = 100.obs;


  //orders
  RxString totalItemPerPage = '0'.obs;
  RxBool isDatePickerEnable = true.obs;
  var currentPage = 1.obs;
  var startIndex = 1.obs;
  var endIndex = 1.obs;
  var totalPage = 1.obs;
  RxList<OrderModel> currentPageBooking = <OrderModel>[].obs;
  RxString selectedOrderStatus = "All".obs;
  RxString selectedOrderStatusForData = "All".obs;
  List<String> orderStatus = [
    "All",
    "Place",
    "Complete",
    "Rejected",
    "Cancelled",
    "Accepted",
    "OnGoing",
  ];




  @override
  void onInit() {
    totalItemPerPage.value = Constant.numOfPageIemList.first;
    // getArguments();
    super.onInit();
  }

  // getArguments() async {
  //   dynamic argumentData = Get.arguments;
  //   if (argumentData != null) {
  //     restaurantModel.value = argumentData["restaurantModel"];
  //     getOrders();
  //   } else {
  //     Get.toNamed(Routes.ERROR_SCREEN);
  //   }
  //   isLoading.value = false;
  // }

  Future<void> getAllRestaurantOrders() async {
    OrdersList.value = await FireStoreUtils.getAllOrderByRestaurant(restaurantModel.value.id);
  }

  // Rx<DateTimeRange> selectedDateRange =
  //     (DateTimeRange(start: DateTime(DateTime.now().year, DateTime.january, 1), end: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, 23, 59, 0, 0))).obs;

  Rx<DateTimeRange> selectedDateRange = (DateTimeRange(
    start: DateTime(
      DateTime.now().year,
      DateTime.now().month - 5, // Subtract 5 months
      1, // Start of the month
    ),
    end: DateTime(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
      23,
      59,
      59,
      999, // End of the day
    ),
  )).obs;

  Future<void> getOrderDataByOrderStatus() async {
    isLoading.value = true;

    if (selectedOrderStatus.value == "Rejected") {
      selectedOrderStatusForData.value = OrderStatus.orderRejected;
      await FireStoreUtils.countStatusWiseRestaurantOrder(selectedOrderStatusForData.value, selectedDateRange.value, restaurantModel.value.id.toString());
      await setPagination(totalItemPerPage.value);
    } else if (selectedOrderStatus.value == "DriverAccepted") {
      selectedOrderStatusForData.value = OrderStatus.driverAccepted;
      await FireStoreUtils.countStatusWiseRestaurantOrder(selectedOrderStatusForData.value, selectedDateRange.value, restaurantModel.value.id.toString());
      await setPagination(totalItemPerPage.value);
    } else if (selectedOrderStatus.value == "Complete") {
      selectedOrderStatusForData.value = OrderStatus.orderComplete;
      await FireStoreUtils.countStatusWiseRestaurantOrder(selectedOrderStatusForData.value, selectedDateRange.value, restaurantModel.value.id.toString());
      await setPagination(totalItemPerPage.value);
    } else if (selectedOrderStatus.value == "Cancelled") {
      selectedOrderStatusForData.value = OrderStatus.orderCancel;
      await FireStoreUtils.countStatusWiseRestaurantOrder(selectedOrderStatusForData.value, selectedDateRange.value, restaurantModel.value.id.toString());
      await setPagination(totalItemPerPage.value);
    } else if (selectedOrderStatus.value == "Accepted") {
      selectedOrderStatusForData.value = OrderStatus.orderAccepted;
      await FireStoreUtils.countStatusWiseRestaurantOrder(selectedOrderStatusForData.value, selectedDateRange.value, restaurantModel.value.id.toString());
      await setPagination(totalItemPerPage.value);
    } else if (selectedOrderStatus.value == "DriverPicked") {
      selectedOrderStatusForData.value = OrderStatus.driverPickup;
      await FireStoreUtils.countStatusWiseRestaurantOrder(selectedOrderStatusForData.value, selectedDateRange.value, restaurantModel.value.id.toString());
      await setPagination(totalItemPerPage.value);
    } else {
      selectedOrderStatusForData.value = "All";
      getOrders();
    }

    isLoading.value = false;
  }

  Future<void> getOrders() async {
    isLoading.value = true;
    await FireStoreUtils.countRestaurantOrders(restaurantModel.value.id.toString());
    getAllRestaurantOrders();
    await setPagination(totalItemPerPage.value);
    isLoading.value = false;
  }

  Future<void> removeOrder(OrderModel orderModel) async {
    isLoading = true.obs;
    await FirebaseFirestore.instance.collection(CollectionName.orders).doc(orderModel.id).delete().then((value) {
      ShowToastDialog.successToast("Order deleted.".tr);
    }).catchError((error) {
      ShowToastDialog.errorToast("An error occurred. Please try again.".tr);
    });
    isLoading = false.obs;
  }

  Future<void> setPagination(String page) async {
    isLoading.value = true;
    totalItemPerPage.value = page;
    int itemPerPage = pageValue(page);
    totalPage.value = (Constant.restaurantOrderLength! / itemPerPage).ceil();
    startIndex.value = (currentPage.value - 1) * itemPerPage;
    endIndex.value = (currentPage.value * itemPerPage) > Constant.restaurantOrderLength! ? Constant.restaurantOrderLength! : (currentPage.value * itemPerPage);
    if (endIndex.value < startIndex.value) {
      currentPage.value = 1;
      setPagination(page);
    } else {
      try {
        List<OrderModel> currentPageBookingData = await FireStoreUtils.getRestaurantOrders(
            currentPage.value, itemPerPage, selectedOrderStatusForData.value, selectedDateRange.value, restaurantModel.value.id.toString());
        currentPageBooking.value = currentPageBookingData;

      } catch (error) {
        log(error.toString());
      }
    }
    update();
    isLoading.value = false;
  }

  int pageValue(String data) {
    if (data == 'All') {
      return Constant.restaurantOrderLength!;
    } else {
      return int.parse(data);
    }
  }
}
