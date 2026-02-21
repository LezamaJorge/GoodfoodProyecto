// ignore_for_file: use_build_context_synchronously, depend_on_referenced_packages

import 'dart:developer';

import 'package:admin_panel/app/constant/collection_name.dart';
import 'package:admin_panel/app/constant/constants.dart';
import 'package:admin_panel/app/constant/order_status.dart';
import 'package:admin_panel/app/constant/show_toast.dart';
import 'package:admin_panel/app/models/order_model.dart';
import 'package:admin_panel/app/models/vendor_model.dart';
import 'package:admin_panel/app/models/wallet_transaction_model.dart';
import 'package:admin_panel/app/pdf_generate/generate_pdf_order.dart';
import 'package:admin_panel/app/utils/fire_store_utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../models/owner_model.dart';

class RestaurantDetailsController extends GetxController {
  RxString title = "Restaurant Details".tr.obs;
  RxString orderTitle = "Orders".tr.obs;
  RxString transactionTitle = "Wallet Transaction".tr.obs;
  RxBool isLoading = true.obs;
  DateTime? startDate;
  DateTime? endDate;
  Rx<VendorModel> restaurantModel = VendorModel().obs;
  Rx<OwnerModel> ownerModel = OwnerModel().obs;
  RxList<OrderModel> ordersList = <OrderModel>[].obs;
  Rx<TextEditingController> topUpAmountController = TextEditingController().obs;
  RxList<WalletTransactionModel> walletTransactionList = <WalletTransactionModel>[].obs;

  RxInt todayService = 87.obs;
  RxInt totalService = 08.obs;
  RxInt totalUser = 70.obs;
  RxInt totalCab = 30.obs;
  RxDouble totalRestaurantEarnings = 0.0.obs;
  RxInt totalEarnings = 100.obs;

  //orders
  RxString totalItemPerPage = '0'.obs;
  RxBool isDatePickerEnable = true.obs;
  var currentPage = 1.obs;
  var startIndex = 1.obs;
  var endIndex = 1.obs;
  var totalPage = 1.obs;
  RxList<OrderModel> currentPageBooking = <OrderModel>[].obs;
  RxList<OrderModel> allOrderList = <OrderModel>[].obs;

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
    "Pending",
  ];

  Rx<TextEditingController> dateRangeController = TextEditingController().obs;
  RxString selectedDateOption = "All".obs;
  DateTime? startDateForPdf;
  DateTime? endDateForPdf;
  Rx<DateTimeRange> selectedDateRangeForPdf =
      (DateTimeRange(start: DateTime(DateTime.now().year, DateTime.january, 1), end: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, 23, 59, 0, 0))).obs;
  RxBool isCustomVisible = false.obs;
  List<String> dateOption = ["All", "Last Month", "Last 6 Months", "Last Year", "Custom"];
  RxString selectedFilterBookingStatus = "All".obs;
  RxBool isHistoryDownload = false.obs;
  RxString selectedFilterBookingCabStatus = "All".obs;
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

  @override
  Future<void> onInit() async {
    totalItemPerPage.value = Constant.numOfPageIemList.first;
    getArguments();
    super.onInit();
  }

  Future<void> getArguments() async {
    String restaurantId = Get.parameters['restaurantId']!;
    await FireStoreUtils.getRestaurantByRestaurantId(restaurantId).then((value) async {
      if (value != null) {
        restaurantModel.value = value;
        await FireStoreUtils.getOwnerByOwnerId(restaurantModel.value.ownerId.toString()).then(
          (value) {
            if (value != null) {
              ownerModel.value = value;
            } else {
              log("Owner not found for the given ID");
            }
          },
        );
        await getOrders();
        await getWalletTransaction();
      }
    });

    isLoading.value = false;
  }

  Future<void> getAllRestaurantOrders() async {
    ordersList.value = await FireStoreUtils.getAllOrderByRestaurant(restaurantModel.value.id);
  }

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
    } else if (selectedOrderStatus.value == "Pending") {
      selectedOrderStatusForData.value = OrderStatus.orderPending;
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
    allOrderList.value = await FireStoreUtils.getCompletedOrder(restaurantModel.value.id.toString());
    await FireStoreUtils.countRestaurantOrders(restaurantModel.value.id.toString());
    await FireStoreUtils.countRestaurantProducts(restaurantModel.value.id.toString());
    await FireStoreUtils.countRestaurantReview(restaurantModel.value.id.toString());
    calculationTotalEarning();
    getAllRestaurantOrders();
    await setPagination(totalItemPerPage.value);
    isLoading.value = false;
  }

  void calculationTotalEarning() {
    for (var booking in allOrderList) {
      if (booking.orderStatus == 'order_complete') {
        totalRestaurantEarnings.value += Constant.calculateFinalAmount(booking);
      }
    }
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
        List<OrderModel> currentPageBookingData =
            await FireStoreUtils.getRestaurantOrders(currentPage.value, itemPerPage, selectedOrderStatusForData.value, selectedDateRange.value, restaurantModel.value.id.toString());
        currentPageBooking.value = currentPageBookingData;
      } catch (error) {
        log(error.toString());
      }
    }
    update();
    isLoading.value = false;
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
    selectedOrderList =
        await FireStoreUtils.dataForOrdersPdfFromRestaurant(selectedDateRangeForPdf.value, selectedFilterBookingCabStatus.value, restaurantModel.value.id.toString(), selectedDateOption.value);
    await generateOrdersExcelWeb(selectedOrderList, selectedDateRangeForPdf.value);
    isHistoryDownload(false);
    Navigator.pop(context);
  }

  int pageValue(String data) {
    if (data == 'All') {
      return Constant.restaurantOrderLength!;
    } else {
      return int.parse(data);
    }
  }

  Future<void> completeTopUp(String transactionId) async {
    WalletTransactionModel walletTransactionModel = WalletTransactionModel(
      id: Constant.getUuid(),
      amount: topUpAmountController.value.text,
      createdDate: Timestamp.now(),
      userId: restaurantModel.value.ownerId,
      transactionId: transactionId,
      paymentType: "admin",
      note: "Wallet Top up by admin",
      type: "owner",
      isCredit: true,
    );
    await FireStoreUtils.addWalletTransaction(walletTransactionModel).then((value) {
      if (value == true) {
        FireStoreUtils.updateOwnerWallet(amount: topUpAmountController.value.text, userId: ownerModel.value.id.toString()).then((value) async {
          if (value == true) {
            Get.back();
            ShowToastDialog.successToast("Top Up Successful".tr);
            ownerModel.value = (await FireStoreUtils.getOwnerByOwnerId(ownerModel.value.id.toString()))!;
            getWalletTransaction();
            topUpAmountController.value.clear();
          } else {
            log("Failed to update wallet");
          }
        });
      }
    }).catchError((error) {
      ShowToastDialog.errorToast("An error occurred. Please try again.".tr);
    });
  }

  Future<void> getWalletTransaction() async {
    isLoading.value = true;
    log("==========> ${restaurantModel.value.ownerId}");
    await FireStoreUtils.getWalletTransactionByUserId(type: "owner", userId: restaurantModel.value.ownerId.toString()).then(
      (value) {
        walletTransactionList.value = value;
        log("====> : ${walletTransactionList.length}");
      },
    ).catchError((error) {
      log("Error fetching wallet transactions: $error");
      ShowToastDialog.errorToast("Failed to fetch wallet transactions".tr);
    });

    isLoading.value = false;
  }
}
