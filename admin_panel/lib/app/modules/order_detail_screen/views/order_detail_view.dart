// ignore_for_file: deprecated_member_use

import 'package:admin_panel/app/components/menu_widget.dart';
import 'package:admin_panel/app/components/network_image_widget.dart';
import 'package:admin_panel/app/constant/constants.dart';
import 'package:admin_panel/app/constant/order_status.dart';
import 'package:admin_panel/app/models/product_model.dart';
import 'package:admin_panel/app/models/tax_model.dart';
import 'package:admin_panel/app/modules/order_detail_screen/controllers/order_detail_controller.dart';
import 'package:admin_panel/app/utils/app_colors.dart';
import 'package:admin_panel/app/utils/app_them_data.dart';
import 'package:admin_panel/app/utils/dark_theme_provider.dart';
import 'package:admin_panel/app/utils/fire_store_utils.dart';
import 'package:admin_panel/app/utils/responsive.dart';
import 'package:admin_panel/widget/common_ui.dart';
import 'package:admin_panel/widget/container_custom.dart';
import 'package:admin_panel/widget/global_widgets.dart';
import 'package:admin_panel/widget/gradient_text.dart';
import 'package:admin_panel/widget/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';
import 'package:timelines_plus/timelines_plus.dart';
import '../../../routes/app_pages.dart';
import 'widget/price_row_view.dart';

