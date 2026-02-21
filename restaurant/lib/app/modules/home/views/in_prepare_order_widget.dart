// ignore_for_file: deprecated_member_use, depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:restaurant/app/models/cart_model.dart';
import 'package:restaurant/app/models/driver_user_model.dart';
import 'package:restaurant/app/models/order_model.dart';
import 'package:restaurant/app/models/user_model.dart';
import 'package:restaurant/app/models/vendor_model.dart';
import 'package:restaurant/app/modules/home/controllers/home_controller.dart';
import 'package:restaurant/app/modules/order_detail_screen/views/order_detail_screen_view.dart';
import 'package:restaurant/app/widget/global_widgets.dart';
import 'package:restaurant/app/widget/network_image_widget.dart';
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
import 'package:restaurant/utils/fire_store_utils.dart';
import 'package:flutter_svg/flutter_svg.dart';

class InPrepareOrderWidget extends StatelessWidget {
  const InPrepareOrderWidget({super.key});

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
                : controller.preparingOrderList.isEmpty
                    ? Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            spaceH(height: 24.h),
                            Image.asset(
                              "assets/animation/no_order_in_preparation_animation.gif",
                              height: 98,
                              width: 98,
                            ),
                            spaceH(height: 12),
                            Padding(
                                padding: paddingEdgeInsets(horizontal: 48, vertical: 0),
                                child: TextCustom(
                                  title: 'No Orders for Pickup'.tr,
                                  fontSize: 20,
                                  fontFamily: FontFamily.bold,
                                )),
                            spaceH(height: 4.h),
                            Padding(
                              padding: paddingEdgeInsets(horizontal: 48, vertical: 0),
                              child: TextCustom(
                                title: 'There are no orders available for pickup right now.'.tr,
                                fontSize: 14,
                                maxLine: 2,
                              ),
                            ),
                            spaceH(height: 50.h),
                          ],
                        ),
                      )
                    : ListView.builder(
                        scrollDirection: Axis.vertical,
                        physics: AlwaysScrollableScrollPhysics(),
                        itemCount: controller.preparingOrderList.length,
                        itemBuilder: (context, index) {
                          OrderModel bookingModel = controller.preparingOrderList[index];
                          return GestureDetector(
                            onTap: () {
                              Get.to(() => OrderDetailScreenView(), arguments: {'BookingModel': bookingModel});
                            },
                            child: ContainerCustom(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Align(
                                      alignment: Alignment.centerRight,
                                      child: Container(
                                        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(8), color: OrderStatus.getOrderStatusBackgroundColor(bookingModel.orderStatus.toString(), context)),
                                        child: TextCustom(
                                          title: OrderStatus.getOrderStatusTitle(bookingModel.orderStatus.toString()),
                                          color: OrderStatus.getOrderStatusTitleColor(bookingModel.orderStatus.toString(), context),
                                        ),
                                      )),
                                  spaceH(height: 8.h),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      TextCustom(
                                        title: Constant.timestampToDateWithTime(bookingModel.createdAt!),
                                        color: themeChange.isDarkTheme() ? AppThemeData.grey400 : AppThemeData.grey600,
                                      ),
                                      TextCustom(
                                        title: Constant.showId(bookingModel.id.toString()),
                                        color: themeChange.isDarkTheme() ? AppThemeData.grey400 : AppThemeData.grey600,
                                        isUnderLine: true,
                                      ),
                                    ],
                                  ),
                                  spaceH(height: 12.h),
                                  ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: bookingModel.items!.length,
                                    physics: const NeverScrollableScrollPhysics(),
                                    itemBuilder: (context, index) {
                                      CartModel cartModel = bookingModel.items![index];
                                      return Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisAlignment: MainAxisAlignment.start,
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
                                  bookingModel.driverId != null && bookingModel.driverId != ''
                                      ? TextCustom(
                                          title: 'Driver has assigned...'.tr,
                                          fontSize: 12,
                                          color: AppThemeData.info300,
                                        )
                                      : SizedBox(),
                                  spaceH(height: 4.h),
                                  FutureBuilder<UserModel?>(
                                    future: FireStoreUtils.getCustomerUserProfile(bookingModel.customerId!),
                                    builder: (context, AsyncSnapshot<UserModel?> snapshot) {
                                      if (!snapshot.hasData) {
                                        return Container();
                                      }
                                      UserModel customerUserModel = snapshot.data!;
                                      return Container(
                                        padding: const EdgeInsets.all(16),
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(12), color: themeChange.isDarkTheme() ? AppThemeData.surface1000 : AppThemeData.surface50),
                                        child: Row(
                                          children: [
                                            SizedBox(
                                                height: 46.w,
                                                width: 46.w,
                                                child: NetworkImageWidget(
                                                  borderRadius: 2000,
                                                  imageUrl: customerUserModel.profilePic!,
                                                  isProfile: true,
                                                )),
                                            spaceW(width: 12),
                                            TextCustom(
                                              title: "${customerUserModel.firstName!} ${customerUserModel.lastName}",
                                              fontSize: 16,
                                              fontFamily: FontFamily.medium,
                                              color: themeChange.isDarkTheme() ? AppThemeData.grey100 : AppThemeData.grey900,
                                            ),
                                            const Spacer(),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                  bookingModel.orderStatus == OrderStatus.driverPickup
                                      ? const SizedBox()
                                      : RoundShapeButton(
                                          title: bookingModel.orderStatus == OrderStatus.orderAccepted ||
                                                  bookingModel.orderStatus == OrderStatus.driverAssigned ||
                                                  bookingModel.orderStatus == OrderStatus.driverAccepted ||
                                                  bookingModel.orderStatus == OrderStatus.driverRejected
                                              ? "Order Ready"
                                              : bookingModel.orderStatus == OrderStatus.orderOnReady
                                                  ? (bookingModel.deliveryType == "take_away" ? "Complete Order" : "Pickup")
                                                  : "On Going",
                                          buttonColor: AppThemeData.primary300,
                                          buttonTextColor: AppThemeData.primaryWhite,
                                          onTap: () async {
                                            if (bookingModel.orderStatus == OrderStatus.orderAccepted ||
                                                bookingModel.orderStatus == OrderStatus.driverAssigned ||
                                                bookingModel.orderStatus == OrderStatus.driverAccepted ||
                                                bookingModel.orderStatus == OrderStatus.driverRejected) {
                                              bookingModel.orderStatus = OrderStatus.orderOnReady;
                                              bookingModel.foodIsReadyToPickup = true;
                                              await controller.updateOrder(bookingModel);

                                              VendorModel? vendorModel = await FireStoreUtils.getRestaurant(bookingModel.vendorId.toString());
                                              if (bookingModel.deliveryType == "take_away") {
                                                UserModel? userModel = await FireStoreUtils.getCustomerUserProfile(bookingModel.customerId.toString());
                                                await SendNotification.sendOneNotification(
                                                    senderId: FireStoreUtils.getCurrentUid(),
                                                    customerId: bookingModel.customerId.toString(),
                                                    token: userModel?.fcmToken ?? "",
                                                    title: "Order Ready to Pickup ✅",
                                                    body: "Your take away order from ${vendorModel?.vendorName} is ready for pickup.",
                                                    type: 'order',
                                                    orderId: bookingModel.id.toString(),
                                                    payload: {"orderId": bookingModel.id},
                                                    isNewOrder: false);
                                              } else {
                                                DriverUserModel? driverModel = await FireStoreUtils.getDriverUserProfile(bookingModel.driverId.toString());
                                                await SendNotification.sendOneNotification(
                                                    senderId: FireStoreUtils.getCurrentUid(),
                                                    driverId: driverModel!.driverId.toString(),
                                                    token: driverModel.fcmToken.toString(),
                                                    title: "Order Ready to Pickup ✅",
                                                    body: 'The order from ${vendorModel!.vendorName} is ready for pickup.',
                                                    type: 'order',
                                                    orderId: bookingModel.id.toString(),
                                                    payload: {"orderId": bookingModel.id},
                                                    isNewOrder: false);
                                              }
                                              controller.update();
                                            } else if (bookingModel.orderStatus == OrderStatus.orderOnReady) {
                                              if (bookingModel.deliveryType == "take_away") {
                                                bookingModel.orderStatus = OrderStatus.orderComplete;
                                                controller.orderModel.value.paymentStatus = true;
                                                await controller.updateOrder(bookingModel);

                                                await controller.addPaymentInWalletForRestaurant(bookingModel);

                                                UserModel? userModel = await FireStoreUtils.getCustomerUserProfile(bookingModel.customerId.toString());
                                                VendorModel? vendorModel = await FireStoreUtils.getRestaurant(bookingModel.vendorId.toString());
                                                await SendNotification.sendOneNotification(
                                                    senderId: FireStoreUtils.getCurrentUid(),
                                                    customerId: bookingModel.customerId.toString(),
                                                    token: userModel?.fcmToken ?? "",
                                                    title: "Order Completed ✅",
                                                    body: "Your take away order from ${vendorModel?.vendorName} has been picked up. Enjoy your meal!",
                                                    type: 'order',
                                                    orderId: bookingModel.id.toString(),
                                                    payload: {"orderId": bookingModel.id},
                                                    isNewOrder: false);

                                                controller.update();
                                              }
                                            }
                                          },
                                          size: Size(326.w, ScreenSize.height(6, context)),
                                        )
                                ],
                              ),
                            ),
                          );
                        }),
          );
        });
  }
}
