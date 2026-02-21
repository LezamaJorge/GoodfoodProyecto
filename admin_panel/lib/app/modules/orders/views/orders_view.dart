// ignore_for_file: deprecated_member_use, depend_on_referenced_packages, use_build_context_synchronously

import 'package:admin_panel/app/components/custom_button.dart';
import 'package:admin_panel/app/components/custom_text_form_field.dart';
import 'package:admin_panel/app/components/dialog_box.dart';
import 'package:admin_panel/app/components/menu_widget.dart';
import 'package:admin_panel/app/constant/constants.dart';
import 'package:admin_panel/app/constant/show_toast.dart';
import 'package:admin_panel/app/models/user_model.dart';
import 'package:admin_panel/app/models/vendor_model.dart';
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
import 'package:admin_panel/widget/web_pagination.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';
import '../../../models/driver_user_model.dart';
import '../controllers/orders_controller.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:intl/intl.dart';

class OrdersView extends GetView<OrdersController> {
  const OrdersView({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetX<OrdersController>(
      init: OrdersController(),
      builder: (controller) {
        return Scaffold(
            backgroundColor: themeChange.isDarkTheme() ? AppThemeData.lynch950 : AppThemeData.lynch50,
            appBar: AppBar(
              elevation: 0.0,
              toolbarHeight: 70,
              automaticallyImplyLeading: false,
              backgroundColor: themeChange.isDarkTheme() ? AppThemeData.primaryBlack : AppThemeData.primaryWhite,
              leadingWidth: 200,
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
              width: 270,
              backgroundColor: themeChange.isDarkTheme() ? AppThemeData.primaryBlack : AppThemeData.primaryWhite,
              child: const MenuWidget(),
            ),
            body: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (ResponsiveWidget.isDesktop(context)) ...{const MenuWidget()},
                Expanded(
                  child: Padding(
                      padding: paddingEdgeInsets(),
                      child: SingleChildScrollView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        child: Column(mainAxisSize: MainAxisSize.min, mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.start, children: [
                          ContainerCustom(
                            child: Column( children: [
                              if (!ResponsiveWidget.isMobile(context))
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                      TextCustom(title: controller.title.value.tr, fontSize: 20, fontFamily: FontFamily.bold),
                                      spaceH(height: 2),
                                      Row(children: [
                                        InkWell(
                                            onTap: () => Get.offAllNamed(Routes.DASHBOARD_SCREEN),
                                            child: TextCustom(
                                                title: 'Dashboard'.tr,
                                                fontSize: 14,
                                                fontFamily: FontFamily.medium,
                                                color: themeChange.isDarkTheme() ? AppThemeData.lynch500 : AppThemeData.lynch950)),
                                        const TextCustom(title: ' / ', fontSize: 14, fontFamily: FontFamily.medium, color: AppThemeData.lynch500),
                                        TextCustom(title: ' ${controller.title.value.tr} ', fontSize: 14, fontFamily: FontFamily.medium, color: AppThemeData.primary500)
                                      ])
                                    ],),
                                    Row(
                                      children: [
                                        // ContainerCustom(
                                        //   padding: paddingEdgeInsets(vertical: 0, horizontal: 0),
                                        //   color: themeChange.isDarkTheme() ? AppThemeData.lynch900 : AppThemeData.lynch100,
                                        //   child: IconButton(
                                        //       onPressed: () async {
                                        //         if (controller.isDatePickerEnable.value) {
                                        //           showDateRangePicker(context);
                                        //         } else {
                                        //           controller.getOrders();
                                        //         }
                                        //       },
                                        //       icon: const Icon(
                                        //         Icons.date_range_outlined,
                                        //       )),
                                        // ),
                                        spaceW(),
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
                                                controller.selectedDateOption.value = statusType ?? "All".tr;
                                                switch (statusType) {
                                                  case 'Last Month':
                                                    controller.selectedDateRangeForPdf.value = DateTimeRange(
                                                      start: now.subtract(const Duration(days: 30)),
                                                      end: DateTime(now.year, now.month, now.day, 23, 59, 0, 0),
                                                    );
                                                    await FireStoreUtils.countStatusWiseBooking(
                                                        driverId: controller.driverId.value,
                                                        status: controller.selectedOrderStatusForData.value,
                                                        dateTimeRange: controller.selectedDateRange.value,
                                                        restaurantId: controller.restaurantId.value);
                                                    await controller.setPagination(controller.totalItemPerPage.value);
                                                    break;
                                                  case 'Last 6 Months':
                                                    controller.selectedDateRangeForPdf.value = DateTimeRange(
                                                      start: DateTime(now.year, now.month - 6, now.day),
                                                      end: DateTime(now.year, now.month, now.day, 23, 59, 0, 0),
                                                    );
                                                    await FireStoreUtils.countStatusWiseBooking(
                                                        driverId: controller.driverId.value,
                                                        status: controller.selectedOrderStatusForData.value,
                                                        dateTimeRange: controller.selectedDateRange.value,
                                                        restaurantId: controller.restaurantId.value);
                                                    await controller.setPagination(controller.totalItemPerPage.value);
                                                    break;
                                                  case 'Last Year':
                                                    controller.selectedDateRangeForPdf.value = DateTimeRange(
                                                      start: DateTime(now.year - 1, now.month, now.day),
                                                      end: DateTime(now.year, now.month, now.day, 23, 59, 0, 0),
                                                    );
                                                    await FireStoreUtils.countStatusWiseBooking(
                                                        driverId: controller.driverId.value,
                                                        status: controller.selectedOrderStatusForData.value,
                                                        dateTimeRange: controller.selectedDateRange.value,
                                                        restaurantId: controller.restaurantId.value);
                                                    await controller.setPagination(controller.totalItemPerPage.value);
                                                    break;
                                                  case 'Custom':
                                                    // controller.isCustomVisible.value = true;
                                                    // controller.selectedBookingStatus.value = statusType ?? "All";
                                                    showDateRangePicker(context);
                                                    break;
                                                  case 'All':
                                                  default:
                                                    // No specific filter, maybe assign null or a full year
                                                    controller.selectedDateRangeForPdf.value = DateTimeRange(
                                                      start: DateTime(now.year, 1, 1),
                                                      end: DateTime(now.year, now.month, now.day, 23, 59, 0, 0),
                                                    );
                                                    break;
                                                }
                                              },
                                              value: controller.selectedDateOption.value,
                                              items: controller.dateOption.map<DropdownMenuItem<String>>((String value) {
                                                return DropdownMenuItem(
                                                    value: value.tr,
                                                    child: TextCustom(
                                                      title: value,
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
                                        Center(
                                          child: SizedBox(
                                            width: 160,
                                            child: DropdownSearch<DriverUserModel>(
                                              // mode: Mode.form,
                                              items: (f, cs) => controller.allDriverList,
                                              itemAsString: (DriverUserModel item) => '${item.firstName}',
                                              compareFn: (item, selectedItem) => item.driverId == selectedItem.driverId,
                                              onChanged: (DriverUserModel? selectedItem) async {
                                                controller.driverId.value = selectedItem!.driverId!;
                                                if (selectedItem.driverId == 'All') {
                                                  controller.driverId.value = 'All';
                                                  await FireStoreUtils.countStatusWiseBooking(
                                                    driverId: 'All',
                                                    status: controller.selectedBookingStatusForData.value,
                                                    dateTimeRange: controller.selectedDateRange.value,
                                                    restaurantId: controller.restaurantId.value,
                                                  );
                                                  await controller.setPagination(controller.totalItemPerPage.value);
                                                } else {
                                                  await FireStoreUtils.countStatusWiseBooking(
                                                    driverId: controller.driverId.value,
                                                    status: controller.selectedBookingStatusForData.value,
                                                    dateTimeRange: controller.selectedDateRange.value,
                                                    restaurantId: controller.restaurantId.value,
                                                  );
                                                  await controller.setPagination(controller.totalItemPerPage.value);
                                                }
                                              },
                                              dropdownBuilder: (context, selectedItem) {
                                                return Text(
                                                  selectedItem != null ? '${selectedItem.firstName}' : 'All Driver'.tr,
                                                  style: TextStyle(
                                                    fontFamily: FontFamily.regular,
                                                    fontSize: 16,
                                                    color: themeChange.isDarkTheme() ? AppThemeData.lynch500 : AppThemeData.lynch800,
                                                  ),
                                                );
                                              },
                                              popupProps: PopupProps.menu(
                                                  showSearchBox: true,
                                                  showSelectedItems: true,
                                                  searchFieldProps: TextFieldProps(
                                                      cursorColor: AppThemeData.appColor,
                                                      decoration: InputDecoration(
                                                        contentPadding: const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
                                                        hintText: "Search Driver".tr,
                                                        hintStyle: TextStyle(
                                                          fontFamily: FontFamily.regular,
                                                          fontSize: 16,
                                                          color: themeChange.isDarkTheme() ? AppThemeData.lynch500 : AppThemeData.lynch800,
                                                        ),
                                                        focusedBorder: OutlineInputBorder(
                                                          borderRadius: BorderRadius.circular(10),
                                                          borderSide: BorderSide(
                                                            width: 0.5,
                                                            color: themeChange.isDarkTheme() ? AppThemeData.lynch950 : AppThemeData.lynch100,
                                                          ),
                                                        ),
                                                        border: OutlineInputBorder(
                                                          borderRadius: BorderRadius.circular(10),
                                                          borderSide: BorderSide(
                                                            width: 0.5,
                                                            color: themeChange.isDarkTheme() ? AppThemeData.lynch950 : AppThemeData.lynch100,
                                                          ),
                                                        ),
                                                        errorBorder: OutlineInputBorder(
                                                          borderRadius: BorderRadius.circular(10),
                                                          borderSide: const BorderSide(width: 0.5, color: AppThemeData.danger400),
                                                        ),
                                                      )),
                                                  itemBuilder: (context, item, isDisabled, isSelected) {
                                                    return Padding(
                                                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                                      child: TextCustom(
                                                        title: item.firstName.toString(),
                                                        fontFamily: FontFamily.regular,
                                                        fontSize: 16,
                                                        color: themeChange.isDarkTheme() ? AppThemeData.lynch500 : AppThemeData.lynch800,
                                                      ),
                                                    );
                                                  }),
                                              suffixProps: const DropdownSuffixProps(
                                                  dropdownButtonProps: DropdownButtonProps(
                                                iconClosed: Icon(
                                                  Icons.arrow_drop_down,
                                                  color: AppThemeData.lynch500,
                                                ),
                                                iconOpened: Icon(
                                                  Icons.arrow_drop_up,
                                                  color: AppThemeData.lynch500,
                                                ),
                                              )),
                                              decoratorProps: DropDownDecoratorProps(decoration: defaultInputDecorationForSearchDropDown(context)),
                                            ),
                                          ),
                                        ),
                                        spaceW(),

                                        Center(
                                          child: SizedBox(
                                            width: 160,
                                            child: DropdownSearch<VendorModel>(
                                              items: (f, cs) => controller.allRestaurantList,
                                              itemAsString: (VendorModel item) => item.vendorName.toString(),
                                              compareFn: (item, selectedItem) => item.id == selectedItem.id,
                                              onChanged: (VendorModel? selectedItem) async {
                                                final selectedId = selectedItem?.id ?? 'All';
                                                controller.restaurantId.value = selectedId;


                                                await FireStoreUtils.countStatusWiseBooking(
                                                  driverId: controller.driverId.value,
                                                  status: controller.selectedBookingStatusForData.value,
                                                  dateTimeRange: controller.selectedDateRange.value,
                                                  restaurantId: selectedId,
                                                );

                                                await controller.setPagination(controller.totalItemPerPage.value);

                                              },
                                              dropdownBuilder: (context, selectedItem) {
                                                return Text(
                                                  selectedItem != null ? selectedItem.vendorName.toString() : 'All Restaurant'.tr,
                                                  style: TextStyle(
                                                    fontFamily: FontFamily.regular,
                                                    fontSize: 16,
                                                    color: themeChange.isDarkTheme() ? AppThemeData.lynch500 : AppThemeData.lynch800,
                                                  ),
                                                );
                                              },
                                              popupProps: PopupProps.menu(
                                                showSearchBox: true,
                                                showSelectedItems: true,
                                                searchFieldProps: TextFieldProps(
                                                  cursorColor: AppThemeData.appColor,
                                                  decoration: InputDecoration(
                                                    contentPadding: const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
                                                    hintText: "Search Restaurant".tr,
                                                    hintStyle: TextStyle(
                                                      fontFamily: FontFamily.regular,
                                                      fontSize: 16,
                                                      color: themeChange.isDarkTheme() ? AppThemeData.lynch500 : AppThemeData.lynch800,
                                                    ),
                                                    focusedBorder: OutlineInputBorder(
                                                      borderRadius: BorderRadius.circular(10),
                                                      borderSide: BorderSide(
                                                        width: 0.5,
                                                        color: themeChange.isDarkTheme() ? AppThemeData.lynch950 : AppThemeData.lynch100,
                                                      ),
                                                    ),
                                                    border: OutlineInputBorder(
                                                      borderRadius: BorderRadius.circular(10),
                                                      borderSide: BorderSide(
                                                        width: 0.5,
                                                        color: themeChange.isDarkTheme() ? AppThemeData.lynch950 : AppThemeData.lynch100,
                                                      ),
                                                    ),
                                                    errorBorder: OutlineInputBorder(
                                                      borderRadius: BorderRadius.circular(10),
                                                      borderSide: const BorderSide(width: 0.5, color: AppThemeData.danger400),
                                                    ),
                                                  ),
                                                ),
                                                itemBuilder: (context, item, isDisabled, isSelected) {
                                                  return Padding(
                                                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                                    child: TextCustom(
                                                      title: item.vendorName.toString(),
                                                      fontFamily: FontFamily.regular,
                                                      fontSize: 16,
                                                      color: themeChange.isDarkTheme() ? AppThemeData.lynch500 : AppThemeData.lynch800,
                                                    ),
                                                  );
                                                },
                                              ),
                                              suffixProps: const DropdownSuffixProps(
                                                dropdownButtonProps: DropdownButtonProps(
                                                  iconClosed: Icon(Icons.arrow_drop_down, color: AppThemeData.lynch500),
                                                  iconOpened: Icon(Icons.arrow_drop_up, color: AppThemeData.lynch500),
                                                ),
                                              ),
                                              decoratorProps: DropDownDecoratorProps(
                                                decoration: defaultInputDecorationForSearchDropDown(context),
                                              ),
                                            ),
                                          ),
                                        ),

                                        spaceW(),
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
                                              onChanged: (String? statusType) {
                                                controller.selectedOrderStatus.value = statusType ?? "All";
                                                controller.getOrderDataByOrderStatus();
                                              },
                                              value: controller.selectedOrderStatus.value,
                                              items: controller.orderStatus.map<DropdownMenuItem<String>>((String value) {
                                                return DropdownMenuItem(
                                                  value: value,
                                                  child: TextCustom(
                                                    title: value,
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
                                        spaceW(),
                                        NumberOfRowsDropDown(
                                          controller: controller,
                                        ),
                                        ContainerCustom(
                                            padding: paddingEdgeInsets(horizontal: 0, vertical: 0),
                                            color: AppThemeData.primary500,
                                            child: IconButton(
                                              onPressed: () {
                                                controller.dateRangeController.value.text = "";
                                                controller.selectedDateOptionForPdf.value = "All";
                                                showDialog(
                                                    context: context,
                                                    builder: (context) => CustomDialog(
                                                          controller: controller,
                                                          title: "Orders Statement Download".tr,
                                                          widgetList: [
                                                            TextCustom(
                                                              title: 'Select Time'.tr,
                                                              fontFamily: FontFamily.regular,
                                                              fontSize: 16,
                                                            ),
                                                            spaceH(),
                                                            SizedBox(
                                                              width: 200,
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
                                                                    controller.selectedDateOptionForPdf.value = statusType ?? "All";
                                                                    switch (statusType) {
                                                                      case 'Last Month':
                                                                        controller.selectedDateRangeForPdf.value = DateTimeRange(
                                                                          start: now.subtract(const Duration(days: 30)),
                                                                          end: DateTime(now.year, now.month, now.day, 23, 59, 0, 0),
                                                                        );
                                                                        await FireStoreUtils.countStatusWiseBooking(
                                                                          driverId: controller.driverId.value,
                                                                          status: controller.selectedBookingStatusForData.value,
                                                                          dateTimeRange: controller.selectedDateRange.value,
                                                                          restaurantId: controller.restaurantId.value,
                                                                        );
                                                                        await controller.setPagination(controller.totalItemPerPage.value);
                                                                        break;
                                                                      case 'Last 6 Months':
                                                                        controller.selectedDateRangeForPdf.value = DateTimeRange(
                                                                          start: DateTime(now.year, now.month - 6, now.day),
                                                                          end: DateTime(now.year, now.month, now.day, 23, 59, 0, 0),
                                                                        );
                                                                        await FireStoreUtils.countStatusWiseBooking(
                                                                          driverId: controller.driverId.value,
                                                                          status: controller.selectedBookingStatusForData.value,
                                                                          dateTimeRange: controller.selectedDateRange.value,
                                                                          restaurantId: controller.restaurantId.value,
                                                                        );
                                                                        await controller.setPagination(controller.totalItemPerPage.value);
                                                                        break;
                                                                      case 'Last Year':
                                                                        controller.selectedDateRangeForPdf.value = DateTimeRange(
                                                                          start: DateTime(now.year - 1, now.month, now.day),
                                                                          end: DateTime(now.year, now.month, now.day, 23, 59, 0, 0),
                                                                        );
                                                                        await FireStoreUtils.countStatusWiseBooking(
                                                                          driverId: controller.driverId.value,
                                                                          status: controller.selectedBookingStatusForData.value,
                                                                          dateTimeRange: controller.selectedDateRange.value,
                                                                          restaurantId: controller.restaurantId.value,
                                                                        );
                                                                        await controller.setPagination(controller.totalItemPerPage.value);
                                                                        break;
                                                                      case 'Custom':
                                                                        // controller.isCustomVisible.value = true;
                                                                        // controller.selectedBookingStatus.value = statusType ?? "All";
                                                                        controller.isCustomVisible.value = true;
                                                                        break;
                                                                      case 'All':
                                                                      default:
                                                                        // No specific filter, maybe assign null or a full year
                                                                        controller.selectedDateRangeForPdf.value = DateTimeRange(
                                                                          start: DateTime(now.year, 1, 1),
                                                                          end: DateTime(now.year, now.month, now.day, 23, 59, 0, 0),
                                                                        );
                                                                        break;
                                                                    }
                                                                    controller.isCustomVisible.value = statusType == 'Custom';

                                                                  },
                                                                  value: controller.selectedDateOptionForPdf.value,
                                                                  items: controller.dateOption.map<DropdownMenuItem<String>>((String value) {
                                                                    return DropdownMenuItem(
                                                                        value: value.tr,
                                                                        child: TextCustom(
                                                                          title: value,
                                                                          fontFamily: FontFamily.regular,
                                                                          fontSize: 16,
                                                                          color: themeChange.isDarkTheme() ? AppThemeData.lynch500 : AppThemeData.lynch800,
                                                                        ));
                                                                  }).toList(),
                                                                  decoration: Constant.DefaultInputDecoration(context),
                                                                ),
                                                              ),
                                                            ),
                                                            spaceH(),
                                                            Obx(
                                                              () => Visibility(
                                                                visible: controller.isCustomVisible.value,
                                                                child: CustomTextFormField(
                                                                  validator: (value) => value != null && value.isNotEmpty ? null : 'Start & End Date Required'.tr,
                                                                  hintText: "Select Start & End Date".tr,
                                                                  controller: controller.dateRangeController.value,
                                                                  title: "Start & End Date".tr,
                                                                  onPress: () {
                                                                    showDateRangePickerForPdf(context);
                                                                  },
                                                                  // isReadOnly: true,
                                                                  suffix: const Icon(
                                                                    Icons.calendar_month_outlined,
                                                                    color: AppThemeData.lynch500,
                                                                    size: 24,
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                            spaceH(),
                                                            Row(
                                                              // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                              children: [
                                                                Column(
                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                  children: [
                                                                    TextCustom(
                                                                      title: 'Select Driver'.tr,
                                                                      fontFamily: FontFamily.regular,
                                                                      fontSize: 16,
                                                                    ),
                                                                    spaceH(),
                                                                    SizedBox(
                                                                      width: 250,
                                                                      child: DropdownSearch<DriverUserModel>(
                                                                        items: (filter, infiniteScrollProps) => controller.allDriverList,
                                                                        // items: (f, cs) => controller.getAllDriver(),
                                                                        // selectedItem: controller.selectedDriver.value,
                                                                        itemAsString: (DriverUserModel? driver) => driver?.firstName ?? "",
                                                                        compareFn: (item, selectedItem) => item.driverId == selectedItem.driverId,
                                                                        onChanged: (DriverUserModel? driver) {
                                                                          controller.selectedDriver.value = driver;
                                                                        },
                                                                        dropdownBuilder: (context, DriverUserModel? driver) {
                                                                          return Text(
                                                                            driver?.firstName ?? "All Driver".tr,
                                                                            style: TextStyle(
                                                                              fontFamily: FontFamily.regular,
                                                                              fontSize: 16,
                                                                              color: themeChange.isDarkTheme() ? AppThemeData.lynch500 : AppThemeData.lynch800,
                                                                            ),
                                                                          );
                                                                        },
                                                                        suffixProps: const DropdownSuffixProps(
                                                                            dropdownButtonProps: DropdownButtonProps(
                                                                          iconClosed: Icon(
                                                                            Icons.arrow_drop_down,
                                                                            color: AppThemeData.lynch500,
                                                                          ),
                                                                          iconOpened: Icon(
                                                                            Icons.arrow_drop_up,
                                                                            color: AppThemeData.lynch500,
                                                                          ),
                                                                        )),
                                                                        popupProps: PopupProps.menu(
                                                                            showSearchBox: true,
                                                                            showSelectedItems: true,
                                                                            searchFieldProps: TextFieldProps(
                                                                                cursorColor: AppThemeData.primary500,
                                                                                decoration: InputDecoration(
                                                                                  fillColor: themeChange.isDarkTheme() ? AppThemeData.background : AppThemeData.lynch500,
                                                                                  contentPadding: const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
                                                                                  hintText: "Search Driver".tr,
                                                                                  hintStyle: TextStyle(
                                                                                      fontSize: 14,
                                                                                      fontFamily: FontFamily.regular,
                                                                                      color: themeChange.isDarkTheme() ? AppThemeData.lynch500 : AppThemeData.lynch950),
                                                                                  focusedBorder: OutlineInputBorder(
                                                                                    borderRadius: BorderRadius.circular(10),
                                                                                    borderSide: const BorderSide(width: 0.5, color: AppThemeData.appColor),
                                                                                  ),
                                                                                  border: OutlineInputBorder(
                                                                                    borderRadius: BorderRadius.circular(10),
                                                                                    borderSide: BorderSide(width: 0.5, color: AppThemeData.primaryBlack),
                                                                                  ),
                                                                                  errorBorder: OutlineInputBorder(
                                                                                    borderRadius: BorderRadius.circular(10),
                                                                                    borderSide: const BorderSide(width: 0.5, color: AppThemeData.red500),
                                                                                  ),
                                                                                )),
                                                                            itemBuilder: (context, item, isDisabled, isSelected) {
                                                                              return Padding(
                                                                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                                                                child: Text(
                                                                                  '${item.firstName}',
                                                                                  style: TextStyle(
                                                                                      fontFamily: FontFamily.regular,
                                                                                      color: themeChange.isDarkTheme() ? AppThemeData.lynch500 : AppThemeData.lynch950),
                                                                                ),
                                                                              );
                                                                            }),
                                                                        decoratorProps: DropDownDecoratorProps(decoration: defaultInputDecorationForSearchDropDown(context)),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                                spaceW(width: 30),
                                                                Column(
                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                  children: [
                                                                    TextCustom(
                                                                      title: 'Order Status'.tr,
                                                                      fontFamily: FontFamily.regular,
                                                                      fontSize: 16,
                                                                    ),
                                                                    spaceH(),
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
                                                                          onChanged: (String? statusType) {
                                                                            controller.selectedFilterBookingStatus.value = statusType ?? "All";
                                                                            // controller.getBookingDataByBookingStatus();
                                                                          },
                                                                          value: controller.selectedFilterBookingStatus.value,
                                                                          items: controller.orderStatus.map<DropdownMenuItem<String>>((String value) {
                                                                            return DropdownMenuItem(
                                                                              value: value,
                                                                              child: TextCustom(
                                                                                title: value,
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
                                                                  ],
                                                                ),
                                                              ],
                                                            ),
                                                          ],
                                                          bottomWidgetList: [
                                                            CustomButtonWidget(
                                                              textColor: themeChange.isDarkTheme() ? Colors.white : Colors.black,
                                                              buttonColor: themeChange.isDarkTheme() ? AppThemeData.lynch900 : AppThemeData.lynch100,
                                                              onPress: () {
                                                                Navigator.pop(context);
                                                              },
                                                              title: "Close".tr,
                                                            ),
                                                            spaceW(),
                                                            Obx(
                                                              () => controller.isHistoryDownload.value
                                                                  ? Constant.circularProgressIndicatourLoader()
                                                                  : CustomButtonWidget(
                                                                      onPress: () {
                                                                        if (Constant.isDemo) {
                                                                          DialogBox.demoDialogBox();
                                                                        } else {
                                                                          if (controller.selectedDriver.value == null ||
                                                                              controller.selectedDriver.value!.driverId == null ||
                                                                              controller.selectedDriver.value!.driverId!.isEmpty) {
                                                                            ShowToastDialog.errorToast('Select Driver'.tr);
                                                                            return;
                                                                          }
                                                                          if (controller.selectedDateOptionForPdf.value == 'Custom' &&
                                                                              controller.dateRangeController.value.text.isEmpty) {
                                                                            ShowToastDialog.errorToast("Please select both a start and end date.".tr);
                                                                            return;
                                                                          }
                                                                          controller.downloadCabBookingPdf(context);
                                                                        }
                                                                      },
                                                                      title: "Download".tr,
                                                                    ),
                                                            ),
                                                          ],
                                                        ));
                                              },
                                              icon: SvgPicture.asset(
                                                "assets/icons/ic_download.svg",
                                                color: AppThemeData.primaryWhite,
                                                height: 24,
                                                width: 24,
                                              ),
                                            )),
                                      ],
                                    )
                                  ],
                                )
                              else
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
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
                                    spaceH(height: 16),
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Expanded(
                                          child: DropdownSearch<DriverUserModel>(
                                            // mode: Mode.form,
                                            items: (f, cs) => controller.allDriverList,
                                            itemAsString: (DriverUserModel item) => '${item.firstName}',
                                            compareFn: (item, selectedItem) => item.driverId == selectedItem.driverId,
                                            onChanged: (DriverUserModel? selectedItem) async {
                                              controller.driverId.value = selectedItem!.driverId!;
                                            },
                                            dropdownBuilder: (context, selectedItem) {
                                              return Text(
                                                selectedItem != null ? '${selectedItem.firstName}' : 'All Driver'.tr,
                                                style: TextStyle(
                                                  fontFamily: FontFamily.regular,
                                                  fontSize: 16,
                                                  color: themeChange.isDarkTheme() ? AppThemeData.lynch500 : AppThemeData.lynch800,
                                                ),
                                              );
                                            },
                                            popupProps: PopupProps.menu(
                                                showSearchBox: true,
                                                showSelectedItems: true,
                                                searchFieldProps: TextFieldProps(
                                                    cursorColor: AppThemeData.appColor,
                                                    decoration: InputDecoration(
                                                      contentPadding: const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
                                                      hintText: "Search Driver".tr,
                                                      hintStyle: TextStyle(
                                                        fontFamily: FontFamily.regular,
                                                        fontSize: 16,
                                                        color: themeChange.isDarkTheme() ? AppThemeData.lynch500 : AppThemeData.lynch800,
                                                      ),
                                                      focusedBorder: OutlineInputBorder(
                                                        borderRadius: BorderRadius.circular(10),
                                                        borderSide: BorderSide(
                                                          width: 0.5,
                                                          color: themeChange.isDarkTheme() ? AppThemeData.lynch950 : AppThemeData.lynch100,
                                                        ),
                                                      ),
                                                      border: OutlineInputBorder(
                                                        borderRadius: BorderRadius.circular(10),
                                                        borderSide: BorderSide(
                                                          width: 0.5,
                                                          color: themeChange.isDarkTheme() ? AppThemeData.lynch950 : AppThemeData.lynch100,
                                                        ),
                                                      ),
                                                      errorBorder: OutlineInputBorder(
                                                        borderRadius: BorderRadius.circular(10),
                                                        borderSide: const BorderSide(width: 0.5, color: AppThemeData.danger400),
                                                      ),
                                                    )),
                                                itemBuilder: (context, item, isDisabled, isSelected) {
                                                  return Padding(
                                                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                                    child: TextCustom(
                                                      title: item.firstName.toString(),
                                                      fontFamily: FontFamily.regular,
                                                      fontSize: 16,
                                                      color: themeChange.isDarkTheme() ? AppThemeData.lynch500 : AppThemeData.lynch800,
                                                    ),
                                                    // Text(
                                                    //   '${item.fullName}',
                                                    //   style: const TextStyle(fontFamily: AppThemeData.regular, color: Colors.black),
                                                    // ),
                                                  );
                                                }),
                                            suffixProps: const DropdownSuffixProps(
                                                dropdownButtonProps: DropdownButtonProps(
                                              iconClosed: Icon(
                                                Icons.arrow_drop_down,
                                                color: AppThemeData.lynch500,
                                              ),
                                              iconOpened: Icon(
                                                Icons.arrow_drop_up,
                                                color: AppThemeData.lynch500,
                                              ),
                                            )),
                                            decoratorProps: DropDownDecoratorProps(decoration: defaultInputDecorationForSearchDropDown(context)),
                                          ),
                                        ),
                                        spaceW(),
                                        Expanded(
                                          child: DropdownSearch<VendorModel>(
                                            // mode: Mode.form,
                                            items: (f, cs) => controller.allRestaurantList,
                                            itemAsString: (VendorModel item) => '${item.vendorName}',
                                            compareFn: (item, selectedItem) => item.id == selectedItem.id,
                                            onChanged: (VendorModel? selectedItem) async {
                                              controller.restaurantId.value = selectedItem!.id!;
                                              if (selectedItem.id == 'All') {
                                                controller.restaurantId.value = 'All';
                                                await FireStoreUtils.countStatusWiseBooking(
                                                    restaurantId: 'All',
                                                    status: controller.selectedBookingStatusForData.value,
                                                    dateTimeRange: controller.selectedDateRange.value,
                                                    driverId: controller.driverId.value);
                                                await controller.setPagination(controller.totalItemPerPage.value);
                                              } else {
                                                await FireStoreUtils.countStatusWiseBooking(
                                                    restaurantId: controller.restaurantId.value,
                                                    status: controller.selectedBookingStatusForData.value,
                                                    dateTimeRange: controller.selectedDateRange.value,
                                                    driverId: controller.driverId.value);
                                                await controller.setPagination(controller.totalItemPerPage.value);
                                              }
                                            },
                                            dropdownBuilder: (context, selectedItem) {
                                              return Text(
                                                selectedItem != null ? '${selectedItem.vendorName}' : 'All Restaurant'.tr,
                                                style: TextStyle(
                                                  fontFamily: FontFamily.regular,
                                                  fontSize: 16,
                                                  color: themeChange.isDarkTheme() ? AppThemeData.lynch500 : AppThemeData.lynch800,
                                                ),
                                              );
                                            },
                                            popupProps: PopupProps.menu(
                                                showSearchBox: true,
                                                showSelectedItems: true,
                                                searchFieldProps: TextFieldProps(
                                                    cursorColor: AppThemeData.appColor,
                                                    decoration: InputDecoration(
                                                      contentPadding: const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
                                                      hintText: "Search Restaurant".tr,
                                                      hintStyle: TextStyle(
                                                        fontFamily: FontFamily.regular,
                                                        fontSize: 16,
                                                        color: themeChange.isDarkTheme() ? AppThemeData.lynch500 : AppThemeData.lynch800,
                                                      ),
                                                      focusedBorder: OutlineInputBorder(
                                                        borderRadius: BorderRadius.circular(10),
                                                        borderSide: BorderSide(
                                                          width: 0.5,
                                                          color: themeChange.isDarkTheme() ? AppThemeData.lynch950 : AppThemeData.lynch100,
                                                        ),
                                                      ),
                                                      border: OutlineInputBorder(
                                                        borderRadius: BorderRadius.circular(10),
                                                        borderSide: BorderSide(
                                                          width: 0.5,
                                                          color: themeChange.isDarkTheme() ? AppThemeData.lynch950 : AppThemeData.lynch100,
                                                        ),
                                                      ),
                                                      errorBorder: OutlineInputBorder(
                                                        borderRadius: BorderRadius.circular(10),
                                                        borderSide: const BorderSide(width: 0.5, color: AppThemeData.danger400),
                                                      ),
                                                    )),
                                                itemBuilder: (context, item, isDisabled, isSelected) {
                                                  return Padding(
                                                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                                    child: TextCustom(
                                                      title: item.vendorName.toString(),
                                                      fontFamily: FontFamily.regular,
                                                      fontSize: 16,
                                                      color: themeChange.isDarkTheme() ? AppThemeData.lynch500 : AppThemeData.lynch800,
                                                    ),
                                                  );
                                                }),
                                            suffixProps: const DropdownSuffixProps(
                                                dropdownButtonProps: DropdownButtonProps(
                                              iconClosed: Icon(
                                                Icons.arrow_drop_down,
                                                color: AppThemeData.lynch500,
                                              ),
                                              iconOpened: Icon(
                                                Icons.arrow_drop_up,
                                                color: AppThemeData.lynch500,
                                              ),
                                            )),
                                            decoratorProps: DropDownDecoratorProps(decoration: defaultInputDecorationForSearchDropDown(context)),
                                          ),
                                        ),
                                      ],
                                    ),
                                    spaceH(),
                                    Row(
                                      children: [
                                        Expanded(
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
                                                    controller.selectedDateRangeForPdf.value = DateTimeRange(
                                                      start: now.subtract(const Duration(days: 30)),
                                                      end: DateTime(now.year, now.month, now.day, 23, 59, 0, 0),
                                                    );
                                                    await FireStoreUtils.countStatusWiseBooking(
                                                        driverId: controller.driverId.value,
                                                        status: controller.selectedOrderStatusForData.value,
                                                        dateTimeRange: controller.selectedDateRange.value,
                                                        restaurantId: controller.restaurantId.value);
                                                    await controller.setPagination(controller.totalItemPerPage.value);
                                                    break;
                                                  case 'Last 6 Months':
                                                    controller.selectedDateRangeForPdf.value = DateTimeRange(
                                                      start: DateTime(now.year, now.month - 6, now.day),
                                                      end: DateTime(now.year, now.month, now.day, 23, 59, 0, 0),
                                                    );
                                                    await FireStoreUtils.countStatusWiseBooking(
                                                        driverId: controller.driverId.value,
                                                        status: controller.selectedOrderStatusForData.value,
                                                        dateTimeRange: controller.selectedDateRange.value,
                                                        restaurantId: controller.restaurantId.value);
                                                    await controller.setPagination(controller.totalItemPerPage.value);
                                                    break;
                                                  case 'Last Year':
                                                    controller.selectedDateRangeForPdf.value = DateTimeRange(
                                                      start: DateTime(now.year - 1, now.month, now.day),
                                                      end: DateTime(now.year, now.month, now.day, 23, 59, 0, 0),
                                                    );
                                                    await FireStoreUtils.countStatusWiseBooking(
                                                        driverId: controller.driverId.value,
                                                        status: controller.selectedOrderStatusForData.value,
                                                        dateTimeRange: controller.selectedDateRange.value,
                                                        restaurantId: controller.restaurantId.value);
                                                    await controller.setPagination(controller.totalItemPerPage.value);
                                                    break;
                                                  case 'Custom':
                                                    // controller.isCustomVisible.value = true;
                                                    // controller.selectedBookingStatus.value = statusType ?? "All";
                                                    showDateRangePicker(context);
                                                    break;
                                                  case 'All':
                                                  default:
                                                    // No specific filter, maybe assign null or a full year
                                                    controller.selectedDateRangeForPdf.value = DateTimeRange(
                                                      start: DateTime(now.year, 1, 1),
                                                      end: DateTime(now.year, now.month, now.day, 23, 59, 0, 0),
                                                    );
                                                    break;
                                                }
                                                controller.isCustomVisible.value = statusType == 'Custom';
                                              },
                                              value: controller.selectedDateOption.value,
                                              items: controller.dateOption.map<DropdownMenuItem<String>>((String value) {
                                                return DropdownMenuItem(
                                                    value: value.tr,
                                                    child: TextCustom(
                                                      title: value,
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
                                        SizedBox(
                                          width: 140,
                                          child: Obx(
                                            () => DropdownButtonFormField(
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
                                                  value: value,
                                                  child: TextCustom(
                                                    title: value,
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
                                        spaceW(),
                                        NumberOfRowsDropDown(
                                          controller: controller,
                                        ),
                                        ContainerCustom(
                                            padding: paddingEdgeInsets(horizontal: 0, vertical: 0),
                                            color: AppThemeData.primary500,
                                            child: IconButton(
                                              onPressed: () {
                                                controller.dateRangeController.value.text = "";
                                                controller.selectedDateOptionForPdf.value = "All";
                                                showDialog(
                                                    context: context,
                                                    builder: (context) => CustomDialog(
                                                          controller: controller,
                                                          title: "Orders Statement Download".tr,
                                                          widgetList: [
                                                            TextCustom(
                                                              title: 'Select Time'.tr,
                                                              fontFamily: FontFamily.regular,
                                                              fontSize: 16,
                                                            ),
                                                            spaceH(),
                                                            SizedBox(
                                                              width: 200,
                                                              child: Obx(
                                                                () => DropdownButtonFormField(
                                                                  borderRadius: BorderRadius.circular(15),
                                                                  isExpanded: true,
                                                                  style: TextStyle(
                                                                    fontFamily: FontFamily.medium,
                                                                    color: themeChange.isDarkTheme() ? AppThemeData.textBlack : AppThemeData.textGrey,
                                                                  ),
                                                                  onChanged: (String? statusType) {
                                                                    // controller.selectedDateOption.value = statusType ?? "All";
                                                                    // if (statusType == 'Custom') {
                                                                    //   controller.isCustomVisible.value = true;
                                                                    // } else {
                                                                    //   controller.isCustomVisible.value = false;
                                                                    // }
                                                                    // controller.getBookingDataByBookingStatus();

                                                                    final now = DateTime.now();
                                                                    controller.selectedDateOptionForPdf.value = statusType ?? "All";

                                                                    switch (statusType) {
                                                                      case 'Last Month':
                                                                        controller.selectedDateRangeForPdf.value = DateTimeRange(
                                                                          start: now.subtract(const Duration(days: 30)),
                                                                          end: DateTime(now.year, now.month, now.day, 23, 59, 0, 0),
                                                                        );
                                                                        break;
                                                                      case 'Last 6 Months':
                                                                        controller.selectedDateRangeForPdf.value = DateTimeRange(
                                                                          start: DateTime(now.year, now.month - 6, now.day),
                                                                          end: DateTime(now.year, now.month, now.day, 23, 59, 0, 0),
                                                                        );
                                                                        break;
                                                                      case 'Last Year':
                                                                        controller.selectedDateRangeForPdf.value = DateTimeRange(
                                                                          start: DateTime(now.year - 1, now.month, now.day),
                                                                          end: DateTime(now.year, now.month, now.day, 23, 59, 0, 0),
                                                                        );
                                                                        break;
                                                                      case 'Custom':
                                                                        controller.isCustomVisible.value = true;
                                                                        break;
                                                                      case 'All':
                                                                      default:
                                                                        // No specific filter, maybe assign null or a full year
                                                                        controller.selectedDateRangeForPdf.value = DateTimeRange(
                                                                          start: DateTime(now.year, 1, 1),
                                                                          end: DateTime(now.year, now.month, now.day, 23, 59, 0, 0),
                                                                        );
                                                                        break;
                                                                    }

                                                                    controller.isCustomVisible.value = statusType == 'Custom';

                                                                  },
                                                                  value: controller.selectedDateOptionForPdf.value,
                                                                  items: controller.dateOption.map<DropdownMenuItem<String>>((String value) {
                                                                    return DropdownMenuItem(
                                                                        value: value.tr,
                                                                        child: TextCustom(
                                                                          title: value,
                                                                          fontFamily: FontFamily.regular,
                                                                          fontSize: 16,
                                                                          color: themeChange.isDarkTheme() ? AppThemeData.lynch500 : AppThemeData.lynch800,
                                                                        ));
                                                                  }).toList(),
                                                                  decoration: Constant.DefaultInputDecoration(context),
                                                                ),
                                                              ),
                                                            ),
                                                            spaceH(),
                                                            Obx(
                                                              () => Visibility(
                                                                visible: controller.isCustomVisible.value,
                                                                child: CustomTextFormField(
                                                                  validator: (value) => value != null && value.isNotEmpty ? null : 'Start & End Date Required'.tr,
                                                                  hintText: "Select Start & End Date".tr,
                                                                  controller: controller.dateRangeController.value,
                                                                  title: "Start & End Date".tr,
                                                                  onPress: () {
                                                                    showDateRangePickerForPdf(context);
                                                                  },
                                                                  // isReadOnly: true,
                                                                  suffix: const Icon(
                                                                    Icons.calendar_month_outlined,
                                                                    color: AppThemeData.lynch500,
                                                                    size: 24,
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                            spaceH(),
                                                            Column(
                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                              children: [
                                                                TextCustom(
                                                                  title: 'Select Driver'.tr,
                                                                  fontFamily: FontFamily.regular,
                                                                  fontSize: 16,
                                                                ),
                                                                spaceH(),
                                                                SizedBox(
                                                                  width: 250,
                                                                  child: DropdownSearch<DriverUserModel>(
                                                                    items: (filter, infiniteScrollProps) => controller.allDriverList,
                                                                    // items: (f, cs) => controller.getAllDriver(),
                                                                    // selectedItem: controller.selectedDriver.value,
                                                                    itemAsString: (DriverUserModel? driver) => driver?.firstName ?? "",
                                                                    compareFn: (item, selectedItem) => item.driverId == selectedItem.driverId,
                                                                    onChanged: (DriverUserModel? driver) {
                                                                      controller.selectedDriver.value = driver;
                                                                    },
                                                                    dropdownBuilder: (context, DriverUserModel? driver) {
                                                                      return Text(
                                                                        driver?.firstName ?? "All Driver".tr,
                                                                        style: TextStyle(
                                                                          fontFamily: FontFamily.regular,
                                                                          fontSize: 16,
                                                                          color: themeChange.isDarkTheme() ? AppThemeData.lynch500 : AppThemeData.lynch800,
                                                                        ),
                                                                      );
                                                                    },
                                                                    suffixProps: const DropdownSuffixProps(
                                                                        dropdownButtonProps: DropdownButtonProps(
                                                                      iconClosed: Icon(
                                                                        Icons.arrow_drop_down,
                                                                        color: AppThemeData.lynch500,
                                                                      ),
                                                                      iconOpened: Icon(
                                                                        Icons.arrow_drop_up,
                                                                        color: AppThemeData.lynch500,
                                                                      ),
                                                                    )),
                                                                    popupProps: PopupProps.menu(
                                                                        showSearchBox: true,
                                                                        showSelectedItems: true,
                                                                        searchFieldProps: TextFieldProps(
                                                                            cursorColor: AppThemeData.primary500,
                                                                            decoration: InputDecoration(
                                                                              fillColor: themeChange.isDarkTheme() ? AppThemeData.background : AppThemeData.lynch500,
                                                                              contentPadding: const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
                                                                              hintText: "Search Driver".tr,
                                                                              hintStyle: TextStyle(
                                                                                  fontSize: 14,
                                                                                  fontFamily: FontFamily.regular,
                                                                                  color: themeChange.isDarkTheme() ? AppThemeData.lynch500 : AppThemeData.lynch950),
                                                                              focusedBorder: OutlineInputBorder(
                                                                                borderRadius: BorderRadius.circular(10),
                                                                                borderSide: const BorderSide(width: 0.5, color: AppThemeData.appColor),
                                                                              ),
                                                                              border: OutlineInputBorder(
                                                                                borderRadius: BorderRadius.circular(10),
                                                                                borderSide: BorderSide(width: 0.5, color: AppThemeData.primaryBlack),
                                                                              ),
                                                                              errorBorder: OutlineInputBorder(
                                                                                borderRadius: BorderRadius.circular(10),
                                                                                borderSide: const BorderSide(width: 0.5, color: AppThemeData.red500),
                                                                              ),
                                                                            )),
                                                                        itemBuilder: (context, item, isDisabled, isSelected) {
                                                                          return Padding(
                                                                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                                                            child: Text(
                                                                              '${item.firstName}',
                                                                              style: TextStyle(
                                                                                  fontFamily: FontFamily.regular,
                                                                                  color: themeChange.isDarkTheme() ? AppThemeData.lynch500 : AppThemeData.lynch950),
                                                                            ),
                                                                          );
                                                                        }),
                                                                    decoratorProps: DropDownDecoratorProps(decoration: defaultInputDecorationForSearchDropDown(context)),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                            spaceH(),
                                                            Center(
                                                              child: SizedBox(
                                                                width: 160,
                                                                child: DropdownSearch<VendorModel>(
                                                                  // mode: Mode.form,
                                                                  items: (f, cs) => controller.allRestaurantList,
                                                                  itemAsString: (VendorModel item) => '${item.vendorName}',
                                                                  compareFn: (item, selectedItem) => item.id == selectedItem.id,
                                                                  onChanged: (VendorModel? selectedItem) async {
                                                                    controller.restaurantId.value = selectedItem!.id!;
                                                                    if (selectedItem.id == 'All') {
                                                                      controller.restaurantId.value = 'All';
                                                                      await FireStoreUtils.countStatusWiseBooking(
                                                                        restaurantId: 'All',
                                                                        driverId: controller.driverId.value,
                                                                        status: controller.selectedBookingStatusForData.value,
                                                                        dateTimeRange: controller.selectedDateRange.value,
                                                                      );
                                                                      await controller.setPagination(controller.totalItemPerPage.value);
                                                                    } else {
                                                                      await FireStoreUtils.countStatusWiseBooking(
                                                                        driverId: controller.driverId.value,
                                                                        status: controller.selectedBookingStatusForData.value,
                                                                        dateTimeRange: controller.selectedDateRange.value,
                                                                        restaurantId: controller.restaurantId.value,
                                                                      );
                                                                      await controller.setPagination(controller.totalItemPerPage.value);
                                                                    }
                                                                  },
                                                                  dropdownBuilder: (context, selectedItem) {
                                                                    return Text(
                                                                      selectedItem != null ? '${selectedItem.vendorName}' : 'All Restaurant'.tr,
                                                                      style: TextStyle(
                                                                        fontFamily: FontFamily.regular,
                                                                        fontSize: 16,
                                                                        color: themeChange.isDarkTheme() ? AppThemeData.lynch500 : AppThemeData.lynch800,
                                                                      ),
                                                                    );
                                                                  },
                                                                  popupProps: PopupProps.menu(
                                                                      showSearchBox: true,
                                                                      showSelectedItems: true,
                                                                      searchFieldProps: TextFieldProps(
                                                                          cursorColor: AppThemeData.appColor,
                                                                          decoration: InputDecoration(
                                                                            contentPadding: const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
                                                                            hintText: "Search Restaurant".tr,
                                                                            hintStyle: TextStyle(
                                                                              fontFamily: FontFamily.regular,
                                                                              fontSize: 16,
                                                                              color: themeChange.isDarkTheme() ? AppThemeData.lynch500 : AppThemeData.lynch800,
                                                                            ),
                                                                            focusedBorder: OutlineInputBorder(
                                                                              borderRadius: BorderRadius.circular(10),
                                                                              borderSide: BorderSide(
                                                                                width: 0.5,
                                                                                color: themeChange.isDarkTheme() ? AppThemeData.lynch950 : AppThemeData.lynch100,
                                                                              ),
                                                                            ),
                                                                            border: OutlineInputBorder(
                                                                              borderRadius: BorderRadius.circular(10),
                                                                              borderSide: BorderSide(
                                                                                width: 0.5,
                                                                                color: themeChange.isDarkTheme() ? AppThemeData.lynch950 : AppThemeData.lynch100,
                                                                              ),
                                                                            ),
                                                                            errorBorder: OutlineInputBorder(
                                                                              borderRadius: BorderRadius.circular(10),
                                                                              borderSide: const BorderSide(width: 0.5, color: AppThemeData.danger400),
                                                                            ),
                                                                          )),
                                                                      itemBuilder: (context, item, isDisabled, isSelected) {
                                                                        return Padding(
                                                                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                                                          child: TextCustom(
                                                                            title: item.vendorName.toString(),
                                                                            fontFamily: FontFamily.regular,
                                                                            fontSize: 16,
                                                                            color: themeChange.isDarkTheme() ? AppThemeData.lynch500 : AppThemeData.lynch800,
                                                                          ),
                                                                        );
                                                                      }),
                                                                  suffixProps: const DropdownSuffixProps(
                                                                      dropdownButtonProps: DropdownButtonProps(
                                                                    iconClosed: Icon(
                                                                      Icons.arrow_drop_down,
                                                                      color: AppThemeData.lynch500,
                                                                    ),
                                                                    iconOpened: Icon(
                                                                      Icons.arrow_drop_up,
                                                                      color: AppThemeData.lynch500,
                                                                    ),
                                                                  )),
                                                                  decoratorProps: DropDownDecoratorProps(decoration: defaultInputDecorationForSearchDropDown(context)),
                                                                ),
                                                              ),
                                                            ),
                                                            spaceH(),
                                                            Column(
                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                              children: [
                                                                TextCustom(
                                                                  title: 'Order Status'.tr,
                                                                  fontFamily: FontFamily.regular,
                                                                  fontSize: 16,
                                                                ),
                                                                spaceH(),
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
                                                                      onChanged: (String? statusType) {
                                                                        controller.selectedFilterBookingStatus.value = statusType ?? "All";
                                                                        // controller.getBookingDataByBookingStatus();
                                                                      },
                                                                      value: controller.selectedFilterBookingStatus.value,
                                                                      items: controller.orderStatus.map<DropdownMenuItem<String>>((String value) {
                                                                        return DropdownMenuItem(
                                                                          value: value,
                                                                          child: TextCustom(
                                                                            title: value,
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
                                                              ],
                                                            ),
                                                          ],
                                                          bottomWidgetList: [
                                                            CustomButtonWidget(
                                                              textColor: themeChange.isDarkTheme() ? Colors.white : Colors.black,
                                                              buttonColor: themeChange.isDarkTheme() ? AppThemeData.lynch900 : AppThemeData.lynch100,
                                                              onPress: () {
                                                                Navigator.pop(context);
                                                              },
                                                              title: "Close".tr,
                                                            ),
                                                            spaceW(),
                                                            Obx(
                                                              () => controller.isHistoryDownload.value
                                                                  ? Constant.circularProgressIndicatourLoader()
                                                                  : CustomButtonWidget(
                                                                      onPress: () {
                                                                        if (Constant.isDemo) {
                                                                          DialogBox.demoDialogBox();
                                                                        } else {
                                                                          if (controller.selectedDriver.value == null ||
                                                                              controller.selectedDriver.value!.driverId == null ||
                                                                              controller.selectedDriver.value!.driverId!.isEmpty) {
                                                                            ShowToastDialog.errorToast('Please select a driver.'.tr);
                                                                            return;
                                                                          }
                                                                          if (controller.selectedDateOptionForPdf.value == 'Custom' &&
                                                                              controller.dateRangeController.value.text.isEmpty) {
                                                                            ShowToastDialog.errorToast("Please select both a start and end date.".tr);
                                                                            return;
                                                                          }
                                                                          controller.downloadCabBookingPdf(context);
                                                                        }
                                                                      },
                                                                      title: "Download".tr,
                                                                    ),
                                                            ),
                                                          ],
                                                        ));
                                              },
                                              icon: SvgPicture.asset(
                                                "assets/icons/ic_download.svg",
                                                color: AppThemeData.primaryWhite,
                                                height: 24,
                                                width: 24,
                                              ),
                                            )),
                                      ],
                                    ),
                                    spaceH()
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
                                      : controller.currentPageBooking.isEmpty
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
                                                    columnTitle: "Customer Name".tr, width: ResponsiveWidget.isMobile(context) ? 150 : MediaQuery.of(context).size.width * 0.10),
                                                CommonUI.dataColumnWidget(context,
                                                    columnTitle: "Items".tr, width: ResponsiveWidget.isMobile(context) ? 300 : MediaQuery.of(context).size.width * 0.15),
                                                CommonUI.dataColumnWidget(context,
                                                    columnTitle: "Restaurant".tr, width: ResponsiveWidget.isMobile(context) ? 300 : MediaQuery.of(context).size.width * 0.08),
                                                CommonUI.dataColumnWidget(context,
                                                    columnTitle: "Date".tr, width: ResponsiveWidget.isMobile(context) ? 220 : MediaQuery.of(context).size.width * 0.12),
                                                CommonUI.dataColumnWidget(context,
                                                    columnTitle: "Booking Status".tr, width: ResponsiveWidget.isMobile(context) ? 150 : MediaQuery.of(context).size.width * 0.07),
                                                CommonUI.dataColumnWidget(context,
                                                    columnTitle: "Payment Type".tr, width: ResponsiveWidget.isMobile(context) ? 220 : MediaQuery.of(context).size.width * 0.08),
                                                CommonUI.dataColumnWidget(context,
                                                    columnTitle: "Payment Status".tr, width: ResponsiveWidget.isMobile(context) ? 120 : MediaQuery.of(context).size.width * 0.07),
                                                CommonUI.dataColumnWidget(context, columnTitle: "Total".tr, width: 120),
                                                // CommonUI.dataColumnWidget(context,
                                                //     columnTitle: "Status", width: ResponsiveWidget.isMobile(context) ? 100 : MediaQuery.of(context).size.width * 0.10),
                                                CommonUI.dataColumnWidget(
                                                  context,
                                                  columnTitle: "Action".tr,
                                                  width: 100,
                                                ),
                                              ],
                                              rows: controller.currentPageBooking
                                                  .map((orderModel) => DataRow(cells: [
                                                        DataCell(
                                                          InkWell(  onTap: () async {
                                                            Get.toNamed("${Routes.ORDER_DETAIL_SCREEN}/${orderModel.id}");
                                                            // Get.toNamed(Routes.ORDER_DETAIL_SCREEN, arguments: {'bookingModel': orderModel});
                                                          },
                                                            child: TextCustom(
                                                              title: orderModel.id!.isEmpty ? "N/A".tr : "#${orderModel.id!.substring(0, 4)}",
                                                            ),
                                                          ),
                                                        ),
                                                        DataCell(
                                                          FutureBuilder<UserModel?>(
                                                              future: FireStoreUtils.getUserByUserID(orderModel.customerId.toString()),
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
                                                                              : userModel.firstName.toString() == "Unknown User".tr
                                                                                  ? "User Deleted".tr
                                                                                  : userModel.firstName.toString(),
                                                                        ),
                                                                      );
                                                                    }
                                                                }
                                                              }),
                                                        ),
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
                                                        DataCell(
                                                          FutureBuilder<VendorModel?>(
                                                              future: FireStoreUtils.getRestaurant(orderModel.vendorId.toString()),
                                                              builder: (BuildContext context, AsyncSnapshot<VendorModel?> snapshot) {
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
                                                                      final vendorModel = snapshot.data;
                                                                      String vendorName;

                                                                      if (vendorModel == null) {
                                                                        vendorName = "User Deleted".tr; // vendor is deleted
                                                                      } else if (vendorModel.vendorName == null || vendorModel.vendorName!.trim().isEmpty) {
                                                                        vendorName = "N/A".tr; // name not available
                                                                      } else if (vendorModel.vendorName == "Unknown User".tr) {
                                                                        vendorName = "User Deleted".tr;
                                                                      } else {
                                                                        vendorName = vendorModel.vendorName!;
                                                                      }

                                                                      return Container(
                                                                        alignment: Alignment.centerLeft,
                                                                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                                                                        child: TextCustom(title: vendorName),
                                                                      );
                                                                    }
                                                                }
                                                              }),
                                                        ),
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
                                                        // DataCell(TextCustom(title: Constant.amountShow(amount: bookingModel.subTotal))),
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
                                                                      bool confirmDelete = await DialogBox.showConfirmationDeleteDialog(context);
                                                                      if (confirmDelete) {
                                                                        await controller.removeOrder(orderModel);
                                                                        controller.getOrders();
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
                            ]),
                          )
                        ]),
                      )),
                ),
              ],
            ));
      },
    );
  }

  Future<void> showDateRangePickerForPdf(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select Date'),
          content: SizedBox(
            height: 300,
            width: 300,
            child: SfDateRangePicker(
              initialDisplayDate: DateTime.now(),
              maxDate: DateTime.now(),
              selectionMode: DateRangePickerSelectionMode.range,
              onSelectionChanged: (DateRangePickerSelectionChangedArgs args) async {
                if (args.value is PickerDateRange) {
                  controller.startDateForPdf = (args.value as PickerDateRange).startDate;
                  controller.endDateForPdf = (args.value as PickerDateRange).endDate;
                }
              },
            ),
          ),
          actions: <Widget>[
            ElevatedButton(
                onPressed: () {
                  controller.selectedDateRangeForPdf.value = DateTimeRange(
                      start: DateTime(DateTime.now().year, DateTime.january, 1), end: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, 23, 59, 0, 0));
                  Navigator.of(context).pop();
                },
                child: const Text('clear')),
            TextButton(
              onPressed: () async {
                if (controller.startDateForPdf != null && controller.endDateForPdf != null) {
                  controller.selectedDateRangeForPdf.value = DateTimeRange(
                      start: controller.startDateForPdf!,
                      end: DateTime(controller.endDateForPdf!.year, controller.endDateForPdf!.month, controller.endDateForPdf!.day, 23, 59, 0, 0));
                  controller.dateRangeController.value.text =
                      "${DateFormat('dd/MM/yyyy').format(controller.selectedDateRangeForPdf.value.start)} to ${DateFormat('dd/MM/yyyy').format(controller.selectedDateRangeForPdf.value.end)}";
                }
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
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
                child: Text('clear'.tr)),
            TextButton(
              onPressed: () async {
                if (controller.startDate != null && controller.endDate != null) {
                  controller.selectedDateRange.value =
                      DateTimeRange(start: controller.startDate!, end: DateTime(controller.endDate!.year, controller.endDate!.month, controller.endDate!.day, 23, 59, 0, 0));
                  await FireStoreUtils.countStatusWiseOrder(
                    controller.selectedOrderStatusForData.value,
                    controller.selectedDateRange.value,
                  );
                  await controller.setPagination(controller.totalItemPerPage.value);
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
