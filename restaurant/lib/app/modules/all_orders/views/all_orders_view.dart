// ignore_for_file: deprecated_member_use, depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:restaurant/app/models/cart_model.dart';
import 'package:restaurant/app/models/order_model.dart';
import 'package:restaurant/app/models/user_model.dart';
import 'package:restaurant/app/modules/all_orders/controllers/all_orders_controller.dart';
import 'package:restaurant/app/modules/order_detail_screen/views/order_detail_screen_view.dart';
import 'package:restaurant/app/widget/global_widgets.dart';
import 'package:restaurant/app/widget/network_image_widget.dart';
import 'package:restaurant/app/widget/text_widget.dart';
import 'package:restaurant/constant/constant.dart';
import 'package:restaurant/constant_widgets/container_custom.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:restaurant/themes/app_fonts.dart';
import 'package:restaurant/themes/app_theme_data.dart';
import 'package:restaurant/themes/common_ui.dart';
import 'package:restaurant/utils/dark_theme_provider.dart';
import 'package:restaurant/utils/fire_store_utils.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class AllOrdersView extends GetView<AllOrdersController> {
  const AllOrdersView({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetBuilder<AllOrdersController>(
      init: AllOrdersController(),
      builder: (controller) {
        return Scaffold(
            backgroundColor: themeChange.isDarkTheme() ? AppThemeData.darkBackground : AppThemeData.grey50,
            appBar: UiInterface.customAppBar(backgroundColor: themeChange.isDarkTheme() ? AppThemeData.darkBackground : AppThemeData.grey50, context, themeChange, "".tr, actions: [
              ContainerCustom(
                padding: paddingEdgeInsets(vertical: 0, horizontal: 0),
                child: IconButton(
                    onPressed: () async {
                      if (controller.isDatePickerEnable.value) {
                        showDateRangePicker(context);
                      } else {
                        controller.clearOrderLists();
                        controller.getOrdersData('All', controller.selectedDateRange.value);
                      }
                    },
                    icon: const Icon(
                      Icons.date_range_outlined,
                    )),
              ),
              spaceW(width: 6.w),
            ]),
            body: Obx(
              () => controller.isLoading.value == true
                  ? Constant.loader()
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: paddingEdgeInsets(),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TextCustom(
                                title: "All Orders".tr,
                                fontSize: 28,
                                maxLine: 2,
                                color: themeChange.isDarkTheme() ? AppThemeData.grey100 : AppThemeData.grey1000,
                                fontFamily: FontFamily.bold,
                                textAlign: TextAlign.start,
                              ),
                              spaceH(height: 2),
                              TextCustom(
                                title: "View your current orders and completed order history in one place.".tr,
                                fontSize: 16,
                                maxLine: 2,
                                color: themeChange.isDarkTheme() ? AppThemeData.grey400 : AppThemeData.grey600,
                                fontFamily: FontFamily.regular,
                                textAlign: TextAlign.start,
                              ),
                            ],
                          ),
                        ),
                        spaceH(height: 20.h),
                        Padding(
                          padding: const EdgeInsets.only(left: 14),
                          child: Wrap(
                            crossAxisAlignment: WrapCrossAlignment.start,
                            alignment: WrapAlignment.start,
                            children: List.generate(
                              controller.tagsList.length,
                              (index) {
                                return GestureDetector(
                                  onTap: () {
                                    controller.selectedTags.value = controller.tagsList[index];
                                    if (controller.selectedTags.value == "Rejected") {
                                      controller.filterOrderList.value = controller.rejectedOrderList;
                                    } else if (controller.selectedTags.value == "Completed") {
                                      controller.filterOrderList.value = controller.completedOrderList;
                                    } else {
                                      controller.filterOrderList.value = controller.cancelledOrderList;
                                    }
                                  },
                                  child: Obx(
                                    () => Padding(
                                      padding: const EdgeInsets.only(bottom: 8, right: 8),
                                      child: Container(
                                        decoration: BoxDecoration(
                                            color: controller.selectedTags.value == controller.tagsList[index]
                                                ? AppThemeData.secondary300
                                                : themeChange.isDarkTheme()
                                                    ? AppThemeData.grey800
                                                    : AppThemeData.grey200,
                                            borderRadius: BorderRadius.circular(30)),
                                        padding: paddingEdgeInsets(horizontal: 22, vertical: 12),
                                        child: TextCustom(
                                          title: controller.tagsList[index].tr,
                                          color: controller.selectedTags.value == controller.tagsList[index]
                                              ? AppThemeData.grey50
                                              : themeChange.isDarkTheme()
                                                  ? AppThemeData.grey400
                                                  : AppThemeData.grey600,
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                        spaceH(height: 16.h),
                        controller.filterOrderList.isEmpty
                            ? Expanded(child: Center(child: TextCustom(title: 'No Available  ${controller.selectedTags.value} Order History')))
                            : Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 16),
                                  child: ListView.builder(
                                      shrinkWrap: true,
                                      scrollDirection: Axis.vertical,
                                      itemCount: controller.filterOrderList.length,
                                      itemBuilder: (context, index) {
                                        OrderModel bookingModel = controller.filterOrderList[index];
                                        return GestureDetector(
                                          onTap: () {
                                            Get.to(() => OrderDetailScreenView(), arguments: {'BookingModel': bookingModel});
                                          },
                                          child: ContainerCustom(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    TextCustom(
                                                      title: Constant.timestampToDateWithTime(bookingModel.createdAt!),
                                                      color: themeChange.isDarkTheme() ? AppThemeData.grey400 : AppThemeData.grey600,
                                                    ),
                                                    controller.selectedTags.value == "Completed"
                                                        ? Container(
                                                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                                            decoration: BoxDecoration(
                                                              borderRadius: BorderRadius.circular(4),
                                                              color: themeChange.isDarkTheme() ? AppThemeData.success600 : AppThemeData.success50,
                                                            ),
                                                            alignment: Alignment.center,
                                                            child: const TextCustom(
                                                              title: 'Completed',
                                                              fontSize: 12,
                                                              fontFamily: FontFamily.bold,
                                                              color: AppThemeData.success300,
                                                            ),
                                                          )
                                                        : controller.selectedTags.value == "Rejected"
                                                            ? Container(
                                                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                                                decoration: BoxDecoration(
                                                                  borderRadius: BorderRadius.circular(4),
                                                                  color: themeChange.isDarkTheme() ? AppThemeData.danger600 : AppThemeData.danger50,
                                                                ),
                                                                alignment: Alignment.center,
                                                                child: const TextCustom(
                                                                  title: 'Rejected',
                                                                  fontSize: 12,
                                                                  fontFamily: FontFamily.bold,
                                                                  color: AppThemeData.danger300,
                                                                ),
                                                              )
                                                            : Container(
                                                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                                                decoration: BoxDecoration(
                                                                  borderRadius: BorderRadius.circular(4),
                                                                  color: themeChange.isDarkTheme() ? AppThemeData.secondary600 : AppThemeData.secondary50,
                                                                ),
                                                                alignment: Alignment.center,
                                                                child: const TextCustom(
                                                                  title: 'Cancelled',
                                                                  fontSize: 12,
                                                                  fontFamily: FontFamily.bold,
                                                                  color: AppThemeData.secondary300,
                                                                ),
                                                              )
                                                  ],
                                                ),
                                                spaceH(height: 12),
                                                ListView.builder(
                                                  shrinkWrap: true,
                                                  itemCount: bookingModel.items!.length,
                                                  physics: const NeverScrollableScrollPhysics(),
                                                  itemBuilder: (context, index) {
                                                    CartModel cartModel = bookingModel.items![index];
                                                    return Row(
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
                                                spaceH(height: 12),
                                                const TextCustom(
                                                  title: 'Customer has assigned...',
                                                  fontSize: 12,
                                                  color: AppThemeData.info300,
                                                ),
                                                spaceH(height: 4),
                                                FutureBuilder<UserModel?>(
                                                  future: FireStoreUtils.getCustomerUserProfile(bookingModel.customerId!),
                                                  builder: (context, AsyncSnapshot<UserModel?> snapshot) {
                                                    if (!snapshot.hasData) {
                                                      return Container();
                                                    }
                                                    UserModel customerUserModel = snapshot.data!;
                                                    return Container(
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
                                              ],
                                            ),
                                          ),
                                        );
                                      }),
                                ),
                              ),
                      ],
                    ),
            ));
      },
    );
  }

  Future<void> showDateRangePicker(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
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
                  controller.selectedDateRange.value =
                      DateTimeRange(start: DateTime(DateTime.now().year, DateTime.january, 1), end: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, 23, 59, 0, 0));
                  controller.clearOrderLists();
                  controller.getOrdersData('All', controller.selectedDateRange.value);

                  Navigator.of(context).pop();
                },
                child: Text('clear'.tr)),
            TextButton(
              onPressed: () async {
                if (controller.startDate != null && controller.endDate != null) {
                  controller.selectedDateRange.value =
                      DateTimeRange(start: controller.startDate!, end: DateTime(controller.endDate!.year, controller.endDate!.month, controller.endDate!.day, 23, 59, 0, 0));
                  controller.clearOrderLists();
                  controller.getOrdersData('filter', controller.selectedDateRange.value);
                }
                Navigator.of(context).pop();
              },
              child: Text('OK'.tr),
            ),
          ],
        );
      },
    );
  }
}
