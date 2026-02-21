// ignore_for_file: deprecated_member_use, depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:restaurant/app/models/cart_model.dart';
import 'package:restaurant/app/models/order_model.dart';
import 'package:restaurant/app/models/user_model.dart';
import 'package:restaurant/app/models/wallet_transaction_model.dart';
import 'package:restaurant/app/modules/driver_order_assign/views/driver_order_assign_view.dart';
import 'package:restaurant/app/modules/home/controllers/home_controller.dart';
import 'package:restaurant/app/modules/order_detail_screen/views/order_detail_screen_view.dart';
import 'package:restaurant/app/widget/global_widgets.dart';
import 'package:restaurant/app/widget/text_widget.dart';
import 'package:restaurant/constant/constant.dart';
import 'package:restaurant/constant/order_status.dart';
import 'package:restaurant/constant/send_notification.dart';
import 'package:restaurant/constant_widgets/container_custom.dart';
import 'package:restaurant/constant_widgets/round_shape_button.dart';
import 'package:restaurant/themes/app_fonts.dart';
import 'package:restaurant/themes/app_theme_data.dart';
import 'package:restaurant/themes/screen_size.dart';
import 'package:restaurant/utils/dark_theme_provider.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:restaurant/utils/fire_store_utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NewOrderWidget extends StatelessWidget {
  const NewOrderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetX(
        init: HomeController(),
        builder: (controller) {
          return Scaffold(
            backgroundColor: Colors.transparent,
            body: controller.isLoading.value
                ? Constant.loader()
                : controller.newOrderList.isEmpty
                    ? Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            spaceH(height: 40.h),
                            Image.asset(
                              "assets/animation/no_new_orders.gif",
                              height: 98,
                              width: 98,
                            ),
                            spaceH(height: 12.h),
                            Padding(
                                padding: paddingEdgeInsets(horizontal: 48, vertical: 0),
                                child: TextCustom(
                                  title: 'No New Orders'.tr,
                                  fontSize: 20,
                                  fontFamily: FontFamily.bold,
                                )),
                            spaceH(height: 4),
                            Padding(
                              padding: paddingEdgeInsets(horizontal: 48, vertical: 0),
                              child: TextCustom(
                                title: 'There are currently no new orders to display.'.tr,
                                fontSize: 14,
                                maxLine: 2,
                              ),
                            ),
                            spaceH(height: 50.h),
                          ],
                        ),
                      )
                    : ListView.builder(
                        itemCount: controller.newOrderList.length,
                        physics: AlwaysScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          OrderModel pendingOrder = controller.newOrderList[index];
                          return GestureDetector(
                            onTap: () {
                              Get.to(() => OrderDetailScreenView(), arguments: {'BookingModel': pendingOrder});
                            },
                            child: ContainerCustom(
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      TextCustom(
                                        title: Constant.timestampToDateWithTime(pendingOrder.createdAt!),
                                        color: themeChange.isDarkTheme() ? AppThemeData.grey400 : AppThemeData.grey600,
                                      ),
                                      TextCustom(
                                        title: Constant.showId(pendingOrder.id.toString()),
                                        color: themeChange.isDarkTheme() ? AppThemeData.grey400 : AppThemeData.grey600,
                                        isUnderLine: true,
                                      ),
                                    ],
                                  ),
                                  spaceH(height: 12.h),
                                  ListView.builder(
                                    shrinkWrap: true,
                                    physics: const NeverScrollableScrollPhysics(),
                                    itemCount: pendingOrder.items!.length,
                                    itemBuilder: (context, index) {
                                      CartModel cartModel = pendingOrder.items![index];
                                      return Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          SvgPicture.asset(
                                            "assets/icons/ic_veg.svg",
                                            color: AppThemeData.success300,
                                          ),
                                          spaceW(width: 5),
                                          TextCustom(
                                            title: '${cartModel.quantity}x ',
                                            color: themeChange.isDarkTheme() ? AppThemeData.grey50 : AppThemeData.grey1000,
                                            fontFamily: FontFamily.bold,
                                            fontSize: 16,
                                          ),
                                          SizedBox(
                                            width: 180.w,
                                            child: TextCustom(
                                              title: cartModel.productName!,
                                              color: themeChange.isDarkTheme() ? AppThemeData.grey50 : AppThemeData.grey1000,
                                              fontFamily: FontFamily.bold,
                                              textAlign: TextAlign.start,
                                              fontSize: 16,
                                            ),
                                          ),
                                          const Spacer(),
                                          TextCustom(
                                            title: Constant.amountShow(amount: cartModel.totalAmount.toString()),
                                            color: themeChange.isDarkTheme() ? AppThemeData.grey50 : AppThemeData.grey1000,
                                            fontFamily: FontFamily.medium,
                                            fontSize: 16,
                                          ),
                                        ],
                                      );
                                    },
                                  ),
                                  spaceH(height: 12.h),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: TextCustom(
                                          title: 'Set food preparation time'.tr,
                                          color: AppThemeData.secondary300,
                                        ),
                                      ),
                                      Container(
                                        padding: paddingEdgeInsets(horizontal: 12, vertical: 12),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(12),
                                          color: themeChange.isDarkTheme() ? AppThemeData.grey1000 : AppThemeData.grey50,
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            GestureDetector(
                                              onTap: () {
                                                if (controller.minutes.value > 0) {
                                                  controller.minutes.value -= 5;
                                                }
                                              },
                                              child: SvgPicture.asset(
                                                "assets/icons/ic_minus.svg",
                                                color: themeChange.isDarkTheme() ? AppThemeData.grey200 : AppThemeData.grey900,
                                              ),
                                            ),
                                            spaceW(width: 8),
                                            Obx(
                                              () => TextCustom(
                                                title: "${controller.minutes.value} mins",
                                                color: themeChange.isDarkTheme() ? AppThemeData.grey200 : AppThemeData.grey900,
                                              ),
                                            ),
                                            spaceW(width: 8.w),
                                            GestureDetector(
                                              onTap: () {
                                                controller.minutes.value += 5;
                                              },
                                              child: SvgPicture.asset(
                                                "assets/icons/ic_plus.svg",
                                                color: themeChange.isDarkTheme() ? AppThemeData.grey200 : AppThemeData.grey900,
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                  Padding(
                                      padding: paddingEdgeInsets(vertical: 12, horizontal: 12),
                                      child: Divider(color: themeChange.isDarkTheme() ? AppThemeData.grey800 : AppThemeData.grey200)),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: RoundShapeButton(
                                          title: "Reject".tr,
                                          buttonColor: AppThemeData.danger300,
                                          buttonTextColor: AppThemeData.primaryWhite,
                                          onTap: () async {
                                            pendingOrder.orderStatus = OrderStatus.orderRejected;
                                            controller.updateOrder(pendingOrder);
                                            UserModel? userModel = await FireStoreUtils.getCustomerUserProfile(pendingOrder.customerId.toString());
                                            Map<String, dynamic> payLoad = <String, dynamic>{"orderId": pendingOrder.id};
                                            await SendNotification.sendOneNotification(
                                                senderId: FireStoreUtils.getCurrentUid(),
                                                customerId: userModel!.id.toString(),
                                                token: userModel.fcmToken.toString(),
                                                title: "Order Rejected by Restaurant",
                                                orderId: pendingOrder.id.toString(),
                                                body: 'Your Order #${pendingOrder.id.toString().substring(0, 5)} has been Rejected by Restaurant.',
                                                type: 'order',
                                                payload: payLoad,
                                                isNewOrder: false);
                                            if (pendingOrder.paymentStatus == true) {
                                              WalletTransactionModel userTransactionModel = WalletTransactionModel(
                                                  id: Constant.getUuid(),
                                                  amount: pendingOrder.totalAmount.toString(),
                                                  createdDate: Timestamp.now(),
                                                  paymentType: 'Wallet',
                                                  transactionId: pendingOrder.id,
                                                  isCredit: true,
                                                  type: "user",
                                                  userId: pendingOrder.customerId!.toString(),
                                                  note: "Order Cancelled");

                                              await FireStoreUtils.setWalletTransaction(userTransactionModel).then((value) async {
                                                if (value == true) {
                                                  await FireStoreUtils.updateUserWallet(
                                                      amount: "+${pendingOrder.totalAmount.toString()}", customerId: pendingOrder.customerId!.toString());
                                                }
                                              });
                                            }
                                            controller.newOrderList.remove(pendingOrder);
                                          },
                                          size: Size(157.w, ScreenSize.height(6, context)),
                                        ),
                                      ),
                                      spaceW(width: 12.w),
                                      Expanded(
                                        child: RoundShapeButton(
                                          title: "Accept".tr,
                                          buttonColor: AppThemeData.success300,
                                          buttonTextColor: AppThemeData.grey1000,
                                          onTap: () async {
                                            if (Constant.isSelfDelivery == true && Constant.vendorModel!.isSelfDelivery == true) {
                                              Get.to(DriverOrderAssignView(), arguments: {'OrderModel': pendingOrder, 'preparationTime': controller.minutes.value});
                                            } else {
                                              pendingOrder.orderStatus = OrderStatus.orderAccepted;
                                              pendingOrder.foodIsReadyToPickup = false;
                                              pendingOrder.preparationTime = controller.minutes.value.toString();
                                              controller.updateOrder(pendingOrder);

                                              UserModel? userModel = await FireStoreUtils.getCustomerUserProfile(pendingOrder.customerId.toString());
                                              Map<String, dynamic> payLoad = <String, dynamic>{"orderId": pendingOrder.id};
                                              await SendNotification.sendOneNotification(
                                                  senderId: FireStoreUtils.getCurrentUid(),
                                                  customerId: userModel!.id.toString(),
                                                  token: userModel.fcmToken.toString(),
                                                  orderId: pendingOrder.id.toString(),
                                                  title: "Order Accepted by Restaurant",
                                                  body: 'Your Order #${pendingOrder.id.toString().substring(0, 5)} has been Accepted by Restaurant.',
                                                  type: 'order',
                                                  payload: payLoad,
                                                  isNewOrder: false);

                                              controller.newOrderList.remove(pendingOrder);
                                            }
                                          },
                                          size: Size(157.w, ScreenSize.height(6, context)),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        }),
          );
        });
  }
}
