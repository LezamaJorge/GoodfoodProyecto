
// ignore_for_file: deprecated_member_use, depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:restaurant/app/models/order_model.dart';
import 'package:restaurant/app/modules/order_detail_screen/views/order_detail_screen_view.dart';
import 'package:restaurant/constant/order_status.dart';
import 'package:restaurant/themes/responsive.dart' as responsive_ui;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';
import 'package:restaurant/app/models/cart_model.dart';
import 'package:restaurant/app/modules/order_screen/controllers/order_screen_controller.dart';
import 'package:restaurant/app/widget/global_widgets.dart';
import 'package:restaurant/app/widget/text_widget.dart';
import 'package:restaurant/constant/constant.dart';
import 'package:restaurant/constant_widgets/container_custom.dart';
import 'package:restaurant/constant_widgets/round_shape_button.dart';
import 'package:restaurant/themes/app_fonts.dart';
import 'package:restaurant/themes/app_theme_data.dart';
import 'package:restaurant/utils/dark_theme_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../constant/send_notification.dart';
import '../../../../themes/screen_size.dart';
import '../../../../utils/fire_store_utils.dart';
import '../../../models/user_model.dart';
import '../../../models/wallet_transaction_model.dart';

class OrderScreenView extends GetView<OrderScreenController> {
  const OrderScreenView({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetBuilder<OrderScreenController>(
      init: OrderScreenController(),
      builder: (controller) {
        return Container(
          width: responsive_ui.Responsive.width(100, context),
          height: responsive_ui.Responsive.height(100, context),
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  stops: const [0.1, 0.3],
                  colors: themeChange.isDarkTheme() ? [const Color(0xff1C1C22), const Color(0xff1C1C22)] : [const Color(0xffFDE7E7), const Color(0xffFFFFFF)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter)),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              systemOverlayStyle: const SystemUiOverlayStyle(
                statusBarColor: Colors.transparent,
                statusBarIconBrightness: Brightness.dark, // Android → black
                statusBarBrightness: Brightness.light,    // iOS → black
              ),
              backgroundColor: Colors.transparent,
              surfaceTintColor: Colors.transparent,
              automaticallyImplyLeading: false,
              leading: GestureDetector(
                onTap: () {
                  Get.back();
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: themeChange.isDarkTheme() ? AppThemeData.grey900 : AppThemeData.grey100,
                    ),
                    child: Icon(
                      Icons.arrow_back_ios_sharp,
                      size: 20,
                      color: themeChange.isDarkTheme() ? AppThemeData.grey100 : AppThemeData.grey900,
                    ),
                  ),
                ),
              ),
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: paddingEdgeInsets(),
                child: Obx(
                  () => Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextCustom(
                            title: "New Orders".tr,
                            fontSize: 28,
                            maxLine: 2,
                            color: themeChange.isDarkTheme() ? AppThemeData.grey100 : AppThemeData.grey1000,
                            fontFamily: FontFamily.bold,
                            textAlign: TextAlign.start,
                          ),
                          2.height,
                          TextCustom(
                            title: "View the full details of the customer’s order below.".tr,
                            fontSize: 16,
                            maxLine: 2,
                            color: themeChange.isDarkTheme() ? AppThemeData.grey400 : AppThemeData.grey600,
                            fontFamily: FontFamily.regular,
                            textAlign: TextAlign.start,
                          ),
                        ],
                      ),
                      controller.isLoading.value
                          ? Constant.loader()
                          : controller.bookedOrderList.isEmpty
                              ? Column(
                                  children: [
                                    spaceH(height: 28),
                                    Image.asset(
                                      "assets/animation/no_new_orders.gif",
                                      height: 98,
                                      width: 98,
                                    ),
                                    spaceH(height: 12),
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
                                )
                              : SingleChildScrollView(
                                  child: ListView.builder(
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    itemCount: controller.bookedOrderList.length,
                                    itemBuilder: (context, index) {
                                      OrderModel orderModel = controller.bookedOrderList[index];
                                      var minutes = 15.obs;
                                      return GestureDetector(
                                        onTap: () {
                                          Get.to(()=>OrderDetailScreenView(), arguments: {'BookingModel': orderModel});
                                        },
                                        child: ContainerCustom(
                                          padding: EdgeInsets.all(16),
                                          child: Column(
                                            children: [
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  TextCustom(
                                                    title: Constant.timestampToDateWithTime(orderModel.createdAt!),
                                                    color: themeChange.isDarkTheme() ? AppThemeData.grey400 : AppThemeData.grey600,
                                                  ),
                                                  TextCustom(
                                                    title: Constant.showId(orderModel.id.toString()),
                                                    color: themeChange.isDarkTheme() ? AppThemeData.grey400 : AppThemeData.grey600,
                                                    isUnderLine: true,
                                                  ),
                                                ],
                                              ),
                                              spaceH(height: 12),
                                              ListView.builder(
                                                shrinkWrap: true,
                                                itemCount: orderModel.items!.length,
                                                itemBuilder: (context, index) {
                                                  CartModel cartModel = orderModel.items![index];
                                                  return Row(
                                                    children: [
                                                      Expanded(
                                                        flex: 3,
                                                        child: Row(
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
                                                            Flexible(
                                                              child: TextCustom(
                                                                title: cartModel.productName!,
                                                                color: themeChange.isDarkTheme() ? AppThemeData.grey50 : AppThemeData.grey1000,
                                                                fontFamily: FontFamily.bold,
                                                                fontSize: 16,
                                                                maxLine: 1,
                                                                textOverflow: TextOverflow.ellipsis,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      Expanded(
                                                        flex: 1,
                                                        child: TextCustom(
                                                          title: Constant.amountShow(amount: cartModel.totalAmount.toString()),
                                                          color: themeChange.isDarkTheme() ? AppThemeData.grey50 : AppThemeData.grey1000,
                                                          fontFamily: FontFamily.medium,
                                                          fontSize: 16,
                                                        ),
                                                      ),
                                                    ],
                                                  );
                                                },
                                              ),
                                              spaceH(height: 12),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  TextCustom(
                                                    title: 'Set food preparation time'.tr,
                                                    color: AppThemeData.secondary300,
                                                  ),
                                                  Container(
                                                    padding: paddingEdgeInsets(horizontal: 12, vertical: 12),
                                                    decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(12),
                                                      color: themeChange.isDarkTheme() ? AppThemeData.grey1000 : AppThemeData.grey50,
                                                    ),
                                                    child: Row(
                                                      children: [
                                                        GestureDetector(
                                                          onTap: () {
                                                            if (minutes.value > 0) {
                                                              minutes.value -= 5;
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
                                                            title: "${minutes.value} mins",
                                                            color: themeChange.isDarkTheme() ? AppThemeData.grey200 : AppThemeData.grey900,
                                                          ),
                                                        ),
                                                        spaceW(width: 8),
                                                        GestureDetector(
                                                          onTap: () {
                                                            minutes.value += 5;
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
                                                        orderModel.orderStatus = OrderStatus.orderRejected;
                                                        controller.updateOrder(orderModel);
                                                        UserModel? userModel = await FireStoreUtils.getCustomerUserProfile(controller.bookedOrderList.first.customerId.toString());
                                                        Map<String, dynamic> payLoad = <String, dynamic>{"orderId": controller.bookedOrderList.first.id};
                                                        await SendNotification.sendOneNotification(
                                                            senderId: FireStoreUtils.getCurrentUid(),
                                                            customerId: userModel!.id.toString(),
                                                            token: userModel.fcmToken.toString(),
                                                            title: "Order Rejected by Restaurant",
                                                            orderId: controller.bookedOrderList.first.id.toString(),
                                                            body: 'Your Order #${controller.bookedOrderList.first.id.toString().substring(0, 5)} has been Rejected by Restaurant.',
                                                            type: 'order',
                                                            payload: payLoad,isNewOrder: false);

                                                        if (controller.bookedOrderList.first.paymentStatus == true) {
                                                          WalletTransactionModel userTransactionModel = WalletTransactionModel(
                                                              id: Constant.getUuid(),
                                                              amount: controller.bookedOrderList.first.totalAmount.toString(),
                                                              createdDate: Timestamp.now(),
                                                              paymentType: 'Wallet',
                                                              transactionId: controller.bookedOrderList.first.id,
                                                              isCredit: true,
                                                              type: "user",
                                                              userId: controller.bookedOrderList.first.customerId!.toString(),
                                                              note: "Order Cancelled");

                                                          await FireStoreUtils.setWalletTransaction(userTransactionModel).then((value) async {
                                                            if (value == true) {
                                                              await FireStoreUtils.updateUserWallet(
                                                                  amount: "+${controller.bookedOrderList.first.totalAmount.toString()}",
                                                                  customerId: controller.bookedOrderList.first.customerId!.toString());
                                                            }
                                                          });
                                                        }

                                                        controller.bookedOrderList.removeAt(index);
                                                      },
                                                      size: Size(157.w, ScreenSize.height(6, context)),
                                                    ),
                                                  ),
                                                  spaceW(width: 12),
                                                  Expanded(
                                                    child: RoundShapeButton(
                                                      title: "Accept".tr,
                                                      buttonColor: AppThemeData.success300,
                                                      buttonTextColor: AppThemeData.grey1000,
                                                      onTap: () async {
                                                        orderModel.orderStatus = OrderStatus.orderAccepted;
                                                        controller.bookedOrderList.first.foodIsReadyToPickup = false;
                                                        orderModel.preparationTime = minutes.value.toString();
                                                        controller.updateOrder(orderModel);

                                                        UserModel? userModel = await FireStoreUtils.getCustomerUserProfile(controller.bookedOrderList.first.customerId.toString());
                                                        Map<String, dynamic> payLoad = <String, dynamic>{"orderId": controller.bookedOrderList.first.id};
                                                        await SendNotification.sendOneNotification(
                                                            senderId: FireStoreUtils.getCurrentUid(),
                                                            customerId: userModel!.id.toString(),
                                                            token: userModel.fcmToken.toString(),
                                                            orderId: controller.bookedOrderList.first.id.toString(),
                                                            title: "Order Accepted by Restaurant",
                                                            body: 'Your Order #${controller.bookedOrderList.first.id.toString().substring(0, 5)} has been Accepted by Restaurant.',
                                                            type: 'order',
                                                            payload: payLoad,isNewOrder: false);

                                                        controller.bookedOrderList.removeAt(index);
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
                                    },
                                  ),
                                ),
                      spaceH(height: 24),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
