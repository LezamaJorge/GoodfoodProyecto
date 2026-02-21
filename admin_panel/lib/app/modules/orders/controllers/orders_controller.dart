// ignore_for_file: body_might_complete_normally_catch_error, use_build_context_synchronously, depend_on_referenced_packages

import 'dart:developer';
import 'package:admin_panel/app/constant/collection_name.dart';
import 'package:admin_panel/app/constant/constants.dart';
import 'package:admin_panel/app/constant/order_status.dart';
import 'package:admin_panel/app/constant/show_toast.dart';
import 'package:admin_panel/app/models/order_model.dart';
import 'package:admin_panel/app/models/driver_user_model.dart';
import 'package:admin_panel/app/models/vendor_model.dart';
import 'package:admin_panel/app/pdf_generate/generate_pdf_order.dart';
import 'package:admin_panel/app/utils/fire_store_utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OrdersController extends GetxController {
  RxString title = "Orders".tr.obs;

  RxBool isLoading = true.obs;
  RxBool isDatePickerEnable = true.obs;
  var currentPage = 1.obs;
  var startIndex = 1.obs;
  var endIndex = 1.obs;
  var totalPage = 1.obs;
  RxList<OrderModel> currentPageBooking = <OrderModel>[].obs;
  Rx<TextEditingController> searchController = TextEditingController().obs;
  DateTime? startDate;
  DateTime? endDate;
  RxString selectedOrderStatus = "All".obs;
  RxString selectedOrderStatusForData = "All".obs;
  List<String> orderStatus = [
    "All",
    "Pending",
    "Complete",
    "Rejected",
    "Cancelled",
    "Accepted",
    "Order On Ready",
  ];

  Rx<TextEditingController> dateRangeController = TextEditingController().obs;
  DateTime? startDateForPdf;
  DateTime? endDateForPdf;
  Rx<DateTimeRange> selectedDateRangeForPdf =
      (DateTimeRange(start: DateTime(DateTime.now().year, DateTime.january, 1), end: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, 23, 59, 0, 0))).obs;


  Rx<DateTimeRange> selectedDateRange = (DateTimeRange(
    start: DateTime(
      DateTime.now().year,
      DateTime.now().month - 5,
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

  RxString selectedDateOption = "All".obs;
  RxString selectedDateOptionForPdf = "All".obs;
  List<String> dateOption = ["All", "Last Month", "Last 6 Months", "Last Year", "Custom"];
  RxBool isCustomVisible = false.obs;
  RxList<DriverUserModel> allDriverList = <DriverUserModel>[].obs;
  Rx<DriverUserModel?> selectedDriver = Rx<DriverUserModel?>(DriverUserModel(driverId: 'All'));
  RxString driverId = "".obs;

  RxList<VendorModel> allRestaurantList = <VendorModel>[].obs;
  RxString restaurantId = "".obs;
  RxString selectedBookingStatusForData = "All".obs;
  RxString selectedFilterBookingStatus = "All".obs;
  RxString selectedFilterBookingCabStatus = "All".obs;
  RxBool isHistoryDownload = false.obs;

  @override
  void onInit() {
    totalItemPerPage.value = Constant.numOfPageIemList.first;
    getOrders();
    getAllDriver();
    getAllRestaurant();
    super.onInit();
  }

  Future<void> getAllDriver() async {
    await FireStoreUtils.getAllDriver().then((value) {
      value.insert(0, DriverUserModel(driverId: "All", firstName: 'All Driver'));
      allDriverList.addAll(value);
      return value;
    }).catchError((error) {
      log('==================> get error $error');
    });
  }

  Future<void> getAllRestaurant() async {
    await FireStoreUtils.getAllRestaurant().then((value) {
      value.insert(0, VendorModel(id: "All", vendorName: 'All Restaurant'));
      allRestaurantList.addAll(value);
      return value;
    }).catchError((error) {
      log('==================> get error $error');
    });
  }

  List<OrderModel> selectedOrderList = [];

  Future<void> downloadCabBookingPdf(BuildContext context) async {
    if (selectedFilterBookingStatus.value == "Rejected") {
      selectedFilterBookingCabStatus.value = "order_rejected";
    } else if (selectedFilterBookingStatus.value == "Complete") {
      selectedFilterBookingCabStatus.value = "order_complete";
    } else if (selectedFilterBookingStatus.value == "Cancelled") {
      selectedFilterBookingCabStatus.value = 'order_cancel';
    } else if (selectedFilterBookingStatus.value == "Accepted") {
      selectedFilterBookingCabStatus.value = 'order_accepted';
    } else if (selectedFilterBookingStatus.value == "OnGoing") {
      selectedFilterBookingCabStatus.value = 'booking_ongoing';
    } else if (selectedFilterBookingStatus.value == "Order On Ready") {
      selectedFilterBookingCabStatus.value = 'order_on_ready';
    } else if (selectedFilterBookingStatus.value == "Pending") {
      selectedFilterBookingCabStatus.value = 'order_pending';
    } else {
      selectedFilterBookingCabStatus.value = "All";
    }

    isHistoryDownload(true);
    selectedOrderList = await FireStoreUtils.dataForOrdersPdf(
        selectedDateRangeForPdf.value, selectedDriver.value!.driverId.toString(), selectedFilterBookingCabStatus.value, selectedDateOption.value);
    await generateOrdersExcelWeb(selectedOrderList, selectedDateRangeForPdf.value);
    isHistoryDownload(false);
    Navigator.pop(context);
  }

  Future<void> getOrderDataByOrderStatus() async {
    isLoading.value = true;

    if (selectedOrderStatus.value == "Rejected") {
      selectedOrderStatusForData.value = OrderStatus.orderRejected;
      await FireStoreUtils.countStatusWiseBooking(
          driverId: driverId.value, status: selectedOrderStatusForData.value, dateTimeRange: selectedDateRange.value, restaurantId: restaurantId.value);
      // await FireStoreUtils.countStatusWiseOrder(selectedOrderStatusForData.value, selectedDateRange.value);
      await setPagination(totalItemPerPage.value);
    } else if (selectedOrderStatus.value == "DriverAccepted") {
      selectedOrderStatusForData.value = OrderStatus.driverAccepted;
      await FireStoreUtils.countStatusWiseBooking(
          driverId: driverId.value, status: selectedOrderStatusForData.value, dateTimeRange: selectedDateRange.value, restaurantId: restaurantId.value);
      // await FireStoreUtils.countStatusWiseOrder(selectedOrderStatusForData.value, selectedDateRange.value);
      await setPagination(totalItemPerPage.value);
    } else if (selectedOrderStatus.value == "Complete") {
      selectedOrderStatusForData.value = OrderStatus.orderComplete;
      await FireStoreUtils.countStatusWiseBooking(
          driverId: driverId.value, status: selectedOrderStatusForData.value, dateTimeRange: selectedDateRange.value, restaurantId: restaurantId.value);
      // await FireStoreUtils.countStatusWiseOrder(selectedOrderStatusForData.value, selectedDateRange.value);
      await setPagination(totalItemPerPage.value);
    } else if (selectedOrderStatus.value == "Cancelled") {
      selectedOrderStatusForData.value = OrderStatus.orderCancel;
      await FireStoreUtils.countStatusWiseBooking(
          driverId: driverId.value, status: selectedOrderStatusForData.value, dateTimeRange: selectedDateRange.value, restaurantId: restaurantId.value);
      // await FireStoreUtils.countStatusWiseOrder(selectedOrderStatusForData.value, selectedDateRange.value);
      await setPagination(totalItemPerPage.value);
    } else if (selectedOrderStatus.value == "Accepted") {
      selectedOrderStatusForData.value = OrderStatus.orderAccepted;
      await FireStoreUtils.countStatusWiseBooking(
          driverId: driverId.value, status: selectedOrderStatusForData.value, dateTimeRange: selectedDateRange.value, restaurantId: restaurantId.value);
      // await FireStoreUtils.countStatusWiseOrder(selectedOrderStatusForData.value, selectedDateRange.value);
      await setPagination(totalItemPerPage.value);
    } else if (selectedOrderStatus.value == "DriverPicked") {
      selectedOrderStatusForData.value = OrderStatus.driverPickup;
      await FireStoreUtils.countStatusWiseBooking(
          driverId: driverId.value, status: selectedOrderStatusForData.value, dateTimeRange: selectedDateRange.value, restaurantId: restaurantId.value);
      // await FireStoreUtils.countStatusWiseOrder(selectedOrderStatusForData.value, selectedDateRange.value);
      await setPagination(totalItemPerPage.value);
    } else if (selectedOrderStatus.value == "Order On Ready") {
      selectedOrderStatusForData.value = OrderStatus.orderOnReady;
      await FireStoreUtils.countStatusWiseBooking(
          driverId: driverId.value, status: selectedOrderStatusForData.value, dateTimeRange: selectedDateRange.value, restaurantId: restaurantId.value);
      // await FireStoreUtils.countStatusWiseOrder(selectedOrderStatusForData.value, selectedDateRange.value);
      await setPagination(totalItemPerPage.value);
    } else if (selectedOrderStatus.value == "Pending") {
      selectedOrderStatusForData.value = OrderStatus.orderPending;
      await FireStoreUtils.countStatusWiseBooking(
          driverId: driverId.value, dateTimeRange: selectedDateRange.value, status: selectedOrderStatusForData.value, restaurantId: restaurantId.value);
      // await FireStoreUtils.countStatusWiseOrder(selectedOrderStatusForData.value, selectedDateRange.value);
      await setPagination(totalItemPerPage.value);
    } else {
      selectedOrderStatusForData.value = "All";
      getOrders();
    }
    isLoading.value = false;
  }

  Future<void> removeOrder(OrderModel bookingModel) async {
    isLoading = true.obs;
    await FirebaseFirestore.instance.collection(CollectionName.orders).doc(bookingModel.id).delete().then((value) {
      ShowToastDialog.successToast("Order deleted.".tr);
    }).catchError((error) {
      ShowToastDialog.errorToast("An error occurred. Please try again.".tr);
    });
    isLoading = false.obs;
  }

  Future<void> getOrders() async {
    isLoading.value = true;
    await FireStoreUtils.countOrders();
    await setPagination(totalItemPerPage.value);
    isLoading.value = false;
  }

  // setPagination(String page) {
  //   totalItemPerPage.value = page;
  //   int itemPerPage = pageValue(page);
  //   totalPage.value = (bookingList.length / itemPerPage).ceil();
  //   startIndex.value = (currentPage.value - 1) * itemPerPage;
  //   endIndex.value = (currentPage.value * itemPerPage) > bookingList.length ? bookingList.length : (currentPage.value * itemPerPage);
  //   if (endIndex.value < startIndex.value) {
  //     currentPage.value = 1;
  //     setPagination(page);
  //   } else {
  //     currentPageBooking.value = bookingList.sublist(startIndex.value, endIndex.value);
  //   }
  //   isLoading.value = false;
  //   update();
  // }

  Future<void> setPagination(String page) async {
    isLoading.value = true;
    totalItemPerPage.value = page;
    int itemPerPage = pageValue(page);
    totalPage.value = (Constant.orderLength! / itemPerPage).ceil();
    startIndex.value = (currentPage.value - 1) * itemPerPage;
    endIndex.value = (currentPage.value * itemPerPage) > Constant.orderLength! ? Constant.orderLength! : (currentPage.value * itemPerPage);
    if (endIndex.value < startIndex.value) {
      currentPage.value = 1;
      setPagination(page);
    } else {
      try {
        List<OrderModel> currentPageBookingData =
            await FireStoreUtils.getOrders(currentPage.value, itemPerPage, selectedOrderStatusForData.value, selectedDateRange.value, driverId.value, restaurantId.value);
        currentPageBooking.value = currentPageBookingData;
      } catch (error) {
        log(error.toString());
      }
    }
    update();
    isLoading.value = false;
  }

  RxString totalItemPerPage = '0'.obs;

  int pageValue(String data) {
    if (data == 'All') {
      return Constant.orderLength!;
    } else {
      return int.parse(data);
    }
  }
}
