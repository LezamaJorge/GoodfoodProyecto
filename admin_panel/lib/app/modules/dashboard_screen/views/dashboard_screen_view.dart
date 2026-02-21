// ignore_for_file: deprecated_member_use

import 'package:admin_panel/app/components/dialog_box.dart';
import 'package:admin_panel/app/components/network_image_widget.dart';
import 'package:admin_panel/app/constant/constants.dart';
import 'package:admin_panel/app/inactive_handler.dart';
import 'package:admin_panel/app/models/product_model.dart';
import 'package:admin_panel/app/models/user_model.dart';
import 'package:admin_panel/app/routes/app_pages.dart';
import 'package:admin_panel/app/utils/app_them_data.dart';
import 'package:admin_panel/app/utils/dark_theme_provider.dart';
import 'package:admin_panel/app/utils/fire_store_utils.dart';
import 'package:admin_panel/app/utils/responsive.dart';
import 'package:admin_panel/app/utils/screen_size.dart';
import 'package:admin_panel/widget/common_ui.dart';
import 'package:admin_panel/widget/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';
import '../../../../widget/container_custom.dart';
import '../../../../widget/global_widgets.dart';
import '../../../components/menu_widget.dart';
import '../../../utils/app_colors.dart';
import '../controllers/dashboard_screen_controller.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class DashboardScreenView extends GetView<DashboardScreenController> {
  const DashboardScreenView({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return InactivityHandler(
      child: GetBuilder<DashboardScreenController>(
        init: DashboardScreenController(),
        builder: (controller) {
          return ResponsiveWidget(
            mobile: Scaffold(
              key: controller.scaffoldKeyDrawer,
              backgroundColor: themeChange.isDarkTheme() ? AppThemeData.lynch950 : AppThemeData.lynch50,
              // appBar: CommonUI.appBarCustom(themeChange: themeChange, scaffoldKey: controller.scaffoldKey),
              appBar: AppBar(
                elevation: 0.0,
                toolbarHeight: 70,
                automaticallyImplyLeading: false,
                backgroundColor: themeChange.isDarkTheme() ? AppThemeData.primaryBlack : AppThemeData.primaryWhite,
                leadingWidth: 200,
                // title: title,
                leading: InkWell(
                    onTap: () {
                      controller.toggleDrawer();
                    },
                    child: Center(
                      child: Row(
                        children: [
                          Expanded(
                            child: Row(
                              children: [
                                10.width,
                                Icon(
                                  Icons.menu,
                                  size: 30,
                                  color: themeChange.isDarkTheme() ? AppThemeData.primary500 : AppThemeData.primary500,
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    )),
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
                  spaceW(),
                  const LanguagePopUp(),
                  spaceW(),
                  ProfilePopUp()
                ],
              ),
              drawer: Drawer(
                // key: scaffoldKey,
                width: 270,
                backgroundColor: themeChange.isDarkTheme() ? AppThemeData.primaryBlack : AppThemeData.primaryWhite,
                child: const MenuWidget(),
              ),
              body: SingleChildScrollView(
                child: Obx(
                  () => Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 16, right: 16, top: 24),
                        child: Wrap(
                          runSpacing: 24,
                          spacing: 24,
                          children: [
                            commonView(
                              context: context,
                              title: "Total Revenue".tr,
                              value: Constant.amountShow(amount: controller.totalEarnings.toString()),
                              imageAssets: "assets/icons/ic_currency_dollar.svg",
                              bgColor: themeChange.isDarkTheme() ? const Color(0xff032426) : const Color(0xffE7FCFD),
                              textColor: const Color(0xff0CB9C1),
                            ),
                            commonView(
                              context: context,
                              title: "Total Orders".tr,
                              value: controller.totalOrders.toString(),
                              imageAssets: "assets/icons/ic_order.svg",
                              bgColor: themeChange.isDarkTheme() ? const Color(0xff200F2F) : const Color(0xffF2ECF9),
                              textColor: const Color(0xff7338B3),
                            ),
                            commonView(
                              context: context,
                              title: "Total Customers".tr,
                              value: controller.totalUser.toString(),
                              imageAssets: "assets/icons/ic_group.svg",
                              bgColor: themeChange.isDarkTheme() ? const Color(0xff021827) : const Color(0xffE6F5FE),
                              textColor: const Color(0xff0479C7),
                            ),
                            commonView(
                              context: context,
                              title: "Total Drivers".tr,
                              value: controller.totalDriver.toString(),
                              imageAssets: "assets/icons/ic_user1.svg",
                              bgColor: themeChange.isDarkTheme() ? const Color(0xff270602) : const Color(0xffFEEAE6),
                              textColor: const Color(0xffF85A40),
                            ),
                          ],
                        ),
                      ),
                      24.height,
                      // Row(children: [Expanded(child: LineChartCard()), Expanded(child: LineChartCard())]),
                      controller.isUserData.value
                          ? Padding(
                              padding: paddingEdgeInsets(),
                              child: Constant.loader(),
                            )
                          : Container(
                              padding: paddingEdgeInsets(horizontal: 16, vertical: 0),
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(10),
                                    child: userChartStatistic(context),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(10),
                                    child: orderChartStatistic(context),
                                  ),
                                ],
                              ),
                            ),
                      24.height,
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Visibility(
                            visible: controller.recentOrderList.isNotEmpty,
                            child: ContainerCustom(
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      TextCustom(
                                        title: "Recent Orders".tr,
                                        fontSize: 16,
                                        fontFamily: FontFamily.bold,
                                        color: themeChange.isDarkTheme() ? AppThemeData.lynch25 : AppThemeData.lynch950,
                                      ),
                                    ],
                                  ),
                                  spaceH(height: 20),
                                  SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(12),
                                        child: controller.isLoading.value
                                            ? Padding(
                                                padding: paddingEdgeInsets(),
                                                child: Constant.loader(),
                                              )
                                            : controller.recentOrderList.isEmpty
                                                ? TextCustom(title: "No Data Available".tr)
                                                : DataTable(
                                                    horizontalMargin: 20,
                                                    columnSpacing: 30,
                                                    dataRowMaxHeight: 65,
                                                    headingRowHeight: 65,
                                                    border: TableBorder.all(
                                                      color: themeChange.isDarkTheme() ? AppThemeData.lynch800 : AppThemeData.lynch100,
                                                      borderRadius: BorderRadius.circular(12),
                                                    ),
                                                    headingRowColor: WidgetStateColor.resolveWith((states) => themeChange.isDarkTheme() ? AppThemeData.lynch800 : AppThemeData.lynch100),
                                                    columns: [
                                                      CommonUI.dataColumnWidget(context, columnTitle: "Order Id".tr, width: 150),
                                                      CommonUI.dataColumnWidget(context,
                                                          columnTitle: "Customer Name".tr, width: ResponsiveWidget.isMobile(context) ? 150 : MediaQuery.of(context).size.width * 0.08),
                                                      CommonUI.dataColumnWidget(context,
                                                          columnTitle: "Items".tr, width: ResponsiveWidget.isMobile(context) ? 150 : MediaQuery.of(context).size.width * 0.15),
                                                      CommonUI.dataColumnWidget(context,
                                                          columnTitle: "Qty".tr, width: ResponsiveWidget.isMobile(context) ? 150 : MediaQuery.of(context).size.width * 0.08),
                                                      CommonUI.dataColumnWidget(context,
                                                          columnTitle: "Price".tr, width: ResponsiveWidget.isMobile(context) ? 150 : MediaQuery.of(context).size.width * 0.08),
                                                      CommonUI.dataColumnWidget(context,
                                                          columnTitle: "Status".tr, width: ResponsiveWidget.isMobile(context) ? 150 : MediaQuery.of(context).size.width * 0.08),
                                                      CommonUI.dataColumnWidget(context,
                                                          columnTitle: "Actions".tr, width: ResponsiveWidget.isMobile(context) ? 150 : MediaQuery.of(context).size.width * 0.08),
                                                    ],
                                                    rows: controller.recentOrderList
                                                        .map((orderModel) => DataRow(cells: [
                                                              DataCell(TextCustom(
                                                                title: "#${orderModel.id.toString().substring(orderModel.id!.length - 10)}",
                                                              )),
                                                              DataCell(FutureBuilder(
                                                                future: FireStoreUtils.getUserByUserID(orderModel.customerId.toString()),
                                                                builder: (context, snapshot) {
                                                                  if (!snapshot.hasData) {
                                                                    return Container();
                                                                  }
                                                                  UserModel user = snapshot.data ?? UserModel();
                                                                  return Row(
                                                                    mainAxisSize: MainAxisSize.min,
                                                                    children: [
                                                                      NetworkImageWidget(
                                                                        imageUrl: user.profilePic.toString(),
                                                                        height: 24,
                                                                        width: 24,
                                                                      ),
                                                                      spaceW(width: 8),
                                                                      TextCustom(
                                                                        title: user.firstName!.isEmpty
                                                                            ? "N/A".tr
                                                                            : user.firstName.toString() == "Unknown User".tr
                                                                                ? "User Deleted".tr
                                                                                : user.firstName.toString(),
                                                                      ),
                                                                    ],
                                                                  );
                                                                },
                                                              )),
                                                              // DataCell(TextCustom(
                                                              //   title: bookingModel.subTotal.toString(),
                                                              // )),
                                                              DataCell(SizedBox(
                                                                width: ResponsiveWidget.isMobile(context) ? 300 : MediaQuery.of(context).size.width * 0.15,
                                                                child: Padding(
                                                                  padding: const EdgeInsets.symmetric(vertical: 10),
                                                                  child: ListView.builder(
                                                                      shrinkWrap: true,
                                                                      // physics: NeverScrollableScrollPhysics(),
                                                                      primary: true,
                                                                      itemCount: orderModel.items!.length,
                                                                      itemBuilder: (context, index) {
                                                                        return Column(
                                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                                          children: [
                                                                            TextCustom(title: orderModel.items![index].productName.toString()),
                                                                            if (index != orderModel.items!.length - 1) 10.height,
                                                                          ],
                                                                        );
                                                                      }),
                                                                ),
                                                              )),

                                                              DataCell(TextCustom(
                                                                title: orderModel.items!.length.toString(),
                                                              )),
                                                              DataCell(TextCustom(
                                                                title: Constant.amountShow(amount: orderModel.totalAmount.toString()),
                                                              )),
                                                              DataCell(
                                                                Constant.bookingStatusText(context, orderModel.orderStatus.toString()),
                                                              ),
                                                              DataCell(Row(
                                                                children: [
                                                                  InkWell(
                                                                    onTap: () {
                                                                      Get.toNamed("${Routes.ORDER_DETAIL_SCREEN}/${orderModel.id}");
                                                                    },
                                                                    child: SvgPicture.asset(
                                                                      "assets/icons/ic_eye.svg",
                                                                      height: 16,
                                                                      width: 16,
                                                                      color: AppThemeData.lynch400,
                                                                    ),
                                                                  ),
                                                                  spaceW(width: 20),
                                                                  InkWell(
                                                                    onTap: () async {
                                                                      if (Constant.isDemo) {
                                                                        DialogBox.demoDialogBox();
                                                                      } else {
                                                                        bool confirmDelete = await DialogBox.showConfirmationDeleteDialog(context);
                                                                        if (confirmDelete) {
                                                                          await controller.removeOrder(orderModel);
                                                                          controller.refreshRecentOrders();
                                                                        }
                                                                      }
                                                                    },
                                                                    child: SvgPicture.asset(
                                                                      "assets/icons/ic_delete.svg",
                                                                      height: 16,
                                                                      width: 16,
                                                                    ),
                                                                  )
                                                                ],
                                                              )),
                                                            ]))
                                                        .toList(),
                                                  ),
                                      ))
                                ],
                              ),
                            )),
                      ),
                      24.height,
                      controller.top5FoodList.isEmpty ?
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: ContainerCustom(
                            child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextCustom(
                              title: "Daily Trending Menu".tr,
                              fontSize: 16,
                              fontFamily: FontFamily.medium,
                              color: themeChange.isDarkTheme() ? AppThemeData.lynch50 : AppThemeData.lynch950,
                            ),
                            spaceH(height: 15),
                            ListView.builder(
                                    itemCount: controller.top5FoodList.length,
                                    shrinkWrap: true,
                                    itemBuilder: (context, index) {
                                      return Column(
                                        children: [
                                          FutureBuilder<ProductModel?>(
                                            future: FireStoreUtils.getProductByProductId(controller.top5FoodList[index].productId.toString()),
                                            builder: (context, snapshot) {
                                              if (!snapshot.hasData) {
                                                return Container();
                                              }
                                              ProductModel? product = snapshot.data ?? ProductModel();
                                              return Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      NetworkImageWidget(
                                                        imageUrl: product.productImage.toString(),
                                                        height: 60,
                                                        width: 60,
                                                        borderRadius: 0,
                                                      ),
                                                      spaceW(width: 12),
                                                      Expanded(
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
                                                                      title: product.productName.toString(),
                                                                      color: themeChange.isDarkTheme() ? AppThemeData.lynch50 : AppThemeData.lynch950,
                                                                      fontSize: 14,
                                                                      fontFamily: FontFamily.medium,
                                                                    ),
                                                                    TextCustom(
                                                                      title: Constant.amountShow(amount: product.price.toString()),
                                                                      color: themeChange.isDarkTheme() ? AppThemeData.lynch50 : AppThemeData.lynch950,
                                                                      fontFamily: FontFamily.regular,
                                                                      fontSize: 14,
                                                                    ),
                                                                  ],
                                                                ),
                                                                Row(
                                                                  children: [
                                                                    const Icon(
                                                                      Icons.star_rate_rounded,
                                                                      color: AppThemeData.warning200,
                                                                    ),
                                                                    spaceW(width: 4),
                                                                    TextCustom(
                                                                      title: product.reviewCount.toString(),
                                                                      color: themeChange.isDarkTheme() ? AppThemeData.primaryWhite : AppThemeData.primaryBlack,
                                                                      fontSize: 14,
                                                                      fontFamily: FontFamily.regular,
                                                                    )
                                                                  ],
                                                                )
                                                              ],
                                                            ),
                                                            TextCustom(
                                                              title: product.description.toString(),
                                                              color: AppThemeData.lynch500,
                                                              maxLine: 1,
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  if (controller.top5FoodList.length - 1 != index)
                                                    Padding(
                                                      padding: const EdgeInsets.symmetric(vertical: 12),
                                                      child: Divider(color: themeChange.isDarkTheme() ? AppThemeData.lynch900 : AppThemeData.lynch100),
                                                    )
                                                ],
                                              );
                                            },
                                          ),
                                          // TextCustom(title: 'Resturant avalible'),
                                        ],
                                      );
                                    },
                                  )
                          ],
                        )),
                      ) : const SizedBox(),

                      24.height,
                    ],
                  ),
                ),
              ),
            ),
            desktop: SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Scaffold(
                backgroundColor: themeChange.isDarkTheme() ? AppThemeData.lynch950 : AppThemeData.lynch50,
                appBar: CommonUI.appBarCustom(themeChange: themeChange, scaffoldKey: controller.scaffoldKeyDrawer),
                body: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const MenuWidget(),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Obx(
                          () => Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 24, top: 24),
                                child: Wrap(
                                  children: [
                                    commonView(
                                      context: context,
                                      title: "Total Revenue".tr,
                                      value: Constant.amountShow(amount: controller.totalEarnings.toString()),
                                      imageAssets: "assets/icons/ic_currency_dollar.svg",
                                      bgColor: themeChange.isDarkTheme() ? const Color(0xff032426) : const Color(0xffE7FCFD),
                                      textColor: const Color(0xff0CB9C1),
                                    ),
                                    spaceW(width: 24),
                                    commonView(
                                      context: context,
                                      title: "Total Orders".tr,
                                      value: controller.totalOrders.toString(),
                                      imageAssets: "assets/icons/ic_order.svg",
                                      bgColor: themeChange.isDarkTheme() ? const Color(0xff200F2F) : const Color(0xffF2ECF9),
                                      textColor: const Color(0xff7338B3),
                                    ),
                                    spaceW(width: 24),
                                    commonView(
                                      context: context,
                                      title: "Total Customers".tr,
                                      value: controller.totalUser.toString(),
                                      imageAssets: "assets/icons/ic_group.svg",
                                      bgColor: themeChange.isDarkTheme() ? const Color(0xff021827) : const Color(0xffE6F5FE),
                                      textColor: const Color(0xff0479C7),
                                    ),
                                    spaceW(width: 24),
                                    commonView(
                                      context: context,
                                      title: "Total Drivers".tr,
                                      value: controller.totalDriver.toString(),
                                      imageAssets: "assets/icons/ic_user1.svg",
                                      bgColor: themeChange.isDarkTheme() ? const Color(0xff270602) : const Color(0xffFEEAE6),
                                      textColor: const Color(0xffF85A40),
                                    ),
                                  ],
                                ),
                              ),
                              24.height,
                              Padding(
                                padding: paddingEdgeInsets(horizontal: 24, vertical: 0),
                                child: SingleChildScrollView(
                                  child: Row(children: [
                                    Expanded(
                                      flex: 7,
                                      child: userChartStatistic(context),
                                    ),
                                    24.width,
                                    Expanded(
                                      flex: 3,
                                      child: orderChartStatistic(context),
                                    ),
                                  ]),
                                ),
                              ),
                              24.height,
                              Padding(
                                padding: paddingEdgeInsets(horizontal: 24, vertical: 0),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                        flex: 7,
                                        child: Visibility(
                                            visible: controller.recentOrderList.isNotEmpty,
                                            child: ContainerCustom(
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      TextCustom(
                                                        title: "Recent Orders".tr,
                                                        fontSize: 16,
                                                        fontFamily: FontFamily.medium,
                                                        color: themeChange.isDarkTheme() ? AppThemeData.lynch25 : AppThemeData.lynch950,
                                                      ),
                                                    ],
                                                  ),
                                                  spaceH(height: 20),
                                                  SingleChildScrollView(
                                                      scrollDirection: Axis.horizontal,
                                                      child: ClipRRect(
                                                        borderRadius: BorderRadius.circular(12),
                                                        child: controller.isLoading.value
                                                            ? Padding(
                                                                padding: paddingEdgeInsets(),
                                                                child: Constant.loader(),
                                                              )
                                                            : controller.recentOrderList.isEmpty
                                                                ? TextCustom(title: "No Data Available".tr)
                                                                : DataTable(
                                                                    horizontalMargin: 20,
                                                                    columnSpacing: 30,
                                                                    dataRowMaxHeight: 65,
                                                                    headingRowHeight: 65,
                                                                    border: TableBorder.all(
                                                                      color: themeChange.isDarkTheme() ? AppThemeData.lynch800 : AppThemeData.lynch100,
                                                                      borderRadius: BorderRadius.circular(12),
                                                                    ),
                                                                    headingRowColor: WidgetStateColor.resolveWith((states) => themeChange.isDarkTheme() ? AppThemeData.lynch800 : AppThemeData.lynch100),
                                                                    columns: [
                                                                      CommonUI.dataColumnWidget(context, columnTitle: "Order Id".tr, width: 120),
                                                                      CommonUI.dataColumnWidget(context,
                                                                          columnTitle: "Customer Name".tr, width: ResponsiveWidget.isMobile(context) ? 150 : MediaQuery.of(context).size.width * 0.08),
                                                                      CommonUI.dataColumnWidget(context,
                                                                          columnTitle: "Items".tr, width: ResponsiveWidget.isMobile(context) ? 150 : MediaQuery.of(context).size.width * 0.15),
                                                                      CommonUI.dataColumnWidget(context, columnTitle: "Qty".tr, width: 80),
                                                                      CommonUI.dataColumnWidget(context,
                                                                          columnTitle: "Price".tr, width: ResponsiveWidget.isMobile(context) ? 150 : MediaQuery.of(context).size.width * 0.08),
                                                                      CommonUI.dataColumnWidget(context,
                                                                          columnTitle: "Status".tr, width: ResponsiveWidget.isMobile(context) ? 150 : MediaQuery.of(context).size.width * 0.08),
                                                                      CommonUI.dataColumnWidget(context, columnTitle: "Actions".tr, width: 80),
                                                                    ],
                                                                    rows: controller.recentOrderList
                                                                        .map((orderModel) => DataRow(cells: [
                                                                              DataCell(TextCustom(
                                                                                title: "#${orderModel.id.toString().substring(orderModel.id!.length - 10)}",
                                                                              )),
                                                                              DataCell(FutureBuilder(
                                                                                future: FireStoreUtils.getUserByUserID(orderModel.customerId.toString()),
                                                                                builder: (context, snapshot) {
                                                                                  if (!snapshot.hasData) {
                                                                                    return Container();
                                                                                  }
                                                                                  UserModel user = snapshot.data ?? UserModel();
                                                                                  return Row(
                                                                                    mainAxisSize: MainAxisSize.min,
                                                                                    children: [
                                                                                      NetworkImageWidget(
                                                                                        imageUrl: user.profilePic.toString(),
                                                                                        height: 24,
                                                                                        width: 24,
                                                                                      ),
                                                                                      spaceW(width: 8),
                                                                                      TextCustom(
                                                                                        title: user.firstName!.isEmpty
                                                                                            ? "N/A".tr
                                                                                            : user.firstName.toString() == "Unknown User".tr
                                                                                                ? "User Deleted".tr
                                                                                                : user.firstName.toString(),
                                                                                      ),
                                                                                    ],
                                                                                  );
                                                                                },
                                                                              )),
                                                                              DataCell(SizedBox(
                                                                                width: ResponsiveWidget.isMobile(context) ? 300 : MediaQuery.of(context).size.width * 0.15,
                                                                                child: Padding(
                                                                                  padding: const EdgeInsets.symmetric(vertical: 10),
                                                                                  child: ListView.builder(
                                                                                      shrinkWrap: true,
                                                                                      // physics: NeverScrollableScrollPhysics(),
                                                                                      primary: true,
                                                                                      itemCount: orderModel.items!.length,
                                                                                      itemBuilder: (context, index) {
                                                                                        return Column(
                                                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                                                          children: [
                                                                                            TextCustom(title: orderModel.items![index].productName.toString()),
                                                                                            if (index != orderModel.items!.length - 1) 10.height,
                                                                                          ],
                                                                                        );
                                                                                      }),
                                                                                ),
                                                                              )),
                                                                              DataCell(TextCustom(
                                                                                title: orderModel.items!.length.toString(),
                                                                              )),
                                                                              DataCell(TextCustom(
                                                                                title: Constant.amountShow(amount: orderModel.totalAmount.toString()),
                                                                              )),
                                                                              DataCell(
                                                                                Constant.bookingStatusText(context, orderModel.orderStatus.toString()),
                                                                              ),
                                                                              DataCell(Row(
                                                                                children: [
                                                                                  InkWell(
                                                                                    onTap: () {
                                                                                      Get.toNamed("${Routes.ORDER_DETAIL_SCREEN}/${orderModel.id}");
                                                                                    },
                                                                                    child: SvgPicture.asset(
                                                                                      "assets/icons/ic_eye.svg",
                                                                                      height: 16,
                                                                                      width: 16,
                                                                                      color: AppThemeData.lynch400,
                                                                                    ),
                                                                                  ),
                                                                                  spaceW(width: 20),
                                                                                  InkWell(
                                                                                    onTap: () async {
                                                                                      if (Constant.isDemo) {
                                                                                        DialogBox.demoDialogBox();
                                                                                      } else {
                                                                                        bool confirmDelete = await DialogBox.showConfirmationDeleteDialog(context);
                                                                                        if (confirmDelete) {
                                                                                          await controller.removeOrder(orderModel);
                                                                                          controller.refreshRecentOrders();
                                                                                        }
                                                                                      }
                                                                                    },
                                                                                    child: SvgPicture.asset(
                                                                                      "assets/icons/ic_delete.svg",
                                                                                      height: 16,
                                                                                      width: 16,
                                                                                    ),
                                                                                  )
                                                                                ],
                                                                              )),
                                                                            ]))
                                                                        .toList(),
                                                                  ),
                                                      ))
                                                ],
                                              ),
                                            ))),
                                    24.width,
                                    controller.top5FoodList.isEmpty ?
                                    Expanded(
                                        flex: 3,
                                        child: ContainerCustom(
                                            child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            TextCustom(
                                              title: "Daily Trending Menu".tr,
                                              fontSize: 16,
                                            ),
                                            spaceH(height: 15),
                                            ListView.builder(
                                                    itemCount: controller.top5FoodList.length,
                                                    shrinkWrap: true,
                                                    itemBuilder: (context, index) {
                                                      return Column(
                                                        children: [
                                                          FutureBuilder<ProductModel?>(
                                                            future: FireStoreUtils.getProductByProductId(controller.top5FoodList[index].productId.toString()),
                                                            builder: (context, snapshot) {
                                                              if (!snapshot.hasData) {
                                                                return Container();
                                                              }
                                                              ProductModel? product = snapshot.data ?? ProductModel();
                                                              return Column(
                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                mainAxisAlignment: MainAxisAlignment.start,
                                                                children: [
                                                                  Row(
                                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                                    children: [
                                                                      NetworkImageWidget(
                                                                        imageUrl: product.productImage.toString(),
                                                                        height: 60,
                                                                        width: 60,
                                                                        borderRadius: 0,
                                                                      ),
                                                                      spaceW(width: 12),
                                                                      Expanded(
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
                                                                                      title: product.productName.toString(),
                                                                                      color: themeChange.isDarkTheme() ? AppThemeData.lynch50 : AppThemeData.lynch950,
                                                                                      fontSize: 14,
                                                                                      fontFamily: FontFamily.medium,
                                                                                    ),
                                                                                    TextCustom(
                                                                                      title: Constant.amountShow(amount: product.price.toString()),
                                                                                      color: themeChange.isDarkTheme() ? AppThemeData.lynch50 : AppThemeData.lynch950,
                                                                                      fontFamily: FontFamily.regular,
                                                                                      fontSize: 14,
                                                                                    ),
                                                                                  ],
                                                                                ),
                                                                                Row(
                                                                                  children: [
                                                                                    const Icon(
                                                                                      Icons.star_rate_rounded,
                                                                                      color: AppThemeData.warning200,
                                                                                    ),
                                                                                    spaceW(width: 4),
                                                                                    TextCustom(
                                                                                      title: product.reviewCount.toString(),
                                                                                      color: themeChange.isDarkTheme() ? AppThemeData.primaryWhite : AppThemeData.primaryBlack,
                                                                                      fontSize: 14,
                                                                                      fontFamily: FontFamily.regular,
                                                                                    )
                                                                                  ],
                                                                                )
                                                                              ],
                                                                            ),
                                                                            TextCustom(
                                                                              title: product.description.toString(),
                                                                              color: AppThemeData.lynch500,
                                                                              maxLine: 1,
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                  if (controller.top5FoodList.length - 1 != index)
                                                                    Padding(
                                                                      padding: const EdgeInsets.symmetric(vertical: 12),
                                                                      child: Divider(color: themeChange.isDarkTheme() ? AppThemeData.lynch900 : AppThemeData.lynch100),
                                                                    )
                                                                ],
                                                              );
                                                            },
                                                          ),
                                                          // TextCustom(title: 'Resturant avalible'),
                                                        ],
                                                      );
                                                    },
                                                  )
                                          ],
                                        ))) : const SizedBox()
                                  ],
                                ),
                              ),
                              24.height,
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            tablet: Scaffold(
              key: controller.scaffoldKeyDrawer,
              backgroundColor: themeChange.isDarkTheme() ? AppThemeData.lynch950 : AppThemeData.lynch50,
              appBar: AppBar(
                elevation: 0.0,
                toolbarHeight: 70,
                automaticallyImplyLeading: false,
                backgroundColor: themeChange.isDarkTheme() ? AppThemeData.primaryBlack : AppThemeData.primaryWhite,
                leadingWidth: 200,
                // title: title,
                leading: InkWell(
                    onTap: () {
                      controller.toggleDrawer();
                    },
                    child: Center(
                      child: Row(
                        children: [
                          Expanded(
                            child: Row(
                              children: [
                                10.width,
                                Icon(
                                  Icons.menu,
                                  size: 30,
                                  color: themeChange.isDarkTheme() ? AppThemeData.primary500 : AppThemeData.primary500,
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    )),
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
                      decoration: BoxDecoration(color: themeChange.isDarkTheme() ? AppThemeData.lynch950 : AppThemeData.lynch50, shape: BoxShape.circle),
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
                // key: scaffoldKey,
                width: 270,
                backgroundColor: themeChange.isDarkTheme() ? AppThemeData.primaryBlack : AppThemeData.primaryWhite,
                child: const MenuWidget(),
              ),
              body: SingleChildScrollView(
                child: Obx(
                  () => Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 16, right: 16, top: 24),
                        child: Wrap(
                          runSpacing: 24,
                          spacing: 24,
                          children: [
                            commonView(
                              context: context,
                              title: "Total Revenue".tr,
                              value: Constant.amountShow(amount: controller.totalEarnings.toString()),
                              imageAssets: "assets/icons/ic_currency_dollar.svg",
                              bgColor: themeChange.isDarkTheme() ? const Color(0xff032426) : const Color(0xffE7FCFD),
                              textColor: const Color(0xff0CB9C1),
                            ),
                            commonView(
                              context: context,
                              title: "Total Orders".tr,
                              value: controller.totalOrders.toString(),
                              imageAssets: "assets/icons/ic_order.svg",
                              bgColor: themeChange.isDarkTheme() ? const Color(0xff200F2F) : const Color(0xffF2ECF9),
                              textColor: const Color(0xff7338B3),
                            ),
                            commonView(
                              context: context,
                              title: "Total Customers".tr,
                              value: controller.totalUser.toString(),
                              imageAssets: "assets/icons/ic_group.svg",
                              bgColor: themeChange.isDarkTheme() ? const Color(0xff021827) : const Color(0xffE6F5FE),
                              textColor: const Color(0xff0479C7),
                            ),
                            commonView(
                              context: context,
                              title: "Total Drivers".tr,
                              value: controller.totalDriver.toString(),
                              imageAssets: "assets/icons/ic_user1.svg",
                              bgColor: themeChange.isDarkTheme() ? const Color(0xff270602) : const Color(0xffFEEAE6),
                              textColor: const Color(0xffF85A40),
                            ),
                          ],
                        ),
                      ),
                      24.height,
                      controller.isUserData.value
                          ? Padding(
                              padding: paddingEdgeInsets(),
                              child: Constant.loader(),
                            )
                          : Container(
                              padding: paddingEdgeInsets(horizontal: 24, vertical: 0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        flex: 10,
                                        child: userChartStatistic(context),
                                      ),
                                      24.width,
                                      Expanded(
                                        flex: 7,
                                        child: orderChartStatistic(context),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                      24.height,
                      Padding(
                        padding: paddingEdgeInsets(horizontal: 24, vertical: 0),
                        child: Visibility(
                            visible: controller.recentOrderList.isNotEmpty,
                            child: ContainerCustom(
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      TextCustom(
                                        title: "Recent Orders".tr,
                                        fontSize: 16,
                                        fontFamily: FontFamily.medium,
                                        color: themeChange.isDarkTheme() ? AppThemeData.lynch25 : AppThemeData.lynch950,
                                      ),
                                    ],
                                  ),
                                  spaceH(height: 20),
                                  SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(12),
                                        child: controller.isLoading.value
                                            ? Padding(
                                                padding: paddingEdgeInsets(),
                                                child: Constant.loader(),
                                              )
                                            : controller.recentOrderList.isEmpty
                                                ? TextCustom(title: "No Data Available".tr)
                                                : DataTable(
                                                    horizontalMargin: 20,
                                                    columnSpacing: 30,
                                                    dataRowMaxHeight: 65,
                                                    headingRowHeight: 65,
                                                    border: TableBorder.all(
                                                      color: themeChange.isDarkTheme() ? AppThemeData.lynch800 : AppThemeData.lynch100,
                                                      borderRadius: BorderRadius.circular(12),
                                                    ),
                                                    headingRowColor: WidgetStateColor.resolveWith((states) => themeChange.isDarkTheme() ? AppThemeData.lynch800 : AppThemeData.lynch100),
                                                    columns: [
                                                      CommonUI.dataColumnWidget(context, columnTitle: "Order Id".tr, width: 150),
                                                      CommonUI.dataColumnWidget(context,
                                                          columnTitle: "Customer Name".tr, width: ResponsiveWidget.isMobile(context) ? 150 : MediaQuery.of(context).size.width * 0.08),
                                                      CommonUI.dataColumnWidget(context,
                                                          columnTitle: "Items".tr, width: ResponsiveWidget.isMobile(context) ? 150 : MediaQuery.of(context).size.width * 0.15),
                                                      CommonUI.dataColumnWidget(context,
                                                          columnTitle: "Qty".tr, width: ResponsiveWidget.isMobile(context) ? 150 : MediaQuery.of(context).size.width * 0.08),
                                                      CommonUI.dataColumnWidget(context,
                                                          columnTitle: "Price".tr, width: ResponsiveWidget.isMobile(context) ? 150 : MediaQuery.of(context).size.width * 0.08),
                                                      CommonUI.dataColumnWidget(context,
                                                          columnTitle: "Status".tr, width: ResponsiveWidget.isMobile(context) ? 150 : MediaQuery.of(context).size.width * 0.08),
                                                      CommonUI.dataColumnWidget(context,
                                                          columnTitle: "Actions".tr, width: ResponsiveWidget.isMobile(context) ? 150 : MediaQuery.of(context).size.width * 0.08),
                                                    ],
                                                    rows: controller.recentOrderList
                                                        .map((orderModel) => DataRow(cells: [
                                                              DataCell(TextCustom(
                                                                title: "#${orderModel.id.toString().substring(orderModel.id!.length - 10)}",
                                                              )),
                                                              DataCell(FutureBuilder(
                                                                future: FireStoreUtils.getUserByUserID(orderModel.customerId.toString()),
                                                                builder: (context, snapshot) {
                                                                  if (!snapshot.hasData) {
                                                                    return Container();
                                                                  }
                                                                  UserModel user = snapshot.data ?? UserModel();
                                                                  return Row(
                                                                    mainAxisSize: MainAxisSize.min,
                                                                    children: [
                                                                      NetworkImageWidget(
                                                                        imageUrl: user.profilePic.toString(),
                                                                        height: 24,
                                                                        width: 24,
                                                                      ),
                                                                      spaceW(width: 8),
                                                                      TextCustom(
                                                                        title: user.firstName!.isEmpty
                                                                            ? "N/A".tr
                                                                            : user.firstName.toString() == "Unknown User".tr
                                                                                ? "User Deleted".tr
                                                                                : user.firstName.toString(),
                                                                      ),
                                                                    ],
                                                                  );
                                                                },
                                                              )),
                                                              DataCell(SizedBox(
                                                                width: ResponsiveWidget.isMobile(context) ? 300 : MediaQuery.of(context).size.width * 0.15,
                                                                child: Padding(
                                                                  padding: const EdgeInsets.symmetric(vertical: 10),
                                                                  child: ListView.builder(
                                                                      shrinkWrap: true,
                                                                      // physics: NeverScrollableScrollPhysics(),
                                                                      primary: true,
                                                                      itemCount: orderModel.items!.length,
                                                                      itemBuilder: (context, index) {
                                                                        return Column(
                                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                                          children: [
                                                                            TextCustom(title: orderModel.items![index].productName.toString()),
                                                                            if (index != orderModel.items!.length - 1) 10.height,
                                                                          ],
                                                                        );
                                                                      }),
                                                                ),
                                                              )),
                                                              DataCell(TextCustom(
                                                                title: orderModel.items!.length.toString(),
                                                              )),
                                                              DataCell(TextCustom(
                                                                title: Constant.amountShow(amount: orderModel.totalAmount.toString()),
                                                              )),
                                                              DataCell(
                                                                Constant.bookingStatusText(context, orderModel.orderStatus.toString()),
                                                              ),
                                                              DataCell(Row(
                                                                children: [
                                                                  InkWell(
                                                                    onTap: () {
                                                                      Get.toNamed("${Routes.ORDER_DETAIL_SCREEN}/${orderModel.id}");
                                                                    },
                                                                    child: SvgPicture.asset(
                                                                      "assets/icons/ic_eye.svg",
                                                                      height: 16,
                                                                      width: 16,
                                                                      color: AppThemeData.lynch400,
                                                                    ),
                                                                  ),
                                                                  spaceW(width: 20),
                                                                  InkWell(
                                                                    onTap: () async {
                                                                      if (Constant.isDemo) {
                                                                        DialogBox.demoDialogBox();
                                                                      } else {
                                                                        bool confirmDelete = await DialogBox.showConfirmationDeleteDialog(context);
                                                                        if (confirmDelete) {
                                                                          await controller.removeOrder(orderModel);
                                                                          controller.refreshRecentOrders();
                                                                        }
                                                                      }
                                                                    },
                                                                    child: SvgPicture.asset(
                                                                      "assets/icons/ic_delete.svg",
                                                                      height: 16,
                                                                      width: 16,
                                                                    ),
                                                                  )
                                                                ],
                                                              )),
                                                            ]))
                                                        .toList(),
                                                  ),
                                      ))
                                ],
                              ),
                            )),
                      ),
                      24.height,
                      controller.top5FoodList.isEmpty
                          ? Padding(
                              padding: paddingEdgeInsets(horizontal: 24, vertical: 0),
                              child: ContainerCustom(
                                  padding: const EdgeInsets.all(20),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      TextCustom(
                                        title: "Daily Trending Menu".tr,
                                        fontSize: 16,
                                        fontFamily: FontFamily.medium,
                                      ),
                                      spaceH(height: 15),
                                      ListView.builder(
                                        itemCount: controller.top5FoodList.length,
                                        shrinkWrap: true,
                                        itemBuilder: (context, index) {
                                          return Column(
                                            children: [
                                              FutureBuilder<ProductModel?>(
                                                future: FireStoreUtils.getProductByProductId(controller.top5FoodList[index].productId.toString()),
                                                builder: (context, snapshot) {
                                                  if (!snapshot.hasData) {
                                                    return Container();
                                                  }
                                                  ProductModel? product = snapshot.data ?? ProductModel();
                                                  return Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                    children: [
                                                      Row(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          NetworkImageWidget(
                                                            imageUrl: product.productImage.toString(),
                                                            height: 60,
                                                            width: 60,
                                                            borderRadius: 0,
                                                          ),
                                                          spaceW(width: 12),
                                                          Expanded(
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
                                                                          title: product.productName.toString(),
                                                                          color: themeChange.isDarkTheme() ? AppThemeData.lynch50 : AppThemeData.lynch950,
                                                                          fontSize: 14,
                                                                          fontFamily: FontFamily.medium,
                                                                        ),
                                                                        TextCustom(
                                                                          title: Constant.amountShow(amount: product.price.toString()),
                                                                          color: themeChange.isDarkTheme() ? AppThemeData.lynch50 : AppThemeData.lynch950,
                                                                          fontFamily: FontFamily.regular,
                                                                          fontSize: 14,
                                                                        ),
                                                                      ],
                                                                    ),
                                                                    Row(
                                                                      children: [
                                                                        const Icon(
                                                                          Icons.star_rate_rounded,
                                                                          color: AppThemeData.warning200,
                                                                        ),
                                                                        spaceW(width: 4),
                                                                        TextCustom(
                                                                          title: product.reviewCount.toString(),
                                                                          color: themeChange.isDarkTheme() ? AppThemeData.primaryWhite : AppThemeData.primaryBlack,
                                                                          fontSize: 14,
                                                                          fontFamily: FontFamily.regular,
                                                                        )
                                                                      ],
                                                                    )
                                                                  ],
                                                                ),
                                                                TextCustom(
                                                                  title: product.description.toString(),
                                                                  color: AppThemeData.lynch500,
                                                                  maxLine: 1,
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      if (controller.top5FoodList.length - 1 != index)
                                                        Padding(
                                                          padding: const EdgeInsets.symmetric(vertical: 8),
                                                          child: Divider(color: themeChange.isDarkTheme() ? AppThemeData.lynch900 : AppThemeData.lynch100),
                                                        )
                                                    ],
                                                  );
                                                },
                                              ),
                                            ],
                                          );
                                        },
                                      )
                                    ],
                                  )),
                            )
                          : const SizedBox(),
                      24.height,
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

