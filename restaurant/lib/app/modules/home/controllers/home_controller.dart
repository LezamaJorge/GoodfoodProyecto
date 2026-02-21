// ignore_for_file: depend_on_referenced_packages

import 'dart:developer' as developer;

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:restaurant/app/models/order_model.dart';
import 'package:restaurant/app/models/wallet_transaction_model.dart';
import 'package:restaurant/constant/collection_name.dart';
import 'package:restaurant/constant/constant.dart';
import 'package:restaurant/constant/order_status.dart';
import 'package:restaurant/utils/fire_store_utils.dart';
import '../../../../constant/show_toast_dialogue.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomeController extends GetxController with GetTickerProviderStateMixin {
  RxBool isLoading = false.obs;
  RxBool restaurantStatus = false.obs;
  var minutes = 15.obs;
  RxString selectedTags = "Preparing".obs;

  late TabController tabController;
  RxList<OrderModel> newOrderList = <OrderModel>[].obs;
  RxList<OrderModel> preparingOrderList = <OrderModel>[].obs;
  Rx<OrderModel> orderModel = OrderModel().obs;

  RxList<OrderModel> readyOrderList = <OrderModel>[].obs;
  RxList<OrderModel> pickUpOrderList = <OrderModel>[].obs;
  RxList<OrderModel> filterOrderList = <OrderModel>[].obs;

  @override
  void onInit() {
    getData();
    tabController = TabController(length: 2, vsync: this);
    super.onInit();
  }

  Future<void> getData() async {
    isLoading.value = true;
    try {
      getNewOrder();
      getInPrepareOrder();

      restaurantStatus.value = Constant.vendorModel?.isOnline ?? false;
    } catch (e, stack) {
      developer.log(
        'Error getting data: ',
        error: e,
        stackTrace: stack,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> isOnlineRestaurant() async {
    try {
      Constant.ownerModel?.isOpen = restaurantStatus.value;
      await FireStoreUtils.updateOwner(Constant.ownerModel!);

      Constant.vendorModel?.isOnline = restaurantStatus.value;
      await FireStoreUtils.updateRestaurant(Constant.vendorModel!);
    } catch (e, stack) {
      developer.log(
        'Error updating online status: ',
        error: e,
        stackTrace: stack,
      );
      ShowToastDialog.toast("Failed to update online status.".tr);
    }
  }

  Future<void> updateOrder(OrderModel bookingOrder) async {
    try {
      await FireStoreUtils.updateOrder(bookingOrder);
    } catch (e, stack) {
      developer.log(
        'Error updating order: ',
        error: e,
        stackTrace: stack,
      );
    }
  }

  void getNewOrder() {
    isLoading.value = true;
    try {
      FireStoreUtils.fireStore
          .collection(CollectionName.orders)
          .where('vendorId', isEqualTo: Constant.ownerModel!.vendorId)
          .where('orderStatus', isEqualTo: OrderStatus.orderPending)
          .orderBy('createdAt', descending: true)
          .snapshots()
          .listen(
        (event) {
          newOrderList.clear();
          List<OrderModel> orderList = [];

          for (var doc in event.docs) {
            OrderModel model = OrderModel.fromJson(doc.data());
            orderList.add(model);
          }

          newOrderList.assignAll(orderList);
          isLoading.value = false;
        },
      );
    } catch (e) {
      isLoading.value = false;
      developer.log("Error in getNewOrder(): $e");
    }
  }

  void getInPrepareOrder() {
    isLoading.value = true;
    try {
      FireStoreUtils.fireStore
          .collection(CollectionName.orders)
          .where('vendorId', isEqualTo: Constant.ownerModel!.vendorId)
          .where("orderStatus", whereIn: [
            OrderStatus.orderAccepted,
            OrderStatus.driverAssigned,
            OrderStatus.driverAccepted,
            OrderStatus.driverRejected,
            OrderStatus.orderOnReady,
            OrderStatus.driverPickup,
          ])
          .orderBy('createdAt', descending: true)
          .snapshots()
          .listen((event) {
            preparingOrderList.clear();
            List<OrderModel> orderList = [];

            for (var doc in event.docs) {
              OrderModel model = OrderModel.fromJson(doc.data());
              orderList.add(model);
            }

            preparingOrderList.assignAll(orderList);
            isLoading.value = false;
          });
    } catch (e) {
      isLoading.value = false;
      developer.log("Error in getInPrepareOrder(): $e");
    }
  }

  Future<void> addPaymentInWalletForRestaurant(OrderModel orderModel) async {
    try {
      double orderSubTotalAmount = double.tryParse(orderModel.subTotal ?? "0") ?? 0;
      int discount = double.tryParse(orderModel.discount ?? "0")?.toInt() ?? 0;
      double tax = 0;

      tax = double.parse(Constant.calculateTax(amount: orderSubTotalAmount.toString(), taxModel: orderModel.taxList![0]).toString());

      double finalOwnerAmount = 0;
      double commissionBaseAmount = 0;

      if (orderModel.coupon != null && orderModel.coupon!.isVendorOffer == true) {
        finalOwnerAmount = orderSubTotalAmount + tax - discount;
        commissionBaseAmount = orderSubTotalAmount - discount;
      } else {
        finalOwnerAmount = orderSubTotalAmount + tax;
        commissionBaseAmount = orderSubTotalAmount;
      }

      /// --- ADMIN COMMISSION AMOUNT ---
      String commissionAmount = Constant.calculateAdminCommission(
        amount: commissionBaseAmount.toStringAsFixed(2),
        adminCommission: orderModel.adminCommission,
      ).toString();

      /// --- ADMIN COMMISSION TRANSACTION ---
      WalletTransactionModel adminCommissionTransaction = WalletTransactionModel(
        id: Constant.getUuid(),
        amount: commissionAmount,
        createdDate: Timestamp.now(),
        paymentType: orderModel.paymentType,
        transactionId: orderModel.transactionPaymentId,
        userId: Constant.ownerModel!.id.toString(),
        isCredit: false,
        type: Constant.owner,
        note: "Admin Commission",
      );

      /// --- COMMISSION DEDUCTION ---
      bool? debitSuccess = await FireStoreUtils.setWalletTransaction(adminCommissionTransaction);
      if (debitSuccess!) {
        await FireStoreUtils.updateOwnerWalletDebited(
          amount: commissionAmount,
          ownerID: Constant.ownerModel!.id.toString(),
        );
      }

      /// --- ONLY IF NOT COD, CREDIT AMOUNT TO OWNER ---
      if (orderModel.paymentType != "Cash on Delivery") {
        WalletTransactionModel ownerTransaction = WalletTransactionModel(
          id: Constant.getUuid(),
          amount: finalOwnerAmount.toStringAsFixed(2),
          createdDate: Timestamp.now(),
          paymentType: orderModel.paymentType,
          transactionId: orderModel.transactionPaymentId,
          userId: Constant.ownerModel!.id.toString(),
          isCredit: true,
          type: Constant.owner,
          note: "Order Amount",
        );

        bool? creditSuccess = await FireStoreUtils.setWalletTransaction(ownerTransaction);
        if (creditSuccess!) {
          await FireStoreUtils.updateOwnerWallet(
            amount: finalOwnerAmount.toStringAsFixed(2),
            ownerID: Constant.ownerModel!.id.toString(),
          );
        }
      }
    } catch (e, stacktrace) {
      debugPrint("Error in addPaymentInWalletForRestaurant: $e");
      debugPrint("Stacktrace: $stacktrace");
    }
  }

  @override
  void onClose() {
    tabController.dispose();
    super.onClose();
  }
}