class OrderDetailView extends GetView<OrderDetailController> {
  const OrderDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetX<OrderDetailController>(
      init: OrderDetailController(),
      builder: (controller) {
        return Scaffold(
          backgroundColor: themeChange.isDarkTheme() ? AppThemeData.lynch950 : AppThemeData.lynch50,
          // appBar: CommonUI.appBarCustom(themeChange: themeChange, scaffoldKey: controller.scaffoldKey),
          appBar: AppBar(
            elevation: 0.0,
            toolbarHeight: 70,
            automaticallyImplyLeading: false,
            backgroundColor: themeChange.isDarkTheme() ? AppThemeData.primaryBlack : AppThemeData.primaryWhite,
            leadingWidth: 200,
            // title: title,
            leading: Builder(
              builder: (BuildContext context) {
                return GestureDetector(
                  onTap: () {
                    if (!ResponsiveWidget.isDesktop(context)) {
                      Scaffold.of(context).openDrawer();
                    }
                  },
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: !ResponsiveWidget.isDesktop(context)
                        ? Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: Icon(
                              Icons.menu,
                              size: 30,
                              color: themeChange.isDarkTheme() ? AppThemeData.primary500 : AppThemeData.primary500,
                            ),
                          )
                        : SizedBox(
                            height: 45,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Image.asset(
                                  "assets/image/logo.png",
                                  height: 34,
                                ),
                                spaceW(),
                                GradientText(
                                  TextCustom(
                                    title: '${Constant.appName}',
                                    color: AppThemeData.primary500,
                                    fontSize: 25,
                                    fontFamily: FontFamily.titleBold,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  gradient: AppThemeData.primaryGradient,
                                ),
                              ],
                            ),
                          ),
                  ),
                );
              },
            ),
            actions: [
              InkWell(
                onTap: () {
                  if (themeChange.darkTheme == 1) {
                    themeChange.darkTheme = 0;
                  } else if (themeChange.darkTheme == 0) {
                    themeChange.darkTheme = 1;
                  } else if (themeChange.darkTheme == 2) {
                    themeChange.darkTheme = 0;
                  } else {
                    themeChange.darkTheme = 2;
                  }
                },
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(color: themeChange.isDarkTheme() ? AppThemeData.lynch950 : AppThemeData.lynch50),
                  child: themeChange.isDarkTheme()
                      ? SvgPicture.asset(
                          "assets/icons/ic_sun.svg",
                          color: themeChange.isDarkTheme() ? AppThemeData.lynch200 : AppThemeData.lynch800,
                          height: 20,
                          width: 20,
                        )
                      : SvgPicture.asset(
                          "assets/icons/ic_moon.svg",
                          color: themeChange.isDarkTheme() ? AppThemeData.lynch200 : AppThemeData.lynch800,
                          height: 20,
                          width: 20,
                        ),
                ),
              ),
              spaceW(),
              const LanguagePopUp(),
              spaceW(),
              ProfilePopUp()
            ],
          ),
          drawer: Drawer(
            width: 270,
            backgroundColor: themeChange.isDarkTheme() ? AppThemeData.primaryBlack : AppThemeData.primaryWhite,
            child: const MenuWidget(),
          ),
          // drawer: CommonUI.drawerCustom(scaffoldKey: controller.scaffoldKey, themeChange: themeChange),
          body: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (ResponsiveWidget.isDesktop(context)) ...{const MenuWidget()},
              Expanded(
                child: Padding(
                  padding: paddingEdgeInsets(),
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ContainerCustom(
                          child: Column(
                            children: [
                              ResponsiveWidget.isDesktop(context)
                                  ? Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                          TextCustom(title: controller.title.value, fontSize: 20, fontFamily: FontFamily.bold),
                                          spaceH(height: 2),
                                          Row(children: [
                                            InkWell(
                                                onTap: () => Get.offAllNamed(Routes.DASHBOARD_SCREEN),
                                                child: TextCustom(title: 'Dashboard'.tr, fontSize: 14, fontFamily: FontFamily.medium, color: AppThemeData.lynch500)),
                                            const TextCustom(title: ' / ', fontSize: 14, fontFamily: FontFamily.medium, color: AppThemeData.lynch500),
                                            InkWell(
                                                onTap: () => Get.offAllNamed(Routes.ORDERS),
                                                child: TextCustom(title: 'Orders'.tr, fontSize: 14, fontFamily: FontFamily.medium, color: AppThemeData.lynch500)),
                                            const TextCustom(title: ' / ', fontSize: 14, fontFamily: FontFamily.medium, color: AppThemeData.lynch500),
                                            TextCustom(title: ' ${controller.title.value} ', fontSize: 14, fontFamily: FontFamily.medium, color: AppThemeData.primary500)
                                          ])
                                        ]),
                                      ],
                                    )
                                  : Column(mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.start, children: [
                                      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                        TextCustom(title: controller.title.value, fontSize: 20, fontFamily: FontFamily.bold),
                                        spaceH(height: 2),
                                        Row(children: [
                                          InkWell(
                                              onTap: () => Get.offAllNamed(Routes.DASHBOARD_SCREEN),
                                              child: TextCustom(title: 'Dashboard'.tr, fontSize: 14, fontFamily: FontFamily.medium, color: AppThemeData.lynch500)),
                                          const TextCustom(title: ' / ', fontSize: 14, fontFamily: FontFamily.medium, color: AppThemeData.lynch500),
                                          InkWell(
                                              onTap: () => Get.offAllNamed(Routes.ORDERS),
                                              child: TextCustom(title: 'Orders'.tr, fontSize: 14, fontFamily: FontFamily.medium, color: AppThemeData.lynch500)),
                                          const TextCustom(title: ' / ', fontSize: 14, fontFamily: FontFamily.medium, color: AppThemeData.lynch500),
                                          TextCustom(title: ' ${controller.title.value} ', fontSize: 14, fontFamily: FontFamily.medium, color: AppThemeData.primary500)
                                        ])
                                      ]),
                                    ]),
                              spaceH(height: 20),
                              ResponsiveWidget(
                                mobile: controller.isLoading.value
                                    ? Constant.loader()
                                    : Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(
                                              color: themeChange.isDarkTheme() ? AppThemeData.lynch950 : AppThemeData.lynch50,
                                              borderRadius: BorderRadius.circular(10),
                                            ),
                                            child: Padding(
                                              padding: paddingEdgeInsets(horizontal: 20, vertical: 20),
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      TextCustom(
                                                          title: "Order ID #${controller.bookingModel.value.id!.substring(0, 4)}".tr, fontSize: 18, fontFamily: FontFamily.bold),
                                                      spaceH(height: 2),
                                                      TextCustom(
                                                          title:
                                                              "${Constant.timestampToDate(controller.bookingModel.value.createdAt!)} at ${Constant.timestampToTime(controller.bookingModel.value.createdAt!)}",
                                                          fontSize: 14,
                                                          fontFamily: FontFamily.medium),
                                                    ],
                                                  ),
                                                  spaceH(),
                                                  Constant.bookingStatusText(context, controller.bookingModel.value.orderStatus.toString()),
                                                  spaceH(height: 24),
                                                  Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      TextCustom(
                                                        title: "Item Summary".tr,
                                                        fontSize: 16,
                                                        fontFamily: FontFamily.bold,
                                                      ),
                                                      spaceH(height: 16),
                                                      SingleChildScrollView(
                                                        scrollDirection: Axis.horizontal,
                                                        child: ClipRRect(
                                                          borderRadius: BorderRadius.circular(12),
                                                          child: DataTable(
                                                            horizontalMargin: 20,
                                                            columnSpacing: 30,
                                                            dataRowMaxHeight: 65,
                                                            headingRowHeight: 65,
                                                            border: TableBorder.all(
                                                              color: themeChange.isDarkTheme() ? AppThemeData.lynch800 : AppThemeData.lynch100,
                                                              borderRadius: BorderRadius.circular(12),
                                                            ),
                                                            headingRowColor:
                                                                WidgetStateColor.resolveWith((states) => themeChange.isDarkTheme() ? AppThemeData.lynch800 : AppThemeData.lynch100),
                                                            columns: [
                                                              CommonUI.dataColumnWidget(context, columnTitle: "Id".tr, width: 100),
                                                              CommonUI.dataColumnWidget(context,
                                                                  columnTitle: "Items".tr,
                                                                  width: ResponsiveWidget.isMobile(context) ? 150 : MediaQuery.of(context).size.width * 0.15),
                                                              CommonUI.dataColumnWidget(context,
                                                                  columnTitle: "Qty".tr,
                                                                  width: ResponsiveWidget.isMobile(context) ? 150 : MediaQuery.of(context).size.width * 0.07),
                                                              CommonUI.dataColumnWidget(context,
                                                                  columnTitle: "Price".tr,
                                                                  width: ResponsiveWidget.isMobile(context) ? 150 : MediaQuery.of(context).size.width * 0.07),
                                                              CommonUI.dataColumnWidget(context,
                                                                  columnTitle: "Total Price".tr,
                                                                  width: ResponsiveWidget.isMobile(context) ? 150 : MediaQuery.of(context).size.width * 0.07),
                                                            ],
                                                            rows: controller.bookingModel.value.items!
                                                                .map((cartItem) => DataRow(cells: [
                                                                      DataCell(TextCustom(
                                                                          title: "${controller.bookingModel.value.items!.indexWhere((element) => element == cartItem) + 1}")),
                                                                      DataCell(Row(
                                                                        children: [
                                                                          FutureBuilder(
                                                                              future: FireStoreUtils.getProductByProductId(cartItem.productId.toString()),
                                                                              builder: (context, snapshot) {
                                                                                if (!snapshot.hasData) {
                                                                                  return Container();
                                                                                }
                                                                                ProductModel product = snapshot.data ?? ProductModel();
                                                                                return NetworkImageWidget(
                                                                                  imageUrl: product.productImage.toString(),
                                                                                  height: 24,
                                                                                  width: 24,
                                                                                  borderRadius: 0,
                                                                                );
                                                                              }),
                                                                          spaceW(),
                                                                          TextCustom(title: cartItem.productName.toString()),
                                                                        ],
                                                                      )),
                                                                      DataCell(TextCustom(title: cartItem.quantity.toString())),
                                                                      DataCell(TextCustom(title: Constant.amountShow(amount: cartItem.itemPrice.toString()))),
                                                                      DataCell(TextCustom(title: Constant.amountShow(amount: cartItem.totalAmount.toString()))),
                                                                    ]))
                                                                .toList(),
                                                          ),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                  spaceH(height: 24),
                                                  TextCustom(
                                                    title: "Customer Details".tr,
                                                    fontSize: 16,
                                                    fontFamily: FontFamily.bold,
                                                  ),
                                                  spaceH(height: 10),
                                                  Container(
                                                    padding: const EdgeInsets.all(16),
                                                    decoration: ShapeDecoration(
                                                      color: themeChange.isDarkTheme() ? AppThemeData.lynch950 : AppThemeData.lynch25,
                                                      shape: RoundedRectangleBorder(
                                                        borderRadius: BorderRadius.circular(12),
                                                      ),
                                                    ),
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        rowDetailsWidget(
                                                            icon: 'assets/icons/ic_id.svg',
                                                            name: 'Id'.tr,
                                                            value: '#${controller.userModel.value.id!.substring(0, 5)}',
                                                            themeChange: themeChange),
                                                        spaceH(height: 8),
                                                        rowDetailsWidget(
                                                            icon: 'assets/icons/ic_user.svg',
                                                            name: 'Name',
                                                            value: controller.userModel.value.fullNameString(),
                                                            themeChange: themeChange),
                                                        spaceH(height: 8),
                                                        rowDetailsWidget(
                                                            icon: 'assets/icons/ic_call.svg',
                                                            name: 'Phone Number',
                                                            value: Constant.maskMobileNumber(
                                                                countryCode: controller.userModel.value.countryCode.toString(),
                                                                mobileNumber: controller.userModel.value.phoneNumber.toString()),
                                                            themeChange: themeChange),
                                                      ],
                                                    ),
                                                  ),
                                                  if (controller.driverModel.value.driverId != null)
                                                    Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                                      TextCustom(
                                                        title: "Driver Details".tr,
                                                        fontSize: 16,
                                                        fontFamily: FontFamily.bold,
                                                      ),
                                                      spaceH(height: 10),
                                                      Container(
                                                        padding: const EdgeInsets.all(16),
                                                        decoration: ShapeDecoration(
                                                          color: themeChange.isDarkTheme() ? AppThemeData.lynch950 : AppThemeData.lynch25,
                                                          shape: RoundedRectangleBorder(
                                                            borderRadius: BorderRadius.circular(12),
                                                          ),
                                                        ),
                                                        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                                          rowDetailsWidget(
                                                              icon: 'assets/icons/ic_id.svg',
                                                              name: 'Id'.tr,
                                                              value: '#${controller.driverModel.value.driverId!.substring(0, 5)}',
                                                              themeChange: themeChange),
                                                          spaceH(height: 8),
                                                          rowDetailsWidget(
                                                              icon: 'assets/icons/ic_user.svg',
                                                              name: 'Name',
                                                              value: controller.driverModel.value.fullNameString(),
                                                              themeChange: themeChange),
                                                          spaceH(height: 8),
                                                          rowDetailsWidget(
                                                              icon: 'assets/icons/ic_call.svg',
                                                              name: 'Phone Number',
                                                              value: Constant.maskMobileNumber(
                                                                  countryCode: controller.driverModel.value.countryCode.toString(),
                                                                  mobileNumber: controller.driverModel.value.phoneNumber.toString()),
                                                              themeChange: themeChange),
                                                        ]),
                                                      ),
                                                    ]),
                                                  if (controller.bookingModel.value.orderStatus == OrderStatus.orderCancel)
                                                    Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                                      spaceH(height: 24),
                                                      TextCustom(
                                                        title: "Cancelled Reason".tr,
                                                        fontSize: 16,
                                                        fontFamily: FontFamily.bold,
                                                      ),
                                                      spaceH(height: 16),
                                                      TextCustom(
                                                          title: controller.bookingModel.value.cancelledReason.toString(),
                                                          fontSize: 14,
                                                          fontFamily: FontFamily.regular,
                                                          color: themeChange.isDarkTheme() ? AppThemeData.lynch400 : AppThemeData.lynch500),
                                                    ]),
                                                  spaceH(height: 24),
                                                  Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                                    TextCustom(
                                                      title: "Shipping Address".tr,
                                                      fontSize: 16,
                                                      fontFamily: FontFamily.bold,
                                                    ),
                                                    spaceH(height: 16),
                                                    Container(
                                                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                                                        decoration: BoxDecoration(
                                                            color: themeChange.isDarkTheme() ? AppThemeData.lynch950 : AppThemeData.lynch50,
                                                            borderRadius: BorderRadius.circular(10),
                                                            border: Border.all(color: themeChange.isDarkTheme() ? AppThemeData.lynch800 : AppThemeData.lynch100)),
                                                        child: Column(
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          children: [
                                                            Row(children: [
                                                              SvgPicture.asset(
                                                                  controller.bookingModel.value.customerAddress!.addressAs == "Home"
                                                                      ? "assets/icons/ic_home.svg"
                                                                      : controller.bookingModel.value.customerAddress!.addressAs == "Work"
                                                                          ? "assets/icons/ic_work.svg"
                                                                          : controller.bookingModel.value.customerAddress!.addressAs == "Friends and Family"
                                                                              ? "assets/icons/ic_user.svg"
                                                                              : "assets/icons/ic_location.svg",
                                                                  color: themeChange.isDarkTheme() ? AppThemeData.primaryWhite : AppThemeData.primaryBlack),
                                                              spaceW(width: 8),
                                                              TextCustom(
                                                                title: controller.bookingModel.value.customerAddress!.addressAs.toString(),
                                                                fontSize: 14,
                                                                fontFamily: FontFamily.medium,
                                                              ),
                                                            ]),
                                                            spaceH(height: 8),
                                                            TextCustom(
                                                              title: controller.bookingModel.value.customerAddress!.address.toString(),
                                                              fontSize: 14,
                                                              maxLine: 2,
                                                              fontFamily: FontFamily.regular,
                                                            ),
                                                            spaceH(height: 8),
                                                            TextCustom(
                                                              title: controller.userModel.value.fullNameString(),
                                                              fontSize: 14,
                                                              fontFamily: FontFamily.regular,
                                                            ),
                                                            spaceH(height: 8),
                                                            TextCustom(
                                                              title: Constant.maskMobileNumber(
                                                                  countryCode: controller.userModel.value.countryCode.toString(),
                                                                  mobileNumber: controller.userModel.value.phoneNumber.toString()),
                                                              fontSize: 14,
                                                              fontFamily: FontFamily.regular,
                                                            ),
                                                          ],
                                                        ))
                                                  ]),
                                                  spaceH(height: 24),
                                                  Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                                    TextCustom(
                                                      title: "Payment Details".tr,
                                                      fontSize: 16,
                                                      fontFamily: FontFamily.bold,
                                                    ),
                                                    spaceH(height: 12),
                                                    Row(mainAxisSize: MainAxisSize.min, mainAxisAlignment: MainAxisAlignment.start, children: [
                                                      Container(
                                                          height: 26.h,
                                                          width: 26.w,
                                                          decoration: BoxDecoration(
                                                              shape: BoxShape.circle, color: themeChange.isDarkTheme() ? AppThemeData.lynch800 : AppThemeData.lynch100),
                                                          child: (controller.bookingModel.value.paymentType == "Cash")
                                                              ? SvgPicture.asset("assets/icons/ic_cash.svg", height: 24, width: 24, fit: BoxFit.cover)
                                                              : (controller.bookingModel.value.paymentType == "Wallet")
                                                                  ? SvgPicture.asset(
                                                                      "assets/icons/ic_wallet.svg",
                                                                      height: 24,
                                                                      width: 24,
                                                                    )
                                                                  : (controller.bookingModel.value.paymentType == "Flutter Wave")
                                                                      ? Image.asset(
                                                                          "assets/image/ig_flutterwave.png",
                                                                          height: 24,
                                                                          width: 24,
                                                                        )
                                                                      : (controller.bookingModel.value.paymentType == "Razorpay")
                                                                          ? Image.asset(
                                                                              "assets/image/ig_razorpay.png",
                                                                              height: 24,
                                                                              width: 24,
                                                                            )
                                                                          : (controller.bookingModel.value.paymentType == "Paypal")
                                                                              ? Image.asset(
                                                                                  "assets/image/ig_paypal.png",
                                                                                  height: 24,
                                                                                  width: 24,
                                                                                )
                                                                              : (controller.bookingModel.value.paymentType == "Strip")
                                                                                  ? Image.asset(
                                                                                      "assets/image/ig_stripe.png",
                                                                                      height: 24,
                                                                                      width: 24,
                                                                                    )
                                                                                  : (controller.bookingModel.value.paymentType == "PayStack")
                                                                                      ? Image.asset(
                                                                                          "assets/image/ig_paystack.png",
                                                                                          height: 24,
                                                                                          width: 24,
                                                                                        )
                                                                                      : (controller.bookingModel.value.paymentType == "Mercado Pago")
                                                                                          ? Image.asset(
                                                                                              "assets/image/ig_marcadopago.png",
                                                                                              height: 24,
                                                                                              width: 24,
                                                                                            )
                                                                                          : (controller.bookingModel.value.paymentType == "payfast")
                                                                                              ? Image.asset(
                                                                                                  "assets/image/ig_payfast.png",
                                                                                                  height: 24,
                                                                                                  width: 24,
                                                                                                )
                                                                                              : SvgPicture.asset(
                                                                                                  "assets/icons/ic_cash.svg",
                                                                                                  height: 24,
                                                                                                  width: 24,
                                                                                                )),
                                                      spaceW(width: 12),
                                                      TextCustom(title: controller.bookingModel.value.paymentType.toString()),
                                                      const Spacer(),
                                                      Container(
                                                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                                                        decoration: BoxDecoration(
                                                          borderRadius: BorderRadius.circular(50),
                                                          color: controller.bookingModel.value.paymentStatus == true
                                                              ? themeChange.isDarkTheme()
                                                                  ? AppThemeData.success600
                                                                  : AppThemeData.success50
                                                              : themeChange.isDarkTheme()
                                                                  ? AppThemeData.danger600
                                                                  : AppThemeData.danger50,
                                                        ),
                                                        child: TextCustom(
                                                          title: controller.bookingModel.value.paymentStatus == true ? "Paid".tr : "Unpaid".tr,
                                                          color: controller.bookingModel.value.paymentStatus == true ? AppThemeData.success300 : AppThemeData.danger300,
                                                        ),
                                                      )
                                                    ])
                                                  ]),
                                                ],
                                              ),
                                            ),
                                          ),
                                          spaceH(height: 16),
                                          Container(
                                            padding: const EdgeInsets.all(20),
                                            decoration: ShapeDecoration(
                                              color: themeChange.isDarkTheme() ? AppThemeData.lynch900 : AppThemeData.lynch50,
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(12),
                                              ),
                                            ),
                                            child: Container(
                                              padding: const EdgeInsets.all(16),
                                              decoration: ShapeDecoration(
                                                color: themeChange.isDarkTheme() ? AppThemeData.lynch950 : AppThemeData.lynch25,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(12),
                                                ),
                                              ),
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  TextCustom(
                                                    title: "Order Status".tr,
                                                    fontSize: 16,
                                                    fontFamily: FontFamily.bold,
                                                  ),
                                                  spaceH(height: 16),
                                                  Timeline.tileBuilder(
                                                    physics: const NeverScrollableScrollPhysics(),
                                                    shrinkWrap: true,
                                                    theme: TimelineThemeData(
                                                      direction: Axis.vertical,
                                                      nodePosition: 0.1,
                                                      indicatorPosition: 0.5,
                                                    ),
                                                    builder: TimelineTileBuilder.connected(
                                                      itemCount: 5,
                                                      itemExtent: 80.0,
                                                      contentsAlign: ContentsAlign.basic,
                                                      indicatorBuilder: (context, index) {
                                                        return Container(
                                                            height: 40.h,
                                                            width: 40.w,
                                                            decoration: BoxDecoration(
                                                                shape: BoxShape.circle, color: themeChange.isDarkTheme() ? AppThemeData.lynch800 : AppThemeData.lynch100),
                                                            child: Center(
                                                                child: index == 0
                                                                    ? SvgPicture.asset(
                                                                        "assets/icons/order_received.svg",
                                                                        height: 24.h,
                                                                        color: controller.bookingModel.value.orderStatus == OrderStatus.driverAccepted ||
                                                                                controller.bookingModel.value.orderStatus == OrderStatus.orderAccepted ||
                                                                                controller.bookingModel.value.orderStatus == OrderStatus.driverPickup ||
                                                                                controller.bookingModel.value.orderStatus == OrderStatus.orderOnReady ||
                                                                                controller.bookingModel.value.orderStatus == OrderStatus.driverAssigned ||
                                                                                controller.bookingModel.value.orderStatus == OrderStatus.orderComplete ||
                                                                                controller.bookingModel.value.orderStatus == OrderStatus.orderPending
                                                                            ? AppThemeData.primary500
                                                                            : themeChange.isDarkTheme()
                                                                                ? AppThemeData.lynch400
                                                                                : AppThemeData.lynch500,
                                                                      )
                                                                    : index == 1
                                                                        ? SvgPicture.asset(
                                                                            "assets/icons/order_accepted.svg",
                                                                            height: 24.h,
                                                                            color: controller.bookingModel.value.orderStatus == OrderStatus.driverAccepted ||
                                                                                    controller.bookingModel.value.orderStatus == OrderStatus.orderAccepted ||
                                                                                    controller.bookingModel.value.orderStatus == OrderStatus.orderOnReady ||
                                                                                    controller.bookingModel.value.orderStatus == OrderStatus.driverAssigned ||
                                                                                    controller.bookingModel.value.orderStatus == OrderStatus.driverPickup ||
                                                                                    controller.bookingModel.value.orderStatus == OrderStatus.orderComplete
                                                                                ? AppThemeData.primary500
                                                                                : themeChange.isDarkTheme()
                                                                                    ? AppThemeData.lynch400
                                                                                    : AppThemeData.lynch500,
                                                                          )
                                                                        : index == 2
                                                                            ? SvgPicture.asset(
                                                                                "assets/icons/order_prepaid.svg",
                                                                                height: 24.h,
                                                                                color: controller.bookingModel.value.foodIsReadyToPickup == true
                                                                                    ? AppThemeData.primary500
                                                                                    : themeChange.isDarkTheme()
                                                                                        ? AppThemeData.lynch400
                                                                                        : AppThemeData.lynch500,
                                                                              )
                                                                            : index == 3
                                                                                ? SvgPicture.asset(
                                                                                    "assets/icons/order_pickup.svg",
                                                                                    color: controller.bookingModel.value.orderStatus == OrderStatus.driverPickup ||
                                                                                            controller.bookingModel.value.orderStatus == OrderStatus.orderComplete
                                                                                        ? AppThemeData.primary500
                                                                                        : themeChange.isDarkTheme()
                                                                                            ? AppThemeData.lynch400
                                                                                            : AppThemeData.lynch500,
                                                                                    height: 24.h,
                                                                                  )
                                                                                : SvgPicture.asset(
                                                                                    "assets/icons/order_delivered.svg",
                                                                                    height: 24.h,
                                                                                    color: controller.bookingModel.value.orderStatus == OrderStatus.orderComplete
                                                                                        ? AppThemeData.primary500
                                                                                        : themeChange.isDarkTheme()
                                                                                            ? AppThemeData.lynch400
                                                                                            : AppThemeData.lynch500,
                                                                                  )));
                                                      },
                                                      connectorBuilder: (context, index, connectorType) {
                                                        bool isConnectorActive = false;
                                                        if (index == 0) {
                                                          isConnectorActive = controller.bookingModel.value.orderStatus == OrderStatus.driverAccepted ||
                                                              controller.bookingModel.value.orderStatus == OrderStatus.orderAccepted ||
                                                              controller.bookingModel.value.orderStatus == OrderStatus.driverPickup ||
                                                              controller.bookingModel.value.orderStatus == OrderStatus.orderOnReady ||
                                                              controller.bookingModel.value.orderStatus == OrderStatus.driverAssigned ||
                                                              controller.bookingModel.value.orderStatus == OrderStatus.orderPending ||
                                                              controller.bookingModel.value.orderStatus == OrderStatus.orderComplete;
                                                        } else if (index == 1) {
                                                          isConnectorActive = controller.bookingModel.value.orderStatus == OrderStatus.driverAccepted ||
                                                              controller.bookingModel.value.orderStatus == OrderStatus.orderAccepted ||
                                                              controller.bookingModel.value.orderStatus == OrderStatus.orderOnReady ||
                                                              controller.bookingModel.value.orderStatus == OrderStatus.driverAssigned ||
                                                              controller.bookingModel.value.orderStatus == OrderStatus.driverPickup ||
                                                              controller.bookingModel.value.orderStatus == OrderStatus.orderComplete;
                                                        } else if (index == 2) {
                                                          isConnectorActive = controller.bookingModel.value.foodIsReadyToPickup == true;
                                                        } else if (index == 3) {
                                                          isConnectorActive = controller.bookingModel.value.orderStatus == OrderStatus.driverPickup ||
                                                              controller.bookingModel.value.orderStatus == OrderStatus.orderComplete;
                                                        }
                                                        return SolidLineConnector(
                                                          thickness: 2,
                                                          endIndent: 0,
                                                          color: isConnectorActive
                                                              ? AppThemeData.primary500 // Active connector color
                                                              : (themeChange.isDarkTheme()
                                                                  ? AppThemeData.lynch400 // Inactive dark theme
                                                                  : AppThemeData.lynch500),
                                                        );
                                                      },
                                                      contentsBuilder: (context, index) {
                                                        List<String> labels = ["Order Received", "Order Accepted", "Order Prepaid", "Order Pickup", "Order Delivered"];
                                                        bool isStatusActive = false;
                                                        if (index == 0) {
                                                          isStatusActive = controller.bookingModel.value.orderStatus == OrderStatus.driverAccepted ||
                                                              controller.bookingModel.value.orderStatus == OrderStatus.orderAccepted ||
                                                              controller.bookingModel.value.orderStatus == OrderStatus.driverPickup ||
                                                              controller.bookingModel.value.orderStatus == OrderStatus.orderOnReady ||
                                                              controller.bookingModel.value.orderStatus == OrderStatus.driverAssigned ||
                                                              controller.bookingModel.value.orderStatus == OrderStatus.orderPending ||
                                                              controller.bookingModel.value.orderStatus == OrderStatus.orderComplete;
                                                        } else if (index == 1) {
                                                          isStatusActive = controller.bookingModel.value.orderStatus == OrderStatus.driverAccepted ||
                                                              controller.bookingModel.value.orderStatus == OrderStatus.orderAccepted ||
                                                              controller.bookingModel.value.orderStatus == OrderStatus.orderOnReady ||
                                                              controller.bookingModel.value.orderStatus == OrderStatus.driverAssigned ||
                                                              controller.bookingModel.value.orderStatus == OrderStatus.driverPickup ||
                                                              controller.bookingModel.value.orderStatus == OrderStatus.orderComplete;
                                                        } else if (index == 2) {
                                                          isStatusActive = controller.bookingModel.value.foodIsReadyToPickup == true;
                                                        } else if (index == 3) {
                                                          isStatusActive = controller.bookingModel.value.orderStatus == OrderStatus.driverPickup ||
                                                              controller.bookingModel.value.orderStatus == OrderStatus.orderComplete;
                                                        } else {
                                                          isStatusActive = controller.bookingModel.value.orderStatus == OrderStatus.orderComplete;
                                                        }
                                                        return Padding(
                                                          padding: const EdgeInsets.symmetric(vertical: 8),
                                                          child: TextCustom(
                                                            title: labels[index],
                                                            fontSize: 14,
                                                            fontFamily: FontFamily.light,
                                                            color: isStatusActive
                                                                ? AppThemeData.primary500
                                                                : themeChange.isDarkTheme()
                                                                    ? AppThemeData.lynch400
                                                                    : AppThemeData.lynch500,
                                                          ),
                                                        );
                                                      },
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          spaceH(height: 16),
                                          Container(
                                            // width: Responsive.width(100, context),
                                            padding: const EdgeInsets.all(20),
                                            decoration: ShapeDecoration(
                                              color: themeChange.isDarkTheme() ? AppThemeData.lynch900 : AppThemeData.lynch50,
                                              // themeChange.getTheme() ? AppColors.primaryBlack : AppColors.primaryWhite,
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(12),
                                              ),
                                            ),
                                            child: Obx(
                                              () => Column(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  TextCustom(
                                                    title: "Order Summary".tr,
                                                    fontSize: 16,
                                                    fontFamily: FontFamily.bold,
                                                  ),
                                                  spaceH(height: 24),
                                                  PriceRowView(
                                                    price: Constant.amountShow(amount: controller.bookingModel.value.subTotal.toString()),
                                                    title: "Item Total".tr,
                                                    priceColor: themeChange.isDarkTheme() ? AppThemeData.lynch25 : AppThemeData.lynch950,
                                                    titleColor: themeChange.isDarkTheme() ? AppThemeData.lynch500 : AppThemeData.lynch400,
                                                  ),
                                                  const SizedBox(height: 16),
                                                  PriceRowView(
                                                    price: controller.bookingModel.value.deliveryCharge!.isEmpty
                                                        ? "Free"
                                                        : Constant.amountShow(amount: controller.bookingModel.value.deliveryCharge.toString()),
                                                    title: "Delivery Fee".tr,
                                                    priceColor: AppThemeData.accent300,
                                                    titleColor: themeChange.isDarkTheme() ? AppThemeData.lynch500 : AppThemeData.lynch400,
                                                  ),
                                                  const SizedBox(height: 16),
                                                  PriceRowView(
                                                      price: Constant.amountToShow(amount: controller.bookingModel.value.discount ?? '0.0'),
                                                      title: (controller.bookingModel.value.coupon?.code ?? '').isEmpty
                                                          ? "Discount".tr
                                                          : "Discount (${controller.bookingModel.value.coupon?.code ?? ""})".tr,
                                                      priceColor: themeChange.isDarkTheme() ? AppThemeData.success200 : AppThemeData.success400,
                                                      titleColor: themeChange.isDarkTheme() ? AppThemeData.lynch500 : AppThemeData.lynch400),
                                                  const SizedBox(height: 16),
                                                  ListView.builder(
                                                    physics: const NeverScrollableScrollPhysics(),
                                                    itemCount: controller.bookingModel.value.taxList!.length,
                                                    shrinkWrap: true,
                                                    itemBuilder: (context, index) {
                                                      TaxModel taxModel = controller.bookingModel.value.taxList![index];
                                                      return Column(
                                                        children: [
                                                          PriceRowView(
                                                              price: Constant.amountToShow(
                                                                  amount: Constant.calculateTax(
                                                                          amount: Constant.amountBeforeTax(controller.bookingModel.value).toString(), taxModel: taxModel)
                                                                      .toString()),
                                                              title:
                                                                  "${taxModel.name!} (${taxModel.isFix == true ? Constant.amountToShow(amount: taxModel.value) : "${taxModel.value}%"})",
                                                              priceColor: themeChange.isDarkTheme() ? AppThemeData.lynch25 : AppThemeData.lynch950,
                                                              titleColor: themeChange.isDarkTheme() ? AppThemeData.lynch500 : AppThemeData.lynch400),
                                                          const SizedBox(height: 16),
                                                        ],
                                                      );
                                                    },
                                                  ),
                                                  const SizedBox(height: 8),
                                                  Divider(color: themeChange.isDarkTheme() ? AppThemeData.lynch800 : AppThemeData.lynch950),
                                                  const SizedBox(height: 12),
                                                  PriceRowView(
                                                    price: Constant.amountShow(amount: Constant.calculateFinalAmount(controller.bookingModel.value).toString()),
                                                    title: "Total".tr,
                                                    priceColor: themeChange.isDarkTheme() ? AppThemeData.lynch25 : AppThemeData.lynch950,
                                                    titleColor: themeChange.isDarkTheme() ? AppThemeData.primaryWhite : AppThemeData.primaryBlack,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                tablet: controller.isLoading.value
                                    ? Constant.loader()
                                    : Column(
                                        children: [
                                          Row(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              Container(
                                                decoration: BoxDecoration(
                                                  color: themeChange.isDarkTheme() ? AppThemeData.lynch950 : AppThemeData.lynch50,
                                                  borderRadius: BorderRadius.circular(10),
                                                ),
                                                child: Padding(
                                                  padding: paddingEdgeInsets(horizontal: 20, vertical: 20),
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Row(
                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                        children: [
                                                          Column(
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            children: [
                                                              TextCustom(
                                                                  title: "Order ID # ${controller.bookingModel.value.id!.substring(0, 4)}".tr,
                                                                  fontSize: 18,
                                                                  fontFamily: FontFamily.bold),
                                                              spaceH(height: 2),
                                                              TextCustom(
                                                                title:
                                                                    "${Constant.timestampToDate(controller.bookingModel.value.createdAt!)} at ${Constant.timestampToTime(controller.bookingModel.value.createdAt!)}",
                                                                fontSize: 14,
                                                                fontFamily: FontFamily.regular,
                                                              ),
                                                            ],
                                                          ),
                                                          Constant.bookingStatusText(context, controller.bookingModel.value.orderStatus.toString()),
                                                        ],
                                                      ),
                                                      spaceH(height: 24),
                                                      Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          TextCustom(
                                                            title: "Item Summary".tr,
                                                            fontSize: 16,
                                                            fontFamily: FontFamily.bold,
                                                          ),
                                                          spaceH(height: 16),
                                                          SingleChildScrollView(
                                                            scrollDirection: Axis.horizontal,
                                                            child: ClipRRect(
                                                              borderRadius: BorderRadius.circular(12),
                                                              child: DataTable(
                                                                horizontalMargin: 20,
                                                                columnSpacing: 30,
                                                                dataRowMaxHeight: 65,
                                                                headingRowHeight: 65,
                                                                border: TableBorder.all(
                                                                  color: themeChange.isDarkTheme() ? AppThemeData.lynch800 : AppThemeData.lynch100,
                                                                  borderRadius: BorderRadius.circular(12),
                                                                ),
                                                                headingRowColor: WidgetStateColor.resolveWith(
                                                                    (states) => themeChange.isDarkTheme() ? AppThemeData.lynch800 : AppThemeData.lynch100),
                                                                columns: [
                                                                  CommonUI.dataColumnWidget(context, columnTitle: "Id".tr, width: 100),
                                                                  CommonUI.dataColumnWidget(context,
                                                                      columnTitle: "Items".tr,
                                                                      width: ResponsiveWidget.isMobile(context) ? 150 : MediaQuery.of(context).size.width * 0.15),
                                                                  CommonUI.dataColumnWidget(context,
                                                                      columnTitle: "Qty".tr,
                                                                      width: ResponsiveWidget.isMobile(context) ? 150 : MediaQuery.of(context).size.width * 0.07),
                                                                  CommonUI.dataColumnWidget(context,
                                                                      columnTitle: "Price".tr,
                                                                      width: ResponsiveWidget.isMobile(context) ? 150 : MediaQuery.of(context).size.width * 0.07),
                                                                  CommonUI.dataColumnWidget(context,
                                                                      columnTitle: "Total Price".tr,
                                                                      width: ResponsiveWidget.isMobile(context) ? 150 : MediaQuery.of(context).size.width * 0.07),
                                                                  // CommonUI.dataColumnWidget(context,
                                                                  //     columnTitle: "Action".tr,
                                                                  //     width: ResponsiveWidget.isMobile(context)
                                                                  //         ? 80
                                                                  //         : MediaQuery.of(context).size.width * 0.04),
                                                                ],
                                                                rows: controller.bookingModel.value.items!
                                                                    .map((cartItem) => DataRow(cells: [
                                                                          DataCell(TextCustom(
                                                                              title: "${controller.bookingModel.value.items!.indexWhere((element) => element == cartItem) + 1}")),
                                                                          DataCell(Row(
                                                                            children: [
                                                                              FutureBuilder(
                                                                                  future: FireStoreUtils.getProductByProductId(cartItem.productId.toString()),
                                                                                  builder: (context, snapshot) {
                                                                                    if (!snapshot.hasData) {
                                                                                      return Container();
                                                                                    }
                                                                                    ProductModel product = snapshot.data ?? ProductModel();
                                                                                    return NetworkImageWidget(
                                                                                      imageUrl: product.productImage.toString(),
                                                                                      height: 24,
                                                                                      width: 24,
                                                                                      borderRadius: 0,
                                                                                    );
                                                                                  }),
                                                                              spaceW(),
                                                                              TextCustom(title: cartItem.productName.toString()),
                                                                            ],
                                                                          )),
                                                                          DataCell(TextCustom(title: cartItem.quantity.toString())),
                                                                          DataCell(TextCustom(title: Constant.amountShow(amount: cartItem.itemPrice.toString()))),
                                                                          DataCell(TextCustom(title: Constant.amountShow(amount: cartItem.totalAmount.toString()))),
                                                                        ]))
                                                                    .toList(),
                                                              ),
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                      spaceH(height: 24),
                                                      TextCustom(
                                                        title: "Customer Details".tr,
                                                        fontSize: 16,
                                                        fontFamily: FontFamily.bold,
                                                      ),
                                                      spaceH(height: 16),
                                                      Container(
                                                        padding: const EdgeInsets.all(16),
                                                        decoration: ShapeDecoration(
                                                          color: themeChange.isDarkTheme() ? AppThemeData.lynch950 : AppThemeData.lynch25,
                                                          shape: RoundedRectangleBorder(
                                                            borderRadius: BorderRadius.circular(12),
                                                          ),
                                                        ),
                                                        child: Column(
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          children: [
                                                            rowDetailsWidget(
                                                                icon: 'assets/icons/ic_id.svg',
                                                                name: 'Id'.tr,
                                                                value: '#${controller.userModel.value.id!.substring(0, 5)}',
                                                                themeChange: themeChange),
                                                            spaceH(height: 8),
                                                            rowDetailsWidget(
                                                                icon: 'assets/icons/ic_user.svg',
                                                                name: 'Name',
                                                                value: controller.userModel.value.fullNameString(),
                                                                themeChange: themeChange),
                                                            spaceH(height: 8),
                                                            rowDetailsWidget(
                                                                icon: 'assets/icons/ic_call.svg',
                                                                name: 'Phone Number',
                                                                value: Constant.maskMobileNumber(
                                                                    countryCode: controller.userModel.value.countryCode.toString(),
                                                                    mobileNumber: controller.userModel.value.phoneNumber.toString()),
                                                                themeChange: themeChange),
                                                          ],
                                                        ),
                                                      ),
                                                      if (controller.driverModel.value.driverId != null)
                                                        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                                          TextCustom(
                                                            title: "Driver Details".tr,
                                                            fontSize: 16,
                                                            fontFamily: FontFamily.bold,
                                                          ),
                                                          spaceH(height: 16),
                                                          Container(
                                                            padding: const EdgeInsets.all(16),
                                                            decoration: ShapeDecoration(
                                                              color: themeChange.isDarkTheme() ? AppThemeData.lynch950 : AppThemeData.lynch25,
                                                              shape: RoundedRectangleBorder(
                                                                borderRadius: BorderRadius.circular(12),
                                                              ),
                                                            ),
                                                            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                                              rowDetailsWidget(
                                                                  icon: 'assets/icons/ic_id.svg',
                                                                  name: 'Id'.tr,
                                                                  value: '#${controller.driverModel.value.driverId!.substring(0, 5)}',
                                                                  themeChange: themeChange),
                                                              spaceH(height: 8),
                                                              rowDetailsWidget(
                                                                  icon: 'assets/icons/ic_user.svg',
                                                                  name: 'Name',
                                                                  value: controller.driverModel.value.fullNameString(),
                                                                  themeChange: themeChange),
                                                              spaceH(height: 8),
                                                              rowDetailsWidget(
                                                                  icon: 'assets/icons/ic_call.svg',
                                                                  name: 'Phone Number',
                                                                  value: Constant.maskMobileNumber(
                                                                      countryCode: controller.driverModel.value.countryCode.toString(),
                                                                      mobileNumber: controller.driverModel.value.phoneNumber.toString()),
                                                                  themeChange: themeChange),
                                                            ]),
                                                          ),
                                                        ]),
                                                      if (controller.bookingModel.value.orderStatus == OrderStatus.orderCancel)
                                                        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                                          spaceH(height: 24),
                                                          TextCustom(
                                                            title: "Cancelled Reason".tr,
                                                            fontSize: 16,
                                                            fontFamily: FontFamily.bold,
                                                          ),
                                                          spaceH(height: 16),
                                                          TextCustom(
                                                              title: controller.bookingModel.value.cancelledReason.toString(),
                                                              fontSize: 14,
                                                              fontFamily: FontFamily.regular,
                                                              color: themeChange.isDarkTheme() ? AppThemeData.lynch400 : AppThemeData.lynch500),
                                                        ]),
                                                      spaceH(height: 24),
                                                      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                                        TextCustom(
                                                          title: "Shipping Address".tr,
                                                          fontSize: 16,
                                                          fontFamily: FontFamily.bold,
                                                        ),
                                                        spaceH(height: 16),
                                                        Container(
                                                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                                                            decoration: BoxDecoration(
                                                                color: themeChange.isDarkTheme() ? AppThemeData.lynch950 : AppThemeData.lynch50,
                                                                borderRadius: BorderRadius.circular(10),
                                                                border: Border.all(color: themeChange.isDarkTheme() ? AppThemeData.lynch800 : AppThemeData.lynch100)),
                                                            child: Column(
                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                              children: [
                                                                Row(children: [
                                                                  SvgPicture.asset(
                                                                      controller.bookingModel.value.customerAddress!.addressAs == "Home"
                                                                          ? "assets/icons/ic_home.svg"
                                                                          : controller.bookingModel.value.customerAddress!.addressAs == "Work"
                                                                              ? "assets/icons/ic_work.svg"
                                                                              : controller.bookingModel.value.customerAddress!.addressAs == "Friends and Family"
                                                                                  ? "assets/icons/ic_user.svg"
                                                                                  : "assets/icons/ic_location.svg",
                                                                      color: themeChange.isDarkTheme() ? AppThemeData.primaryWhite : AppThemeData.primaryBlack),
                                                                  spaceW(width: 8),
                                                                  TextCustom(
                                                                    title: controller.bookingModel.value.customerAddress!.addressAs.toString(),
                                                                    fontSize: 14,
                                                                    fontFamily: FontFamily.medium,
                                                                  ),
                                                                ]),
                                                                spaceH(height: 8),
                                                                TextCustom(
                                                                  title: controller.bookingModel.value.customerAddress!.address.toString(),
                                                                  fontSize: 14,
                                                                  fontFamily: FontFamily.regular,
                                                                ),
                                                                spaceH(height: 8),
                                                                TextCustom(
                                                                  title: controller.userModel.value.fullNameString(),
                                                                  fontSize: 14,
                                                                  fontFamily: FontFamily.regular,
                                                                ),
                                                                spaceH(height: 8),
                                                                TextCustom(
                                                                  title: Constant.maskMobileNumber(
                                                                      countryCode: controller.userModel.value.countryCode.toString(),
                                                                      mobileNumber: controller.userModel.value.phoneNumber.toString()),
                                                                  fontSize: 14,
                                                                  fontFamily: FontFamily.regular,
                                                                ),
                                                              ],
                                                            ))
                                                      ]),
                                                      spaceH(height: 24),
                                                      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                                        TextCustom(
                                                          title: "Payment Details".tr,
                                                          fontSize: 16,
                                                          fontFamily: FontFamily.bold,
                                                        ),
                                                        spaceH(height: 16),
                                                        Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                                                          Container(
                                                              height: 26.h,
                                                              width: 26.w,
                                                              decoration: BoxDecoration(
                                                                  shape: BoxShape.circle, color: themeChange.isDarkTheme() ? AppThemeData.lynch800 : AppThemeData.lynch100),
                                                              child: (controller.bookingModel.value.paymentType == "Cash")
                                                                  ? SvgPicture.asset("assets/icons/ic_cash.svg", height: 24, width: 24, fit: BoxFit.cover)
                                                                  : (controller.bookingModel.value.paymentType == "Wallet")
                                                                      ? SvgPicture.asset(
                                                                          "assets/icons/ic_wallet.svg",
                                                                          height: 24,
                                                                          width: 24,
                                                                        )
                                                                      : (controller.bookingModel.value.paymentType == "Flutter Wave")
                                                                          ? Image.asset(
                                                                              "assets/image/ig_flutterwave.png",
                                                                              height: 24,
                                                                              width: 24,
                                                                            )
                                                                          : (controller.bookingModel.value.paymentType == "Razorpay")
                                                                              ? Image.asset(
                                                                                  "assets/image/ig_razorpay.png",
                                                                                  height: 24,
                                                                                  width: 24,
                                                                                )
                                                                              : (controller.bookingModel.value.paymentType == "Paypal")
                                                                                  ? Image.asset(
                                                                                      "assets/image/ig_paypal.png",
                                                                                      height: 24,
                                                                                      width: 24,
                                                                                    )
                                                                                  : (controller.bookingModel.value.paymentType == "Strip")
                                                                                      ? Image.asset(
                                                                                          "assets/image/ig_stripe.png",
                                                                                          height: 24,
                                                                                          width: 24,
                                                                                        )
                                                                                      : (controller.bookingModel.value.paymentType == "PayStack")
                                                                                          ? Image.asset(
                                                                                              "assets/image/ig_paystack.png",
                                                                                              height: 24,
                                                                                              width: 24,
                                                                                            )
                                                                                          : (controller.bookingModel.value.paymentType == "Mercado Pago")
                                                                                              ? Image.asset(
                                                                                                  "assets/image/ig_marcadopago.png",
                                                                                                  height: 24,
                                                                                                  width: 24,
                                                                                                )
                                                                                              : (controller.bookingModel.value.paymentType == "payfast")
                                                                                                  ? Image.asset(
                                                                                                      "assets/image/ig_payfast.png",
                                                                                                      height: 24,
                                                                                                      width: 24,
                                                                                                    )
                                                                                                  : SvgPicture.asset(
                                                                                                      "assets/icons/ic_cash.svg",
                                                                                                      height: 24,
                                                                                                      width: 24,
                                                                                                    )),
                                                          spaceW(width: 12),
                                                          TextCustom(title: controller.bookingModel.value.paymentType.toString(), fontSize: 14, fontFamily: FontFamily.regular),
                                                          const Spacer(),
                                                          Container(
                                                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                                                            decoration: BoxDecoration(
                                                              borderRadius: BorderRadius.circular(50),
                                                              color: controller.bookingModel.value.paymentStatus == true
                                                                  ? themeChange.isDarkTheme()
                                                                      ? AppThemeData.success600
                                                                      : AppThemeData.success50
                                                                  : themeChange.isDarkTheme()
                                                                      ? AppThemeData.danger600
                                                                      : AppThemeData.danger50,
                                                            ),
                                                            child: TextCustom(
                                                                title: controller.bookingModel.value.paymentStatus == true ? "Paid".tr : "Unpaid".tr,
                                                                color: controller.bookingModel.value.paymentStatus == true ? AppThemeData.success300 : AppThemeData.danger300,
                                                                fontSize: 12,
                                                                fontFamily: FontFamily.medium),
                                                          )
                                                        ])
                                                      ]),
                                                    ],
                                                  ),
                                                ),
                                              ).expand(flex: 2),
                                              spaceW(width: 20),
                                              Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Container(
                                                    padding: const EdgeInsets.all(20),
                                                    decoration: ShapeDecoration(
                                                      color: themeChange.isDarkTheme() ? AppThemeData.lynch900 : AppThemeData.lynch50,
                                                      shape: RoundedRectangleBorder(
                                                        borderRadius: BorderRadius.circular(12),
                                                      ),
                                                    ),
                                                    child: Container(
                                                        padding: const EdgeInsets.all(16),
                                                        decoration: ShapeDecoration(
                                                          color: themeChange.isDarkTheme() ? AppThemeData.lynch950 : AppThemeData.lynch25,
                                                          shape: RoundedRectangleBorder(
                                                            borderRadius: BorderRadius.circular(12),
                                                          ),
                                                        ),
                                                        child: Column(
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          children: [
                                                            TextCustom(
                                                              title: "Order Status".tr,
                                                              fontSize: 16,
                                                              fontFamily: FontFamily.bold,
                                                            ),
                                                            spaceH(height: 16),
                                                            Timeline.tileBuilder(
                                                              physics: const NeverScrollableScrollPhysics(),
                                                              shrinkWrap: true,
                                                              theme: TimelineThemeData(
                                                                direction: Axis.vertical,
                                                                nodePosition: 0.1,
                                                                indicatorPosition: 0.5,
                                                              ),
                                                              builder: TimelineTileBuilder.connected(
                                                                itemCount: 5,
                                                                itemExtent: 80.0,
                                                                contentsAlign: ContentsAlign.basic,
                                                                indicatorBuilder: (context, index) {
                                                                  return Container(
                                                                      height: 40.h,
                                                                      width: 40.w,
                                                                      decoration: BoxDecoration(
                                                                          shape: BoxShape.circle, color: themeChange.isDarkTheme() ? AppThemeData.lynch800 : AppThemeData.lynch100),
                                                                      child: Center(
                                                                          child: index == 0
                                                                              ? SvgPicture.asset(
                                                                                  "assets/icons/order_received.svg",
                                                                                  height: 24.h,
                                                                                  color: controller.bookingModel.value.orderStatus == OrderStatus.driverAccepted ||
                                                                                          controller.bookingModel.value.orderStatus == OrderStatus.orderAccepted ||
                                                                                          controller.bookingModel.value.orderStatus == OrderStatus.driverPickup ||
                                                                                          controller.bookingModel.value.orderStatus == OrderStatus.orderOnReady ||
                                                                                          controller.bookingModel.value.orderStatus == OrderStatus.orderComplete ||
                                                                                          controller.bookingModel.value.orderStatus == OrderStatus.driverAssigned ||
                                                                                          controller.bookingModel.value.orderStatus == OrderStatus.orderPending
                                                                                      ? AppThemeData.primary500
                                                                                      : themeChange.isDarkTheme()
                                                                                          ? AppThemeData.lynch400
                                                                                          : AppThemeData.lynch500,
                                                                                )
                                                                              : index == 1
                                                                                  ? SvgPicture.asset(
                                                                                      "assets/icons/order_accepted.svg",
                                                                                      height: 24.h,
                                                                                      color: controller.bookingModel.value.orderStatus == OrderStatus.driverAccepted ||
                                                                                              controller.bookingModel.value.orderStatus == OrderStatus.orderAccepted ||
                                                                                              controller.bookingModel.value.orderStatus == OrderStatus.driverAssigned ||
                                                                                              controller.bookingModel.value.orderStatus == OrderStatus.driverPickup ||
                                                                                              controller.bookingModel.value.orderStatus == OrderStatus.orderOnReady ||
                                                                                              controller.bookingModel.value.orderStatus == OrderStatus.orderComplete
                                                                                          ? AppThemeData.primary500
                                                                                          : themeChange.isDarkTheme()
                                                                                              ? AppThemeData.lynch400
                                                                                              : AppThemeData.lynch500,
                                                                                    )
                                                                                  : index == 2
                                                                                      ? SvgPicture.asset(
                                                                                          "assets/icons/order_prepaid.svg",
                                                                                          height: 24.h,
                                                                                          color: controller.bookingModel.value.foodIsReadyToPickup == true
                                                                                              ? AppThemeData.primary500
                                                                                              : themeChange.isDarkTheme()
                                                                                                  ? AppThemeData.lynch400
                                                                                                  : AppThemeData.lynch500,
                                                                                        )
                                                                                      : index == 3
                                                                                          ? SvgPicture.asset(
                                                                                              "assets/icons/order_pickup.svg",
                                                                                              color: controller.bookingModel.value.orderStatus == OrderStatus.driverPickup ||
                                                                                                      controller.bookingModel.value.orderStatus == OrderStatus.orderComplete
                                                                                                  ? AppThemeData.primary500
                                                                                                  : themeChange.isDarkTheme()
                                                                                                      ? AppThemeData.lynch400
                                                                                                      : AppThemeData.lynch500,
                                                                                              height: 24.h,
                                                                                            )
                                                                                          : SvgPicture.asset(
                                                                                              "assets/icons/order_delivered.svg",
                                                                                              height: 24.h,
                                                                                              color: controller.bookingModel.value.orderStatus == OrderStatus.orderComplete
                                                                                                  ? AppThemeData.primary500
                                                                                                  : themeChange.isDarkTheme()
                                                                                                      ? AppThemeData.lynch400
                                                                                                      : AppThemeData.lynch500,
                                                                                            )));
                                                                },
                                                                connectorBuilder: (context, index, connectorType) {
                                                                  bool isConnectorActive = false;
                                                                  if (index == 0) {
                                                                    isConnectorActive = controller.bookingModel.value.orderStatus == OrderStatus.driverAccepted ||
                                                                        controller.bookingModel.value.orderStatus == OrderStatus.orderAccepted ||
                                                                        controller.bookingModel.value.orderStatus == OrderStatus.driverPickup ||
                                                                        controller.bookingModel.value.orderStatus == OrderStatus.driverAssigned ||
                                                                        controller.bookingModel.value.orderStatus == OrderStatus.driverPickup ||
                                                                        controller.bookingModel.value.orderStatus == OrderStatus.orderOnReady ||
                                                                        controller.bookingModel.value.orderStatus == OrderStatus.orderPending ||
                                                                        controller.bookingModel.value.orderStatus == OrderStatus.orderComplete;
                                                                  } else if (index == 1) {
                                                                    isConnectorActive = controller.bookingModel.value.orderStatus == OrderStatus.driverAccepted ||
                                                                        controller.bookingModel.value.orderStatus == OrderStatus.orderAccepted ||
                                                                        controller.bookingModel.value.orderStatus == OrderStatus.orderOnReady ||
                                                                        controller.bookingModel.value.orderStatus == OrderStatus.driverPickup ||
                                                                        controller.bookingModel.value.orderStatus == OrderStatus.orderComplete;
                                                                  } else if (index == 2) {
                                                                    isConnectorActive = controller.bookingModel.value.foodIsReadyToPickup == true;
                                                                  } else if (index == 3) {
                                                                    isConnectorActive = controller.bookingModel.value.orderStatus == OrderStatus.driverPickup ||
                                                                        controller.bookingModel.value.orderStatus == OrderStatus.orderComplete;
                                                                  }
                                                                  return SolidLineConnector(
                                                                    thickness: 2,
                                                                    endIndent: 0,
                                                                    color: isConnectorActive
                                                                        ? AppThemeData.primary500 // Active connector color
                                                                        : (themeChange.isDarkTheme()
                                                                            ? AppThemeData.lynch400 // Inactive dark theme
                                                                            : AppThemeData.lynch500),
                                                                  );
                                                                },
                                                                contentsBuilder: (context, index) {
                                                                  List<String> labels = ["Order Received", "Order Accepted", "Order Prepaid", "Order Pickup", "Order Delivered"];
                                                                  bool isStatusActive = false;
                                                                  if (index == 0) {
                                                                    isStatusActive = controller.bookingModel.value.orderStatus == OrderStatus.driverAccepted ||
                                                                        controller.bookingModel.value.orderStatus == OrderStatus.orderAccepted ||
                                                                        controller.bookingModel.value.orderStatus == OrderStatus.driverPickup ||
                                                                        controller.bookingModel.value.orderStatus == OrderStatus.orderOnReady ||
                                                                        controller.bookingModel.value.orderStatus == OrderStatus.driverAssigned ||
                                                                        controller.bookingModel.value.orderStatus == OrderStatus.driverPickup ||
                                                                        controller.bookingModel.value.orderStatus == OrderStatus.orderPending ||
                                                                        controller.bookingModel.value.orderStatus == OrderStatus.orderComplete;
                                                                  } else if (index == 1) {
                                                                    isStatusActive = controller.bookingModel.value.orderStatus == OrderStatus.driverAccepted ||
                                                                        controller.bookingModel.value.orderStatus == OrderStatus.orderAccepted ||
                                                                        controller.bookingModel.value.orderStatus == OrderStatus.orderOnReady ||
                                                                        controller.bookingModel.value.orderStatus == OrderStatus.driverPickup ||
                                                                        controller.bookingModel.value.orderStatus == OrderStatus.driverAssigned ||
                                                                        controller.bookingModel.value.orderStatus == OrderStatus.orderComplete;
                                                                  } else if (index == 2) {
                                                                    isStatusActive = controller.bookingModel.value.foodIsReadyToPickup == true;
                                                                  } else if (index == 3) {
                                                                    isStatusActive = controller.bookingModel.value.orderStatus == OrderStatus.driverPickup ||
                                                                        controller.bookingModel.value.orderStatus == OrderStatus.orderComplete;
                                                                  } else {
                                                                    isStatusActive = controller.bookingModel.value.orderStatus == OrderStatus.orderComplete;
                                                                  }
                                                                  return Padding(
                                                                    padding: const EdgeInsets.symmetric(vertical: 8),
                                                                    child: TextCustom(
                                                                      title: labels[index],
                                                                      fontSize: 14,
                                                                      fontFamily: FontFamily.light,
                                                                      color: isStatusActive
                                                                          ? AppThemeData.primary500
                                                                          : themeChange.isDarkTheme()
                                                                              ? AppThemeData.lynch400
                                                                              : AppThemeData.lynch500,
                                                                    ),
                                                                  );
                                                                },
                                                              ),
                                                            ),
                                                          ],
                                                        )),
                                                  ),
                                                  Container(
                                                    // width: Responsive.width(100, context),
                                                    padding: const EdgeInsets.all(20),
                                                    margin: const EdgeInsets.only(top: 12),
                                                    decoration: ShapeDecoration(
                                                      color: themeChange.isDarkTheme() ? AppThemeData.lynch900 : AppThemeData.lynch50,
                                                      // themeChange.getTheme() ? AppColors.primaryBlack : AppColors.primaryWhite,
                                                      shape: RoundedRectangleBorder(
                                                        borderRadius: BorderRadius.circular(12),
                                                      ),
                                                    ),
                                                    child: Obx(
                                                      () => Column(
                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          TextCustom(
                                                            title: "Order Summary".tr,
                                                            fontSize: 16,
                                                            fontFamily: FontFamily.bold,
                                                          ),
                                                          spaceH(height: 24),
                                                          PriceRowView(
                                                            price: Constant.amountShow(amount: controller.bookingModel.value.subTotal.toString()),
                                                            title: "Item Total".tr,
                                                            priceColor: themeChange.isDarkTheme() ? AppThemeData.lynch25 : AppThemeData.lynch950,
                                                            titleColor: themeChange.isDarkTheme() ? AppThemeData.lynch500 : AppThemeData.lynch400,
                                                          ),
                                                          const SizedBox(height: 16),
                                                          PriceRowView(
                                                            price: controller.bookingModel.value.deliveryCharge!.isEmpty
                                                                ? "Free"
                                                                : Constant.amountShow(amount: controller.bookingModel.value.deliveryCharge.toString()),
                                                            title: "Delivery Fee".tr,
                                                            priceColor: AppThemeData.accent300,
                                                            titleColor: themeChange.isDarkTheme() ? AppThemeData.lynch500 : AppThemeData.lynch400,
                                                          ),
                                                          const SizedBox(height: 16),
                                                          PriceRowView(
                                                              price: Constant.amountToShow(amount: controller.bookingModel.value.discount ?? '0.0'),
                                                              title: (controller.bookingModel.value.coupon?.code ?? '').isEmpty
                                                                  ? "Discount".tr
                                                                  : "Discount (${controller.bookingModel.value.coupon?.code ?? ""})".tr,
                                                              priceColor: themeChange.isDarkTheme() ? AppThemeData.success200 : AppThemeData.success400,
                                                              titleColor: themeChange.isDarkTheme() ? AppThemeData.lynch500 : AppThemeData.lynch400),
                                                          const SizedBox(height: 16),
                                                          ListView.builder(
                                                            physics: const NeverScrollableScrollPhysics(),
                                                            itemCount: controller.bookingModel.value.taxList!.length,
                                                            shrinkWrap: true,
                                                            itemBuilder: (context, index) {
                                                              TaxModel taxModel = controller.bookingModel.value.taxList![index];
                                                              return Column(
                                                                children: [
                                                                  PriceRowView(
                                                                      price: Constant.amountToShow(
                                                                          amount: Constant.calculateTax(
                                                                                  amount: Constant.amountBeforeTax(controller.bookingModel.value).toString(), taxModel: taxModel)
                                                                              .toString()),
                                                                      title:
                                                                          "${taxModel.name!} (${taxModel.isFix == true ? Constant.amountToShow(amount: taxModel.value) : "${taxModel.value}%"})",
                                                                      priceColor: themeChange.isDarkTheme() ? AppThemeData.lynch25 : AppThemeData.lynch950,
                                                                      titleColor: themeChange.isDarkTheme() ? AppThemeData.lynch500 : AppThemeData.lynch400),
                                                                  const SizedBox(height: 16),
                                                                ],
                                                              );
                                                            },
                                                          ),
                                                          const SizedBox(height: 8),
                                                          Divider(color: themeChange.isDarkTheme() ? AppThemeData.lynch800 : AppThemeData.lynch950),
                                                          const SizedBox(height: 12),
                                                          PriceRowView(
                                                            price: Constant.amountShow(amount: Constant.calculateFinalAmount(controller.bookingModel.value).toString()),
                                                            title: "Total".tr,
                                                            priceColor: themeChange.isDarkTheme() ? AppThemeData.lynch25 : AppThemeData.lynch950,
                                                            titleColor: themeChange.isDarkTheme() ? AppThemeData.primaryWhite : AppThemeData.primaryBlack,
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ).expand(flex: 1),
                                            ],
                                          ),
                                        ],
                                      ),
                                desktop: controller.isLoading.value
                                    ? Constant.loader()
                                    : Column(
                                        children: [
                                          Row(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              Container(
                                                decoration: BoxDecoration(
                                                  color: themeChange.isDarkTheme() ? AppThemeData.lynch950 : AppThemeData.lynch50,
                                                  borderRadius: BorderRadius.circular(10),
                                                ),
                                                child: Padding(
                                                  padding: paddingEdgeInsets(horizontal: 20, vertical: 20),
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Row(
                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                        children: [
                                                          Column(
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            children: [
                                                              TextCustom(
                                                                  title: "Order ID # ${controller.bookingModel.value.id!.substring(0, 4)}".tr,
                                                                  fontSize: 18,
                                                                  fontFamily: FontFamily.bold),
                                                              spaceH(height: 2),
                                                              TextCustom(
                                                                title:
                                                                    "${Constant.timestampToDate(controller.bookingModel.value.createdAt!)} at ${Constant.timestampToTime(controller.bookingModel.value.createdAt!)}",
                                                                fontSize: 14,
                                                                fontFamily: FontFamily.regular,
                                                              ),
                                                            ],
                                                          ),
                                                          Constant.bookingStatusText(context, controller.bookingModel.value.orderStatus.toString()),
                                                        ],
                                                      ),
                                                      spaceH(height: 24),
                                                      Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          TextCustom(
                                                            title: "Item Summary".tr,
                                                            fontSize: 16,
                                                            fontFamily: FontFamily.bold,
                                                          ),
                                                          spaceH(height: 16),
                                                          SingleChildScrollView(
                                                            scrollDirection: Axis.horizontal,
                                                            child: ClipRRect(
                                                              borderRadius: BorderRadius.circular(12),
                                                              child: DataTable(
                                                                horizontalMargin: 20,
                                                                columnSpacing: 30,
                                                                dataRowMaxHeight: 65,
                                                                headingRowHeight: 65,
                                                                border: TableBorder.all(
                                                                  color: themeChange.isDarkTheme() ? AppThemeData.lynch800 : AppThemeData.lynch100,
                                                                  borderRadius: BorderRadius.circular(12),
                                                                ),
                                                                headingRowColor: WidgetStateColor.resolveWith(
                                                                    (states) => themeChange.isDarkTheme() ? AppThemeData.lynch800 : AppThemeData.lynch100),
                                                                columns: [
                                                                  CommonUI.dataColumnWidget(context, columnTitle: "Id".tr, width: 100),
                                                                  CommonUI.dataColumnWidget(context,
                                                                      columnTitle: "Items".tr,
                                                                      width: ResponsiveWidget.isMobile(context) ? 150 : MediaQuery.of(context).size.width * 0.15),
                                                                  CommonUI.dataColumnWidget(context,
                                                                      columnTitle: "Qty".tr,
                                                                      width: ResponsiveWidget.isMobile(context) ? 150 : MediaQuery.of(context).size.width * 0.07),
                                                                  CommonUI.dataColumnWidget(context,
                                                                      columnTitle: "Price".tr,
                                                                      width: ResponsiveWidget.isMobile(context) ? 150 : MediaQuery.of(context).size.width * 0.07),
                                                                  CommonUI.dataColumnWidget(context,
                                                                      columnTitle: "Total Price".tr,
                                                                      width: ResponsiveWidget.isMobile(context) ? 150 : MediaQuery.of(context).size.width * 0.07),
                                                                  // CommonUI.dataColumnWidget(context,
                                                                  //     columnTitle: "Action".tr,
                                                                  //     width: ResponsiveWidget.isMobile(context)
                                                                  //         ? 80
                                                                  //         : MediaQuery.of(context).size.width * 0.04),
                                                                ],
                                                                rows: controller.bookingModel.value.items!
                                                                    .map((cartItem) => DataRow(cells: [
                                                                          DataCell(TextCustom(
                                                                              title: "${controller.bookingModel.value.items!.indexWhere((element) => element == cartItem) + 1}")),
                                                                          DataCell(Row(
                                                                            children: [
                                                                              FutureBuilder(
                                                                                  future: FireStoreUtils.getProductByProductId(cartItem.productId.toString()),
                                                                                  builder: (context, snapshot) {
                                                                                    if (!snapshot.hasData) {
                                                                                      return Container();
                                                                                    }
                                                                                    ProductModel product = snapshot.data ?? ProductModel();
                                                                                    return NetworkImageWidget(
                                                                                      imageUrl: product.productImage.toString(),
                                                                                      height: 24,
                                                                                      width: 24,
                                                                                      borderRadius: 0,
                                                                                    );
                                                                                  }),
                                                                              spaceW(),
                                                                              TextCustom(title: cartItem.productName.toString()),
                                                                            ],
                                                                          )),
                                                                          DataCell(TextCustom(title: cartItem.quantity.toString())),
                                                                          DataCell(TextCustom(title: Constant.amountShow(amount: cartItem.itemPrice.toString()))),
                                                                          DataCell(TextCustom(title: Constant.amountShow(amount: cartItem.totalAmount.toString()))),
                                                                        ]))
                                                                    .toList(),
                                                              ),
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                      spaceH(height: 24),
                                                      Row(
                                                        children: [
                                                          Column(
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            children: [
                                                              TextCustom(
                                                                title: "Customer Details".tr,
                                                                fontSize: 16,
                                                                fontFamily: FontFamily.bold,
                                                              ),
                                                              spaceH(height: 16),
                                                              Container(
                                                                padding: const EdgeInsets.all(16),
                                                                decoration: ShapeDecoration(
                                                                  color: themeChange.isDarkTheme() ? AppThemeData.lynch950 : AppThemeData.lynch25,
                                                                  shape: RoundedRectangleBorder(
                                                                    borderRadius: BorderRadius.circular(12),
                                                                  ),
                                                                ),
                                                                child: Column(
                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                  children: [
                                                                    rowDetailsWidget(
                                                                        icon: 'assets/icons/ic_id.svg',
                                                                        name: 'Id'.tr,
                                                                        value: '#${controller.userModel.value.id!.substring(0, 5)}',
                                                                        themeChange: themeChange),
                                                                    spaceH(height: 8),
                                                                    rowDetailsWidget(
                                                                        icon: 'assets/icons/ic_user.svg',
                                                                        name: 'Name',
                                                                        value: controller.userModel.value.fullNameString(),
                                                                        themeChange: themeChange),
                                                                    spaceH(height: 8),
                                                                    rowDetailsWidget(
                                                                        icon: 'assets/icons/ic_call.svg',
                                                                        name: 'Phone Number',
                                                                        value: Constant.maskMobileNumber(
                                                                            countryCode: controller.userModel.value.countryCode.toString(),
                                                                            mobileNumber: controller.userModel.value.phoneNumber.toString()),
                                                                        themeChange: themeChange),
                                                                  ],
                                                                ),
                                                              ),
                                                            ],
                                                          ).expand(),
                                                          if (controller.driverModel.value.driverId != null && controller.driverModel.value.driverId!="")
                                                            Padding(
                                                              padding: const EdgeInsets.only(left: 24),
                                                              child: Column(
                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                children: [
                                                                  TextCustom(
                                                                    title: "Driver Details".tr,
                                                                    fontSize: 16,
                                                                    fontFamily: FontFamily.bold,
                                                                  ),
                                                                  spaceH(height: 16),
                                                                  Container(
                                                                    padding: const EdgeInsets.all(16),
                                                                    decoration: ShapeDecoration(
                                                                      color: themeChange.isDarkTheme() ? AppThemeData.lynch950 : AppThemeData.lynch25,
                                                                      shape: RoundedRectangleBorder(
                                                                        borderRadius: BorderRadius.circular(12),
                                                                      ),
                                                                    ),
                                                                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                                                      rowDetailsWidget(
                                                                          icon: 'assets/icons/ic_id.svg',
                                                                          name: 'Id'.tr,
                                                                          value: '#${controller.driverModel.value.driverId!.substring(0, 5)}',
                                                                          themeChange: themeChange),
                                                                      spaceH(height: 8),
                                                                      rowDetailsWidget(
                                                                          icon: 'assets/icons/ic_user.svg',
                                                                          name: 'Name'.tr,
                                                                          value: controller.driverModel.value.fullNameString(),
                                                                          themeChange: themeChange),
                                                                      spaceH(height: 8),
                                                                      rowDetailsWidget(
                                                                          icon: 'assets/icons/ic_call.svg',
                                                                          name: 'Phone Number'.tr,
                                                                          value: Constant.maskMobileNumber(
                                                                              countryCode: controller.driverModel.value.countryCode.toString(),
                                                                              mobileNumber: controller.driverModel.value.phoneNumber.toString()),
                                                                          themeChange: themeChange),
                                                                    ]),
                                                                  ),
                                                                ],
                                                              ),
                                                            ).expand()
                                                          else
                                                            const SizedBox().expand()
                                                        ],
                                                      ),
                                                      if (controller.bookingModel.value.orderStatus == OrderStatus.orderCancel)
                                                        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                                          spaceH(height: 24),
                                                          TextCustom(
                                                            title: "Cancelled Reason".tr,
                                                            fontSize: 16,
                                                            fontFamily: FontFamily.bold,
                                                          ),
                                                          spaceH(height: 16),
                                                          TextCustom(
                                                              title: controller.bookingModel.value.cancelledReason.toString(),
                                                              fontSize: 14,
                                                              fontFamily: FontFamily.regular,
                                                              color: themeChange.isDarkTheme() ? AppThemeData.lynch400 : AppThemeData.lynch500),
                                                        ]),
                                                      spaceH(height: 24),
                                                      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                                        TextCustom(
                                                          title: "Shipping Address".tr,
                                                          fontSize: 16,
                                                          fontFamily: FontFamily.bold,
                                                        ),
                                                        spaceH(height: 16),
                                                        Container(
                                                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                                                            decoration: BoxDecoration(
                                                                color: themeChange.isDarkTheme() ? AppThemeData.lynch950 : AppThemeData.lynch50,
                                                                borderRadius: BorderRadius.circular(10),
                                                                border: Border.all(color: themeChange.isDarkTheme() ? AppThemeData.lynch800 : AppThemeData.lynch100)),
                                                            child: Column(
                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                              children: [
                                                                Row(children: [
                                                                  SvgPicture.asset(
                                                                      controller.bookingModel.value.customerAddress!.addressAs == "Home"
                                                                          ? "assets/icons/ic_home.svg"
                                                                          : controller.bookingModel.value.customerAddress!.addressAs == "Work"
                                                                              ? "assets/icons/ic_work.svg"
                                                                              : controller.bookingModel.value.customerAddress!.addressAs == "Friends and Family"
                                                                                  ? "assets/icons/ic_user.svg"
                                                                                  : "assets/icons/ic_location.svg",
                                                                      color: themeChange.isDarkTheme() ? AppThemeData.primaryWhite : AppThemeData.primaryBlack),
                                                                  spaceW(width: 8),
                                                                  TextCustom(
                                                                    title: controller.bookingModel.value.customerAddress!.addressAs.toString(),
                                                                    fontSize: 14,
                                                                    fontFamily: FontFamily.medium,
                                                                  ),
                                                                ]),
                                                                spaceH(height: 8),
                                                                TextCustom(
                                                                  title: controller.bookingModel.value.customerAddress!.address.toString(),
                                                                  fontSize: 14,
                                                                  fontFamily: FontFamily.regular,
                                                                ),
                                                                spaceH(height: 8),
                                                                TextCustom(
                                                                  title: controller.userModel.value.fullNameString(),
                                                                  fontSize: 14,
                                                                  fontFamily: FontFamily.regular,
                                                                ),
                                                                spaceH(height: 8),
                                                                TextCustom(
                                                                  title: Constant.maskMobileNumber(
                                                                      countryCode: controller.userModel.value.countryCode.toString(),
                                                                      mobileNumber: controller.userModel.value.phoneNumber.toString()),
                                                                  fontSize: 14,
                                                                  fontFamily: FontFamily.regular,
                                                                ),
                                                              ],
                                                            ))
                                                      ]),
                                                      spaceH(height: 24),
                                                      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                                        TextCustom(
                                                          title: "Payment Details".tr,
                                                          fontSize: 16,
                                                          fontFamily: FontFamily.bold,
                                                        ),
                                                        spaceH(height: 12),
                                                        Row(mainAxisSize: MainAxisSize.min, mainAxisAlignment: MainAxisAlignment.start, children: [
                                                          Container(
                                                              height: 26.h,
                                                              width: 26.w,
                                                              decoration: BoxDecoration(
                                                                  shape: BoxShape.circle, color: themeChange.isDarkTheme() ? AppThemeData.lynch800 : AppThemeData.lynch100),
                                                              child: (controller.bookingModel.value.paymentType == "Cash")
                                                                  ? SvgPicture.asset("assets/icons/ic_cash.svg", height: 24, width: 24, fit: BoxFit.cover)
                                                                  : (controller.bookingModel.value.paymentType == "Wallet")
                                                                      ? SvgPicture.asset(
                                                                          "assets/icons/ic_wallet.svg",
                                                                          height: 24,
                                                                          width: 24,
                                                                        )
                                                                      : (controller.bookingModel.value.paymentType == "Flutter Wave")
                                                                          ? Image.asset(
                                                                              "assets/image/ig_flutterwave.png",
                                                                              height: 24,
                                                                              width: 24,
                                                                            )
                                                                          : (controller.bookingModel.value.paymentType == "Razorpay")
                                                                              ? Image.asset(
                                                                                  "assets/image/ig_razorpay.png",
                                                                                  height: 24,
                                                                                  width: 24,
                                                                                )
                                                                              : (controller.bookingModel.value.paymentType == "Paypal")
                                                                                  ? Image.asset(
                                                                                      "assets/image/ig_paypal.png",
                                                                                      height: 24,
                                                                                      width: 24,
                                                                                    )
                                                                                  : (controller.bookingModel.value.paymentType == "Strip")
                                                                                      ? Image.asset(
                                                                                          "assets/image/ig_stripe.png",
                                                                                          height: 24,
                                                                                          width: 24,
                                                                                        )
                                                                                      : (controller.bookingModel.value.paymentType == "PayStack")
                                                                                          ? Image.asset(
                                                                                              "assets/image/ig_paystack.png",
                                                                                              height: 24,
                                                                                              width: 24,
                                                                                            )
                                                                                          : (controller.bookingModel.value.paymentType == "Mercado Pago")
                                                                                              ? Image.asset(
                                                                                                  "assets/image/ig_marcadopago.png",
                                                                                                  height: 24,
                                                                                                  width: 24,
                                                                                                )
                                                                                              : (controller.bookingModel.value.paymentType == "payfast")
                                                                                                  ? Image.asset(
                                                                                                      "assets/image/ig_payfast.png",
                                                                                                      height: 24,
                                                                                                      width: 24,
                                                                                                    )
                                                                                                  : SvgPicture.asset(
                                                                                                      "assets/icons/ic_cash.svg",
                                                                                                      height: 24,
                                                                                                      width: 24,
                                                                                                    )),
                                                          spaceW(width: 12),
                                                          TextCustom(title: controller.bookingModel.value.paymentType.toString()),
                                                          const Spacer(),
                                                          Container(
                                                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                                                            decoration: BoxDecoration(
                                                              borderRadius: BorderRadius.circular(50),
                                                              color: controller.bookingModel.value.paymentStatus == true
                                                                  ? themeChange.isDarkTheme()
                                                                      ? AppThemeData.success600
                                                                      : AppThemeData.success50
                                                                  : themeChange.isDarkTheme()
                                                                      ? AppThemeData.danger600
                                                                      : AppThemeData.danger50,
                                                            ),
                                                            child: TextCustom(
                                                              title: controller.bookingModel.value.paymentStatus == true ? "Paid".tr : "Unpaid".tr,
                                                              color: controller.bookingModel.value.paymentStatus == true ? AppThemeData.success300 : AppThemeData.danger300,
                                                            ),
                                                          )
                                                        ])
                                                      ]),
                                                    ],
                                                  ),
                                                ),
                                              ).expand(flex: 2),
                                              spaceW(width: 20),
                                              Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Container(
                                                    padding: const EdgeInsets.all(20),
                                                    decoration: ShapeDecoration(
                                                      color: themeChange.isDarkTheme() ? AppThemeData.lynch900 : AppThemeData.lynch50,
                                                      shape: RoundedRectangleBorder(
                                                        borderRadius: BorderRadius.circular(12),
                                                      ),
                                                    ),
                                                    child: Container(
                                                        padding: const EdgeInsets.all(16),
                                                        decoration: ShapeDecoration(
                                                          color: themeChange.isDarkTheme() ? AppThemeData.lynch950 : AppThemeData.lynch25,
                                                          shape: RoundedRectangleBorder(
                                                            borderRadius: BorderRadius.circular(12),
                                                          ),
                                                        ),
                                                        child: Column(
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          children: [
                                                            TextCustom(
                                                              title: "Order Status".tr,
                                                              fontSize: 16,
                                                              fontFamily: FontFamily.bold,
                                                            ),
                                                            spaceH(height: 16),
                                                            Timeline.tileBuilder(
                                                              physics: const NeverScrollableScrollPhysics(),
                                                              shrinkWrap: true,
                                                              theme: TimelineThemeData(
                                                                direction: Axis.vertical,
                                                                nodePosition: 0.1,
                                                                indicatorPosition: 0.5,
                                                              ),
                                                              builder: TimelineTileBuilder.connected(
                                                                itemCount: 5,
                                                                itemExtent: 80.0,
                                                                contentsAlign: ContentsAlign.basic,
                                                                indicatorBuilder: (context, index) {
                                                                  return Container(
                                                                      height: 40.h,
                                                                      width: 40.w,
                                                                      decoration: BoxDecoration(
                                                                          shape: BoxShape.circle, color: themeChange.isDarkTheme() ? AppThemeData.lynch800 : AppThemeData.lynch100),
                                                                      child: Center(
                                                                          child: index == 0
                                                                              ? SvgPicture.asset(
                                                                                  "assets/icons/order_received.svg",
                                                                                  height: 24.h,
                                                                                  color: controller.bookingModel.value.orderStatus == OrderStatus.driverAccepted ||
                                                                                          controller.bookingModel.value.orderStatus == OrderStatus.orderAccepted ||
                                                                                          controller.bookingModel.value.orderStatus == OrderStatus.driverPickup ||
                                                                                          controller.bookingModel.value.orderStatus == OrderStatus.orderOnReady ||
                                                                                          controller.bookingModel.value.orderStatus == OrderStatus.orderComplete ||
                                                                                          controller.bookingModel.value.orderStatus == OrderStatus.driverAssigned ||
                                                                                          controller.bookingModel.value.orderStatus == OrderStatus.orderPending
                                                                                      ? AppThemeData.primary500
                                                                                      : themeChange.isDarkTheme()
                                                                                          ? AppThemeData.lynch400
                                                                                          : AppThemeData.lynch500,
                                                                                )
                                                                              : index == 1
                                                                                  ? SvgPicture.asset(
                                                                                      "assets/icons/order_accepted.svg",
                                                                                      height: 24.h,
                                                                                      color: controller.bookingModel.value.orderStatus == OrderStatus.driverAccepted ||
                                                                                              controller.bookingModel.value.orderStatus == OrderStatus.orderAccepted ||
                                                                                              controller.bookingModel.value.orderStatus == OrderStatus.driverAssigned ||
                                                                                              controller.bookingModel.value.orderStatus == OrderStatus.driverPickup ||
                                                                                              controller.bookingModel.value.orderStatus == OrderStatus.orderOnReady ||
                                                                                              controller.bookingModel.value.orderStatus == OrderStatus.orderComplete
                                                                                          ? AppThemeData.primary500
                                                                                          : themeChange.isDarkTheme()
                                                                                              ? AppThemeData.lynch400
                                                                                              : AppThemeData.lynch500,
                                                                                    )
                                                                                  : index == 2
                                                                                      ? SvgPicture.asset(
                                                                                          "assets/icons/order_prepaid.svg",
                                                                                          height: 24.h,
                                                                                          color: controller.bookingModel.value.foodIsReadyToPickup == true
                                                                                              ? AppThemeData.primary500
                                                                                              : themeChange.isDarkTheme()
                                                                                                  ? AppThemeData.lynch400
                                                                                                  : AppThemeData.lynch500,
                                                                                        )
                                                                                      : index == 3
                                                                                          ? SvgPicture.asset(
                                                                                              "assets/icons/order_pickup.svg",
                                                                                              color: controller.bookingModel.value.orderStatus == OrderStatus.driverPickup ||
                                                                                                      controller.bookingModel.value.orderStatus == OrderStatus.orderComplete
                                                                                                  ? AppThemeData.primary500
                                                                                                  : themeChange.isDarkTheme()
                                                                                                      ? AppThemeData.lynch400
                                                                                                      : AppThemeData.lynch500,
                                                                                              height: 24.h,
                                                                                            )
                                                                                          : SvgPicture.asset(
                                                                                              "assets/icons/order_delivered.svg",
                                                                                              height: 24.h,
                                                                                              color: controller.bookingModel.value.orderStatus == OrderStatus.orderComplete
                                                                                                  ? AppThemeData.primary500
                                                                                                  : themeChange.isDarkTheme()
                                                                                                      ? AppThemeData.lynch400
                                                                                                      : AppThemeData.lynch500,
                                                                                            )));
                                                                },
                                                                connectorBuilder: (context, index, connectorType) {
                                                                  bool isConnectorActive = false;
                                                                  if (index == 0) {
                                                                    isConnectorActive = controller.bookingModel.value.orderStatus == OrderStatus.driverAccepted ||
                                                                        controller.bookingModel.value.orderStatus == OrderStatus.orderAccepted ||
                                                                        controller.bookingModel.value.orderStatus == OrderStatus.driverPickup ||
                                                                        controller.bookingModel.value.orderStatus == OrderStatus.driverAssigned ||
                                                                        controller.bookingModel.value.orderStatus == OrderStatus.driverPickup ||
                                                                        controller.bookingModel.value.orderStatus == OrderStatus.orderOnReady ||
                                                                        controller.bookingModel.value.orderStatus == OrderStatus.orderPending ||
                                                                        controller.bookingModel.value.orderStatus == OrderStatus.orderComplete;
                                                                  } else if (index == 1) {
                                                                    isConnectorActive = controller.bookingModel.value.orderStatus == OrderStatus.driverAccepted ||
                                                                        controller.bookingModel.value.orderStatus == OrderStatus.orderAccepted ||
                                                                        controller.bookingModel.value.orderStatus == OrderStatus.orderOnReady ||
                                                                        controller.bookingModel.value.orderStatus == OrderStatus.driverPickup ||
                                                                        controller.bookingModel.value.orderStatus == OrderStatus.orderComplete;
                                                                  } else if (index == 2) {
                                                                    isConnectorActive = controller.bookingModel.value.foodIsReadyToPickup == true;
                                                                  } else if (index == 3) {
                                                                    isConnectorActive = controller.bookingModel.value.orderStatus == OrderStatus.driverPickup ||
                                                                        controller.bookingModel.value.orderStatus == OrderStatus.orderComplete;
                                                                  }
                                                                  return SolidLineConnector(
                                                                    thickness: 2,
                                                                    endIndent: 0,
                                                                    color: isConnectorActive
                                                                        ? AppThemeData.primary500 // Active connector color
                                                                        : (themeChange.isDarkTheme()
                                                                            ? AppThemeData.lynch400 // Inactive dark theme
                                                                            : AppThemeData.lynch500),
                                                                  );
                                                                },
                                                                contentsBuilder: (context, index) {
                                                                  List<String> labels = ["Order Received", "Order Accepted", "Order Prepaid", "Order Pickup", "Order Delivered"];
                                                                  bool isStatusActive = false;
                                                                  if (index == 0) {
                                                                    isStatusActive = controller.bookingModel.value.orderStatus == OrderStatus.driverAccepted ||
                                                                        controller.bookingModel.value.orderStatus == OrderStatus.orderAccepted ||
                                                                        controller.bookingModel.value.orderStatus == OrderStatus.driverPickup ||
                                                                        controller.bookingModel.value.orderStatus == OrderStatus.orderOnReady ||
                                                                        controller.bookingModel.value.orderStatus == OrderStatus.driverAssigned ||
                                                                        controller.bookingModel.value.orderStatus == OrderStatus.driverPickup ||
                                                                        controller.bookingModel.value.orderStatus == OrderStatus.orderPending ||
                                                                        controller.bookingModel.value.orderStatus == OrderStatus.orderComplete;
                                                                  } else if (index == 1) {
                                                                    isStatusActive = controller.bookingModel.value.orderStatus == OrderStatus.driverAccepted ||
                                                                        controller.bookingModel.value.orderStatus == OrderStatus.orderAccepted ||
                                                                        controller.bookingModel.value.orderStatus == OrderStatus.orderOnReady ||
                                                                        controller.bookingModel.value.orderStatus == OrderStatus.driverPickup ||
                                                                        controller.bookingModel.value.orderStatus == OrderStatus.driverAssigned ||
                                                                        controller.bookingModel.value.orderStatus == OrderStatus.orderComplete;
                                                                  } else if (index == 2) {
                                                                    isStatusActive = controller.bookingModel.value.foodIsReadyToPickup == true;
                                                                  } else if (index == 3) {
                                                                    isStatusActive = controller.bookingModel.value.orderStatus == OrderStatus.driverPickup ||
                                                                        controller.bookingModel.value.orderStatus == OrderStatus.orderComplete;
                                                                  } else {
                                                                    isStatusActive = controller.bookingModel.value.orderStatus == OrderStatus.orderComplete;
                                                                  }
                                                                  return Padding(
                                                                    padding: const EdgeInsets.symmetric(vertical: 8),
                                                                    child: TextCustom(
                                                                      title: labels[index],
                                                                      fontSize: 14,
                                                                      fontFamily: FontFamily.light,
                                                                      color: isStatusActive
                                                                          ? AppThemeData.primary500
                                                                          : themeChange.isDarkTheme()
                                                                              ? AppThemeData.lynch400
                                                                              : AppThemeData.lynch500,
                                                                    ),
                                                                  );
                                                                },
                                                              ),
                                                            ),
                                                          ],
                                                        )),
                                                  ),
                                                  Container(
                                                    // width: Responsive.width(100, context),
                                                    padding: const EdgeInsets.all(20),
                                                    margin: const EdgeInsets.only(top: 12),
                                                    decoration: ShapeDecoration(
                                                      color: themeChange.isDarkTheme() ? AppThemeData.lynch900 : AppThemeData.lynch50,
                                                      // themeChange.getTheme() ? AppColors.primaryBlack : AppColors.primaryWhite,
                                                      shape: RoundedRectangleBorder(
                                                        borderRadius: BorderRadius.circular(12),
                                                      ),
                                                    ),
                                                    child: Obx(
                                                      () => Column(
                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          TextCustom(
                                                            title: "Order Summary".tr,
                                                            fontSize: 16,
                                                            fontFamily: FontFamily.bold,
                                                          ),
                                                          spaceH(height: 24),
                                                          Container(
                                                            padding: const EdgeInsets.all(16),
                                                            decoration: ShapeDecoration(
                                                              color: themeChange.isDarkTheme() ? AppThemeData.lynch950 : AppThemeData.lynch25,
                                                              shape: RoundedRectangleBorder(
                                                                borderRadius: BorderRadius.circular(12),
                                                              ),
                                                            ),
                                                            child: PriceRowView(
                                                              price: Constant.amountShow(
                                                                  amount:
                                                                      "${Constant.calculateAdminCommission(amount: double.parse(controller.bookingModel.value.subTotal ?? "0.0").toString(), adminCommission: controller.bookingModel.value.adminCommission)}"),
                                                              title: "Admin commission".tr,
                                                              priceColor: themeChange.isDarkTheme() ? AppThemeData.lynch25 : AppThemeData.lynch950,
                                                              titleColor: themeChange.isDarkTheme() ? AppThemeData.lynch100 : AppThemeData.lynch900,
                                                            ),
                                                          ),
                                                          const SizedBox(height: 16),
                                                          PriceRowView(
                                                            price: Constant.amountShow(amount: controller.bookingModel.value.subTotal.toString()),
                                                            title: "Item Total".tr,
                                                            priceColor: themeChange.isDarkTheme() ? AppThemeData.lynch25 : AppThemeData.lynch950,
                                                            titleColor: themeChange.isDarkTheme() ? AppThemeData.lynch500 : AppThemeData.lynch400,
                                                          ),
                                                          const SizedBox(height: 16),
                                                          PriceRowView(
                                                            price: controller.bookingModel.value.deliveryCharge!.isEmpty
                                                                ? "Free".tr
                                                                : Constant.amountShow(amount: controller.bookingModel.value.deliveryCharge.toString()),
                                                            title: "Delivery Fee".tr,
                                                            priceColor: AppThemeData.accent300,
                                                            titleColor: themeChange.isDarkTheme() ? AppThemeData.lynch500 : AppThemeData.lynch400,
                                                          ),
                                                          const SizedBox(height: 16),
                                                          PriceRowView(
                                                              price: Constant.amountToShow(amount: controller.bookingModel.value.discount ?? '0.0'),
                                                              title: (controller.bookingModel.value.coupon?.code ?? '').isEmpty
                                                                  ? "Discount".tr
                                                                  : "Discount (${controller.bookingModel.value.coupon?.code ?? ""})".tr,
                                                              priceColor: themeChange.isDarkTheme() ? AppThemeData.success200 : AppThemeData.success400,
                                                              titleColor: themeChange.isDarkTheme() ? AppThemeData.lynch500 : AppThemeData.lynch400),
                                                          const SizedBox(height: 16),
                                                          ListView.builder(
                                                            physics: const NeverScrollableScrollPhysics(),
                                                            itemCount: controller.bookingModel.value.taxList!.length,
                                                            shrinkWrap: true,
                                                            itemBuilder: (context, index) {
                                                              TaxModel taxModel = controller.bookingModel.value.taxList![index];
                                                              return Column(
                                                                children: [
                                                                  PriceRowView(
                                                                      price: Constant.amountToShow(
                                                                          amount: Constant.calculateTax(
                                                                                  amount: Constant.amountBeforeTax(controller.bookingModel.value).toString(), taxModel: taxModel)
                                                                              .toString()),
                                                                      title:
                                                                          "${taxModel.name!} (${taxModel.isFix == true ? Constant.amountToShow(amount: taxModel.value) : "${taxModel.value}%"})",
                                                                      priceColor: themeChange.isDarkTheme() ? AppThemeData.lynch25 : AppThemeData.lynch950,
                                                                      titleColor: themeChange.isDarkTheme() ? AppThemeData.lynch500 : AppThemeData.lynch400),
                                                                  const SizedBox(height: 16),
                                                                ],
                                                              );
                                                            },
                                                          ),
                                                          const SizedBox(height: 8),
                                                          Divider(color: themeChange.isDarkTheme() ? AppThemeData.lynch800 : AppThemeData.lynch950),
                                                          const SizedBox(height: 12),
                                                          PriceRowView(
                                                            price: Constant.amountShow(amount: Constant.calculateFinalAmount(controller.bookingModel.value).toString()),
                                                            title: "Total".tr,
                                                            priceColor: themeChange.isDarkTheme() ? AppThemeData.lynch25 : AppThemeData.lynch950,
                                                            titleColor: themeChange.isDarkTheme() ? AppThemeData.primaryWhite : AppThemeData.primaryBlack,
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ).expand(flex: 1),
                                            ],
                                          ),
                                          20.height,
                                        ],
                                      ),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

