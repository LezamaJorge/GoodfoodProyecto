// ignore_for_file: unnecessary_overrides, depend_on_referenced_packages

import 'dart:async';
import 'dart:developer' as developer;

import 'package:driver/app/models/customer_user_model.dart';
import 'package:driver/app/models/driver_user_model.dart';
import 'package:driver/app/models/order_model.dart';
import 'package:driver/app/models/owner_model.dart';
import 'package:driver/app/models/reject_driver_reason_model.dart';
import 'package:driver/app/models/vendor_model.dart';
import 'package:driver/app/models/wallet_transaction_model.dart';
import 'package:driver/app/modules/home_screen/views/widget/reject_order.dart';
import 'package:driver/app/widget/global_widgets.dart';
import 'package:driver/app/widget/text_field_suffix_widget.dart';
import 'package:driver/app/widget/text_widget.dart';
import 'package:driver/constant/collection_name.dart';
import 'package:driver/constant/constant.dart';
import 'package:driver/constant/order_status.dart';
import 'package:driver/constant/show_toast_dialogue.dart';
import 'package:driver/constant_widget/round_shape_button.dart';
import 'package:driver/themes/app_colors.dart';
import 'package:driver/themes/font_family.dart';
import 'package:driver/themes/screen_size.dart';
import 'package:driver/utils/dark_theme_provider.dart';
import 'package:driver/utils/fire_store_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../constant/send_notification.dart';

class OrdersScreenController extends GetxController {
  RxList<OrderModel> orderCompletedList = <OrderModel>[].obs;
  RxList<OrderModel> rejectOrderListList = <OrderModel>[].obs;

  RxList<String> rejectOrderList = <String>['Vehicle issues', 'Emergency situations', 'Busy Schedule', 'Unsafe Location', 'Long Distance'].obs;
  RxString selectedRejectOrderReason = "".obs;
  Rx<TextEditingController> otherRejectReasonController = TextEditingController().obs;

  Rx<DriverUserModel> driverUserModel = DriverUserModel().obs;
  Rx<OrderModel> orderModel = OrderModel().obs;

  RxList<String> tagsList = <String>[
    "New Order",
    "Completed",
    "Rejected",
  ].obs;
  RxString selectedTags = "New Order".obs;

  RxBool isLoading = true.obs;

  // RxBool driverStatus = false.obs;
  Rx<VendorModel> restaurantModel = VendorModel().obs;
  Rx<CustomerUserModel> customerModel = CustomerUserModel().obs;
  RxBool isLoadingOrderData = false.obs;
  RxBool isRestaurantDataLoading = true.obs;
  Rx<OwnerModel> ownerModel = OwnerModel().obs;

  @override
  void onInit() {
    getDriver();
    super.onInit();
  }

  Future<void> getDriver() async {
    try {
      isLoading.value = true;

      orderCompletedList.value = (await FireStoreUtils.getCompletedOrder()) ?? [];
      rejectOrderListList.value = (await FireStoreUtils.getRejectsOrder()) ?? [];

      FireStoreUtils.fireStore.collection(CollectionName.driver).doc(FireStoreUtils.getCurrentUid()).snapshots().listen((event) async {
        try {
          if (event.exists) {
            driverUserModel.value = DriverUserModel.fromJson(event.data()!);
            Constant.isDriverOnline.value = driverUserModel.value.isOnline ?? false;
            Constant.driverUserModel = driverUserModel.value;

            if (driverUserModel.value.orderId != null && driverUserModel.value.orderId!.isNotEmpty) {
              timerForAssignedOrder(driverUserModel.value.orderId.toString());

              FireStoreUtils.fireStore.collection(CollectionName.orders).doc(driverUserModel.value.orderId).snapshots().listen((orderEvent) {
                try {
                  if (orderEvent.exists) {
                    orderModel.value = OrderModel.fromJson(orderEvent.data()!);
                    restaurantAndCustomerData(
                      orderModel.value.vendorId.toString(),
                      orderModel.value.customerId.toString(),
                    );
                  } else {
                    orderModel.value = OrderModel();
                  }
                } catch (e, stack) {
                  developer.log("Error in getDriver", error: e, stackTrace: stack);
                } finally {
                  isLoading.value = false;
                  update();
                }
              });
            } else {
              stopTimer();
              orderModel.value = OrderModel();
              isLoading.value = false;
              update();
            }
          } else {
            isLoading.value = false;
          }
        } catch (e, stack) {
          developer.log("Error in getDriver", error: e, stackTrace: stack);
          isLoading.value = false;
        }
      });
    } catch (e, stack) {
      developer.log("Error in getDriver", error: e, stackTrace: stack);
      isLoading.value = false;
    }
  }

