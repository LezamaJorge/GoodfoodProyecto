import 'package:admin_panel/app/models/order_model.dart';
import 'package:admin_panel/app/models/driver_user_model.dart';
import 'package:admin_panel/app/models/user_model.dart';
import 'package:admin_panel/app/utils/fire_store_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class OrderDetailController extends GetxController {
  RxString title = "Order Detail".tr.obs;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  RxBool isLoading = true.obs;
  Rx<OrderModel> bookingModel = OrderModel().obs;
  Rx<DriverUserModel> driverModel = DriverUserModel().obs;
  Rx<UserModel> userModel = UserModel().obs;

  // BitmapDescriptor? pickUpIcon;
  // BitmapDescriptor? dropIcon;

  @override
  void onInit() {
    getArgument();
    super.onInit();
  }

  Future<void> getArgument() async {
    String orderId = Get.parameters['orderId']!;
    await FireStoreUtils.getOrderByOrderId(orderId).then((value) {
      if (value != null) {
        bookingModel.value = value;
      }
    });

    if (bookingModel.value.driverId != null && bookingModel.value.driverId!.isNotEmpty) {
      await FireStoreUtils.getDriverByDriverID(bookingModel.value.driverId.toString()).then((value) {
        driverModel.value = value!;
      });
    }
    await FireStoreUtils.getCustomerByCustomerID(bookingModel.value.customerId.toString()).then((value) {
      userModel.value = value!;
    });

    isLoading.value = false;
  }
}