Padding priceDetailWidget({required String name, required String value}) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Row(
      children: [
        Expanded(
          child: TextCustom(title: name.tr, fontSize: 14, fontFamily: FontFamily.medium),
        ),
        TextCustom(
          title: (value.length > 35) ? value.substring(0, 30) : value,
          fontSize: 14,
          fontFamily: FontFamily.bold,
        ),
      ],
    ),
  );
}

Row rowDataWidget({required String icon, required String name, required String value, required themeChange}) {
  return Row(children: [
    SvgPicture.asset(icon, color: themeChange.isDarkTheme() ? AppThemeData.lynch400 : AppThemeData.lynch500),
    spaceW(width: 12),
    TextCustom(title: name.tr, fontSize: 14, fontFamily: FontFamily.regular, color: themeChange.isDarkTheme() ? AppThemeData.lynch400 : AppThemeData.lynch500),
    const Spacer(),
    TextCustom(title: value, fontSize: 14, fontFamily: FontFamily.regular),
  ]);
}

Row rowDetailsWidget({required String icon, required String name, required String value, required themeChange}) {
  return Row(children: [
    SvgPicture.asset(icon, color: themeChange.isDarkTheme() ? AppThemeData.lynch400 : AppThemeData.lynch500),
    spaceW(width: 12),
    TextCustom(title: name.tr, fontSize: 14, fontFamily: FontFamily.regular, color: themeChange.isDarkTheme() ? AppThemeData.lynch400 : AppThemeData.lynch500),
    TextCustom(title: ' : ', fontSize: 14, fontFamily: FontFamily.regular, color: themeChange.isDarkTheme() ? AppThemeData.lynch400 : AppThemeData.lynch500),
    TextCustom(title: value, fontSize: 14, fontFamily: FontFamily.regular),
  ]);
}