  Future<void> restaurantAndCustomerData(String restaurantID, String customerUserID) async {
    try {
      restaurantModel.value = (await FireStoreUtils.getRestaurant(restaurantID))!;
      customerModel.value = (await FireStoreUtils.getCustomerUserData(customerUserID))!;

      final owner = await FireStoreUtils.getOwnerProfile(restaurantModel.value.ownerId.toString());
      if (owner != null) {
        ownerModel.value = owner;
      }
    } catch (e, stack) {
      developer.log("Error in restaurantAndCustomerData", error: e, stackTrace: stack);
    } finally {
      isRestaurantDataLoading.value = false;
    }
  }

  Future<void> addPaymentInWallet() async {
    double driverWalletAmount = double.parse(Constant.driverUserModel!.walletAmount!);
    double orderTotalAmount = double.parse(orderModel.value.totalAmount!);
    double orderSubTotalAmount = double.parse(orderModel.value.subTotal!);
    int deliveryCharge = int.parse(orderModel.value.deliveryCharge!);
    int discount = double.tryParse(orderModel.value.discount!)?.toInt() ?? 0;
    double tax = 0;

    tax = double.parse(Constant.calculateTax(amount: orderSubTotalAmount.toString(), taxModel: orderModel.value.taxList![0]).toString());

    if (orderModel.value.paymentType == "Cash on Delivery") {
      double finalOwnerAmount = 0;
      double commissionBaseAmount = 0;
      double finalWalletAmount = driverWalletAmount - orderTotalAmount + deliveryCharge;

      Constant.driverUserModel!.walletAmount = finalWalletAmount.toStringAsFixed(2);

      if (orderModel.value.coupon!.isVendorOffer != null && orderModel.value.coupon!.isVendorOffer == true) {
        finalOwnerAmount = orderSubTotalAmount + tax - discount;
        commissionBaseAmount = orderSubTotalAmount - discount;
      } else {
        finalOwnerAmount = orderSubTotalAmount + tax;
        commissionBaseAmount = orderSubTotalAmount;
      }

      WalletTransactionModel transactionModelOfDriver = WalletTransactionModel(
          id: Constant.getUuid(),
          amount: orderModel.value.totalAmount,
          createdDate: Timestamp.now(),
          paymentType: orderModel.value.paymentType,
          transactionId: DateTime.now().millisecondsSinceEpoch.toString(),
          userId: FireStoreUtils.getCurrentUid(),
          isCredit: false,
          type: Constant.driver,
          note: "Order Amount");

      WalletTransactionModel transactionModelOfOwner = WalletTransactionModel(
          id: Constant.getUuid(),
          amount: finalOwnerAmount.toStringAsFixed(2),
          createdDate: Timestamp.now(),
          paymentType: orderModel.value.paymentType,
          transactionId: DateTime.now().millisecondsSinceEpoch.toString(),
          userId: ownerModel.value.id,
          isCredit: true,
          type: Constant.owner,
          note: "Order Amount");

      await FireStoreUtils.setWalletTransaction(transactionModelOfDriver).then((value) async {
        if (value == true) {
          await FireStoreUtils.updateDriverUserProfile(Constant.driverUserModel!).then((value) async {});
        }
      });

      WalletTransactionModel transactionModelOfOrderAdminCommission = WalletTransactionModel(
          id: Constant.getUuid(),
          amount: "${Constant.calculateAdminCommission(amount: commissionBaseAmount.toStringAsFixed(2), adminCommission: orderModel.value.adminCommission)}",
          createdDate: Timestamp.now(),
          paymentType: orderModel.value.paymentType,
          transactionId: orderModel.value.transactionPaymentId,
          userId: ownerModel.value.id,
          isCredit: false,
          type: Constant.owner,
          note: "Admin Commission");

      WalletTransactionModel transactionModelOfDeliveryChargeDriver = WalletTransactionModel(
          id: Constant.getUuid(),
          amount: deliveryCharge.toString(),
          createdDate: Timestamp.now(),
          paymentType: orderModel.value.paymentType,
          transactionId: orderModel.value.transactionPaymentId,
          userId: FireStoreUtils.getCurrentUid(),
          isCredit: true,
          type: Constant.driver,
          note: "Delivery Charge");

      await FireStoreUtils.setWalletTransaction(transactionModelOfOwner).then((value) async {
        if (value == true) {
          await FireStoreUtils.updateOwnerWallet(amount: finalOwnerAmount.toStringAsFixed(2), ownerID: ownerModel.value.id.toString()).then((value) async {});
        }
      });

      await FireStoreUtils.setWalletTransaction(transactionModelOfDeliveryChargeDriver).then((value) async {
        if (value == true) {}
      });

      await FireStoreUtils.setWalletTransaction(transactionModelOfOrderAdminCommission).then((value) async {
        if (value == true) {
          await FireStoreUtils.updateOwnerWalletDebited(
                  amount: Constant.calculateAdminCommission(amount: commissionBaseAmount.toStringAsFixed(2), adminCommission: orderModel.value.adminCommission).toString(),
                  ownerID: ownerModel.value.id.toString())
              .then((value) async {});
        }
      });

      Map<String, dynamic> playLoad = <String, dynamic>{"orderId": orderModel.value.id};

      SendNotification.sendOneNotification(
          isPayment: orderModel.value.paymentStatus ?? false,
          isSaveNotification: false,
          token: Constant.ownerModel!.fcmToken.toString(),
          title: 'Order delivered successfully 📦'.tr,
          body: 'Your order#${orderModel.value.id.toString().substring(0, 4)} Delivered Successfully.',
          type: 'order',
          orderId: orderModel.value.id,
          senderId: FireStoreUtils.getCurrentUid(),
          ownerId: ownerModel.value.id.toString(),
          payload: playLoad,isNewOrder: false);

      SendNotification.sendOneNotification(
          isPayment: orderModel.value.paymentStatus ?? false,
          isSaveNotification: true,
          token: customerModel.value.fcmToken.toString(),
          title: 'Order delivered successfully 📦'.tr,
          body: 'Your order#${orderModel.value.id.toString().substring(0, 4)} Delivered Successfully.',
          type: 'order',
          orderId: orderModel.value.id,
          senderId: FireStoreUtils.getCurrentUid(),
          customerId: customerModel.value.id,
          payload: playLoad,isNewOrder: false);
    } else {
      double finalOwnerAmount = 0;
      double commissionBaseAmount = 0;
      double finalDriverWalletAmount = driverWalletAmount + deliveryCharge;

      Constant.driverUserModel!.walletAmount = finalDriverWalletAmount.toStringAsFixed(2);

      if (orderModel.value.coupon!.isVendorOffer != null && orderModel.value.coupon!.isVendorOffer == true) {
        finalOwnerAmount = orderSubTotalAmount + tax - discount;
        commissionBaseAmount = orderSubTotalAmount - discount;
      } else {
        finalOwnerAmount = orderSubTotalAmount + tax;
        commissionBaseAmount = orderSubTotalAmount;
      }

      WalletTransactionModel transactionModelOfOwner = WalletTransactionModel(
          id: Constant.getUuid(),
          amount: finalOwnerAmount.toStringAsFixed(2),
          createdDate: Timestamp.now(),
          paymentType: orderModel.value.paymentType,
          transactionId: orderModel.value.transactionPaymentId,
          userId: ownerModel.value.id,
          isCredit: true,
          type: Constant.owner,
          note: "Order Amount");

      WalletTransactionModel transactionModelOfOrderAdminCommission = WalletTransactionModel(
          id: Constant.getUuid(),
          amount: "${Constant.calculateAdminCommission(amount: commissionBaseAmount.toStringAsFixed(2), adminCommission: orderModel.value.adminCommission)}",
          createdDate: Timestamp.now(),
          paymentType: orderModel.value.paymentType,
          transactionId: orderModel.value.transactionPaymentId,
          userId: ownerModel.value.id,
          isCredit: false,
          type: Constant.owner,
          note: "Admin Commission");

      WalletTransactionModel transactionModelOfDeliveryChargeDriver = WalletTransactionModel(
          id: Constant.getUuid(),
          amount: deliveryCharge.toString(),
          createdDate: Timestamp.now(),
          paymentType: orderModel.value.paymentType,
          transactionId: orderModel.value.transactionPaymentId,
          userId: FireStoreUtils.getCurrentUid(),
          isCredit: true,
          type: Constant.driver,
          note: "Delivery Charge");

      await FireStoreUtils.setWalletTransaction(transactionModelOfOwner).then((value) async {
        if (value == true) {
          await FireStoreUtils.updateOwnerWallet(amount: finalOwnerAmount.toStringAsFixed(2), ownerID: ownerModel.value.id.toString()).then((value) async {});
        }
      });

      await FireStoreUtils.setWalletTransaction(transactionModelOfDeliveryChargeDriver).then((value) async {
        if (value == true) {
          await FireStoreUtils.updateDriverUserProfile(Constant.driverUserModel!).then((value) async {});
        }
      });

      await FireStoreUtils.setWalletTransaction(transactionModelOfOrderAdminCommission).then((value) async {
        if (value == true) {
          await FireStoreUtils.updateOwnerWalletDebited(
                  amount: Constant.calculateAdminCommission(amount: commissionBaseAmount.toStringAsFixed(2), adminCommission: orderModel.value.adminCommission).toString(),
                  ownerID: ownerModel.value.id.toString())
              .then((value) async {});
        }
      });

      Map<String, dynamic> playLoad = <String, dynamic>{"orderId": orderModel.value.id};

      SendNotification.sendOneNotification(
          isPayment: orderModel.value.paymentStatus ?? false,
          isSaveNotification: true,
          token: customerModel.value.fcmToken.toString(),
          title: 'Order delivered successfully 📦'.tr,
          body: 'Your order#${orderModel.value.id.toString().substring(0, 4)} Delivered Successfully.',
          type: 'order',
          orderId: orderModel.value.id,
          senderId: FireStoreUtils.getCurrentUid(),
          customerId: customerModel.value.id,
          payload: playLoad,isNewOrder: false);

      SendNotification.sendOneNotification(
          isPayment: orderModel.value.paymentStatus ?? false,
          isSaveNotification: true,
          token: Constant.ownerModel!.fcmToken.toString(),
          title: 'Order delivered successfully 📦'.tr,
          body: 'Order delivered successfully and  check your wallet order#${orderModel.value.id.toString().substring(0, 4)}',
          type: 'order',
          orderId: orderModel.value.id,
          senderId: FireStoreUtils.getCurrentUid(),
          ownerId: ownerModel.value.id.toString(),
          payload: playLoad,isNewOrder: false);
    }
  }

