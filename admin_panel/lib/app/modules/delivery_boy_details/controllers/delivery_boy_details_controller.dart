// ignore_for_file: depend_on_referenced_packages

import 'dart:developer';

import 'package:admin_panel/app/constant/order_status.dart';
import 'package:admin_panel/app/constant/show_toast.dart';
import 'package:admin_panel/app/models/driver_user_model.dart';
import 'package:admin_panel/app/models/order_model.dart';
import 'package:admin_panel/app/models/wallet_transaction_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../constant/collection_name.dart';
import '../../../constant/constants.dart';
import '../../../models/payout_request_model.dart';
import '../../../utils/fire_store_utils.dart';

class DeliveryBoyDetailsController extends GetxController {
  RxString title = "Delivery Boy Detail".tr.obs;
  RxString transactionTitle = "Wallet Transaction".tr.obs;
  RxBool isLoading = true.obs;
  DateTime? startDate;
  DateTime? endDate;
  Rx<TextEditingController> topUpAmountController = TextEditingController().obs;
  Rx<DriverUserModel> driverModel = DriverUserModel().obs;
  RxList<WalletTransactionModel> walletTransactionList = <WalletTransactionModel>[].obs;
  RxList<BankDetailsModel> bankDetailsList = <BankDetailsModel>[].obs;

  RxList<OrderModel> currentPageOrder = <OrderModel>[].obs;
  RxList<OrderModel> ordersList = <OrderModel>[].obs;
  RxString totalItemPerPage = '0'.obs;
  RxBool isDatePickerEnable = true.obs;
  var currentPage = 1.obs;
  var startIndex = 1.obs;
  var endIndex = 1.obs;
  var totalPage = 1.obs;
  RxString selectedOrderStatus = "All".obs;
  RxString selectedOrderStatusForData = "All".obs;

  RxString selectedDateOption = "All".obs;
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

  List<String> dateOption = [
    "All",
    "Last Month",
    "Last 6 Months",
    "Last Year",
    "Custom",
  ];

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

  @override
  Future<void> onInit() async {
    super.onInit();
    totalItemPerPage.value = Constant.numOfPageIemList.first;
    getArgument();

  }

  Future<void> getArgument() async {
    String driverId = Get.parameters['driverId']!;
    await FireStoreUtils.getDriverByDriverID(driverId).then((value) {
      if (value != null) {
        driverModel.value = value;
      }
    });
    getWalletTransaction();
    getBankDetails();
    isLoading.value = false;
  }

  Future<void> getAllDriverOrders() async {
    isLoading.value = true;
    await FireStoreUtils.countDriverOrders(driverModel.value.driverId.toString());
    ordersList.value = await FireStoreUtils.getAllOrderByDriver(selectedOrderStatusForData.value, driverModel.value.driverId.toString());
    setPagination(totalItemPerPage.value);
    isLoading.value = false;
  }

  Future<void> setPagination(String page) async {
    isLoading.value = true;
    totalItemPerPage.value = page;
    int itemPerPage = pageValue(page);
    totalPage.value = (ordersList.length / itemPerPage).ceil();
    startIndex.value = (currentPage.value - 1) * itemPerPage;
    endIndex.value = (currentPage.value * itemPerPage) > ordersList.length ? ordersList.length : (currentPage.value * itemPerPage);
    if (endIndex.value < startIndex.value) {
      currentPage.value = 1;
      setPagination(page);
    } else {
      try {
        List<OrderModel> currentPageBookingData = await FireStoreUtils.getDriverOrders(
            pageNumber: currentPage.value, pageSize: itemPerPage, status: selectedOrderStatusForData.value, dateTimeRange: selectedDateRange.value, driverId: driverModel.value.driverId.toString());
        currentPageOrder.value = currentPageBookingData;
      } catch (error) {
        log(error.toString());
      }
    }
    update();
    isLoading.value = false;
  }

  int pageValue(String data) {
    if (data == 'All') {
      return Constant.orderLength!;
    } else {
      return int.parse(data);
    }
  }

  Future<void> getOrderDataByOrderStatus() async {
    isLoading.value = true;

    if (selectedOrderStatus.value == "Rejected") {
      selectedOrderStatusForData.value = OrderStatus.orderRejected;
      await getAllDriverOrders();
    } else if (selectedOrderStatus.value == "DriverAccepted") {
      selectedOrderStatusForData.value = OrderStatus.driverAccepted;
      await getAllDriverOrders();
    } else if (selectedOrderStatus.value == "Complete") {
      selectedOrderStatusForData.value = OrderStatus.orderComplete;
      await getAllDriverOrders();
    } else if (selectedOrderStatus.value == "Cancelled") {
      selectedOrderStatusForData.value = OrderStatus.orderCancel;
      await getAllDriverOrders();
    } else if (selectedOrderStatus.value == "Accepted") {
      selectedOrderStatusForData.value = OrderStatus.orderAccepted;
      await getAllDriverOrders();
    } else if (selectedOrderStatus.value == "OnGoing") {
      selectedOrderStatusForData.value = OrderStatus.driverPickup;
      await getAllDriverOrders();
    } else if (selectedOrderStatus.value == "Place") {
      selectedOrderStatusForData.value = OrderStatus.orderPending;
      await getAllDriverOrders();
    } else {
      selectedOrderStatusForData.value = "All";
      await getAllDriverOrders();
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

  Future<void> completeTopUp(String transactionId) async {
    WalletTransactionModel walletTransactionModel = WalletTransactionModel(
      id: Constant.getUuid(),
      amount: topUpAmountController.value.text,
      createdDate: Timestamp.now(),
      userId: driverModel.value.driverId,
      transactionId: transactionId,
      paymentType: "admin",
      note: "Wallet Top up by admin",
      type: "driver",
      isCredit: true,
    );
    await FireStoreUtils.addWalletTransaction(walletTransactionModel).then((value) {
      if (value == true) {
        FireStoreUtils.updateDriverWallet(amount: topUpAmountController.value.text, userId: driverModel.value.driverId.toString()).then((value) async {
          if (value == true) {
            Get.back();
            ShowToastDialog.successToast("Top Up Successful".tr);
            driverModel.value = (await FireStoreUtils.getDriverByDriverID(driverModel.value.driverId.toString()))!;
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
    await FireStoreUtils.getWalletTransactionByUserId(type: "driver", userId: driverModel.value.driverId.toString()).then(
      (value) {
        walletTransactionList.value = value;
      },
    ).catchError((error) {
      log("Error fetching wallet transactions: $error");
      ShowToastDialog.errorToast("Failed to fetch wallet transactions".tr);
    });

    isLoading.value = false;
  }

  Future<void> getBankDetails() async {
    isLoading.value = true;
    await FireStoreUtils.getBankDetailsByUserId(driverModel.value.driverId.toString()).then(
      (value) {
        bankDetailsList.value = value;
      },
    ).catchError((error) {
      log("Error fetching wallet transactions: $error");
      ShowToastDialog.errorToast("Failed to fetch wallet transactions".tr);
    });

    isLoading.value = false;
  }
}
