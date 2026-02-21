// ignore_for_file: use_super_parameters, deprecated_member_use

import 'package:admin_panel/app/components/menu_widget.dart';
import 'package:admin_panel/app/components/network_image_widget.dart';
import 'package:admin_panel/app/constant/constants.dart';
import 'package:admin_panel/app/models/product_model.dart';
import 'package:admin_panel/app/routes/app_pages.dart';
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
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';
import '../controllers/customer_detail_screen_controller.dart';

class CustomerDetailScreenView extends GetView<CustomerDetailScreenController> {
  const CustomerDetailScreenView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetX<CustomerDetailScreenController>(
      init: CustomerDetailScreenController(),
      builder: (controller) {
        return Scaffold(
          backgroundColor: themeChange.isDarkTheme() ? AppThemeData.lynch950 : AppThemeData.lynch50,
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
          body: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (ResponsiveWidget.isDesktop(context)) ...{const MenuWidget()},
              Expanded(
                child: controller.isLoading.value
                    ? Constant.loader()
                    : Padding(
                        padding: paddingEdgeInsets(),
                        child: SingleChildScrollView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          child: Column(mainAxisSize: MainAxisSize.min, mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.start, children: [
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
                                                    onTap: () => Get.offAllNamed(Routes.CUSTOMER_SCREEN),
                                                    child: TextCustom(title: 'Users'.tr, fontSize: 14, fontFamily: FontFamily.medium, color: AppThemeData.lynch500)),
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
                                                  onTap: () => Get.offAllNamed(Routes.CUSTOMER_SCREEN),
                                                  child: TextCustom(title: 'Users'.tr, fontSize: 14, fontFamily: FontFamily.medium, color: AppThemeData.lynch500)),
                                              const TextCustom(title: ' / ', fontSize: 14, fontFamily: FontFamily.medium, color: AppThemeData.lynch500),
                                              TextCustom(title: ' ${controller.title.value} ', fontSize: 14, fontFamily: FontFamily.medium, color: AppThemeData.primary500)
                                            ])
                                          ]),
                                        ]),
                                  spaceH(height: 20),
                                  ResponsiveWidget(
                                    mobile: Column(
                                      children: [
                                        ContainerCustom(
                                          color: themeChange.isDarkTheme() ? AppThemeData.lynch900 : AppThemeData.lynch50,
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: [
                                                  NetworkImageWidget(
                                                    imageUrl: controller.userModel.value.profilePic.toString(),
                                                    height: 64,
                                                    width: 64,
                                                  ),
                                                  spaceW(width: 12),
                                                  TextCustom(
                                                    title: controller.userModel.value.fullNameString(),
                                                    fontSize: 16,
                                                    fontFamily: FontFamily.medium,
                                                    color: themeChange.isDarkTheme() ? AppThemeData.lynch25 : AppThemeData.lynch950,
                                                  )
                                                ],
                                              ),
                                              spaceH(height: 16),
                                              TextCustom(
                                                title: "Mobile Number",
                                                fontSize: 14,
                                                fontFamily: FontFamily.regular,
                                                color: themeChange.isDarkTheme() ? AppThemeData.lynch400 : AppThemeData.lynch500,
                                              ),
                                              TextCustom(
                                                title: Constant.maskMobileNumber(
                                                    countryCode: controller.userModel.value.countryCode.toString(),
                                                    mobileNumber: controller.userModel.value.phoneNumber.toString()),
                                                fontSize: 14,
                                                fontFamily: FontFamily.medium,
                                                color: themeChange.isDarkTheme() ? AppThemeData.lynch25 : AppThemeData.lynch950,
                                              ),
                                              spaceH(height: 16),
                                              TextCustom(
                                                title: "Date",
                                                fontSize: 14,
                                                fontFamily: FontFamily.regular,
                                                color: themeChange.isDarkTheme() ? AppThemeData.lynch400 : AppThemeData.lynch500,
                                              ),
                                              TextCustom(
                                                title: Constant.timestampToDate(controller.userModel.value.createdAt!),
                                                fontSize: 14,
                                                fontFamily: FontFamily.medium,
                                                color: themeChange.isDarkTheme() ? AppThemeData.lynch25 : AppThemeData.lynch950,
                                              ),
                                              spaceH(height: 16),
                                              TextCustom(
                                                title: "Total Orders",
                                                fontSize: 14,
                                                fontFamily: FontFamily.regular,
                                                color: themeChange.isDarkTheme() ? AppThemeData.lynch400 : AppThemeData.lynch500,
                                              ),
                                              TextCustom(
                                                title: controller.totalOrders.toString(),
                                                fontSize: 14,
                                                fontFamily: FontFamily.medium,
                                                color: themeChange.isDarkTheme() ? AppThemeData.lynch25 : AppThemeData.lynch950,
                                              ),
                                            ],
                                          ),
                                        ),
                                        spaceH(height: 24),
                                        controller.bookingList.isEmpty
                                            ? const SizedBox()
                                            : ContainerCustom(
                                                color: themeChange.isDarkTheme() ? AppThemeData.lynch900 : AppThemeData.lynch50,
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    TextCustom(
                                                      title: "Order History".tr,
                                                      fontSize: 18,
                                                      fontFamily: FontFamily.regular,
                                                      color: themeChange.isDarkTheme() ? AppThemeData.lynch50 : AppThemeData.lynch950,
                                                    ),
                                                    spaceH(height: 24),
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
                                                                width: ResponsiveWidget.isMobile(context) ? 150 : MediaQuery.of(context).size.width * 0.12),
                                                            CommonUI.dataColumnWidget(context,
                                                                columnTitle: "Date".tr, width: ResponsiveWidget.isMobile(context) ? 150 : MediaQuery.of(context).size.width * 0.12),
                                                            CommonUI.dataColumnWidget(context,
                                                                columnTitle: "Price".tr,
                                                                width: ResponsiveWidget.isMobile(context) ? 150 : MediaQuery.of(context).size.width * 0.07),
                                                            CommonUI.dataColumnWidget(context,
                                                                columnTitle: "Status".tr,
                                                                width: ResponsiveWidget.isMobile(context) ? 150 : MediaQuery.of(context).size.width * 0.12),
                                                            CommonUI.dataColumnWidget(context,
                                                                columnTitle: "Action".tr,
                                                                width: ResponsiveWidget.isMobile(context) ? 80 : MediaQuery.of(context).size.width * 0.04),
                                                          ],
                                                          rows: controller.bookingList
                                                              .map((bookingModel) => DataRow(cells: [
                                                                    DataCell(
                                                                      TextCustom(
                                                                        title: bookingModel.id!.isEmpty ? "N/A".tr : "#${bookingModel.id!.substring(0, 4)}",
                                                                      ),
                                                                    ),
                                                                    DataCell(
                                                                      SingleChildScrollView(
                                                                        child: Column(
                                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                                          children: List.generate(
                                                                            bookingModel.items!.length,
                                                                            (index) {
                                                                              return FutureBuilder<ProductModel?>(
                                                                                future: FireStoreUtils.getProductByProductId(
                                                                                  bookingModel.items![index].productId.toString(),
                                                                                ),
                                                                                builder: (context, snapshot) {
                                                                                  if (!snapshot.hasData) {
                                                                                    return Container();
                                                                                  }
                                                                                  ProductModel? product = snapshot.data ?? ProductModel();
                                                                                  return Padding(
                                                                                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                                                                                    child: Row(
                                                                                      children: [
                                                                                        NetworkImageWidget(
                                                                                          imageUrl: product.productImage.toString(),
                                                                                          height: 24,
                                                                                          width: 24,
                                                                                        ),
                                                                                        spaceW(width: 12),
                                                                                        TextCustom(
                                                                                          title: product.productName.toString(),
                                                                                        ),
                                                                                      ],
                                                                                    ),
                                                                                  );
                                                                                },
                                                                              );
                                                                            },
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    DataCell(
                                                                      TextCustom(
                                                                        title: Constant.timestampToDate(bookingModel.createdAt!),
                                                                      ),
                                                                    ),
                                                                    DataCell(
                                                                      TextCustom(
                                                                        title: Constant.amountShow(amount: bookingModel.totalAmount.toString()),
                                                                      ),
                                                                    ),
                                                                    DataCell(Constant.bookingStatusText(context, bookingModel.orderStatus)),
                                                                    DataCell(
                                                                      InkWell(
                                                                        onTap: () async {
                                                                          Get.toNamed("${Routes.ORDER_DETAIL_SCREEN}/${bookingModel.id}");
                                                                        },
                                                                        child: SvgPicture.asset(
                                                                          "assets/icons/ic_eye.svg",
                                                                          color: AppThemeData.lynch400,
                                                                          height: 16,
                                                                          width: 16,
                                                                        ),
                                                                      ),
                                                                    )
                                                                  ]))
                                                              .toList(),
                                                        ),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                      ],
                                    ),
                                    tablet: Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        controller.bookingList.isEmpty
                                            ? const SizedBox()
                                            : Padding(
                                                padding: const EdgeInsets.only(right: 24),
                                                child: ContainerCustom(
                                                  color: themeChange.isDarkTheme() ? AppThemeData.lynch900 : AppThemeData.lynch50,
                                                  child: Column(
                                                    mainAxisSize: MainAxisSize.min,
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      TextCustom(
                                                        title: "Order History".tr,
                                                        fontSize: 18,
                                                        fontFamily: FontFamily.regular,
                                                        color: themeChange.isDarkTheme() ? AppThemeData.lynch50 : AppThemeData.lynch950,
                                                      ),
                                                      spaceH(height: 24),
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
                                                                  width: ResponsiveWidget.isMobile(context) ? 150 : MediaQuery.of(context).size.width * 0.12),
                                                              CommonUI.dataColumnWidget(context,
                                                                  columnTitle: "Date".tr,
                                                                  width: ResponsiveWidget.isMobile(context) ? 150 : MediaQuery.of(context).size.width * 0.12),
                                                              CommonUI.dataColumnWidget(context,
                                                                  columnTitle: "Price".tr,
                                                                  width: ResponsiveWidget.isMobile(context) ? 150 : MediaQuery.of(context).size.width * 0.07),
                                                              CommonUI.dataColumnWidget(context,
                                                                  columnTitle: "Status".tr,
                                                                  width: ResponsiveWidget.isMobile(context) ? 150 : MediaQuery.of(context).size.width * 0.12),
                                                              CommonUI.dataColumnWidget(context,
                                                                  columnTitle: "Action".tr,
                                                                  width: ResponsiveWidget.isMobile(context) ? 80 : MediaQuery.of(context).size.width * 0.04),
                                                            ],
                                                            rows: controller.bookingList
                                                                .map((bookingModel) => DataRow(cells: [
                                                                      DataCell(
                                                                        TextCustom(
                                                                          title: bookingModel.id!.isEmpty ? "N/A".tr : "#${bookingModel.id!.substring(0, 4)}",
                                                                        ),
                                                                      ),
                                                                      DataCell(
                                                                        SingleChildScrollView(
                                                                          child: Column(
                                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                                            children: List.generate(
                                                                              bookingModel.items!.length,
                                                                              (index) {
                                                                                return FutureBuilder<ProductModel?>(
                                                                                  future: FireStoreUtils.getProductByProductId(
                                                                                    bookingModel.items![index].productId.toString(),
                                                                                  ),
                                                                                  builder: (context, snapshot) {
                                                                                    if (!snapshot.hasData) {
                                                                                      return Container();
                                                                                    }
                                                                                    ProductModel? product = snapshot.data ?? ProductModel();
                                                                                    return Padding(
                                                                                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                                                                                      child: Row(
                                                                                        children: [
                                                                                          NetworkImageWidget(
                                                                                            imageUrl: product.productImage.toString(),
                                                                                            height: 24,
                                                                                            width: 24,
                                                                                          ),
                                                                                          spaceW(width: 12),
                                                                                          TextCustom(
                                                                                            title: product.productName.toString(),
                                                                                          ),
                                                                                        ],
                                                                                      ),
                                                                                    );
                                                                                  },
                                                                                );
                                                                              },
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      DataCell(
                                                                        TextCustom(
                                                                          title: Constant.timestampToDate(bookingModel.createdAt!),
                                                                        ),
                                                                      ),
                                                                      DataCell(
                                                                        TextCustom(
                                                                          title: Constant.amountShow(amount: bookingModel.totalAmount.toString()),
                                                                        ),
                                                                      ),
                                                                      DataCell(Constant.bookingStatusText(context, bookingModel.orderStatus)),
                                                                      DataCell(
                                                                        InkWell(
                                                                          onTap: () async {
                                                                            Get.toNamed("${Routes.ORDER_DETAIL_SCREEN}/${bookingModel.id}");
                                                                          },
                                                                          child: SvgPicture.asset(
                                                                            "assets/icons/ic_eye.svg",
                                                                            color: AppThemeData.lynch400,
                                                                            height: 16,
                                                                            width: 16,
                                                                          ),
                                                                        ),
                                                                      )
                                                                    ]))
                                                                .toList(),
                                                          ),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ).expand(flex: 2),
                                              ),
                                        ContainerCustom(
                                          color: themeChange.isDarkTheme() ? AppThemeData.lynch900 : AppThemeData.lynch50,
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: [
                                                  NetworkImageWidget(
                                                    imageUrl: controller.userModel.value.profilePic.toString(),
                                                    height: 64,
                                                    width: 64,
                                                  ),
                                                  spaceW(width: 12),
                                                  TextCustom(
                                                    title: controller.userModel.value.fullNameString(),
                                                    fontSize: 16,
                                                    fontFamily: FontFamily.medium,
                                                    color: themeChange.isDarkTheme() ? AppThemeData.lynch25 : AppThemeData.lynch950,
                                                  )
                                                ],
                                              ),
                                              spaceH(height: 16),
                                              TextCustom(
                                                title: "Mobile Number".tr,
                                                fontSize: 14,
                                                fontFamily: FontFamily.regular,
                                                color: themeChange.isDarkTheme() ? AppThemeData.lynch400 : AppThemeData.lynch500,
                                              ),
                                              TextCustom(
                                                title: Constant.maskMobileNumber(
                                                    countryCode: controller.userModel.value.countryCode.toString(),
                                                    mobileNumber: controller.userModel.value.phoneNumber.toString()),
                                                fontSize: 14,
                                                fontFamily: FontFamily.medium,
                                                color: themeChange.isDarkTheme() ? AppThemeData.lynch25 : AppThemeData.lynch950,
                                              ),
                                              spaceH(height: 16),
                                              TextCustom(
                                                title: "Date",
                                                fontSize: 14,
                                                fontFamily: FontFamily.regular,
                                                color: themeChange.isDarkTheme() ? AppThemeData.lynch400 : AppThemeData.lynch500,
                                              ),
                                              TextCustom(
                                                title: Constant.timestampToDate(controller.userModel.value.createdAt!),
                                                fontSize: 14,
                                                fontFamily: FontFamily.medium,
                                                color: themeChange.isDarkTheme() ? AppThemeData.lynch25 : AppThemeData.lynch950,
                                              ),
                                              spaceH(height: 16),
                                              TextCustom(
                                                title: "Total Orders",
                                                fontSize: 14,
                                                fontFamily: FontFamily.regular,
                                                color: themeChange.isDarkTheme() ? AppThemeData.lynch400 : AppThemeData.lynch500,
                                              ),
                                              TextCustom(
                                                title: controller.totalOrders.toString(),
                                                fontSize: 14,
                                                fontFamily: FontFamily.medium,
                                                color: themeChange.isDarkTheme() ? AppThemeData.lynch25 : AppThemeData.lynch950,
                                              ),
                                            ],
                                          ),
                                        ).expand(flex: 1)
                                      ],
                                    ),
                                    desktop: Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        controller.bookingList.isEmpty
                                            ? const SizedBox()
                                            : Expanded(
                                                flex: 2,
                                                child: ContainerCustom(
                                                  color: themeChange.isDarkTheme() ? AppThemeData.lynch900 : AppThemeData.lynch50,
                                                  child: Column(
                                                    mainAxisSize: MainAxisSize.min,
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      TextCustom(
                                                        title: "Order History".tr,
                                                        fontSize: 18,
                                                        fontFamily: FontFamily.regular,
                                                        color: themeChange.isDarkTheme() ? AppThemeData.lynch50 : AppThemeData.lynch950,
                                                      ),
                                                      spaceH(height: 24),
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
                                                                  width: ResponsiveWidget.isMobile(context) ? 150 : MediaQuery.of(context).size.width * 0.12),
                                                              CommonUI.dataColumnWidget(context,
                                                                  columnTitle: "Date".tr,
                                                                  width: ResponsiveWidget.isMobile(context) ? 150 : MediaQuery.of(context).size.width * 0.12),
                                                              CommonUI.dataColumnWidget(context,
                                                                  columnTitle: "Price".tr,
                                                                  width: ResponsiveWidget.isMobile(context) ? 150 : MediaQuery.of(context).size.width * 0.07),
                                                              CommonUI.dataColumnWidget(context,
                                                                  columnTitle: "Status".tr,
                                                                  width: ResponsiveWidget.isMobile(context) ? 150 : MediaQuery.of(context).size.width * 0.12),
                                                              CommonUI.dataColumnWidget(context,
                                                                  columnTitle: "Action".tr,
                                                                  width: ResponsiveWidget.isMobile(context) ? 80 : MediaQuery.of(context).size.width * 0.04),
                                                            ],
                                                            rows: controller.bookingList
                                                                .map((bookingModel) => DataRow(cells: [
                                                                      DataCell(
                                                                        TextCustom(
                                                                          title: bookingModel.id!.isEmpty ? "N/A".tr : "#${bookingModel.id!.substring(0, 4)}",
                                                                        ),
                                                                      ),
                                                                      DataCell(
                                                                        SingleChildScrollView(
                                                                          child: Column(
                                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                                            children: List.generate(
                                                                              bookingModel.items!.length,
                                                                              (index) {
                                                                                return FutureBuilder<ProductModel?>(
                                                                                  future: FireStoreUtils.getProductByProductId(
                                                                                    bookingModel.items![index].productId.toString(),
                                                                                  ),
                                                                                  builder: (context, snapshot) {
                                                                                    if (!snapshot.hasData) {
                                                                                      return Container();
                                                                                    }
                                                                                    ProductModel? product = snapshot.data ?? ProductModel();
                                                                                    return Padding(
                                                                                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                                                                                      child: Row(
                                                                                        children: [
                                                                                          NetworkImageWidget(
                                                                                            imageUrl: product.productImage.toString(),
                                                                                            height: 24,
                                                                                            width: 24,
                                                                                          ),
                                                                                          spaceW(width: 12),
                                                                                          TextCustom(
                                                                                            title: product.productName.toString(),
                                                                                          ),
                                                                                        ],
                                                                                      ),
                                                                                    );
                                                                                  },
                                                                                );
                                                                              },
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      DataCell(
                                                                        TextCustom(
                                                                          title: Constant.timestampToDate(bookingModel.createdAt!),
                                                                        ),
                                                                      ),
                                                                      DataCell(
                                                                        TextCustom(
                                                                          title: Constant.amountShow(amount: bookingModel.totalAmount.toString()),
                                                                        ),
                                                                      ),
                                                                      DataCell(Constant.bookingStatusText(context, bookingModel.orderStatus)),
                                                                      DataCell(
                                                                        InkWell(
                                                                          onTap: () async {
                                                                            Get.toNamed("${Routes.ORDER_DETAIL_SCREEN}/${bookingModel.id}");
                                                                          },
                                                                          child: SvgPicture.asset(
                                                                            "assets/icons/ic_eye.svg",
                                                                            color: AppThemeData.lynch400,
                                                                            height: 16,
                                                                            width: 16,
                                                                          ),
                                                                        ),
                                                                      )
                                                                    ]))
                                                                .toList(),
                                                          ),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ).paddingOnly(right: 24),
                                              ),
                                        Expanded(
                                          flex: 1,
                                          child: ContainerCustom(
                                            color: themeChange.isDarkTheme() ? AppThemeData.lynch900 : AppThemeData.lynch50,
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  children: [
                                                    NetworkImageWidget(
                                                      imageUrl: controller.userModel.value.profilePic.toString(),
                                                      height: 64,
                                                      width: 64,
                                                    ),
                                                    spaceW(width: 12),
                                                    TextCustom(
                                                      title: controller.userModel.value.fullNameString(),
                                                      fontSize: 16,
                                                      fontFamily: FontFamily.medium,
                                                      color: themeChange.isDarkTheme() ? AppThemeData.lynch25 : AppThemeData.lynch950,
                                                    )
                                                  ],
                                                ),
                                                spaceH(height: 16),
                                                TextCustom(
                                                  title: "Mobile Number".tr,
                                                  fontSize: 14,
                                                  fontFamily: FontFamily.regular,
                                                  color: themeChange.isDarkTheme() ? AppThemeData.lynch400 : AppThemeData.lynch500,
                                                ),
                                                TextCustom(
                                                  title: Constant.maskMobileNumber(
                                                      countryCode: controller.userModel.value.countryCode.toString(),
                                                      mobileNumber: controller.userModel.value.phoneNumber.toString()),
                                                  fontSize: 14,
                                                  fontFamily: FontFamily.medium,
                                                  color: themeChange.isDarkTheme() ? AppThemeData.lynch25 : AppThemeData.lynch950,
                                                ),
                                                spaceH(height: 16),
                                                TextCustom(
                                                  title: "Date".tr,
                                                  fontSize: 14,
                                                  fontFamily: FontFamily.regular,
                                                  color: themeChange.isDarkTheme() ? AppThemeData.lynch400 : AppThemeData.lynch500,
                                                ),
                                                TextCustom(
                                                  title: Constant.timestampToDate(controller.userModel.value.createdAt!),
                                                  fontSize: 14,
                                                  fontFamily: FontFamily.medium,
                                                  color: themeChange.isDarkTheme() ? AppThemeData.lynch25 : AppThemeData.lynch950,
                                                ),
                                                spaceH(height: 16),
                                                TextCustom(
                                                  title: "Total Orders".tr,
                                                  fontSize: 14,
                                                  fontFamily: FontFamily.regular,
                                                  color: themeChange.isDarkTheme() ? AppThemeData.lynch400 : AppThemeData.lynch500,
                                                ),
                                                TextCustom(
                                                  title: controller.totalOrders.toString(),
                                                  fontSize: 14,
                                                  fontFamily: FontFamily.medium,
                                                  color: themeChange.isDarkTheme() ? AppThemeData.lynch25 : AppThemeData.lynch950,
                                                ),
                                              ],
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ]),
                        )),
              ),
            ],
          ),
        );
      },
    );
  }
}
