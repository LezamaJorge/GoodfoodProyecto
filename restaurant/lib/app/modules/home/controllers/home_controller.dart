// ignore_for_file: depend_on_referenced_packages

import 'dart:developer' as developer;

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:restaurant/app/models/order_model.dart';
import 'package:restaurant/app/models/wallet_transaction_model.dart';
import 'package:restaurant/constant/collection_name.dart';
import 'package:restaurant/constant/constant.dart';
import 'package:restaurant/constant/order_status.dart';
import 'package:restaurant/constant/send_notification.dart';
import 'package:restaurant/utils/fire_store_utils.dart';
import 'package:restaurant/app/models/driver_user_model.dart';
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
    listenForReassignments();
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
      double orderSubTotalAmount = double.tryParse(orderModel.subTotal?.toString() ?? "0.0") ?? 0.0;
      double discount = double.tryParse(orderModel.discount?.toString() ?? "0.0") ?? 0.0;
      double tax = 0.0;

      if (orderModel.taxList != null && orderModel.taxList!.isNotEmpty) {
        tax = double.parse(Constant.calculateTax(amount: orderSubTotalAmount.toString(), taxModel: orderModel.taxList![0]).toString());
      }

      double finalOwnerAmount = 0.0;
      double commissionBaseAmount = 0.0;

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

      developer.log("Restaurant Payment Processing: Subtotal: $orderSubTotalAmount, Final Owner: $finalOwnerAmount, Commission: $commissionAmount");

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
      if (debitSuccess == true) {
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
        if (creditSuccess == true) {
          await FireStoreUtils.updateOwnerWallet(
            amount: finalOwnerAmount.toStringAsFixed(2),
            ownerID: Constant.ownerModel!.id.toString(),
          );
        }
      }
    } catch (e, stacktrace) {
      developer.log("Error in addPaymentInWalletForRestaurant: $e", stackTrace: stacktrace);
    }
  }

  void listenForReassignments() {
    FireStoreUtils.fireStore
        .collection(CollectionName.orders)
        .where('vendorId', isEqualTo: Constant.ownerModel!.vendorId)
        .where('orderStatus', isEqualTo: OrderStatus.driverRejected)
        .snapshots()
        .listen((event) {
      for (var doc in event.docs) {
        OrderModel order = OrderModel.fromJson(doc.data());
        developer.log("Detected rejected order ${order.id}. Re-assigning...");
        assignIndependentDriver(order);
      }
    });
  }

  Future<void> assignIndependentDriver(OrderModel pendingOrder) async {
    try {
      ShowToastDialog.showLoader("Buscando repartidor cercano...".tr);

      // 1. Obtener todos los repartidores disponibles
      List<DriverUserModel> allDrivers = await FireStoreUtils.getAllDrivers();

      if (allDrivers.isEmpty) {
        ShowToastDialog.closeLoader();
        ShowToastDialog.toast("No hay repartidores conectados en este momento.".tr);
        return;
      }

      double? restaurantLat = pendingOrder.vendorAddress?.location?.latitude;
      double? restaurantLng = pendingOrder.vendorAddress?.location?.longitude;

      if (restaurantLat == null || restaurantLng == null) {
        ShowToastDialog.closeLoader();
        ShowToastDialog.toast("Error: No se encontró la ubicación del restaurante.".tr);
        return;
      }

      DriverUserModel? nearestDriver;
      double shortestDistance = double.maxFinite;

      for (var driver in allDrivers) {
        // Excluir si ya rechazó
        if (pendingOrder.rejectedDriverIds != null && pendingOrder.rejectedDriverIds!.contains(driver.driverId)) {
          continue;
        }

        double? driverLat = driver.location?.latitude;
        double? driverLng = driver.location?.longitude;

        if (driverLat != null && driverLng != null) {
          double distance = FireStoreUtils.calculateDistance(restaurantLat, restaurantLng, driverLat, driverLng);
          if (distance < shortestDistance) {
            shortestDistance = distance;
            nearestDriver = driver;
          }
        }
      }

      if (nearestDriver == null) {
        ShowToastDialog.closeLoader();
        ShowToastDialog.toast("No se encontraron repartidores elegibles cerca.".tr);
        return;
      }

      // 2. Asignar el pedido al conductor
      pendingOrder.driverId = nearestDriver.driverId;
      pendingOrder.orderStatus = OrderStatus.driverAssigned;
      pendingOrder.assignedAt = Timestamp.now();
      pendingOrder.foodIsReadyToPickup = false;
      pendingOrder.preparationTime = minutes.value.toString();

      await FireStoreUtils.updateOrder(pendingOrder);

      // 3. Actualizar el estado del conductor
      nearestDriver.orderId = pendingOrder.id;
      nearestDriver.status = "busy";
      await FireStoreUtils.updateDriver(nearestDriver);

      // 4. Enviar notificación (En un try-catch separado para que no bloquee la asignación)
      try {
        Map<String, dynamic> playLoad = <String, dynamic>{"orderId": pendingOrder.id};
        await SendNotification.sendOneNotification(
          token: nearestDriver.fcmToken.toString(),
          title: 'New Order Received'.tr,
          body: 'You have a new order assignment #'.tr + pendingOrder.id.toString().substring(0, 4),
          payload: playLoad,
          type: "order",
          orderId: pendingOrder.id,
          driverId: nearestDriver.driverId,
          isNewOrder: true,
        );
      } catch (e) {
        developer.log("Notification failed but order was assigned: $e");
      }

      ShowToastDialog.closeLoader();
      ShowToastDialog.toast("Repartidor asignado correctamente.".tr);
    } catch (e) {
      ShowToastDialog.closeLoader();
      developer.log("Error assigning independent driver: $e");
      ShowToastDialog.toast("Error al asignar repartidor automático.".tr);
    }
  }

  @override
  void onClose() {
    tabController.dispose();
    super.onClose();
  }
}
