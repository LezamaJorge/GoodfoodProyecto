// ignore_for_file: deprecated_member_use, depend_on_referenced_packages

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dash/flutter_dash.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';
import 'package:restaurant/app/models/cart_model.dart';
import 'package:restaurant/app/models/driver_user_model.dart';
import 'package:restaurant/app/models/tax_model.dart';
import 'package:restaurant/app/widget/global_widgets.dart';
import 'package:restaurant/app/widget/network_image_widget.dart';
import 'package:restaurant/app/widget/text_widget.dart';
import 'package:restaurant/constant/constant.dart';
import 'package:restaurant/constant_widgets/container_custom.dart';
import 'package:restaurant/constant_widgets/pick_drop_point_view.dart';
import 'package:restaurant/themes/app_fonts.dart';
import 'package:restaurant/themes/app_theme_data.dart';
import 'package:restaurant/utils/dark_theme_provider.dart';
import 'package:restaurant/utils/fire_store_utils.dart';
import 'package:url_launcher/url_launcher.dart';
import '../controllers/order_detail_screen_controller.dart';
import 'widget/price_row_view.dart';
import 'package:restaurant/themes/responsive.dart' as responsive_ui;

class OrderDetailScreenView extends GetView<OrderDetailScreenController> {
  const OrderDetailScreenView({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetBuilder<OrderDetailScreenController>(
      init: OrderDetailScreenController(),
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
              actions: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextButton.icon(
                    onPressed: () {
                       controller.printTicket();
                    },
                    icon: const Icon(Icons.print),
                    label: const Text("Print"),
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.greenAccent,
                      foregroundColor: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
            body: SingleChildScrollView(
              child: Obx(
                () => Padding(
                  padding: paddingEdgeInsets(),
                  child: controller.isLoading.value
                      ? Center(child: Constant.loader())
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextCustom(
                              title: "Order Details".tr,
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
                            spaceH(height: 32.h),
                            TextCustom(
                              title: "Item Details".tr,
                              color: themeChange.isDarkTheme() ? AppThemeData.grey100 : AppThemeData.grey900,
                              fontFamily: FontFamily.medium,
                              fontSize: 16,
                            ),
                            spaceH(height: 12),
                            ContainerCustom(
                              child: ListView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: controller.bookingModel.value.items!.length,
                                itemBuilder: (context, index) {
                                  CartModel cartModel = controller.bookingModel.value.items![index];
                                  return Column(
                                    children: [
                                      Row(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          SvgPicture.asset(
                                            "assets/icons/ic_veg.svg",
                                            color: AppThemeData.success300,
                                          ),
                                          spaceW(width: 4.h),
                                          TextCustom(
                                            title: '${cartModel.quantity}x ',
                                            color: themeChange.isDarkTheme() ? AppThemeData.grey50 : AppThemeData.grey1000,
                                            fontFamily: FontFamily.bold,
                                            fontSize: 16,
                                          ),
                                          SizedBox(
                                            width: 195.w,
                                            child: TextCustom(
                                              textAlign: TextAlign.start,
                                              title: cartModel.productName!,
                                              color: themeChange.isDarkTheme() ? AppThemeData.grey50 : AppThemeData.grey1000,
                                              fontFamily: FontFamily.bold,
                                              fontSize: 16,
                                              maxLine: 3,
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
                                      ),
                                      if (cartModel.variation != null && cartModel.variation!.optionList != null && cartModel.variation!.optionList!.isNotEmpty)
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            if (cartModel.variation!.optionList!.first.name != null && cartModel.variation!.optionList!.first.name!.isNotEmpty)
                                              TextCustom(
                                                title: '${cartModel.variation!.name}: ',
                                                color: themeChange.isDarkTheme() ? AppThemeData.grey400 : AppThemeData.grey600,
                                                fontSize: 14,
                                                fontFamily: FontFamily.regular,
                                              ),
                                            spaceW(width: 4),
                                            if (cartModel.variation!.optionList!.first.name != null && cartModel.variation!.optionList!.first.name!.isNotEmpty)
                                              Expanded(
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    TextCustom(
                                                      title: cartModel.variation!.optionList!.first.name.toString(),
                                                      color: themeChange.isDarkTheme() ? AppThemeData.grey50 : AppThemeData.grey1000,
                                                      fontSize: 14,
                                                      fontFamily: FontFamily.regular,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                          ],
                                        ),
                                      if (cartModel.addOns != null && cartModel.addOns!.isNotEmpty)
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            TextCustom(
                                              title: "Addons:",
                                              color: themeChange.isDarkTheme() ? AppThemeData.grey400 : AppThemeData.grey600,
                                              fontSize: 14,
                                              fontFamily: FontFamily.regular,
                                            ),
                                            spaceW(width: 4),
                                            Expanded(
                                              child: cartModel.addOns != null && cartModel.addOns!.isNotEmpty
                                                  ? TextCustom(
                                                      title: cartModel.addOns!.map((addon) => addon['name'].toString()).join(', '),
                                                      color: themeChange.isDarkTheme() ? AppThemeData.grey50 : AppThemeData.grey1000,
                                                      fontSize: 14,
                                                      fontFamily: FontFamily.regular,
                                                      textAlign: TextAlign.start,
                                                    )
                                                  : SizedBox(),
                                            ),
                                          ],
                                        ),
                                      if (index != controller.bookingModel.value.items!.length - 1) spaceH(height: 4)
                                    ],
                                  );
                                },
                              ),
                            ),
                            spaceH(height: 24.h),
                            TextCustom(
                              title: "Order Details".tr,
                              color: themeChange.isDarkTheme() ? AppThemeData.grey100 : AppThemeData.grey900,
                              fontFamily: FontFamily.medium,
                              fontSize: 16,
                            ),
                            spaceH(height: 12.h),
                            ContainerCustom(
                                child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    TextCustom(
                                      title: "Order ID".tr,
                                      color: themeChange.isDarkTheme() ? AppThemeData.grey400 : AppThemeData.grey600,
                                      fontSize: 16,
                                      fontFamily: FontFamily.medium,
                                    ),
                                    TextCustom(
                                      title: Constant.showId(controller.bookingModel.value.id.toString()),
                                      color: themeChange.isDarkTheme() ? AppThemeData.grey100 : AppThemeData.grey900,
                                      fontSize: 16,
                                      fontFamily: FontFamily.medium,
                                    ),
                                  ],
                                ),
                                spaceH(height: 8.h),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    TextCustom(
                                      title: "Date".tr,
                                      color: themeChange.isDarkTheme() ? AppThemeData.grey400 : AppThemeData.grey600,
                                      fontSize: 16,
                                      fontFamily: FontFamily.medium,
                                    ),
                                    TextCustom(
                                      title: Constant.timestampToDateWithTime(controller.bookingModel.value.createdAt!),
                                      color: themeChange.isDarkTheme() ? AppThemeData.grey100 : AppThemeData.grey900,
                                      fontSize: 16,
                                      fontFamily: FontFamily.medium,
                                    ),
                                  ],
                                ),
                                spaceH(height: 8.h),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    TextCustom(
                                      title: "Payment".tr,
                                      color: themeChange.isDarkTheme() ? AppThemeData.grey400 : AppThemeData.grey600,
                                      fontSize: 16,
                                      fontFamily: FontFamily.medium,
                                    ),
                                    TextCustom(
                                      title: controller.bookingModel.value.paymentType!,
                                      color: themeChange.isDarkTheme() ? AppThemeData.grey100 : AppThemeData.grey900,
                                      fontSize: 16,
                                      fontFamily: FontFamily.medium,
                                    ),
                                  ],
                                ),
                                spaceH(height: 8.h),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    TextCustom(
                                      title: "Delivery Type".tr,
                                      fontSize: 16,
                                      textAlign: TextAlign.start,
                                      fontFamily: FontFamily.medium,
                                      color: themeChange.isDarkTheme() ? AppThemeData.grey400 : AppThemeData.grey600,
                                    ),
                                    const Spacer(),
                                    TextCustom(
                                      title: controller.bookingModel.value.deliveryType == 'take_away' ? 'Take Away' : 'Home Delivery',
                                      fontSize: 16,
                                      fontFamily: FontFamily.medium,
                                      color: themeChange.isDarkTheme() ? AppThemeData.grey100 : AppThemeData.grey900,
                                    ),
                                  ],
                                ),
                              ],
                            )),
                            spaceH(height: 24.h),
                            TextCustom(
                              title: "Delivery Address".tr,
                              color: themeChange.isDarkTheme() ? AppThemeData.grey100 : AppThemeData.grey900,
                              fontFamily: FontFamily.medium,
                              fontSize: 16,
                            ),
                            spaceH(height: 12.h),
                            PickDropPointView(
                                pickUpAddress: Constant.vendorModel!.address!.address!,
                                dropOutAddress: "${controller.bookingModel.value.customerAddress!.address!} ${controller.bookingModel.value.customerAddress!.locality!}"),
                            spaceH(height: 24.h),
                            TextCustom(
                              title: "Customer Details".tr,
                              fontSize: 16,
                              fontFamily: FontFamily.medium,
                              color: themeChange.isDarkTheme() ? AppThemeData.grey50 : AppThemeData.grey1000,
                            ),
                            spaceH(height: 8.h),
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration:
                                  BoxDecoration(borderRadius: BorderRadius.circular(12), color: themeChange.isDarkTheme() ? AppThemeData.surface1000 : AppThemeData.surface50),
                              child: Row(
                                children: [
                                  SizedBox(
                                      height: 46.w,
                                      width: 46.w,
                                      child: NetworkImageWidget(
                                        borderRadius: 2000,
                                        imageUrl: controller.customerUserModel.value.profilePic!,
                                        isProfile: true,
                                      )),
                                  spaceW(width: 8),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      TextCustom(
                                        title: "${controller.customerUserModel.value.firstName!} ${controller.customerUserModel.value.lastName} ",
                                        fontSize: 16,
                                        fontFamily: FontFamily.bold,
                                        color: themeChange.isDarkTheme() ? AppThemeData.grey100 : AppThemeData.grey900,
                                      ),
                                      TextCustom(
                                        title: "${controller.customerUserModel.value.countryCode!} ${controller.customerUserModel.value.phoneNumber!}",
                                        fontSize: 14,
                                        fontFamily: FontFamily.regular,
                                        color: themeChange.isDarkTheme() ? AppThemeData.grey400 : AppThemeData.grey600,
                                      )
                                    ],
                                  ),
                                  const Spacer(),
                                  GestureDetector(
                                    onTap: () async {
                                      String phoneNumber = controller.customerUserModel.value.phoneNumber!;
                                      String countryCode = controller.customerUserModel.value.countryCode!;

                                      if (phoneNumber.startsWith(countryCode)) {
                                        phoneNumber = phoneNumber.substring(countryCode.length);
                                      }

                                      final Uri launchUri = Uri(
                                        scheme: 'tel',
                                        path: phoneNumber,
                                      );
                                      if (await canLaunchUrl(launchUri)) {
                                        await launchUrl(launchUri);
                                      } else {
                                        if (kDebugMode) {}
                                      }
                                    },
                                    child: Container(
                                      height: 46.w,
                                      width: 46.w,
                                      padding: paddingEdgeInsets(vertical: 8, horizontal: 8),
                                      decoration: BoxDecoration(color: AppThemeData.primary300, shape: BoxShape.circle),
                                      child: SvgPicture.asset("assets/icons/ic_call.svg", color: themeChange.isDarkTheme() ? AppThemeData.primaryWhite : AppThemeData.primaryWhite),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            if (controller.bookingModel.value.driverId != null && controller.bookingModel.value.driverId!.isNotEmpty)
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  spaceH(height: 18),
                                  TextCustom(
                                    title: "Driver Details".tr,
                                    fontSize: 16,
                                    fontFamily: FontFamily.medium,
                                    color: themeChange.isDarkTheme() ? AppThemeData.grey50 : AppThemeData.grey1000,
                                  ),
                                  spaceH(height: 8),
                                  ContainerCustom(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        FutureBuilder<DriverUserModel?>(
                                          future: FireStoreUtils.getDriverUserProfile(controller.bookingModel.value.driverId ?? ''),
                                          builder: (context, snapshot) {
                                            if (!snapshot.hasData) {
                                              return Container();
                                            }
                                            DriverUserModel driverUserModel = snapshot.data ?? DriverUserModel();
                                            return Row(
                                              children: [
                                                Expanded(
                                                  child: Row(
                                                    mainAxisSize: MainAxisSize.min,
                                                    children: [
                                                      SizedBox(
                                                          height: 45.h,
                                                          width: 45.h,
                                                          child: NetworkImageWidget(
                                                            imageUrl: driverUserModel.profileImage.toString(),
                                                            borderRadius: 50,
                                                          )),
                                                      spaceW(width: 8),
                                                      Expanded(
                                                        child: Column(
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          children: [
                                                            TextCustom(
                                                              title: driverUserModel.fullNameString().toString(),
                                                              fontSize: 16,
                                                              fontFamily: FontFamily.bold,
                                                              textAlign: TextAlign.start,
                                                              color: themeChange.isDarkTheme() ? AppThemeData.grey100 : AppThemeData.grey900,
                                                            ),
                                                            TextCustom(
                                                              title: "${driverUserModel.countryCode!.toString()} ${driverUserModel.phoneNumber}",
                                                              fontSize: 14,
                                                              maxLine: 1,
                                                              textOverflow: TextOverflow.ellipsis,
                                                              textAlign: TextAlign.start,
                                                              fontFamily: FontFamily.regular,
                                                              color: themeChange.isDarkTheme() ? AppThemeData.grey100 : AppThemeData.grey900,
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                spaceW(width: 8),
                                                GestureDetector(
                                                  onTap: () async {
                                                    final fullPhoneNumber = '${driverUserModel.countryCode}${driverUserModel.phoneNumber}';
                                                    final url = 'tel:$fullPhoneNumber';
                                                    if (await canLaunch(url)) {
                                                      await launch(url);
                                                    } else {}
                                                  },
                                                  child: Container(
                                                    height: 46.w,
                                                    width: 46.w,
                                                    padding: paddingEdgeInsets(vertical: 8, horizontal: 8),
                                                    decoration: BoxDecoration(color: AppThemeData.primary300, shape: BoxShape.circle),
                                                    child: SvgPicture.asset("assets/icons/ic_call.svg",
                                                        color: themeChange.isDarkTheme() ? AppThemeData.primaryWhite : AppThemeData.primaryWhite),
                                                  ),
                                                )
                                              ],
                                            );
                                          },
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(left: 50),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            children: [
                                              SvgPicture.asset("assets/icons/ic_star.svg"),
                                              spaceW(width: 4),
                                              TextCustom(
                                                title: Constant.calculateReview(
                                                    reviewCount: controller.driverModel.value.reviewCount, reviewSum: controller.driverModel.value.reviewSum),
                                                fontSize: 14,
                                                fontFamily: FontFamily.regular,
                                                color: themeChange.isDarkTheme() ? AppThemeData.grey50 : AppThemeData.grey1000,
                                              ),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            spaceH(height: 24),
                            TextCustom(
                              title: "Bill Details".tr,
                              fontSize: 16,
                              fontFamily: FontFamily.medium,
                              color: themeChange.isDarkTheme() ? AppThemeData.grey50 : AppThemeData.grey1000,
                            ),
                            spaceH(height: 8.h),
                            Obx(
                              () => ContainerCustom(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    PriceRowView(
                                        title: "Item Total".tr,
                                        price: Constant.amountShow(amount: controller.bookingModel.value.subTotal),
                                        priceColor: themeChange.isDarkTheme() ? AppThemeData.grey100 : AppThemeData.grey900,
                                        titleColor: const Color(0xff656565)),
                                    spaceH(height: 12),
                                    controller.bookingModel.value.deliveryCharge == '0'
                                        ? PriceRowView(title: "Delivery Fee".tr, price: "Free", priceColor: AppThemeData.secondary300, titleColor: const Color(0xff656565))
                                        : PriceRowView(
                                            title: "Delivery Fee".tr,
                                            price: Constant.amountShow(amount: controller.bookingModel.value.deliveryCharge.toString()),
                                            priceColor: AppThemeData.secondary300,
                                            titleColor: const Color(0xff656565)),
                                    spaceH(height: 12),
                                    PriceRowView(
                                        title: "Discount".tr,
                                        price: controller.bookingModel.value.discount == "" || controller.bookingModel.value.discount == null
                                            ? Constant.amountShow(amount: "00")
                                            : Constant.amountShow(amount: controller.bookingModel.value.discount.toString()),
                                        priceColor: themeChange.isDarkTheme() ? AppThemeData.success200 : AppThemeData.success400,
                                        titleColor: const Color(0xff656565)),
                                    spaceH(height: 12),
                                    ListView.builder(
                                        physics: const NeverScrollableScrollPhysics(),
                                        shrinkWrap: true,
                                        itemCount: controller.bookingModel.value.taxList!.length,
                                        itemBuilder: (context, index) {
                                          TaxModel taxModel = controller.bookingModel.value.taxList![index];
                                          return PriceRowView(
                                              price: Constant.amountShow(
                                                  amount: Constant.calculateTax(amount: Constant.amountBeforeTax(controller.bookingModel.value).toString(), taxModel: taxModel)
                                                      .toString()),
                                              title: "${taxModel.name} (${taxModel.isFix == true ? Constant.amountShow(amount: taxModel.value) : "${taxModel.value}%"})",
                                              priceColor: themeChange.isDarkTheme() ? AppThemeData.grey100 : AppThemeData.grey900,
                                              titleColor: const Color(0xff656565));
                                        }),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 8),
                                      child: Dash(
                                        length: 320.w,
                                        direction: Axis.horizontal,
                                        dashColor: themeChange.isDarkTheme() ? AppThemeData.grey700 : AppThemeData.grey300,
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        TextCustom(
                                          title: "Total".tr,
                                          fontSize: 16,
                                          textAlign: TextAlign.start,
                                          fontFamily: FontFamily.regular,
                                          color: AppThemeData.orange300,
                                        ),
                                        const Spacer(),
                                        TextCustom(
                                          title: Constant.amountShow(amount: controller.bookingModel.value.totalAmount),
                                          fontSize: 16,
                                          fontFamily: FontFamily.bold,
                                          color: AppThemeData.orange300,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
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
