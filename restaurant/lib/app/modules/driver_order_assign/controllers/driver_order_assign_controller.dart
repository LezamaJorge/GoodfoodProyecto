import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:restaurant/app/models/driver_user_model.dart';
import 'package:restaurant/app/models/order_model.dart';
import 'package:restaurant/app/models/user_model.dart';
import 'package:restaurant/constant/constant.dart';
import 'package:restaurant/constant/order_status.dart';
import 'package:restaurant/constant/show_toast_dialogue.dart';
import 'package:restaurant/utils/fire_store_utils.dart';

import '../../../../constant/send_notification.dart';

class DriverOrderAssignController extends GetxController {
  RxList<DriverUserModel> driverList = <DriverUserModel>[].obs;
  RxBool isLoading = false.obs;
  var minutes = 15.obs;
  Rx<DriverUserModel> driver = DriverUserModel().obs;
  Rx<OrderModel> orderModel = OrderModel().obs;

  @override
  void onInit() {
    super.onInit();
    getArgument();
    getData();
  }

  void getArgument() {
    dynamic argument = Get.arguments;
    if (argument != null) {
      orderModel.value = argument['OrderModel'];
      minutes.value = argument['preparationTime'];
      log("_________ orderModel ${orderModel.value.toJson()}");
    }
  }

  Future<void> getData() async {
    try {
      isLoading.value = true;
      await FireStoreUtils.getDriverByVendorId(Constant.vendorModel!.id.toString()).then(
        (value) {
          driverList.value = value!;
          log("_________________ driver ${driverList.length}");
        },
      );
    } catch (e, stack) {
      log('Error fetching drivers:', error: e, stackTrace: stack);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> driverOrderAssign() async {
    orderModel.value.orderStatus = OrderStatus.orderAccepted;
    orderModel.value.foodIsReadyToPickup = false;
    orderModel.value.preparationTime = minutes.value.toString();
    await FireStoreUtils.updateOrder(orderModel.value);
    UserModel? userModel = await FireStoreUtils.getCustomerUserProfile(orderModel.value.customerId.toString());
    Map<String, dynamic> payLoad = <String, dynamic>{"orderId": orderModel.value.id};
    await SendNotification.sendOneNotification(
        senderId: FireStoreUtils.getCurrentUid(),
        customerId: userModel!.id.toString(),
        token: userModel.fcmToken.toString(),
        orderId: orderModel.value.id.toString(),
        title: "Order Accepted by Restaurant",
        body: 'Your Order #${orderModel.value.id.toString().substring(0, 5)} has been Accepted by Restaurant.',
        type: 'order',
        payload: payLoad,
        isNewOrder: false);
  }

  Future<void> selectedDriverOrderAssign(String orderId, String driverId) async {
    try {
      ShowToastDialog.showLoader("Please Wait..".tr);
      driver.value.orderId = orderModel.value.id.toString();
      driver.value.status = "busy";
      await FireStoreUtils.updateDriver(driver.value);
      orderModel.value.driverId = driverId;
      orderModel.value.orderStatus = OrderStatus.driverAssigned;
      orderModel.value.assignedAt = Timestamp.now();
      orderModel.value.foodIsReadyToPickup = false;
      orderModel.value.preparationTime = minutes.value.toString();
      await FireStoreUtils.updateOrder(orderModel.value);
      log("✅ Order $orderId assigned to Driver $driverId successfully");

      UserModel? userModel = await FireStoreUtils.getCustomerUserProfile(orderModel.value.customerId.toString());

      if (userModel != null && userModel.fcmToken?.isNotEmpty == true) {
        Map<String, dynamic> customerPayload = {
          "orderId": orderModel.value.id,
        };

        await SendNotification.sendOneNotification(
          senderId: FireStoreUtils.getCurrentUid(),
          customerId: userModel.id.toString(),
          token: userModel.fcmToken.toString(),
          orderId: orderModel.value.id.toString(),
          title: "Order Accepted by Restaurant",
          body: 'Your Order #${orderModel.value.id.toString().substring(0, 5)} has been accepted by the restaurant.',
          type: 'order',
          payload: customerPayload,
          isNewOrder: false,
        );
      }

      DriverUserModel? driverModel = await FireStoreUtils.getDriverUserProfile(driverId);

      if (driverModel != null && driverModel.fcmToken?.isNotEmpty == true) {
        Map<String, dynamic> driverPayload = {
          "orderId": orderModel.value.id,
        };

        await SendNotification.sendOneNotification(
          senderId: FireStoreUtils.getCurrentUid(),
          customerId: driverModel.driverId.toString(),
          token: driverModel.fcmToken.toString(),
          orderId: orderModel.value.id.toString(),
          title: "New Order Assigned",
          body: "You have been assigned Order #${orderModel.value.id.toString().substring(0, 5)}",
          type: 'driverOrder',
          payload: driverPayload,
          isNewOrder: true,
        );
      }

      Get.back();
    } catch (e, stack) {
      log("❌ Error assigning order to driver: $e", error: e, stackTrace: stack);
    } finally {
      ShowToastDialog.closeLoader();
    }
  }
}
