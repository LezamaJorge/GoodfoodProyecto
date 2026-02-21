// ignore_for_file: deprecated_member_use

import 'package:admin_panel/app/components/dialog_box.dart';
import 'package:admin_panel/app/constant/constants.dart';
import 'package:admin_panel/app/constant/show_toast.dart';
import 'package:admin_panel/app/modules/restaurant_details/controllers/restaurant_review_controller.dart';
import 'package:admin_panel/app/utils/app_colors.dart';
import 'package:admin_panel/app/utils/app_them_data.dart';
import 'package:admin_panel/app/utils/dark_theme_provider.dart';
import 'package:admin_panel/app/utils/fire_store_utils.dart';
import 'package:admin_panel/app/utils/responsive.dart';
import 'package:admin_panel/widget/common_ui.dart';
import 'package:admin_panel/widget/container_custom.dart';
import 'package:admin_panel/widget/global_widgets.dart';
import 'package:admin_panel/widget/text_widget.dart';
import 'package:admin_panel/widget/web_pagination.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:provider/provider.dart';
import '../../../../routes/app_pages.dart';

class RestaurantReviewScreen extends GetView {
  const RestaurantReviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<RestaurantReviewController>(
        init: RestaurantReviewController(),
        builder: (controller) {
          final themeChange = Provider.of<DarkThemeProvider>(context);
          return ResponsiveWidget(
            mobile: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    ContainerCustom(
                      alignment: Alignment.topLeft,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          TextCustom(
                            title: controller.rating.value.toString(),
                            fontSize: 18,
                            fontFamily: FontFamily.semiBold,
                            fontWeight: FontWeight.w600,
                          ),
                          RatingBar.builder(
                            glow: true,
                            initialRating: controller.rating.value,
                            minRating: 0,
                            direction: Axis.horizontal,
                            allowHalfRating: false,
                            ignoreGestures: true,
                            itemCount: 5,
                            itemSize: 40,
                            itemPadding: const EdgeInsets.symmetric(horizontal: 2.0),
                            itemBuilder: (context, index) {
                              return Icon(
                                Icons.star,
                                color: index < controller.rating.value
                                    ? AppThemeData.secondary500 // Selected star color
                                    : AppThemeData.lynch100, // Unselected star color
                              );
                            },
                            onRatingUpdate: (rating) {
                              controller.rating(rating);
                            },
                          ),
                          TextCustom(title: '${Constant.restaurantReviewLength} ratings'),
                          spaceH(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              LinearPercentIndicator(
                                width: 140.0,
                                lineHeight: 10.0,
                                percent: controller.calculatePercentage(controller.total5Length, int.parse(Constant.restaurantReviewLength.toString())),
                                backgroundColor: themeChange.isDarkTheme() ? AppThemeData.lynch900 : AppThemeData.lynch100,
                                progressColor: AppThemeData.primary500,
                                barRadius: const Radius.circular(15),
                              ),
                              spaceW(),
                              const TextCustom(title: '5'),
                            ],
                          ),
                          spaceH(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              LinearPercentIndicator(
                                width: 140.0,
                                lineHeight: 10.0,
                                percent: controller.calculatePercentage(controller.total4Length, int.parse(Constant.restaurantReviewLength.toString())),
                                backgroundColor: themeChange.isDarkTheme() ? AppThemeData.lynch900 : AppThemeData.lynch100,
                                progressColor: AppThemeData.primary500,
                                barRadius: const Radius.circular(15),
                              ),
                              spaceW(),
                              const TextCustom(title: '4'),
                            ],
                          ),
                          spaceH(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              LinearPercentIndicator(
                                width: 140.0,
                                lineHeight: 10.0,
                                percent: controller.calculatePercentage(controller.total3Length, int.parse(Constant.restaurantReviewLength.toString())),
                                backgroundColor: themeChange.isDarkTheme() ? AppThemeData.lynch900 : AppThemeData.lynch100,
                                progressColor: AppThemeData.primary500,
                                barRadius: const Radius.circular(15),
                              ),
                              spaceW(),
                              const TextCustom(title: '3'),
                            ],
                          ),
                          spaceH(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              LinearPercentIndicator(
                                width: 140.0,
                                lineHeight: 10.0,
                                percent: controller.calculatePercentage(controller.total2Length, int.parse(Constant.restaurantReviewLength.toString())),
                                backgroundColor: themeChange.isDarkTheme() ? AppThemeData.lynch900 : AppThemeData.lynch100,
                                progressColor: AppThemeData.primary500,
                                barRadius: const Radius.circular(15),
                              ),
                              spaceW(),
                              const TextCustom(title: '2'),
                            ],
                          ),
                          spaceH(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              LinearPercentIndicator(
                                width: 140.0,
                                lineHeight: 10.0,
                                percent: controller.calculatePercentage(controller.total1Length, int.parse(Constant.restaurantReviewLength.toString())),
                                backgroundColor: themeChange.isDarkTheme() ? AppThemeData.lynch900 : AppThemeData.lynch100,
                                progressColor: AppThemeData.primary500,
                                barRadius: const Radius.circular(15),
                              ),
                              spaceW(),
                              const TextCustom(title: '1'),
                            ],
                          ),
                        ],
                      ),
                    )
                  ],
                ),
                spaceH(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    ContainerCustom(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
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
                                        TextCustom(title: ' ${controller.title.value} ', fontSize: 14, fontFamily: FontFamily.medium, color: AppThemeData.primary500)
                                      ])
                                    ]),
                                    spaceH(),
                                    Row(
                                      children: [
                                        spaceW(),
                                        NumberOfRowsDropDown(
                                          controller: controller,
                                        ),
                                        spaceW(),
                                      ],
                                    )
                                  ],
                                )
                              : Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                      TextCustom(title: controller.title.value, fontSize: 20, fontFamily: FontFamily.bold),
                                      spaceH(height: 2),
                                      Row(children: [
                                        InkWell(
                                            onTap: () => Get.offAllNamed(Routes.DASHBOARD_SCREEN),
                                            child: TextCustom(title: 'Dashboard'.tr, fontSize: 14, fontFamily: FontFamily.medium, color: AppThemeData.lynch500)),
                                        const TextCustom(title: ' / ', fontSize: 14, fontFamily: FontFamily.medium, color: AppThemeData.lynch500),
                                        TextCustom(title: ' ${controller.title.value} ', fontSize: 14, fontFamily: FontFamily.medium, color: AppThemeData.primary500)
                                      ])
                                    ]),
                                    spaceH(),
                                    spaceH(),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        NumberOfRowsDropDown(
                                          controller: controller,
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                          spaceH(height: 16),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: controller.isLoading.value
                                  ? Padding(
                                      padding: paddingEdgeInsets(),
                                      child: Constant.loader(),
                                    )
                                  : controller.currentPageRestaurantReview.isEmpty
                                      ? TextCustom(title: "No Data available".tr)
                                      : DataTable(
                                          horizontalMargin: 20,
                                          columnSpacing: 30,
                                          dataRowMaxHeight: 80,
                                          headingRowHeight: 65,
                                          border: TableBorder.all(
                                            color: themeChange.isDarkTheme() ? AppThemeData.lynch800 : AppThemeData.lynch100,
                                            borderRadius: BorderRadius.circular(12),
                                          ),
                                          headingRowColor: WidgetStateColor.resolveWith((states) => themeChange.isDarkTheme() ? AppThemeData.lynch800 : AppThemeData.lynch100),
                                          columns: [
                                            CommonUI.dataColumnWidget(context, columnTitle: "Order Id".tr, width: 150),
                                            CommonUI.dataColumnWidget(context,
                                                columnTitle: "Comment".tr, width: ResponsiveWidget.isMobile(context) ? 150 : MediaQuery.of(context).size.width * 0.15),
                                            CommonUI.dataColumnWidget(context,
                                                columnTitle: "Date".tr, width: ResponsiveWidget.isMobile(context) ? 170 : MediaQuery.of(context).size.width * 0.12),
                                            CommonUI.dataColumnWidget(context,
                                                columnTitle: "Rating".tr, width: ResponsiveWidget.isMobile(context) ? 200 : MediaQuery.of(context).size.width * 0.07),
                                            CommonUI.dataColumnWidget(
                                              context,
                                              columnTitle: "Action".tr,
                                              width: 100,
                                            ),
                                          ],
                                          rows: controller.currentPageRestaurantReview
                                              .map((reviewModelModel) => DataRow(cells: [
                                                    DataCell(
                                                      TextCustom(
                                                        title:
                                                            (reviewModelModel.id == null || reviewModelModel.id!.isEmpty) ? "N/A".tr : "#${reviewModelModel.id!.substring(0, 8)}",
                                                      ),
                                                    ),
                                                    // DataCell(TextCustom(
                                                    //   // title: reviewModelModel.comment.toString(),
                                                    //   title: (reviewModelModel.comment == null || reviewModelModel.comment!.isEmpty || reviewModelModel.comment == "") ? "N/A".tr : reviewModelModel.comment.toString(),
                                                    //   maxLine: 5,
                                                    // )),
                                                    DataCell(
                                                      TextCustom(
                                                        title: (reviewModelModel.comment == null || reviewModelModel.comment == "" || reviewModelModel.comment!.trim().isEmpty)
                                                            ? "N/A".tr
                                                            : reviewModelModel.comment!,
                                                        maxLine: 5,
                                                      ),
                                                    ),
                                                    DataCell(TextCustom(title: reviewModelModel.date == null ? '' : Constant.timestampToDateTime(reviewModelModel.date!))),
                                                    DataCell(TextCustom(
                                                      title: reviewModelModel.rating.toString(),
                                                      color: AppThemeData.yellow800,
                                                    )),
                                                    DataCell(
                                                      Container(
                                                        alignment: Alignment.center,
                                                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                                                        child: Row(
                                                          children: [
                                                            InkWell(
                                                              onTap: () async {
                                                                if (Constant.isDemo) {
                                                                  DialogBox.demoDialogBox();
                                                                } else {
                                                                  // await controller.removeBooking(bookingModel);
                                                                  // controller.getBookings();
                                                                  bool confirmDelete = await DialogBox.showConfirmationDeleteDialog(context);
                                                                  if (confirmDelete) {
                                                                    await FireStoreUtils.removeRestaurantReview(reviewModelModel);
                                                                    ShowToastDialog.successToast("Delete Review Successful".tr);
                                                                    controller.getData();
                                                                  }
                                                                }
                                                              },
                                                              child: SvgPicture.asset(
                                                                "assets/icons/ic_delete.svg",
                                                                height: 16,
                                                                width: 16,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ]))
                                              .toList()),
                            ),
                          ),
                          spaceH(),
                          ResponsiveWidget.isMobile(context)
                              ? SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Visibility(
                                    visible: controller.totalPage.value > 1,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Align(
                                          alignment: Alignment.centerRight,
                                          child: WebPagination(
                                              currentPage: controller.currentPage.value,
                                              totalPage: controller.totalPage.value,
                                              displayItemCount: controller.pageValue("5"),
                                              onPageChanged: (page) {
                                                controller.currentPage.value = page;
                                                controller.setPagination(controller.totalItemPerPage.value);
                                              }),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              : Visibility(
                                  visible: controller.totalPage.value > 1,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Align(
                                        alignment: Alignment.centerRight,
                                        child: WebPagination(
                                            currentPage: controller.currentPage.value,
                                            totalPage: controller.totalPage.value,
                                            displayItemCount: controller.pageValue("5"),
                                            onPageChanged: (page) {
                                              controller.currentPage.value = page;
                                              controller.setPagination(controller.totalItemPerPage.value);
                                            }),
                                      ),
                                    ],
                                  ),
                                ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            tablet: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 4,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      ContainerCustom(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
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
                                          TextCustom(title: ' ${controller.title.value} ', fontSize: 14, fontFamily: FontFamily.medium, color: AppThemeData.primary500)
                                        ])
                                      ]),
                                      spaceH(),
                                      Row(
                                        children: [
                                          spaceW(),
                                          NumberOfRowsDropDown(
                                            controller: controller,
                                          ),
                                          spaceW(),
                                        ],
                                      )
                                    ],
                                  )
                                : Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                        TextCustom(title: controller.title.value, fontSize: 20, fontFamily: FontFamily.bold),
                                        spaceH(height: 2),
                                        Row(children: [
                                          InkWell(
                                              onTap: () => Get.offAllNamed(Routes.DASHBOARD_SCREEN),
                                              child: TextCustom(title: 'Dashboard'.tr, fontSize: 14, fontFamily: FontFamily.medium, color: AppThemeData.lynch500)),
                                          const TextCustom(title: ' / ', fontSize: 14, fontFamily: FontFamily.medium, color: AppThemeData.lynch500),
                                          TextCustom(title: ' ${controller.title.value} ', fontSize: 14, fontFamily: FontFamily.medium, color: AppThemeData.primary500)
                                        ])
                                      ]),
                                      spaceH(),
                                      spaceH(),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          NumberOfRowsDropDown(
                                            controller: controller,
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                            spaceH(height: 16),
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: controller.isLoading.value
                                    ? Padding(
                                        padding: paddingEdgeInsets(),
                                        child: Constant.loader(),
                                      )
                                    : controller.currentPageRestaurantReview.isEmpty
                                        ? TextCustom(title: "No Data available".tr)
                                        : DataTable(
                                            horizontalMargin: 20,
                                            columnSpacing: 30,
                                            dataRowMaxHeight: 80,
                                            headingRowHeight: 65,
                                            border: TableBorder.all(
                                              color: themeChange.isDarkTheme() ? AppThemeData.lynch800 : AppThemeData.lynch100,
                                              borderRadius: BorderRadius.circular(12),
                                            ),
                                            headingRowColor: WidgetStateColor.resolveWith((states) => themeChange.isDarkTheme() ? AppThemeData.lynch800 : AppThemeData.lynch100),
                                            columns: [
                                              CommonUI.dataColumnWidget(context, columnTitle: "Order Id".tr, width: 150),
                                              CommonUI.dataColumnWidget(context,
                                                  columnTitle: "Comment".tr, width: ResponsiveWidget.isMobile(context) ? 150 : MediaQuery.of(context).size.width * 0.15),
                                              CommonUI.dataColumnWidget(context,
                                                  columnTitle: "Date".tr, width: ResponsiveWidget.isMobile(context) ? 170 : MediaQuery.of(context).size.width * 0.12),
                                              CommonUI.dataColumnWidget(context,
                                                  columnTitle: "Rating".tr, width: ResponsiveWidget.isMobile(context) ? 200 : MediaQuery.of(context).size.width * 0.07),
                                              CommonUI.dataColumnWidget(
                                                context,
                                                columnTitle: "Action".tr,
                                                width: 100,
                                              ),
                                            ],
                                            rows: controller.currentPageRestaurantReview
                                                .map((reviewModelModel) => DataRow(cells: [
                                                      DataCell(
                                                        TextCustom(
                                                          title:
                                                              (reviewModelModel.id == null || reviewModelModel.id!.isEmpty) ? "N/A".tr : "#${reviewModelModel.id!.substring(0, 4)}",
                                                        ),
                                                      ),
                                                      DataCell(
                                                        TextCustom(
                                                          title: (reviewModelModel.comment == null || reviewModelModel.comment == "" || reviewModelModel.comment!.trim().isEmpty)
                                                              ? "N/A".tr
                                                              : reviewModelModel.comment!,
                                                          maxLine: 5,
                                                        ),
                                                      ),
                                                      DataCell(TextCustom(title: reviewModelModel.date == null ? '' : Constant.timestampToDateTime(reviewModelModel.date!))),
                                                      DataCell(TextCustom(
                                                        title: reviewModelModel.rating.toString(),
                                                        color: AppThemeData.yellow800,
                                                      )),
                                                      DataCell(
                                                        Container(
                                                          alignment: Alignment.center,
                                                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                                                          child: Row(
                                                            children: [
                                                              spaceW(width: 20),
                                                              InkWell(
                                                                onTap: () async {
                                                                  if (Constant.isDemo) {
                                                                    DialogBox.demoDialogBox();
                                                                  } else {
                                                                    // await controller.removeBooking(bookingModel);
                                                                    // controller.getBookings();
                                                                    bool confirmDelete = await DialogBox.showConfirmationDeleteDialog(context);
                                                                    if (confirmDelete) {
                                                                      await FireStoreUtils.removeRestaurantReview(reviewModelModel);
                                                                      ShowToastDialog.successToast("Delete Review Successful".tr);
                                                                      controller.getData();
                                                                    }
                                                                  }
                                                                },
                                                                child: SvgPicture.asset(
                                                                  "assets/icons/ic_delete.svg",
                                                                  height: 16,
                                                                  width: 16,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ]))
                                                .toList()),
                              ),
                            ),
                            spaceH(),
                            ResponsiveWidget.isMobile(context)
                                ? SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Visibility(
                                      visible: controller.totalPage.value > 1,
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: [
                                          Align(
                                            alignment: Alignment.centerRight,
                                            child: WebPagination(
                                                currentPage: controller.currentPage.value,
                                                totalPage: controller.totalPage.value,
                                                displayItemCount: controller.pageValue("5"),
                                                onPageChanged: (page) {
                                                  controller.currentPage.value = page;
                                                  controller.setPagination(controller.totalItemPerPage.value);
                                                }),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                : Visibility(
                                    visible: controller.totalPage.value > 1,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Align(
                                          alignment: Alignment.centerRight,
                                          child: WebPagination(
                                              currentPage: controller.currentPage.value,
                                              totalPage: controller.totalPage.value,
                                              displayItemCount: controller.pageValue("5"),
                                              onPageChanged: (page) {
                                                controller.currentPage.value = page;
                                                controller.setPagination(controller.totalItemPerPage.value);
                                              }),
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
                spaceW(),
                Expanded(
                    flex: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        ContainerCustom(
                          alignment: Alignment.topLeft,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              TextCustom(
                                title: controller.rating.value.toString(),
                                fontSize: 18,
                                fontFamily: FontFamily.semiBold,
                                fontWeight: FontWeight.w600,
                              ),
                              RatingBar.builder(
                                glow: true,
                                initialRating: controller.rating.value,
                                minRating: 0,
                                direction: Axis.horizontal,
                                allowHalfRating: false,
                                ignoreGestures: true,
                                itemCount: 5,
                                itemSize: 40,
                                itemPadding: const EdgeInsets.symmetric(horizontal: 2.0),
                                itemBuilder: (context, index) {
                                  return Icon(
                                    Icons.star,
                                    color: index < controller.rating.value
                                        ? AppThemeData.secondary500 // Selected star color
                                        : AppThemeData.lynch100, // Unselected star color
                                  );
                                },
                                onRatingUpdate: (rating) {
                                  controller.rating(rating);
                                },
                              ),
                              TextCustom(title: '${Constant.restaurantReviewLength} ratings'),
                              spaceH(),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  LinearPercentIndicator(
                                    width: 140.0,
                                    lineHeight: 10.0,
                                    percent: controller.calculatePercentage(controller.total5Length, int.parse(Constant.restaurantReviewLength.toString())),
                                    backgroundColor: themeChange.isDarkTheme() ? AppThemeData.lynch900 : AppThemeData.lynch100,
                                    progressColor: AppThemeData.primary500,
                                    barRadius: const Radius.circular(15),
                                  ),
                                  spaceW(),
                                  const TextCustom(title: '5'),
                                ],
                              ),
                              spaceH(),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  LinearPercentIndicator(
                                    width: 140.0,
                                    lineHeight: 10.0,
                                    percent: controller.calculatePercentage(controller.total4Length, int.parse(Constant.restaurantReviewLength.toString())),
                                    backgroundColor: themeChange.isDarkTheme() ? AppThemeData.lynch900 : AppThemeData.lynch100,
                                    progressColor: AppThemeData.primary500,
                                    barRadius: const Radius.circular(15),
                                  ),
                                  spaceW(),
                                  const TextCustom(title: '4'),
                                ],
                              ),
                              spaceH(),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  LinearPercentIndicator(
                                    width: 140.0,
                                    lineHeight: 10.0,
                                    percent: controller.calculatePercentage(controller.total3Length, int.parse(Constant.restaurantReviewLength.toString())),
                                    backgroundColor: themeChange.isDarkTheme() ? AppThemeData.lynch900 : AppThemeData.lynch100,
                                    progressColor: AppThemeData.primary500,
                                    barRadius: const Radius.circular(15),
                                  ),
                                  spaceW(),
                                  const TextCustom(title: '3'),
                                ],
                              ),
                              spaceH(),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  LinearPercentIndicator(
                                    width: 140.0,
                                    lineHeight: 10.0,
                                    percent: controller.calculatePercentage(controller.total2Length, int.parse(Constant.restaurantReviewLength.toString())),
                                    backgroundColor: themeChange.isDarkTheme() ? AppThemeData.lynch900 : AppThemeData.lynch100,
                                    progressColor: AppThemeData.primary500,
                                    barRadius: const Radius.circular(15),
                                  ),
                                  spaceW(),
                                  const TextCustom(title: '2'),
                                ],
                              ),
                              spaceH(),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  LinearPercentIndicator(
                                    width: 140.0,
                                    lineHeight: 10.0,
                                    percent: controller.calculatePercentage(controller.total1Length, int.parse(Constant.restaurantReviewLength.toString())),
                                    backgroundColor: themeChange.isDarkTheme() ? AppThemeData.lynch900 : AppThemeData.lynch100,
                                    progressColor: AppThemeData.primary500,
                                    barRadius: const Radius.circular(15),
                                  ),
                                  spaceW(),
                                  const TextCustom(title: '1'),
                                ],
                              ),
                            ],
                          ),
                        )
                      ],
                    ))
              ],
            ),
            desktop: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 4,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      ContainerCustom(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
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
                                          TextCustom(title: ' ${controller.title.value} ', fontSize: 14, fontFamily: FontFamily.medium, color: AppThemeData.primary500)
                                        ])
                                      ]),
                                      spaceH(),
                                      Row(
                                        children: [
                                          spaceW(),
                                          NumberOfRowsDropDown(
                                            controller: controller,
                                          ),
                                          spaceW(),
                                        ],
                                      )
                                    ],
                                  )
                                : Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                        TextCustom(title: controller.title.value, fontSize: 20, fontFamily: FontFamily.bold),
                                        spaceH(height: 2),
                                        Row(children: [
                                          InkWell(
                                              onTap: () => Get.offAllNamed(Routes.DASHBOARD_SCREEN),
                                              child: TextCustom(title: 'Dashboard'.tr, fontSize: 14, fontFamily: FontFamily.medium, color: AppThemeData.lynch500)),
                                          const TextCustom(title: ' / ', fontSize: 14, fontFamily: FontFamily.medium, color: AppThemeData.lynch500),
                                          TextCustom(title: ' ${controller.title.value} ', fontSize: 14, fontFamily: FontFamily.medium, color: AppThemeData.primary500)
                                        ])
                                      ]),
                                      spaceH(),
                                      spaceH(),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          NumberOfRowsDropDown(
                                            controller: controller,
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                            spaceH(height: 16),
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: controller.isLoading.value
                                    ? Padding(
                                        padding: paddingEdgeInsets(),
                                        child: Constant.loader(),
                                      )
                                    : controller.currentPageRestaurantReview.isEmpty
                                        ? TextCustom(title: "No Data available".tr)
                                        : DataTable(
                                            horizontalMargin: 20,
                                            columnSpacing: 30,
                                            dataRowMaxHeight: 80,
                                            headingRowHeight: 65,
                                            border: TableBorder.all(
                                              color: themeChange.isDarkTheme() ? AppThemeData.lynch800 : AppThemeData.lynch100,
                                              borderRadius: BorderRadius.circular(12),
                                            ),
                                            headingRowColor: WidgetStateColor.resolveWith((states) => themeChange.isDarkTheme() ? AppThemeData.lynch800 : AppThemeData.lynch100),
                                            columns: [
                                              CommonUI.dataColumnWidget(context, columnTitle: "Order Id".tr, width: 150),
                                              CommonUI.dataColumnWidget(context,
                                                  columnTitle: "Comment".tr, width: ResponsiveWidget.isMobile(context) ? 150 : MediaQuery.of(context).size.width * 0.15),
                                              CommonUI.dataColumnWidget(context,
                                                  columnTitle: "Date".tr, width: ResponsiveWidget.isMobile(context) ? 170 : MediaQuery.of(context).size.width * 0.12),
                                              CommonUI.dataColumnWidget(context,
                                                  columnTitle: "Rating".tr, width: ResponsiveWidget.isMobile(context) ? 200 : MediaQuery.of(context).size.width * 0.07),
                                              CommonUI.dataColumnWidget(
                                                context,
                                                columnTitle: "Action".tr,
                                                width: 100,
                                              ),
                                            ],
                                            rows: controller.currentPageRestaurantReview
                                                .map((reviewModelModel) => DataRow(cells: [
                                                      DataCell(
                                                        TextCustom(
                                                          title:
                                                              (reviewModelModel.id == null || reviewModelModel.id!.isEmpty) ? "N/A".tr : "#${reviewModelModel.id!.substring(0, 4)}",
                                                        ),
                                                      ),
                                                      DataCell(
                                                        TextCustom(
                                                          title: (reviewModelModel.comment == null || reviewModelModel.comment == "" || reviewModelModel.comment!.trim().isEmpty)
                                                              ? "N/A".tr
                                                              : reviewModelModel.comment!,
                                                          maxLine: 5,
                                                        ),
                                                      ),
                                                      DataCell(TextCustom(title: reviewModelModel.date == null ? '' : Constant.timestampToDateTime(reviewModelModel.date!))),
                                                      DataCell(TextCustom(
                                                        title: reviewModelModel.rating.toString(),
                                                        color: AppThemeData.yellow800,
                                                      )),
                                                      DataCell(
                                                        Container(
                                                          alignment: Alignment.center,
                                                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                                                          child: Row(
                                                            children: [
                                                              spaceW(width: 20),
                                                              InkWell(
                                                                onTap: () async {
                                                                  if (Constant.isDemo) {
                                                                    DialogBox.demoDialogBox();
                                                                  } else {
                                                                    // await controller.removeBooking(bookingModel);
                                                                    // controller.getBookings();
                                                                    bool confirmDelete = await DialogBox.showConfirmationDeleteDialog(context);
                                                                    if (confirmDelete) {
                                                                      await FireStoreUtils.removeRestaurantReview(reviewModelModel);
                                                                      ShowToastDialog.successToast("Delete Review Successful".tr);
                                                                      controller.getData();
                                                                    }
                                                                  }
                                                                },
                                                                child: SvgPicture.asset(
                                                                  "assets/icons/ic_delete.svg",
                                                                  height: 16,
                                                                  width: 16,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ]))
                                                .toList()),
                              ),
                            ),
                            spaceH(),
                            ResponsiveWidget.isMobile(context)
                                ? SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Visibility(
                                      visible: controller.totalPage.value > 1,
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: [
                                          Align(
                                            alignment: Alignment.centerRight,
                                            child: WebPagination(
                                                currentPage: controller.currentPage.value,
                                                totalPage: controller.totalPage.value,
                                                displayItemCount: controller.pageValue("5"),
                                                onPageChanged: (page) {
                                                  controller.currentPage.value = page;
                                                  controller.setPagination(controller.totalItemPerPage.value);
                                                }),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                : Visibility(
                                    visible: controller.totalPage.value > 1,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Align(
                                          alignment: Alignment.centerRight,
                                          child: WebPagination(
                                              currentPage: controller.currentPage.value,
                                              totalPage: controller.totalPage.value,
                                              displayItemCount: controller.pageValue("5"),
                                              onPageChanged: (page) {
                                                controller.currentPage.value = page;
                                                controller.setPagination(controller.totalItemPerPage.value);
                                              }),
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
                spaceW(),
                Expanded(
                    flex: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        // ContainerCustom(
                        //   alignment: Alignment.topLeft,
                        //   child: Column(
                        //     crossAxisAlignment: CrossAxisAlignment.start,
                        //     mainAxisAlignment: MainAxisAlignment.start,
                        //     children: [
                        //       TextCustom(
                        //         title: controller.rating.value.toString(),
                        //         fontSize: 18,
                        //         fontFamily: FontFamily.semiBold,
                        //         fontWeight: FontWeight.w600,
                        //       ),
                        //       RatingBar.builder(
                        //         glow: true,
                        //         initialRating: controller.rating.value,
                        //         minRating: 0,
                        //         direction: Axis.horizontal,
                        //         allowHalfRating: false,
                        //         ignoreGestures: true,
                        //         itemCount: 5,
                        //         itemSize: 40,
                        //         itemPadding: const EdgeInsets.symmetric(horizontal: 2.0),
                        //         itemBuilder: (context, index) {
                        //           return Icon(
                        //             Icons.star,
                        //             color: index < controller.rating.value
                        //                 ? AppThemeData.secondary500 // Selected star color
                        //                 : AppThemeData.lynch100, // Unselected star color
                        //           );
                        //         },
                        //         onRatingUpdate: (rating) {
                        //           controller.rating(rating);
                        //         },
                        //       ),
                        //       TextCustom(title: '${Constant.restaurantReviewLength} ratings'),
                        //       spaceH(),
                        //       Row(
                        //         mainAxisAlignment: MainAxisAlignment.start,
                        //         crossAxisAlignment: CrossAxisAlignment.start,
                        //         children: [
                        //           LinearPercentIndicator(
                        //             width: 140.0,
                        //             lineHeight: 10.0,
                        //             percent: controller.calculatePercentage(controller.total5Length, int.parse(Constant.restaurantReviewLength.toString())),
                        //             backgroundColor: themeChange.isDarkTheme() ? AppThemeData.lynch900 : AppThemeData.lynch100,
                        //             progressColor: AppThemeData.primary500,
                        //             barRadius: const Radius.circular(15),
                        //           ),
                        //           spaceW(),
                        //           const TextCustom(title: '5'),
                        //         ],
                        //       ),
                        //       spaceH(),
                        //       Row(
                        //         mainAxisAlignment: MainAxisAlignment.start,
                        //         crossAxisAlignment: CrossAxisAlignment.start,
                        //         children: [
                        //           LinearPercentIndicator(
                        //             width: 140.0,
                        //             lineHeight: 10.0,
                        //             percent: controller.calculatePercentage(controller.total4Length, int.parse(Constant.restaurantReviewLength.toString())),
                        //             backgroundColor: themeChange.isDarkTheme() ? AppThemeData.lynch900 : AppThemeData.lynch100,
                        //             progressColor: AppThemeData.primary500,
                        //             barRadius: const Radius.circular(15),
                        //           ),
                        //           spaceW(),
                        //           const TextCustom(title: '4'),
                        //         ],
                        //       ),
                        //       spaceH(),
                        //       Row(
                        //         mainAxisAlignment: MainAxisAlignment.start,
                        //         crossAxisAlignment: CrossAxisAlignment.start,
                        //         children: [
                        //           LinearPercentIndicator(
                        //             width: 140.0,
                        //             lineHeight: 10.0,
                        //             percent: controller.calculatePercentage(controller.total3Length, int.parse(Constant.restaurantReviewLength.toString())),
                        //             backgroundColor: themeChange.isDarkTheme() ? AppThemeData.lynch900 : AppThemeData.lynch100,
                        //             progressColor: AppThemeData.primary500,
                        //             barRadius: const Radius.circular(15),
                        //           ),
                        //           spaceW(),
                        //           const TextCustom(title: '3'),
                        //         ],
                        //       ),
                        //       spaceH(),
                        //       Row(
                        //         mainAxisAlignment: MainAxisAlignment.start,
                        //         crossAxisAlignment: CrossAxisAlignment.start,
                        //         children: [
                        //           LinearPercentIndicator(
                        //             width: 140.0,
                        //             lineHeight: 10.0,
                        //             percent: controller.calculatePercentage(controller.total2Length, int.parse(Constant.restaurantReviewLength.toString())),
                        //             backgroundColor: themeChange.isDarkTheme() ? AppThemeData.lynch900 : AppThemeData.lynch100,
                        //             progressColor: AppThemeData.primary500,
                        //             barRadius: const Radius.circular(15),
                        //           ),
                        //           spaceW(),
                        //           const TextCustom(title: '2'),
                        //         ],
                        //       ),
                        //       spaceH(),
                        //       Row(
                        //         mainAxisAlignment: MainAxisAlignment.start,
                        //         crossAxisAlignment: CrossAxisAlignment.start,
                        //         children: [
                        //           LinearPercentIndicator(
                        //             width: 140.0,
                        //             lineHeight: 10.0,
                        //             percent: controller.calculatePercentage(controller.total1Length, int.parse(Constant.restaurantReviewLength.toString())),
                        //             backgroundColor: themeChange.isDarkTheme() ? AppThemeData.lynch900 : AppThemeData.lynch100,
                        //             progressColor: AppThemeData.primary500,
                        //             barRadius: const Radius.circular(15),
                        //           ),
                        //           spaceW(),
                        //           const TextCustom(title: '1'),
                        //         ],
                        //       ),
                        //     ],
                        //   ),
                        // )

                        ContainerCustom(
                          alignment: Alignment.topLeft,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              RatingBar.builder(
                                glow: true,
                                initialRating: controller.rating.value,
                                minRating: 0,
                                direction: Axis.horizontal,
                                allowHalfRating: false,
                                ignoreGestures: true,
                                itemCount: 5,
                                itemSize: 40,
                                itemPadding: const EdgeInsets.symmetric(horizontal: 2.0),
                                itemBuilder: (context, index) {
                                  return Icon(
                                    Icons.star,
                                    color: index < controller.rating.value ? AppThemeData.secondary500 : AppThemeData.lynch100,
                                  );
                                },
                                onRatingUpdate: (rating) {
                                  controller.rating(rating);
                                },
                              ),
                              TextCustom(
                                title: Constant.restaurantReviewLength == 0 ? "No ratings yet" : '${Constant.restaurantReviewLength} ratings',
                              ),
                              spaceH(),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  LinearPercentIndicator(
                                    width: 140.0,
                                    lineHeight: 10.0,
                                    percent: controller.calculatePercentage(controller.total5Length, int.parse(Constant.restaurantReviewLength.toString())),
                                    backgroundColor: themeChange.isDarkTheme() ? AppThemeData.lynch900 : AppThemeData.lynch100,
                                    progressColor: AppThemeData.primary500,
                                    barRadius: const Radius.circular(15),
                                  ),
                                  spaceW(),
                                  const TextCustom(title: '5'),
                                ],
                              ),
                              spaceH(),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  LinearPercentIndicator(
                                    width: 140.0,
                                    lineHeight: 10.0,
                                    percent: controller.calculatePercentage(controller.total4Length, int.parse(Constant.restaurantReviewLength.toString())),
                                    backgroundColor: themeChange.isDarkTheme() ? AppThemeData.lynch900 : AppThemeData.lynch100,
                                    progressColor: AppThemeData.primary500,
                                    barRadius: const Radius.circular(15),
                                  ),
                                  spaceW(),
                                  const TextCustom(title: '4'),
                                ],
                              ),
                              spaceH(),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  LinearPercentIndicator(
                                    width: 140.0,
                                    lineHeight: 10.0,
                                    percent: controller.calculatePercentage(controller.total3Length, int.parse(Constant.restaurantReviewLength.toString())),
                                    backgroundColor: themeChange.isDarkTheme() ? AppThemeData.lynch900 : AppThemeData.lynch100,
                                    progressColor: AppThemeData.primary500,
                                    barRadius: const Radius.circular(15),
                                  ),
                                  spaceW(),
                                  const TextCustom(title: '3'),
                                ],
                              ),
                              spaceH(),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  LinearPercentIndicator(
                                    width: 140.0,
                                    lineHeight: 10.0,
                                    percent: controller.calculatePercentage(controller.total2Length, int.parse(Constant.restaurantReviewLength.toString())),
                                    backgroundColor: themeChange.isDarkTheme() ? AppThemeData.lynch900 : AppThemeData.lynch100,
                                    progressColor: AppThemeData.primary500,
                                    barRadius: const Radius.circular(15),
                                  ),
                                  spaceW(),
                                  const TextCustom(title: '2'),
                                ],
                              ),
                              spaceH(),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  LinearPercentIndicator(
                                    width: 140.0,
                                    lineHeight: 10.0,
                                    percent: controller.calculatePercentage(controller.total1Length, int.parse(Constant.restaurantReviewLength.toString())),
                                    backgroundColor: themeChange.isDarkTheme() ? AppThemeData.lynch900 : AppThemeData.lynch100,
                                    progressColor: AppThemeData.primary500,
                                    barRadius: const Radius.circular(15),
                                  ),
                                  spaceW(),
                                  const TextCustom(title: '1'),
                                ],
                              ),
                            ],
                          ),
                        )
                      ],
                    ))
              ],
            ),
          );
        });
  }
}