  StatefulBuilder rejectOrderBottomSheet(BuildContext context, OrdersScreenController controller, DarkThemeProvider themeChange, OrderModel bookingModel) {
    return StatefulBuilder(
      builder: (context, setState) {
        return SizedBox(
          height: ScreenSize.height(80, context),
          width: ScreenSize.height(100, context),
          child: Obx(
            () => SingleChildScrollView(
              reverse: true,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        margin: EdgeInsets.only(top: 20.h),
                        width: 72.w,
                        height: 8.h,
                        decoration: BoxDecoration(color: AppThemeData.grey400, borderRadius: BorderRadius.circular(100)),
                      ),
                    ),
                    spaceH(height: 20.h),
                    TextCustom(
                      title: 'Reject Order'.tr,
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                    TextCustom(
                      title: 'Choose a reason for Reject your order.'.tr,
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: AppThemeData.grey600,
                    ),
                    spaceH(height: 24.h),
                    ListView.builder(
                      shrinkWrap: true,
                      itemCount: controller.rejectOrderList.length,
                      itemBuilder: (context, index) {
                        return Obx(() => RadioGroup<String>(
                              groupValue: controller.selectedRejectOrderReason.value,
                              onChanged: (value) {
                                controller.selectedRejectOrderReason.value = value!;
                                controller.otherRejectReasonController.value.text = '';
                              },
                              child: RadioListTile(
                                value: controller.rejectOrderList[index],
                                controlAffinity: ListTileControlAffinity.trailing,
                                contentPadding: EdgeInsets.zero,
                                activeColor: AppThemeData.primary300,
                                title: Text(
                                  controller.rejectOrderList[index].toString(),
                                  style: TextStyle(
                                    color: themeChange.isDarkTheme() ? AppThemeData.primaryWhite : AppThemeData.primaryBlack,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                    fontFamily: FontFamily.regular,
                                  ),
                                ),
                              ),
                            ));
                      },
                    ),
                    RadioGroup<String>(
                      groupValue: controller.selectedRejectOrderReason.value,
                      onChanged: (value) {
                        controller.selectedRejectOrderReason.value = value!;
                      },
                      child: RadioListTile(
                        value: 'Other Reason'.tr,
                        controlAffinity: ListTileControlAffinity.trailing,
                        contentPadding: EdgeInsets.zero,
                        activeColor: AppThemeData.primary300,
                        title: Text(
                          'Other Reason'.tr,
                          style: TextStyle(
                            color: themeChange.isDarkTheme() ? AppThemeData.primaryWhite : AppThemeData.primaryBlack,
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            fontFamily: FontFamily.regular,
                          ),
                        ),
                      ),
                    ),
                    if (controller.selectedRejectOrderReason.value == 'Other Reason')
                      TextFieldWidget(
                        title: "Enter other reason".tr,
                        hintText: "Enter other reason".tr,
                        validator: (value) => value != null && value.isNotEmpty ? null : 'This field required'.tr,
                        controller: controller.otherRejectReasonController.value,
                        onPress: () {},
                      ),
                    spaceH(height: 54.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        RoundShapeButton(
                            size: Size(173.w, ScreenSize.height(6, context)),
                            title: "Keep order".tr,
                            buttonColor: themeChange.isDarkTheme() ? AppThemeData.grey200 : AppThemeData.grey200,
                            buttonTextColor: themeChange.isDarkTheme() ? AppThemeData.grey500 : AppThemeData.grey500,
                            onTap: () {
                              Navigator.pop(context);
                            }),
                        RoundShapeButton(
                            size: Size(173.w, ScreenSize.height(6, context)),
                            title: "Reject order".tr,
                            buttonColor: AppThemeData.primary300,
                            buttonTextColor: themeChange.isDarkTheme() ? AppThemeData.grey1000 : AppThemeData.grey100,
                            onTap: () {
                              if (controller.selectedRejectOrderReason.value == '') {
                                return ShowToastDialog.showToast(' Select Reject order reason'.tr);
                              }
                              if (controller.selectedRejectOrderReason.value == 'Other Reason' && controller.otherRejectReasonController.value.text == '') {
                                return ShowToastDialog.showToast(' Enter Reject order reason'.tr);
                              }

                              bookingModel.rejectedDriverReason ??= [];

                              if (controller.selectedRejectOrderReason.value == 'Other Reason') {
                                RejectDriverReasonModel rejectedOrderModel =
                                    RejectDriverReasonModel(reason: controller.otherRejectReasonController.value.text, driverId: FireStoreUtils.getCurrentUid());
                                bookingModel.rejectedDriverReason!.add(rejectedOrderModel);
                              } else {
                                bookingModel.rejectedDriverReason!.add(RejectDriverReasonModel(reason: controller.selectedRejectOrderReason.value, driverId: FireStoreUtils.getCurrentUid()));
                              }

                              bookingModel.orderStatus = OrderStatus.driverRejected;
                              bookingModel.rejectedDriverIds!.add(FireStoreUtils.getCurrentUid());
                              driverUserModel.value.orderId = null;
                              driverUserModel.value.status = 'free';
                              FireStoreUtils.updateOrder(bookingModel);
                              FireStoreUtils.updateDriverUser(driverUserModel.value);
                              Get.offAll(() => RejectOrderView());
                            }),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  RxInt remainingSeconds = 0.obs;
  Timer? timer;

  void timerForAssignedOrder(String orderId) {
    try {
      FirebaseFirestore.instance.collection(CollectionName.orders).doc(orderId).snapshots().listen((doc) {
        try {
          if (!doc.exists) return;

          final data = doc.data()!;
          String assignedDriverId = data['driverId'];
          String currentDriverId = FireStoreUtils.getCurrentUid();

          if (assignedDriverId == currentDriverId) {
            int totalSeconds = int.tryParse(Constant.secondsForOrderCancel) ?? 180;

            Timestamp? assignedAtTimestamp = data['assignedAt'];

            if (assignedAtTimestamp != null) {
              int elapsedSeconds = DateTime.now().difference(assignedAtTimestamp.toDate()).inSeconds;
              int remaining = totalSeconds - elapsedSeconds;

              if (remaining <= 0) {
                stopTimer();
                return;
              } else {
                startSecondsTimer(remaining);
              }
            } else {
              startSecondsTimer(totalSeconds);
            }
          } else {
            stopTimer();
          }
        } catch (e, stack) {
          developer.log("Error in timerForAssignedOrder", error: e, stackTrace: stack);
          stopTimer();
        }
      });
    } catch (e, stack) {
      developer.log("Error in timerForAssignedOrder", error: e, stackTrace: stack);
      stopTimer();
    }
  }

  void startSecondsTimer(int seconds) {
    try {
      remainingSeconds.value = seconds;

      timer?.cancel(); // Cancel any existing timer

      timer = Timer.periodic(Duration(seconds: 1), (timer) {
        try {
          if (remainingSeconds.value <= 1) {
            timer.cancel();
            stopTimer();
            // Optionally: handle timeout (e.g., auto-reject)
          } else {
            remainingSeconds.value--;
          }
        } catch (e, stack) {
          developer.log("Error in startSecondsTimer", error: e, stackTrace: stack);

          timer.cancel();
        }
      });
    } catch (e, stack) {
      developer.log("Error in startSecondsTimer", error: e, stackTrace: stack);
    }
  }

  void stopTimer() {
    try {
      timer?.cancel();
      remainingSeconds.value = 0;
    } catch (e, stack) {
      developer.log("Error in stopTimer", error: e, stackTrace: stack);
    }
  }

  String formatSeconds(int seconds) {
    try {
      final minutes = (seconds ~/ 60).toString();
      final secs = (seconds % 60).toString().padLeft(2, '0');
      return "$minutes:$secs";
    } catch (e, stack) {
      developer.log("Error in formatSeconds", error: e, stackTrace: stack);
      return "00:00";
    }
  }
}
