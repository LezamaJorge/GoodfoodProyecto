// ignore_for_file: deprecated_member_use

import 'package:admin_panel/app/components/custom_button.dart';
import 'package:admin_panel/app/components/custom_text_form_field.dart';
import 'package:admin_panel/app/components/dialog_box.dart';
import 'package:admin_panel/app/components/menu_widget.dart';
import 'package:admin_panel/app/constant/constants.dart';
import 'package:admin_panel/app/constant/show_toast.dart';
import 'package:admin_panel/app/models/vendor_model.dart';
import 'package:admin_panel/app/restaurant_offer_screen/controllers/restaurant_offer_controller.dart';
import 'package:admin_panel/app/utils/app_colors.dart';
import 'package:admin_panel/app/utils/app_them_data.dart';
import 'package:admin_panel/app/utils/dark_theme_provider.dart';
import 'package:admin_panel/app/utils/fire_store_utils.dart';
import 'package:admin_panel/app/utils/responsive.dart';
import 'package:admin_panel/widget/common_ui.dart';
import 'package:admin_panel/widget/container_custom.dart';
import 'package:admin_panel/widget/global_widgets.dart';
import 'package:admin_panel/widget/text_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import '../../routes/app_pages.dart';


class RestaurantOfferScreenView extends GetView<RestaurantOfferController> {
  const RestaurantOfferScreenView({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetBuilder<RestaurantOfferController>(
      init: RestaurantOfferController(),
      builder: (controller) {
        return Scaffold(
          backgroundColor: themeChange.isDarkTheme() ? AppThemeData.lynch950 : AppThemeData.lynch50,
          appBar: CommonUI.appBarCustom(themeChange: themeChange, scaffoldKey: controller.scaffoldKeyDrawer),
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
                                      InkWell(onTap: () => Get.offAllNamed(Routes.DASHBOARD_SCREEN), child: TextCustom(title: 'Dashboard'.tr, fontSize: 14, fontFamily: FontFamily.medium, color: AppThemeData.lynch500)),
                                      const TextCustom(title: ' / ', fontSize: 14, fontFamily: FontFamily.medium, color: AppThemeData.lynch500),
                                      TextCustom(title: ' ${controller.title.value} ', fontSize: 14, fontFamily: FontFamily.medium, color: AppThemeData.primary500)
                                    ])
                                  ]),
                                  // CustomButtonWidget(
                                  //   padding: const EdgeInsets.symmetric(horizontal: 22),
                                  //   buttonTitle: "+ Add Coupon".tr,
                                  //   borderRadius: 10,
                                  //   onPress: () {
                                  //     controller.setDefaultData();
                                  //     showDialog(context: context, builder: (context) => const CouponDialog());
                                  //   },
                                  // ),
                                  CustomButtonWidget(
                                      title: "+ Add Restaurant Offer".tr,
                                      onPress: () {
                                        // controller.setDefaultData();
                                        showDialog(context: context, builder: (context) => const CouponDialog());
                                      })
                                ],
                              )
                                  : Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                    TextCustom(title: controller.title.value, fontSize: 20, fontFamily: FontFamily.bold),
                                    spaceH(height: 2),
                                    Row(children: [
                                      InkWell(onTap: () => Get.offAllNamed(Routes.DASHBOARD_SCREEN), child: TextCustom(title: 'Dashboard'.tr, fontSize: 14, fontFamily: FontFamily.medium, color: AppThemeData.lynch500)),
                                      const TextCustom(title: ' / ', fontSize: 14, fontFamily: FontFamily.medium, color: AppThemeData.lynch500),
                                      TextCustom(title: ' ${controller.title.value} ', fontSize: 14, fontFamily: FontFamily.medium, color: AppThemeData.primary500)
                                    ])
                                  ]),
                                  spaceH(),
                                  CustomButtonWidget(
                                    width: MediaQuery
                                        .sizeOf(context)
                                        .width * 0.7,
                                    padding: const EdgeInsets.symmetric(horizontal: 22),
                                    title: "+ Add Coupon".tr,
                                    // borderRadius: 10,
                                    onPress: () {
                                      controller.setDefaultData();
                                      showDialog(context: context, builder: (context) => const CouponDialog());
                                    },
                                  ),
                                ],
                              ),
                              spaceH(height: 20),
                              Obx(
                                    () =>
                                    SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: ClipRRect(
                                          borderRadius: BorderRadius.circular(12),
                                          child: controller.isLoading.value
                                              ? Padding(
                                            padding: paddingEdgeInsets(),
                                            child: Constant.loader(),
                                          )
                                              : controller.restaurantOfferList.isEmpty
                                              ? TextCustom(title: "No Data available".tr)
                                              : DataTable(
                                            horizontalMargin: 20,
                                            columnSpacing: 30,
                                            dataRowMaxHeight: 65,
                                            headingRowHeight: 65,
                                            border: TableBorder.all(
                                              color: themeChange.isDarkTheme() ? AppThemeData.lynch900 : AppThemeData.lynch100,
                                              borderRadius: BorderRadius.circular(12),
                                            ),
                                            headingRowColor: WidgetStateColor.resolveWith((states) => themeChange.isDarkTheme() ? AppThemeData.lynch900 : AppThemeData.lynch100),
                                            columns: [
                                              CommonUI.dataColumnWidget(context, columnTitle: "Title".tr, width: ResponsiveWidget.isMobile(context) ? 150 : MediaQuery
                                                  .of(context)
                                                  .size
                                                  .width * 0.15),
                                              CommonUI.dataColumnWidget(context, columnTitle: "Code".tr, width: ResponsiveWidget.isMobile(context) ? 150 : MediaQuery
                                                  .of(context)
                                                  .size
                                                  .width * 0.08),
                                              CommonUI.dataColumnWidget(context, columnTitle: "Expire".tr, width: ResponsiveWidget.isMobile(context) ? 150 : MediaQuery
                                                  .of(context)
                                                  .size
                                                  .width * 0.10),
                                              CommonUI.dataColumnWidget(context, columnTitle: "Active".tr, width: ResponsiveWidget.isMobile(context) ? 100 : MediaQuery
                                                  .of(context)
                                                  .size
                                                  .width * 0.03),
                                              CommonUI.dataColumnWidget(context, columnTitle: "Restaurant Name".tr, width: ResponsiveWidget.isMobile(context) ? 150 : MediaQuery
                                                  .of(context)
                                                  .size
                                                  .width * 0.12),
                                              CommonUI.dataColumnWidget(context, columnTitle: "Coupon Type".tr, width: ResponsiveWidget.isMobile(context) ? 100 : MediaQuery
                                                  .of(context)
                                                  .size
                                                  .width * 0.09),
                                              CommonUI.dataColumnWidget(context, columnTitle: "Commission Type".tr, width: ResponsiveWidget.isMobile(context) ? 100 : MediaQuery
                                                  .of(context)
                                                  .size
                                                  .width * 0.07),
                                              CommonUI.dataColumnWidget(context, columnTitle: "MinAmount".tr, width: ResponsiveWidget.isMobile(context) ? 85 : MediaQuery
                                                  .of(context)
                                                  .size
                                                  .width * 0.05),
                                              CommonUI.dataColumnWidget(context, columnTitle: "Amount".tr, width: ResponsiveWidget.isMobile(context) ? 80 : MediaQuery
                                                  .of(context)
                                                  .size
                                                  .width * 0.05),
                                              CommonUI.dataColumnWidget(context, columnTitle: "Actions".tr, width: ResponsiveWidget.isMobile(context) ? 80 : MediaQuery
                                                  .of(context)
                                                  .size
                                                  .width * 0.05),
                                            ],
                                            rows: controller.restaurantOfferList
                                                .map((couponModel) =>
                                                DataRow(cells: [
                                                  DataCell(TextCustom(title: couponModel.title.toString())),
                                                  DataCell(TextCustom(title: couponModel.code.toString())),
                                                  DataCell(TextCustom(title: Constant.timestampToDate(couponModel.expireAt!))),
                                                  DataCell(
                                                    Transform.scale(
                                                      scale: 0.8,
                                                      child: CupertinoSwitch(
                                                        activeTrackColor: AppThemeData.primary500,
                                                        value: couponModel.active!,
                                                        onChanged: (value) async {
                                                          if (Constant.isDemo) {
                                                            DialogBox.demoDialogBox();
                                                          } else {
                                                            couponModel.active = value;
                                                            await FireStoreUtils.updateCoupon(couponModel);
                                                            controller.getData();
                                                          }
                                                        },
                                                      ),
                                                    ),
                                                  ),

                                                  DataCell(
                                                    (couponModel.vendorId == null || couponModel.vendorId!.trim().isEmpty)
                                                        ? const TextCustom(
                                                      title: "N/A",
                                                      fontSize: 14,
                                                      fontFamily: FontFamily.medium,
                                                    )
                                                        : FutureBuilder<VendorModel?>(
                                                      future: FireStoreUtils.getRestaurantByRestaurantId(
                                                          couponModel.vendorId.toString()),
                                                      builder: (context, snapshot) {
                                                        // if (snapshot.connectionState == ConnectionState.waiting) {
                                                        //   return const TextCustom(
                                                        //     title: "Loading...",
                                                        //     fontSize: 14,
                                                        //     fontFamily: FontFamily.medium,
                                                        //   );
                                                        // }
                                                        if (snapshot.hasError || !snapshot.hasData || snapshot.data == null) {
                                                          return const TextCustom(
                                                            title: "N/A",
                                                            fontSize: 14,
                                                            fontFamily: FontFamily.medium,
                                                          );
                                                        }
                                                        VendorModel restaurant = snapshot.data!;
                                                        return TextCustom(
                                                          title: (restaurant.vendorName == null ||
                                                              restaurant.vendorName!.trim().isEmpty)
                                                              ? "N/A"
                                                              : restaurant.vendorName!,
                                                          fontSize: 14,
                                                          fontFamily: FontFamily.medium,
                                                        );
                                                      },
                                                    ),
                                                  ),
                                                  DataCell(TextCustom(title: couponModel.isFix == true ? 'Fix'.tr : 'Percentage'.tr)),
                                                  DataCell(TextCustom(title: couponModel.isPrivate == true ? 'Private'.tr : 'Public'.tr)),
                                                  DataCell(TextCustom(title: couponModel.minAmount.toString())),
                                                  DataCell(TextCustom(title: couponModel.amount.toString())),
                                                  DataCell(
                                                    Container(
                                                      alignment: Alignment.center,
                                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                                                      child: Row(
                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                        children: [
                                                          InkWell(
                                                            onTap: () {
                                                              int restaurantIndex = controller.restaurantList.indexWhere((element) => element.id == couponModel.vendorId);
                                                              if (restaurantIndex != -1) {
                                                                controller.selectedRestaurantId.value = controller.restaurantList[restaurantIndex];
                                                              }
                                                              controller.isEditing.value = true;
                                                              controller.couponTitleController.value.text = couponModel.title!;
                                                              controller.couponCodeController.value.text = couponModel.code!;
                                                              controller.couponMinAmountController.value.text = couponModel.minAmount!;
                                                              controller.couponAmountController.value.text = couponModel.amount!;
                                                              controller.isActive.value = couponModel.active!;
                                                              controller.editingId.value = couponModel.id!;
                                                              controller.selectedAdminCommissionType.value = couponModel.isFix == true ? 'Fix' : 'Percentage';
                                                              controller.couponPrivateType.value = couponModel.isPrivate == true ? 'Private' : 'Public';
                                                              controller.expireDateController.value.text = Constant.timestampToDate(couponModel.expireAt!);
                                                              showDialog(context: context, builder: (context) => const CouponDialog());
                                                            },
                                                            child: SvgPicture.asset(
                                                              "assets/icons/ic_edit.svg",
                                                              color: AppThemeData.lynch500,
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
                                                                // controller.removeCoupon(couponModel);
                                                                bool confirmDelete = await DialogBox.showConfirmationDeleteDialog(context);
                                                                if (confirmDelete) {
                                                                  controller.removeCoupon(couponModel);
                                                                }
                                                              }
                                                            },
                                                            child: SvgPicture.asset(
                                                              "assets/icons/ic_delete.svg",
                                                              //color: AppThemeData.lynch500,
                                                              height: 16,
                                                              width: 16,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ]))
                                                .toList(),
                                          )),
                                    ),
                              )
                            ],
                          ),
                        )
                        // Your widgets here
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

class CouponDialog extends StatelessWidget {
  const CouponDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetX<RestaurantOfferController>(
      init: RestaurantOfferController(),
      builder: (controller) {
        return SingleChildScrollView(
          child: CustomDialog(
            title: controller.title.value,
            widgetList: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomTextFormField(hintText: 'Enter Coupon Title'.tr, controller: controller.couponTitleController.value, title: 'Title'.tr),
                  spaceH(),
                  CustomTextFormField(hintText: 'Enter Coupon Code'.tr, controller: controller.couponCodeController.value, title: 'Code'.tr),
                  spaceH(),
                  Row(
                    children: [
                      Expanded(child: CustomTextFormField(hintText: 'Enter Minimum Amount'.tr,
                          controller: controller.couponMinAmountController.value,
                          textInputType: TextInputType.number,
                          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                          title: 'Minimum Amount'.tr)),
                      spaceW(),
                      Expanded(child:
                      CustomTextFormField(hintText: 'Enter Amount'.tr,
                          textInputType: TextInputType.number,
                          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                          controller: controller.couponAmountController.value,
                          title: 'Discount'.tr)),
                    ],
                  ),
                  spaceH(),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextCustom(
                              maxLine: 1,
                              title: "Commission Type".tr,
                              fontFamily: FontFamily.medium,
                              fontSize: 14,
                            ),
                            spaceH(),
                            Obx(
                                  () =>
                                  DropdownButtonFormField(
                                    isExpanded: true,
                                    style: TextStyle(
                                      fontFamily: FontFamily.medium,
                                      color: themeChange.isDarkTheme() ? AppThemeData.primaryWhite : AppThemeData.textBlack,
                                    ),
                                    hint: TextCustom(title: 'Select Commission Type'.tr),
                                    onChanged: (String? taxType) {
                                      controller.selectedAdminCommissionType.value = taxType ?? "Fix";
                                    },
                                    value: controller.selectedAdminCommissionType.value,
                                    items: controller.adminCommissionType.map<DropdownMenuItem<String>>((String value) {
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
                          ],
                        ),
                      ),
                      spaceW(),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextCustom(
                              maxLine: 1,
                              title: "Coupon Type".tr,
                              fontFamily: FontFamily.medium,
                              fontSize: 14,
                            ),
                            spaceH(),
                            Obx(
                                  () =>
                                  DropdownButtonFormField(
                                    borderRadius: BorderRadius.circular(15),
                                    isExpanded: true,
                                    style: TextStyle(
                                      fontFamily: FontFamily.medium,
                                      color: themeChange.isDarkTheme() ? AppThemeData.primaryWhite : AppThemeData.textBlack,
                                    ),
                                    hint: TextCustom(title: 'Select Coupon Type'.tr),
                                    onChanged: (String? couponType) {
                                      controller.couponPrivateType.value = couponType ?? "Public".tr;
                                    },
                                    value: controller.couponPrivateType.value,
                                    items: controller.couponType.map<DropdownMenuItem<String>>((String value) {
                                      return DropdownMenuItem(
                                        value: value,
                                        child: TextCustom(
                                          title: value,
                                          color: themeChange.isDarkTheme() ? AppThemeData.lynch500 : AppThemeData.lynch800,
                                          fontSize: 16,
                                        ),
                                      );
                                    }).toList(),
                                    decoration: Constant.DefaultInputDecoration(context),
                                    // decoration: Constant.DefaultInputDecorationForDrawerWidgets(context),
                                  ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                  spaceH(),
                  spaceH(),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            spaceH(),
                            CustomTextFormField(
                                onPress: () {
                                  controller.selectDate(context);
                                },
                                hintText: 'Select coupon expire date'.tr,
                                controller: controller.expireDateController.value,
                                title: 'Coupon Expire Date'.tr),
                          ],
                        ),
                      ),
                    ],
                  ),
                  spaceH(),
                  TextCustom(
                    title: "Restaurant Name *".tr,
                    fontSize: 14,
                  ),
                  spaceH(height: 10),
                  DropdownButtonFormField<VendorModel>(
                    isExpanded: true,
                    dropdownColor: themeChange.isDarkTheme() ? AppThemeData.lynch800 : AppThemeData.lynch100,
                    style: TextStyle(
                      fontFamily: FontFamily.medium,
                      color: themeChange.isDarkTheme() ? AppThemeData.primaryWhite : AppThemeData.textBlack,
                    ),
                    hint: TextCustom(title: 'Select Restaurant Name'.tr, fontSize: 14, fontFamily: FontFamily.regular, color: themeChange.isDarkTheme() ? AppThemeData.lynch300 : AppThemeData.lynch400),
                    onChanged: (restaurant) {
                      controller.selectedRestaurantId.value = restaurant!;
                    },
                    validator: (value) => value != null ? null : 'This field required'.tr,
                    value: controller.selectedRestaurantId.value.id == null ? null : controller.selectedRestaurantId.value,
                    icon: const Icon(Icons.keyboard_arrow_down_outlined),
                    items: controller.restaurantList.map((value) {
                      return DropdownMenuItem<VendorModel>(
                        value: value,
                        child: Text(
                          value.vendorName.toString(),
                          style: TextStyle(
                            fontFamily: FontFamily.regular,
                            fontSize: 14,
                            color: themeChange.isDarkTheme() ? AppThemeData.lynch200 : AppThemeData.lynch800,
                          ),
                        ),
                      );
                    }).toList(),
                    decoration: Constant.DefaultInputDecoration(context),
                  ),
                ],
              ),
              spaceH(),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextCustom(
                          title: 'Status'.tr,
                          fontSize: 12,
                        ),
                        spaceH(),
                        Transform.scale(
                          scale: 0.8,
                          child: CupertinoSwitch(
                            activeTrackColor: AppThemeData.primary500,
                            value: controller.isActive.value,
                            onChanged: (value) {
                              controller.isActive.value = value;
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
            bottomWidgetList: [
              CustomButtonWidget(
                title: "Close".tr,
                buttonColor: themeChange.isDarkTheme() ? AppThemeData.lynch500 : AppThemeData.lynch500,
                onPress: () {
                  controller.setDefaultData();
                  Navigator.pop(context);
                },
              ),
              spaceW(),
              CustomButtonWidget(
                title: "Save".tr,
                onPress: () {
                  if (Constant.isDemo) {
                    DialogBox.demoDialogBox();
                  } else {
                    if (controller.couponTitleController.value.text.isNotEmpty &&
                        controller.couponCodeController.value.text.isNotEmpty &&
                        controller.couponMinAmountController.value.text.isNotEmpty &&
                        controller.couponAmountController.value.text.isNotEmpty &&
                        controller.expireDateController.value.text.isNotEmpty) {
                      controller.isEditing.value ? controller.updateCoupon() : controller.addCoupon();
                      controller.setDefaultData();
                      Navigator.pop(context);
                    } else {
                      ShowToastDialog.errorToast("All fields are required.".tr);
                    }
                  }
                },
              ),
            ],
            controller: controller,
          ),
        );
      },
    );
  }
}