GetX<DashboardScreenController> userChartStatistic(BuildContext context) {
  return GetX<DashboardScreenController>(builder: (controller) {
    return SizedBox(
      child: ContainerCustom(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextCustom(
                    title: 'Total User'.tr,
                    fontSize: 20,
                    fontFamily: FontFamily.bold,
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                      height: 200,
                      width: ResponsiveWidget.isDesktop(context)
                          ? (ScreenSize.width(100, context) - 270) * 0.65
                          : ResponsiveWidget.isTablet(context)
                              ? (ScreenSize.width(100, context) - 270) * 0.75
                              : ScreenSize.width(74, context),
                      child: controller.isLoadingBookingChart.value
                          ? Constant.loader()
                          : SfCartesianChart(
                              borderWidth: 0,
                              tooltipBehavior: TooltipBehavior(enable: true),
                              plotAreaBorderColor: Colors.transparent,
                              borderColor: Colors.transparent,
                              primaryXAxis: CategoryAxis(
                                axisLine: AxisLine(color: AppThemeData.textBlack.withOpacity(.5)),
                                majorGridLines: const MajorGridLines(color: Colors.transparent),
                                labelStyle: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600),
                              ),
                              primaryYAxis: const NumericAxis(
                                borderWidth: 0,
                                borderColor: Colors.transparent,
                                axisLine: AxisLine(color: AppThemeData.textBlack),
                                majorGridLines: MajorGridLines(color: Colors.transparent, width: 0),
                                minorTickLines: MinorTickLines(color: Colors.transparent, width: 0),
                                minimum: 0,
                                interval: 10,
                                labelStyle: TextStyle(fontSize: 10, fontWeight: FontWeight.w600),
                              ),
                              series: <CartesianSeries>[
                                ColumnSeries<ChartData, String>(
                                  dataSource: controller.usersChartData!,
                                  xValueMapper: (ChartData data, _) => data.x,
                                  yValueMapper: (ChartData data, _) => data.y,
                                  name: 'Active Users',
                                  color: AppThemeData.chartColor,
                                  width: 0.25,
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(8),
                                    topRight: Radius.circular(8),
                                  ),
                                ),
                                // ColumnSeries<ChartData, String>(
                                //   dataSource: controller.usersChartData!,
                                //   xValueMapper: (ChartData data, _) => data.x,
                                //   yValueMapper: (ChartData data, _) => data.y,
                                //   name: 'Inactive Users',
                                //   color: Colors.purple,
                                //   width: 0.3,
                                // ),
                              ],
                            )

                      // SfCartesianChart(
                      //         borderWidth: 0,
                      //         tooltipBehavior: TooltipBehavior(enable: true),
                      //         plotAreaBorderColor: Colors.transparent,
                      //         borderColor: Colors.transparent,
                      //         primaryXAxis: CategoryAxis(
                      //           axisLine: AxisLine(color: AppThemeData.textBlack.withOpacity(.5)),
                      //           majorGridLines: const MajorGridLines(color: Colors.transparent),
                      //           labelStyle: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600),
                      //         ),
                      //         primaryYAxis: const NumericAxis(
                      //           borderWidth: 0,
                      //           borderColor: Colors.transparent,
                      //           axisLine: AxisLine(color: AppThemeData.textBlack),
                      //           majorGridLines: MajorGridLines(color: Colors.transparent, width: 0),
                      //           minorTickLines: MinorTickLines(color: Colors.transparent, width: 0),
                      //           minimum: 0,
                      //           minorGridLines: MinorGridLines(),
                      //           interval: 10,
                      //           labelStyle: TextStyle(fontSize: 10, fontWeight: FontWeight.w600),
                      //         ),
                      //         series: <CartesianSeries<ChartData, String>>[
                      //           ColumnSeries<ChartData, String>(
                      //             dataSource: controller.usersChartData!,
                      //             xValueMapper: (ChartData data, _) => data.x,
                      //             yValueMapper: (ChartData data, _) => data.y,
                      //             markerSettings: const MarkerSettings(isVisible: true),
                      //             name: 'Users'.tr,
                      //             color: AppThemeData.primary500,
                      //             width: 0.4,
                      //           ),
                      //         ],
                      //       ),
                      ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  });
}

GetX<DashboardScreenController> recentUserChartStatistic(BuildContext context) {
  final themeChange = Provider.of<DarkThemeProvider>(context);

  return GetX<DashboardScreenController>(builder: (controller) {
    return SizedBox(
      child: ContainerCustom(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextCustom(
                    title: 'Recent User'.tr,
                    fontSize: 20,
                    fontFamily: FontFamily.bold,
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    height: 200,
                    width: ResponsiveWidget.isDesktop(context)
                        ? (ScreenSize.width(100, context) - 270) * 0.65
                        : ResponsiveWidget.isTablet(context)
                            ? (ScreenSize.width(100, context) - 270) * 0.75
                            : ScreenSize.width(74, context),
                    child: controller.isLoadingBookingChart.value
                        ? Constant.loader()
                        : SfCartesianChart(
                            borderWidth: 0,
                            plotAreaBorderColor: Colors.transparent,
                            borderColor: Colors.transparent,
                            primaryXAxis: CategoryAxis(
                              axisLine: AxisLine(color: AppThemeData.textBlack.withOpacity(.5)),
                              majorGridLines: const MajorGridLines(color: Colors.transparent),
                              labelStyle: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600),
                            ),
                            primaryYAxis: const NumericAxis(
                              borderWidth: 0,
                              borderColor: Colors.transparent,
                              axisLine: AxisLine(color: AppThemeData.textBlack),
                              majorGridLines: MajorGridLines(color: Colors.transparent, width: 0),
                              minorTickLines: MinorTickLines(color: Colors.transparent, width: 0),
                              minimum: 0,
                              minorGridLines: MinorGridLines(),
                              interval: 10,
                              labelStyle: TextStyle(fontSize: 10, fontWeight: FontWeight.w600),
                            ),
                            tooltipBehavior: TooltipBehavior(enable: false),
                            series: <CartesianSeries<ChartData, String>>[
                              SplineAreaSeries<ChartData, String>(
                                dataSource: controller.recentUsersChartData!,
                                xValueMapper: (ChartData data, _) => data.x,
                                yValueMapper: (ChartData data, _) => data.y,
                                markerSettings: const MarkerSettings(isVisible: false),
                                name: 'Users'.tr,
                                borderColor: themeChange.isDarkTheme() ? AppThemeData.tertiary700 : AppThemeData.tertiary300,
                                borderWidth: 5,
                                color: themeChange.isDarkTheme() ? AppThemeData.primaryBlack : AppThemeData.primaryWhite,
                              ),
                            ],
                          ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  });
}

GetX<DashboardScreenController> orderChartStatistic(BuildContext context) {
  final themeChange = Provider.of<DarkThemeProvider>(context);
  return GetX<DashboardScreenController>(builder: (controller) {
    return ContainerCustom(
      // color: Colors.pink,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextCustom(
            title: 'Total Orders'.tr,
            fontSize: 20,
            fontFamily: FontFamily.bold,
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 200,
            child: (controller.isUserData.value)
                ? Constant.loader()
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: SfCircularChart(
                          annotations: <CircularChartAnnotation>[
                            CircularChartAnnotation(
                              widget: Center(
                                child: TextCustom(
                                  title: "${(controller.totalOrders.value == 0 ? 0 : ((controller.totalCompletedOrders.value / controller.totalOrders.value) * 100).round())}%",
                                  fontFamily: FontFamily.bold,
                                  fontSize: 20,
                                ),
                              ),
                            )
                          ],
                          borderWidth: 0,
                          tooltipBehavior: TooltipBehavior(enable: true),
                          borderColor: Colors.transparent,
                          series: <RadialBarSeries<ChartDataCircle, String>>[
                            RadialBarSeries<ChartDataCircle, String>(
                              cornerStyle: CornerStyle.bothCurve,
                              gap: "3",
                              radius: "70",
                              trackColor: themeChange.isDarkTheme() ? AppThemeData.lynch800 : AppThemeData.lynch100,
                              dataSource: [
                                ChartDataCircle('Completed'.tr, controller.totalCompletedOrders.value, const Color(0xffF87626)),
                                ChartDataCircle('Pending'.tr, controller.totalPendingOrders.value, const Color(0xff0479C7)),
                                ChartDataCircle('Rejected'.tr, controller.totalRejectedOrders.value, const Color(0xffF85A40)),
                              ],
                              xValueMapper: (ChartDataCircle data, _) => data.x,
                              yValueMapper: (ChartDataCircle data, _) => data.y,
                              pointColorMapper: (ChartDataCircle data, _) => data.color,
                              strokeWidth: 30,
                              dataLabelSettings: const DataLabelSettings(isVisible: false),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          buildLegendDot("Completed".tr, const Color(0xffF87626), controller.totalOrders.value, controller.totalCompletedOrders.value),
                          spaceW(width: 12),
                          buildLegendDot("Pending".tr, const Color(0xff0479C7), controller.totalOrders.value, controller.totalPendingOrders.value),
                          spaceW(width: 12),
                          buildLegendDot("Rejected".tr, const Color(0xffF85A40), controller.totalOrders.value, controller.totalRejectedOrders.value),
                        ],
                      ),
                    ],
                  ),
          )
        ],
      ),
    );
  });
}

