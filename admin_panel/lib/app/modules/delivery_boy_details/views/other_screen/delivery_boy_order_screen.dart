// ignore_for_file: deprecated_member_use

import 'package:admin_panel/app/components/dialog_box.dart';
import 'package:admin_panel/app/modules/delivery_boy_details/controllers/delivery_boy_details_controller.dart';
import 'package:admin_panel/app/utils/dark_theme_provider.dart';
import 'package:admin_panel/widget/container_custom.dart';
import 'package:admin_panel/widget/global_widgets.dart';
import 'package:admin_panel/widget/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import '../../../../../widget/common_ui.dart';
import '../../../../../widget/web_pagination.dart';
import '../../../../constant/constants.dart';
import '../../../../models/user_model.dart';
import '../../../../routes/app_pages.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/app_them_data.dart';
import '../../../../utils/fire_store_utils.dart';
import '../../../../utils/responsive.dart';

class DeliveryBoyOrderScreen extends StatelessWidget {
  const DeliveryBoyOrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetX(
      init: DeliveryBoyDetailsController(),
      builder: (controller) {
        return Scaffold(
            backgroundColor: themeChange.isDarkTheme() ? AppThemeData.lynch950 : AppThemeData.lynch50,
            body: SingleChildScrollView(
              // color: themeChange.isDarkTheme() ? AppThemeData.primaryBlack : AppThemeData.primaryWhite,
              child: ContainerCustom(
                color: themeChange.isDarkTheme() ? AppThemeData.primaryBlack : AppThemeData.primaryWhite,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    spaceH(height: 16),
                    Row(
                      //mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        const Spacer(),
                        SizedBox(
                          width: 120,
                          child: Obx(
                            () => DropdownButtonFormField(
                              borderRadius: BorderRadius.circular(15),
                              isExpanded: true,
                              style: TextStyle(
                                fontFamily: FontFamily.medium,
                                color: themeChange.isDarkTheme() ? AppThemeData.textBlack : AppThemeData.textGrey,
                              ),
                              onChanged: (String? statusType) async {
                                final now = DateTime.now();
                                controller.selectedDateOption.value = statusType ?? "All";
                                switch (statusType) {
                                  case 'Last Month':
                                    controller.selectedDateRange.value = DateTimeRange(
                                      start: now.subtract(const Duration(days: 30)),
                                      end: DateTime(now.year, now.month, now.day, 23, 59, 0, 0),
                                    );
                                    await FireStoreUtils.countStatusWiseOrderDriver(
                                      status: controller.selectedOrderStatusForData.value,
                                      dateTimeRange: controller.selectedDateRange.value,
                                      driverId: controller.driverModel.value.driverId.toString(),
                                    );
                                    await controller.setPagination(controller.totalItemPerPage.value);
                                    break;
                                  case 'Last 6 Months':
                                    controller.selectedDateRange.value = DateTimeRange(
                                      start: DateTime(now.year, now.month - 6, now.day),
                                      end: DateTime(now.year, now.month, now.day, 23, 59, 0, 0),
                                    );
                                    await FireStoreUtils.countStatusWiseOrderDriver(
                                      status: controller.selectedOrderStatusForData.value,
                                      dateTimeRange: controller.selectedDateRange.value,
                                      driverId: controller.driverModel.value.driverId.toString(),
                                    );
                                    await controller.setPagination(controller.totalItemPerPage.value);
                                    break;
                                  case 'Last Year':
                                    controller.selectedDateRange.value = DateTimeRange(
                                      start: DateTime(now.year - 1, now.month, now.day),
                                      end: DateTime(now.year, now.month, now.day, 23, 59, 0, 0),
                                    );
                                    await FireStoreUtils.countStatusWiseOrderDriver(
                                      status: controller.selectedOrderStatusForData.value,
                                      dateTimeRange: controller.selectedDateRange.value,
                                      driverId: controller.driverModel.value.driverId.toString(),
                                    );
                                    await controller.setPagination(controller.totalItemPerPage.value);
                                    break;
                                  case 'Custom':
                                    // controller.isCustomVisible.value = true;
                                    // controller.selectedBookingStatus.value = statusType ?? "All";
                                    showDateRangePicker(context);
                                    break;
                                  case 'All':
                                  // await FireStoreUtils.countStatusWiseOrderDriver(controller.selectedOrderStatusForData.value,
                                  //     controller.selectedDateRange.value, controller.restaurantModel.value.id.toString());
                                  // await controller.setPagination(controller.totalItemPerPage.value);
                                  default:
                                    // No specific filter, maybe assign null or a full year
                                    await FireStoreUtils.countStatusWiseOrderDriver(
                                      status: controller.selectedOrderStatusForData.value,
                                      dateTimeRange: controller.selectedDateRange.value,
                                      driverId: controller.driverModel.value.driverId.toString(),
                                    );
                                    await controller.setPagination(controller.totalItemPerPage.value);
                                    break;
                                }
                              },
                              value: controller.selectedDateOption.value,
                              items: controller.dateOption.map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem(
                                    value: value.tr,
                                    child: TextCustom(
                                      title: value.tr,
                                      fontFamily: FontFamily.regular,
                                      fontSize: 16,
                                      color: themeChange.isDarkTheme() ? AppThemeData.lynch500 : AppThemeData.lynch800,
                                    ));
                              }).toList(),
                              decoration: Constant.DefaultInputDecoration(context),
                            ),
                          ),
                        ),
                        spaceW(),
                        Align(
                          alignment: Alignment.topRight,
                          child: SizedBox(
                            width: 120,
                            child: Obx(
                              () => DropdownButtonFormField(
                                //alignment: Alignment.bottomRight,
                                borderRadius: BorderRadius.circular(15),
                                isExpanded: true,
                                style: TextStyle(
                                  fontFamily: FontFamily.medium,
                                  color: themeChange.isDarkTheme() ? AppThemeData.textBlack : AppThemeData.textGrey,
                                ),
                                onChanged: (String? statusType) {
                                  controller.selectedOrderStatus.value = statusType ?? "All";
                                  controller.getOrderDataByOrderStatus();
                                },
                                value: controller.selectedOrderStatus.value,
                                items: controller.orderStatus.map<DropdownMenuItem<String>>((String value) {
                                  return DropdownMenuItem(
                                    value: value.tr,
                                    child: TextCustom(
                                      title: value.tr,
                                      fontFamily: FontFamily.regular,
                                      fontSize: 16,
                                      color: themeChange.isDarkTheme() ? AppThemeData.lynch500 : AppThemeData.lynch800,
                                    ),
                                  );
                                }).toList(),
                                decoration: Constant.DefaultInputDecoration(context),
                              ),
                            ),
                          ),
                        ),
                        spaceW(),
                        NumberOfRowsDropDown(
                          controller: controller,
                        ),
                      ],
                    ),
                    spaceH(height: 20),
                    Obx(
                      () => controller.isLoading.value
                          ? Constant.loader()
                          : controller.currentPageOrder.isEmpty
                              ? Center(
                                  child: TextCustom(
                                    title: "No Orders Found".tr,
                                  ),
                                )
                              : SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: themeChange.isDarkTheme() ? AppThemeData.lynch800 : AppThemeData.lynch100,
                                        ),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: DataTable(
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
                                              columnTitle: "Customer Name".tr, width: ResponsiveWidget.isMobile(context) ? 150 : MediaQuery.of(context).size.width * 0.15),
                                          CommonUI.dataColumnWidget(context, columnTitle: "Items".tr, width: ResponsiveWidget.isMobile(context) ? 300 : MediaQuery.of(context).size.width * 0.20),
                                          CommonUI.dataColumnWidget(context,
                                              columnTitle: "Booking Date".tr, width: ResponsiveWidget.isMobile(context) ? 220 : MediaQuery.of(context).size.width * 0.17),
                                          CommonUI.dataColumnWidget(context,
                                              columnTitle: "Booking Status".tr, width: ResponsiveWidget.isMobile(context) ? 220 : MediaQuery.of(context).size.width * 0.07),
                                          CommonUI.dataColumnWidget(context,
                                              columnTitle: "Payment Type".tr, width: ResponsiveWidget.isMobile(context) ? 220 : MediaQuery.of(context).size.width * 0.10),
                                          CommonUI.dataColumnWidget(context,
                                              columnTitle: "Payment Status".tr, width: ResponsiveWidget.isMobile(context) ? 220 : MediaQuery.of(context).size.width * 0.07),
                                          CommonUI.dataColumnWidget(context, columnTitle: "Total".tr, width: 140),
                                          CommonUI.dataColumnWidget(
                                            context,
                                            columnTitle: "Action".tr,
                                            width: 100,
                                          ),
                                        ],
                                        rows: controller.currentPageOrder
                                            .map(
                                              (orderModel) => DataRow(
                                                cells: [
                                                  DataCell(
                                                    TextCustom(
                                                      title: orderModel.id!.isEmpty ? "N/A".tr : "#${orderModel.id!.substring(0, 4)}",
                                                    ),
                                                  ),
                                                  DataCell(
                                                    FutureBuilder<UserModel?>(
                                                        future: FireStoreUtils.getUserByUserID(orderModel.customerId.toString()),
                                                        // async work
                                                        builder: (BuildContext context, AsyncSnapshot<UserModel?> snapshot) {
                                                          switch (snapshot.connectionState) {
                                                            case ConnectionState.waiting:
                                                              // return Center(child: Constant.loader());
                                                              return const TextShimmer();
                                                            default:
                                                              if (snapshot.hasError) {
                                                                return TextCustom(
                                                                  title: 'Error: ${snapshot.error}',
                                                                );
                                                              } else {
                                                                UserModel userModel = snapshot.data!;
                                                                return Container(
                                                                  alignment: Alignment.centerLeft,
                                                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                                                                  child: TextCustom(
                                                                    title: userModel.firstName!.isEmpty
                                                                        ? "N/A".tr
                                                                        : userModel.firstName.toString() == "Unknown User"
                                                                            ? "User Deleted".tr
                                                                            : userModel.firstName.toString(),
                                                                  ),
                                                                );
                                                              }
                                                          }
                                                        }),
                                                  ),
                                                  DataCell(SizedBox(
                                                    width: ResponsiveWidget.isMobile(context) ? 300 : MediaQuery.of(context).size.width * 0.20,
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
                                                  DataCell(TextCustom(title: orderModel.createdAt == null ? '' : Constant.timestampToDateTime(orderModel.createdAt!))),
                                                  DataCell(
                                                    // e.bookingStatus.toString()
                                                    Constant.bookingStatusText(context, orderModel.orderStatus.toString()),
                                                  ),
                                                  DataCell(TextCustom(title: orderModel.paymentType.toString())),
                                                  DataCell(Container(
                                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                                                    decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(12),
                                                      color: orderModel.paymentStatus == true
                                                          ? themeChange.isDarkTheme()
                                                              ? AppThemeData.success600
                                                              : AppThemeData.success50
                                                          : themeChange.isDarkTheme()
                                                              ? AppThemeData.danger600
                                                              : AppThemeData.danger50,
                                                    ),
                                                    child: TextCustom(
                                                      title: orderModel.paymentStatus == true ? "Paid".tr : "Unpaid".tr,
                                                      color: orderModel.paymentStatus == true ? AppThemeData.success300 : AppThemeData.danger300,
                                                    ),
                                                  )),
                                                  DataCell(TextCustom(title: Constant.amountShow(amount: orderModel.totalAmount))),
                                                  DataCell(
                                                    Container(
                                                      alignment: Alignment.center,
                                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                                                      child: Row(
                                                        children: [
                                                          InkWell(
                                                            onTap: () async {
                                                              Get.toNamed("${Routes.ORDER_DETAIL_SCREEN}/${orderModel.id}");
                                                            },
                                                            child: SvgPicture.asset(
                                                              "assets/icons/ic_eye.svg",
                                                              color: AppThemeData.lynch400,
                                                              height: 16,
                                                              width: 16,
                                                            ),
                                                          ),
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
                                                                  await controller.removeOrder(orderModel);
                                                                  controller.getAllDriverOrders();
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
                                                ],
                                              ),
                                            )
                                            .toList(),
                                      ),
                                    ),
                                  ),
                                ),
                    ),
                    spaceH(height: 20),
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
            ));
      },
    );
  }

  Future<void> showDateRangePicker(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        DeliveryBoyDetailsController controller = Get.put(DeliveryBoyDetailsController());
        return AlertDialog(
          title: Text('Select Date'.tr),
          content: SizedBox(
            height: 300,
            width: 300,
            child: SfDateRangePicker(
              initialDisplayDate: DateTime.now(),
              maxDate: DateTime.now(),
              selectionMode: DateRangePickerSelectionMode.range,
              onSelectionChanged: (DateRangePickerSelectionChangedArgs args) async {
                if (args.value is PickerDateRange) {
                  controller.startDate = (args.value as PickerDateRange).startDate;
                  controller.endDate = (args.value as PickerDateRange).endDate;
                }
              },
            ),
          ),
          actions: <Widget>[
            ElevatedButton(
                onPressed: () {
                  controller.selectedDateRange.value = DateTimeRange(
                    start: DateTime(
                      DateTime.now().year,
                      DateTime.now().month - 5, // Subtract 5 months
                      1, // Start of the month
                    ),
                    end: DateTime(
                      DateTime.now().year,
                      DateTime.now().month,
                      DateTime.now().day,
                      23,
                      59,
                      59,
                      999, // End of the day
                    ),
                  );
                  controller.selectedOrderStatus.value = "All";
                  controller.getOrderDataByOrderStatus();
                  Navigator.of(context).pop();
                },
                child: const Text('clear')),
            TextButton(
              onPressed: () async {
                if (controller.startDate != null && controller.endDate != null) {
                  controller.selectedDateRange.value =
                      DateTimeRange(start: controller.startDate!, end: DateTime(controller.endDate!.year, controller.endDate!.month, controller.endDate!.day, 23, 59, 0, 0));
                  await FireStoreUtils.countStatusWiseOrderDriver(
                    status: controller.selectedOrderStatusForData.value,
                    dateTimeRange: controller.selectedDateRange.value,
                    driverId: controller.driverModel.value.driverId.toString(),
                  );
                  await controller.setPagination(controller.totalItemPerPage.value);
                }
                if (context.mounted) {
                  Navigator.of(context).pop();
                }              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