Widget buildLegendDot(String title, Color color, int totalOrders, int value) {
  int percentage = totalOrders == 0 ? 0 : ((value / totalOrders) * 100).round();

  return Column(
    children: [
      Row(
        children: [
          Container(
            height: 12.0,
            width: 12.0,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 6),
          TextCustom(title: title),
        ],
      ),
      TextCustom(
        title: "$percentage%",
        fontFamily: FontFamily.bold,
      ),
    ],
  );
}

Container commonView({required BuildContext context, required String title, required String value, required String imageAssets, required Color bgColor, required Color textColor}) {
  final themeChange = Provider.of<DarkThemeProvider>(context);
  return Container(
    // margin: const EdgeInsets.only(right: 24, top: 24),
    padding: const EdgeInsets.all(12),
    height: 120,
    width: ResponsiveWidget.isDesktop(context) ? (ScreenSize.width(100, context) - 445) / 4 : (ScreenSize.width(100, context) - 80) / 2,
    decoration: BoxDecoration(
      // image: const DecorationImage(image: AssetImage("assets/image/Card1.png"), fit: BoxFit.fill),
      color: themeChange.isDarkTheme() ? AppThemeData.primaryBlack : AppThemeData.primaryWhite,
      // border: Border.all(color: themeChange.getTheme() ? AppColors.greyShade900 : AppColors.lynch25.withOpacity(.5)),
      borderRadius: BorderRadius.circular(12),
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(shape: BoxShape.circle, color: bgColor),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SvgPicture.asset(
              imageAssets,
              color: textColor,
              height: 20,
              width: 20,
            ),
          ),
        ),
        const Spacer(),
        TextCustom(
          title: title,
          fontSize: 14,
        ),
        TextCustom(
          title: value,
          fontFamily: FontFamily.bold,
          fontSize: 24,
        )
      ],
    ),
  );
}
