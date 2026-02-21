// ignore_for_file: deprecated_member_use

import 'package:admin_panel/app/components/custom_text_form_field.dart';
import 'package:admin_panel/app/components/network_image_widget.dart';
import 'package:admin_panel/app/modules/owner_details_screen/controllers/owner_detail_controller.dart';
import 'package:admin_panel/app/modules/restaurant/controllers/restaurant_controller.dart';
import 'package:admin_panel/app/modules/restaurant/views/restaurant_view.dart';
import 'package:admin_panel/app/utils/app_them_data.dart';
import 'package:admin_panel/app/utils/dark_theme_provider.dart';
import 'package:admin_panel/app/utils/responsive.dart';
import 'package:admin_panel/app/utils/screen_size.dart';
import 'package:admin_panel/widget/global_widgets.dart';
import 'package:admin_panel/widget/text_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';

import '../../../../../widget/common_ui.dart';
import '../../../../../widget/container_custom.dart';
import '../../../../components/custom_button.dart';
import '../../../../components/dialog_box.dart';
import '../../../../constant/constants.dart';
import '../../../../routes/app_pages.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/fire_store_utils.dart';

class OwnerDetailsWidget extends StatelessWidget {
  const OwnerDetailsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetX(
        init: OwnerDetailController(),
        builder: (controller) {
          return Scaffold(
              backgroundColor: themeChange.isDarkTheme() ? AppThemeData.lynch950 : AppThemeData.lynch50,
              body: ResponsiveWidget(
                  mobile: controller.isLoading.value
                      ? Constant.loader()
                      : ContainerCustom(
                          color: themeChange.isDarkTheme() ? AppThemeData.primaryBlack : AppThemeData.primaryWhite,
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    color: themeChange.isDarkTheme() ? AppThemeData.lynch950 : AppThemeData.lynch50,
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          NetworkImageWidget(
                                            imageUrl: controller.ownerModel.value.profileImage.toString(),
                                            fit: BoxFit.fill,
                                            height: ScreenSize.height(20, context),
                                            width: ScreenSize.width(30, context),
                                            borderRadius: 8,
                                          ),
                                          spaceW(width: 12),
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              TextCustom(
                                                title: "Driver Details".tr,
                                                fontSize: 16,
                                                fontFamily: FontFamily.medium,
                                                color: themeChange.isDarkTheme() ? AppThemeData.lynch25 : AppThemeData.lynch950,
                                              ),
                                              spaceH(height: 12),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                children: [
                                                  SvgPicture.asset(
                                                    "assets/icons/ic_user.svg",
                                                    color: themeChange.isDarkTheme() ? AppThemeData.lynch25 : AppThemeData.lynch950,
                                                  ),
                                                  spaceW(width: 8),
                                                  TextCustom(
                                                    title: controller.ownerModel.value.fullNameString(),
                                                    fontSize: 14,
                                                    fontFamily: FontFamily.regular,
                                                    color: themeChange.isDarkTheme() ? AppThemeData.lynch25 : AppThemeData.lynch950,
                                                  ),
                                                ],
                                              ),
                                              spaceH(height: 4),
                                              if (controller.ownerModel.value.email != null && controller.ownerModel.value.email!.isNotEmpty)
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  children: [
                                                    SvgPicture.asset(
                                                      "assets/icons/ic_mail.svg",
                                                      color: themeChange.isDarkTheme() ? AppThemeData.lynch25 : AppThemeData.lynch950,
                                                    ),
                                                    spaceW(width: 8),
                                                    TextCustom(
                                                      title: controller.ownerModel.value.email.toString(),
                                                      fontSize: 14,
                                                      fontFamily: FontFamily.regular,
                                                      color: themeChange.isDarkTheme() ? AppThemeData.lynch25 : AppThemeData.lynch950,
                                                    ),
                                                  ],
                                                ),
                                              spaceH(height: 4),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                children: [
                                                  SvgPicture.asset(
                                                    "assets/icons/ic_call.svg",
                                                    color: themeChange.isDarkTheme() ? AppThemeData.lynch25 : AppThemeData.lynch950,
                                                  ),
                                                  spaceW(width: 8),
                                                  TextCustom(
                                                    title: "${controller.ownerModel.value.countryCode} ${controller.ownerModel.value.phoneNumber}",
                                                    fontSize: 14,
                                                    fontFamily: FontFamily.regular,
                                                    color: themeChange.isDarkTheme() ? AppThemeData.lynch25 : AppThemeData.lynch950,
                                                  ),
                                                ],
                                              ),
                                              spaceH(height: 16),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                children: [
                                                  Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      TextCustom(
                                                        title: 'Wallet Amount : ',
                                                        fontSize: 16,
                                                        fontFamily: FontFamily.regular,
                                                        color: themeChange.isDarkTheme() ? AppThemeData.lynch25 : AppThemeData.lynch950,
                                                      ),
                                                      spaceH(height: 2),
                                                      Obx(
                                                        () {
                                                          return TextCustom(
                                                            title: Constant.amountShow(amount: controller.ownerModel.value.walletAmount!),
                                                            fontSize: 18,
                                                            color: themeChange.isDarkTheme() ? AppThemeData.lynch25 : AppThemeData.lynch950,
                                                            fontFamily: FontFamily.bold,
                                                          );
                                                        },
                                                      ),
                                                    ],
                                                  ),
                                                  Align(
                                                    alignment: Alignment.bottomRight,
                                                    child: CustomButtonWidget(
                                                      title: 'Top Up'.tr,
                                                      buttonColor: AppThemeData.primary500,
                                                      onPress: () {
                                                        showDialog(context: context, builder: (context) => const TopUpDialog());
                                                      },
                                                    ),
                                                  )
                                                ],
                                              )
                                            ],
                                          ),
                                        ],
                                      ),
                                      spaceH(height: 24),
                                      SingleChildScrollView(
                                        scrollDirection: Axis.horizontal,
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(12),
                                          child: Obx(() {
                                            if (controller.isLoading.value) {
                                              return Padding(
                                                padding: paddingEdgeInsets(),
                                                child: Constant.loader(),
                                              );
                                            } else if (controller.restaurantList.isEmpty) {
                                              return const SizedBox.shrink(); // Hides everything if list is empty
                                            } else {
                                              return DataTable(
                                                horizontalMargin: 20,
                                                columnSpacing: 30,
                                                dataRowMaxHeight: 65,
                                                headingRowHeight: 65,
                                                border: TableBorder.all(
                                                  color: themeChange.isDarkTheme()
                                                      ? AppThemeData.lynch800
                                                      : AppThemeData.lynch100,
                                                  borderRadius: BorderRadius.circular(12),
                                                ),
                                                headingRowColor: WidgetStateColor.resolveWith(
                                                      (states) => themeChange.isDarkTheme()
                                                      ? AppThemeData.lynch800
                                                      : AppThemeData.lynch100,
                                                ),
                                                columns: [
                                                  CommonUI.dataColumnWidget(context, columnTitle: "Name".tr, width: 150),
                                                  CommonUI.dataColumnWidget(context, columnTitle: "Owner Name".tr, width: MediaQuery.of(context).size.width * 0.15),
                                                  CommonUI.dataColumnWidget(context, columnTitle: "Created At".tr, width: MediaQuery.of(context).size.width * 0.15),
                                                  CommonUI.dataColumnWidget(context, columnTitle: "Cuisine".tr, width: MediaQuery.of(context).size.width * 0.12),
                                                  CommonUI.dataColumnWidget(context, columnTitle: "Status".tr, width: MediaQuery.of(context).size.width * 0.10),
                                                  CommonUI.dataColumnWidget(context, columnTitle: "Action".tr, width: MediaQuery.of(context).size.width * 0.10),
                                                ],
                                                rows: controller.restaurantList.map((restaurantModel) {
                                                  return DataRow(
                                                    cells: [
                                                      DataCell(Row(
                                                        children: [
                                                          NetworkImageWidget(
                                                            imageUrl: restaurantModel.coverImage.toString(),
                                                            height: 35,
                                                            width: 35,
                                                          ),
                                                          spaceW(width: 8),
                                                          InkWell(
                                                            onTap: () async {
                                                              Get.toNamed("${Routes.RESTAURANT_DETAILS}/${restaurantModel.id}");
                                                            },
                                                            child: TextCustom(
                                                              title: restaurantModel.vendorName.toString(),
                                                              fontSize: 14,
                                                              fontFamily: FontFamily.regular,
                                                            ),
                                                          ),
                                                        ],
                                                      )),
                                                      DataCell(TextCustom(
                                                        title: restaurantModel.ownerFullName.toString(),
                                                        fontSize: 14,
                                                        fontFamily: FontFamily.regular,
                                                      )),
                                                      DataCell(TextCustom(
                                                        title: Constant.timestampToDate(restaurantModel.createdAt!),
                                                        fontSize: 14,
                                                        fontFamily: FontFamily.regular,
                                                      )),
                                                      DataCell(TextCustom(
                                                        title: restaurantModel.cuisineName.toString(),
                                                        fontSize: 14,
                                                        fontFamily: FontFamily.regular,
                                                      )),
                                                      DataCell(Transform.scale(
                                                        scale: 0.8,
                                                        child: CupertinoSwitch(
                                                          activeTrackColor: AppThemeData.primary500,
                                                          value: restaurantModel.active ?? false,
                                                          onChanged: (value) async {
                                                            restaurantModel.active = value;
                                                            await FireStoreUtils.updateNewRestaurant(restaurantModel);
                                                            controller.getArgument();
                                                          },
                                                        ),
                                                      )),
                                                      DataCell(Container(
                                                        alignment: Alignment.center,
                                                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                                                        child: Row(
                                                          mainAxisAlignment: MainAxisAlignment.start,
                                                          children: [
                                                            InkWell(
                                                              onTap: () async {
                                                                Get.toNamed("${Routes.RESTAURANT_DETAILS}/${restaurantModel.id}");
                                                              },
                                                              child: SvgPicture.asset(
                                                                "assets/icons/ic_eye.svg",
                                                                color: themeChange.isDarkTheme()
                                                                    ? AppThemeData.lynch400
                                                                    : AppThemeData.lynch500,
                                                                height: 16,
                                                                width: 16,
                                                              ),
                                                            ),
                                                            spaceW(width: 20),
                                                            InkWell(
                                                              onTap: () {

                                                                showDialog(
                                                                  context: context,
                                                                  builder: (context) => const AddRestaurant(),
                                                                );
                                                              },
                                                              child: SvgPicture.asset(
                                                                "assets/icons/ic_edit.svg",
                                                                color: themeChange.isDarkTheme()
                                                                    ? AppThemeData.lynch400
                                                                    : AppThemeData.lynch500,
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
                                                                  RestaurantController restaurantController = Get.put(RestaurantController());
                                                                  bool confirmDelete = await DialogBox.showConfirmationDeleteDialog(context);
                                                                  if (confirmDelete) {
                                                                    await restaurantController.removeRestaurant(restaurantModel);
                                                                    controller.getArgument();
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
                                                      )),
                                                    ],
                                                  );
                                                }).toList(),
                                              );
                                            }
                                          }),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                  tablet: controller.isLoading.value
                      ? Constant.loader()
                      : ContainerCustom(
                          color: themeChange.isDarkTheme() ? AppThemeData.primaryBlack : AppThemeData.primaryWhite,
                          child: Column(
                            children: [
                              ContainerCustom(
                                color: themeChange.isDarkTheme() ? AppThemeData.lynch950 : AppThemeData.lynch50,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    NetworkImageWidget(
                                      imageUrl: controller.ownerModel.value.profileImage.toString(),
                                      fit: BoxFit.fill,
                                      height: ScreenSize.height(20, context),
                                      width: ScreenSize.width(30, context),
                                      borderRadius: 8,
                                    ),
                                    spaceW(width: 12),
                                    Expanded(
                                      child: SingleChildScrollView(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    TextCustom(
                                                      title: "Owner Details".tr,
                                                      fontSize: 16,
                                                      fontFamily: FontFamily.medium,
                                                      color: themeChange.isDarkTheme() ? AppThemeData.lynch25 : AppThemeData.lynch950,
                                                    ),
                                                    spaceH(height: 12),
                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                      children: [
                                                        SvgPicture.asset(
                                                          "assets/icons/ic_user.svg",
                                                          color: themeChange.isDarkTheme() ? AppThemeData.lynch25 : AppThemeData.lynch950,
                                                        ),
                                                        spaceW(width: 8),
                                                        TextCustom(
                                                          title: controller.ownerModel.value.fullNameString(),
                                                          fontSize: 14,
                                                          fontFamily: FontFamily.regular,
                                                          color: themeChange.isDarkTheme() ? AppThemeData.lynch25 : AppThemeData.lynch950,
                                                        ),
                                                      ],
                                                    ),
                                                    spaceH(height: 4),
                                                    if (controller.ownerModel.value.email != null && controller.ownerModel.value.email!.isNotEmpty)
                                                      Row(
                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                        children: [
                                                          SvgPicture.asset(
                                                            "assets/icons/ic_mail.svg",
                                                            color: themeChange.isDarkTheme() ? AppThemeData.lynch25 : AppThemeData.lynch950,
                                                          ),
                                                          spaceW(width: 8),
                                                          TextCustom(
                                                            title: controller.ownerModel.value.email.toString(),
                                                            fontSize: 14,
                                                            fontFamily: FontFamily.regular,
                                                            color: themeChange.isDarkTheme() ? AppThemeData.lynch25 : AppThemeData.lynch950,
                                                          ),
                                                        ],
                                                      ),
                                                    spaceH(height: 4),
                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                      children: [
                                                        SvgPicture.asset(
                                                          "assets/icons/ic_call.svg",
                                                          color: themeChange.isDarkTheme() ? AppThemeData.lynch25 : AppThemeData.lynch950,
                                                        ),
                                                        spaceW(width: 8),
                                                        TextCustom(
                                                          title: "${controller.ownerModel.value.countryCode} ${controller.ownerModel.value.phoneNumber}",
                                                          fontSize: 14,
                                                          fontFamily: FontFamily.regular,
                                                          color: themeChange.isDarkTheme() ? AppThemeData.lynch25 : AppThemeData.lynch950,
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                                const Spacer(),
                                                Column(
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  crossAxisAlignment: CrossAxisAlignment.end,
                                                  children: [
                                                    TextCustom(
                                                      title: 'Wallet Amount : ',
                                                      fontSize: 16,
                                                      fontFamily: FontFamily.regular,
                                                      color: themeChange.isDarkTheme() ? AppThemeData.lynch25 : AppThemeData.lynch950,
                                                    ),
                                                    spaceH(height: 2),
                                                    Obx(
                                                      () {
                                                        return TextCustom(
                                                          title: Constant.amountShow(amount: controller.ownerModel.value.walletAmount!),
                                                          fontSize: 18,
                                                          color: themeChange.isDarkTheme() ? AppThemeData.lynch25 : AppThemeData.lynch950,
                                                          fontFamily: FontFamily.bold,
                                                        );
                                                      },
                                                    ),
                                                    spaceH(height: 10),
                                                    Align(
                                                      alignment: Alignment.bottomRight,
                                                      child: CustomButtonWidget(
                                                        title: 'Top Up'.tr,
                                                        buttonColor: AppThemeData.primary500,
                                                        onPress: () {
                                                          showDialog(context: context, builder: (context) => const TopUpDialog());
                                                        },
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ],
                                            ),
                                            spaceH(height: 24),
                                            SingleChildScrollView(
                                              scrollDirection: Axis.horizontal,
                                              child: ClipRRect(
                                                borderRadius: BorderRadius.circular(12),
                                                child: Obx(() {
                                                  if (controller.isLoading.value) {
                                                    return Padding(
                                                      padding: paddingEdgeInsets(),
                                                      child: Constant.loader(),
                                                    );
                                                  } else if (controller.restaurantList.isEmpty) {
                                                    return const SizedBox.shrink(); // Hides everything if list is empty
                                                  } else {
                                                    return DataTable(
                                                      horizontalMargin: 20,
                                                      columnSpacing: 30,
                                                      dataRowMaxHeight: 65,
                                                      headingRowHeight: 65,
                                                      border: TableBorder.all(
                                                        color: themeChange.isDarkTheme()
                                                            ? AppThemeData.lynch800
                                                            : AppThemeData.lynch100,
                                                        borderRadius: BorderRadius.circular(12),
                                                      ),
                                                      headingRowColor: WidgetStateColor.resolveWith(
                                                            (states) => themeChange.isDarkTheme()
                                                            ? AppThemeData.lynch800
                                                            : AppThemeData.lynch100,
                                                      ),
                                                      columns: [
                                                        CommonUI.dataColumnWidget(context, columnTitle: "Name".tr, width: 150),
                                                        CommonUI.dataColumnWidget(context, columnTitle: "Owner Name".tr, width: MediaQuery.of(context).size.width * 0.15),
                                                        CommonUI.dataColumnWidget(context, columnTitle: "Created At".tr, width: MediaQuery.of(context).size.width * 0.15),
                                                        CommonUI.dataColumnWidget(context, columnTitle: "Cuisine".tr, width: MediaQuery.of(context).size.width * 0.12),
                                                        CommonUI.dataColumnWidget(context, columnTitle: "Status".tr, width: MediaQuery.of(context).size.width * 0.10),
                                                        CommonUI.dataColumnWidget(context, columnTitle: "Action".tr, width: MediaQuery.of(context).size.width * 0.10),
                                                      ],
                                                      rows: controller.restaurantList.map((restaurantModel) {
                                                        return DataRow(
                                                          cells: [
                                                            DataCell(Row(
                                                              children: [
                                                                NetworkImageWidget(
                                                                  imageUrl: restaurantModel.coverImage.toString(),
                                                                  height: 35,
                                                                  width: 35,
                                                                ),
                                                                spaceW(width: 8),
                                                                InkWell(
                                                                  onTap: () async {
                                                                    Get.toNamed("${Routes.RESTAURANT_DETAILS}/${restaurantModel.id}");
                                                                  },
                                                                  child: TextCustom(
                                                                    title: restaurantModel.vendorName.toString(),
                                                                    fontSize: 14,
                                                                    fontFamily: FontFamily.regular,
                                                                  ),
                                                                ),
                                                              ],
                                                            )),
                                                            DataCell(TextCustom(
                                                              title: restaurantModel.ownerFullName.toString(),
                                                              fontSize: 14,
                                                              fontFamily: FontFamily.regular,
                                                            )),
                                                            DataCell(TextCustom(
                                                              title: Constant.timestampToDate(restaurantModel.createdAt!),
                                                              fontSize: 14,
                                                              fontFamily: FontFamily.regular,
                                                            )),
                                                            DataCell(TextCustom(
                                                              title: restaurantModel.cuisineName.toString(),
                                                              fontSize: 14,
                                                              fontFamily: FontFamily.regular,
                                                            )),
                                                            DataCell(Transform.scale(
                                                              scale: 0.8,
                                                              child: CupertinoSwitch(
                                                                activeTrackColor: AppThemeData.primary500,
                                                                value: restaurantModel.active ?? false,
                                                                onChanged: (value) async {
                                                                  restaurantModel.active = value;
                                                                  await FireStoreUtils.updateNewRestaurant(restaurantModel);
                                                                  controller.getArgument();
                                                                },
                                                              ),
                                                            )),
                                                            DataCell(Container(
                                                              alignment: Alignment.center,
                                                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                                                              child: Row(
                                                                mainAxisAlignment: MainAxisAlignment.start,
                                                                children: [
                                                                  InkWell(
                                                                    onTap: () async {
                                                                      Get.toNamed("${Routes.RESTAURANT_DETAILS}/${restaurantModel.id}");
                                                                    },
                                                                    child: SvgPicture.asset(
                                                                      "assets/icons/ic_eye.svg",
                                                                      color: themeChange.isDarkTheme()
                                                                          ? AppThemeData.lynch400
                                                                          : AppThemeData.lynch500,
                                                                      height: 16,
                                                                      width: 16,
                                                                    ),
                                                                  ),
                                                                  spaceW(width: 20),
                                                                  InkWell(
                                                                    onTap: () {

                                                                      showDialog(
                                                                        context: context,
                                                                        builder: (context) => const AddRestaurant(),
                                                                      );
                                                                    },
                                                                    child: SvgPicture.asset(
                                                                      "assets/icons/ic_edit.svg",
                                                                      color: themeChange.isDarkTheme()
                                                                          ? AppThemeData.lynch400
                                                                          : AppThemeData.lynch500,
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
                                                                        RestaurantController restaurantController = Get.put(RestaurantController());
                                                                        bool confirmDelete = await DialogBox.showConfirmationDeleteDialog(context);
                                                                        if (confirmDelete) {
                                                                          await restaurantController.removeRestaurant(restaurantModel);
                                                                          controller.getArgument();
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
                                                            )),
                                                          ],
                                                        );
                                                      }).toList(),
                                                    );
                                                  }
                                                }),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ).expand(),
                            ],
                          ),
                        ),
                  desktop: controller.isLoading.value
                      ? Constant.loader()
                      : SingleChildScrollView(
                          child: Column(
                            children: [
                              ContainerCustom(
                                color: themeChange.isDarkTheme() ? AppThemeData.primaryBlack : AppThemeData.primaryWhite,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        NetworkImageWidget(
                                          imageUrl: controller.ownerModel.value.profileImage.toString(),
                                          fit: BoxFit.fill,
                                          height: ScreenSize.height(30, context),
                                          width: ScreenSize.width(20, context),
                                          borderRadius: 8,
                                        ),
                                        spaceW(width: 16),
                                        ContainerCustom(
                                          padding: EdgeInsets.zero,
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      TextCustom(
                                                        title: "Owner Details".tr,
                                                        fontSize: 16,
                                                        fontFamily: FontFamily.medium,
                                                        color: themeChange.isDarkTheme() ? AppThemeData.lynch25 : AppThemeData.lynch950,
                                                      ),
                                                      spaceH(height: 16),
                                                      Row(
                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                        children: [
                                                          SvgPicture.asset(
                                                            "assets/icons/ic_user.svg",
                                                            color: themeChange.isDarkTheme() ? AppThemeData.lynch25 : AppThemeData.lynch950,
                                                          ),
                                                          spaceW(width: 8),
                                                          TextCustom(
                                                            title: controller.ownerModel.value.fullNameString(),
                                                            fontSize: 14,
                                                            fontFamily: FontFamily.regular,
                                                            color: themeChange.isDarkTheme() ? AppThemeData.lynch25 : AppThemeData.lynch950,
                                                          ),
                                                        ],
                                                      ),
                                                      spaceH(height: 4),
                                                      if (controller.ownerModel.value.email != null && controller.ownerModel.value.email!.isNotEmpty)
                                                        Row(
                                                          mainAxisAlignment: MainAxisAlignment.start,
                                                          children: [
                                                            SvgPicture.asset(
                                                              "assets/icons/ic_mail.svg",
                                                              color: themeChange.isDarkTheme() ? AppThemeData.lynch25 : AppThemeData.lynch950,
                                                            ),
                                                            spaceW(width: 8),
                                                            TextCustom(
                                                              title: controller.ownerModel.value.email.toString(),
                                                              fontSize: 14,
                                                              fontFamily: FontFamily.regular,
                                                              color: themeChange.isDarkTheme() ? AppThemeData.lynch25 : AppThemeData.lynch950,
                                                            ),
                                                          ],
                                                        ),
                                                      spaceH(height: 4),
                                                      Row(
                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                        children: [
                                                          SvgPicture.asset(
                                                            "assets/icons/ic_call.svg",
                                                            color: themeChange.isDarkTheme() ? AppThemeData.lynch25 : AppThemeData.lynch950,
                                                          ),
                                                          spaceW(width: 8),
                                                          TextCustom(
                                                            title: "${controller.ownerModel.value.countryCode} ${controller.ownerModel.value.phoneNumber}",
                                                            fontSize: 14,
                                                            fontFamily: FontFamily.regular,
                                                            color: themeChange.isDarkTheme() ? AppThemeData.lynch25 : AppThemeData.lynch950,
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                  Row(
                                                    children: [
                                                      Column(
                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          TextCustom(
                                                            title: 'Wallet Amount : ',
                                                            fontSize: 16,
                                                            fontFamily: FontFamily.regular,
                                                            color: themeChange.isDarkTheme() ? AppThemeData.lynch25 : AppThemeData.lynch950,
                                                          ),
                                                          spaceH(height: 2),
                                                          Obx(
                                                            () {
                                                              return TextCustom(
                                                                title: Constant.amountShow(amount: controller.ownerModel.value.walletAmount!),
                                                                fontSize: 18,
                                                                color: themeChange.isDarkTheme() ? AppThemeData.lynch25 : AppThemeData.lynch950,
                                                                fontFamily: FontFamily.bold,
                                                              );
                                                            },
                                                          ),
                                                        ],
                                                      ),
                                                      spaceW(width: 16),
                                                      Align(
                                                        alignment: Alignment.bottomRight,
                                                        child: CustomButtonWidget(
                                                          title: 'Top Up'.tr,
                                                          buttonColor: AppThemeData.primary500,
                                                          onPress: () {
                                                            showDialog(context: context, builder: (context) => const TopUpDialog());
                                                          },
                                                        ),
                                                      )
                                                    ],
                                                  )
                                                ],
                                              ),
                                              spaceH(height: 24),
                                              SingleChildScrollView(
                                                scrollDirection: Axis.horizontal,
                                                child: ClipRRect(
                                                  borderRadius: BorderRadius.circular(12),
                                                  child: Obx(() {
                                                    if (controller.isLoading.value) {
                                                      return Padding(
                                                        padding: paddingEdgeInsets(),
                                                        child: Constant.loader(),
                                                      );
                                                    } else if (controller.restaurantList.isEmpty) {
                                                      return const SizedBox.shrink(); // Hides everything if list is empty
                                                    } else {
                                                      return DataTable(
                                                        horizontalMargin: 20,
                                                        columnSpacing: 30,
                                                        dataRowMaxHeight: 65,
                                                        headingRowHeight: 65,
                                                        border: TableBorder.all(
                                                          color: themeChange.isDarkTheme()
                                                              ? AppThemeData.lynch800
                                                              : AppThemeData.lynch100,
                                                          borderRadius: BorderRadius.circular(12),
                                                        ),
                                                        headingRowColor: WidgetStateColor.resolveWith(
                                                              (states) => themeChange.isDarkTheme()
                                                              ? AppThemeData.lynch800
                                                              : AppThemeData.lynch100,
                                                        ),
                                                        columns: [
                                                          CommonUI.dataColumnWidget(context, columnTitle: "Name".tr, width: 150),
                                                          CommonUI.dataColumnWidget(context, columnTitle: "Owner Name".tr, width: MediaQuery.of(context).size.width * 0.15),
                                                          CommonUI.dataColumnWidget(context, columnTitle: "Created At".tr, width: MediaQuery.of(context).size.width * 0.15),
                                                          CommonUI.dataColumnWidget(context, columnTitle: "Cuisine".tr, width: MediaQuery.of(context).size.width * 0.12),
                                                          CommonUI.dataColumnWidget(context, columnTitle: "Status".tr, width: MediaQuery.of(context).size.width * 0.10),
                                                          CommonUI.dataColumnWidget(context, columnTitle: "Action".tr, width: MediaQuery.of(context).size.width * 0.10),
                                                        ],
                                                        rows: controller.restaurantList.map((restaurantModel) {
                                                          return DataRow(
                                                            cells: [
                                                              DataCell(Row(
                                                                children: [
                                                                  NetworkImageWidget(
                                                                    imageUrl: restaurantModel.coverImage.toString(),
                                                                    height: 35,
                                                                    width: 35,
                                                                  ),
                                                                  spaceW(width: 8),
                                                                  InkWell(
                                                                    onTap: () async {
                                                                      Get.toNamed("${Routes.RESTAURANT_DETAILS}/${restaurantModel.id}");
                                                                    },
                                                                    child: TextCustom(
                                                                      title: restaurantModel.vendorName.toString(),
                                                                      fontSize: 14,
                                                                      fontFamily: FontFamily.regular,
                                                                    ),
                                                                  ),
                                                                ],
                                                              )),
                                                              DataCell(TextCustom(
                                                                title: restaurantModel.ownerFullName.toString(),
                                                                fontSize: 14,
                                                                fontFamily: FontFamily.regular,
                                                              )),
                                                              DataCell(TextCustom(
                                                                title: Constant.timestampToDate(restaurantModel.createdAt!),
                                                                fontSize: 14,
                                                                fontFamily: FontFamily.regular,
                                                              )),
                                                              DataCell(TextCustom(
                                                                title: restaurantModel.cuisineName.toString(),
                                                                fontSize: 14,
                                                                fontFamily: FontFamily.regular,
                                                              )),
                                                              DataCell(Transform.scale(
                                                                scale: 0.8,
                                                                child: CupertinoSwitch(
                                                                  activeTrackColor: AppThemeData.primary500,
                                                                  value: restaurantModel.active ?? false,
                                                                  onChanged: (value) async {
                                                                    restaurantModel.active = value;
                                                                    await FireStoreUtils.updateNewRestaurant(restaurantModel);
                                                                    controller.getArgument();
                                                                  },
                                                                ),
                                                              )),
                                                              DataCell(Container(
                                                                alignment: Alignment.center,
                                                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                                                                child: Row(
                                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                                  children: [
                                                                    InkWell(
                                                                      onTap: () async {
                                                                        Get.toNamed("${Routes.RESTAURANT_DETAILS}/${restaurantModel.id}");
                                                                      },
                                                                      child: SvgPicture.asset(
                                                                        "assets/icons/ic_eye.svg",
                                                                        color: themeChange.isDarkTheme()
                                                                            ? AppThemeData.lynch400
                                                                            : AppThemeData.lynch500,
                                                                        height: 16,
                                                                        width: 16,
                                                                      ),
                                                                    ),
                                                                    spaceW(width: 20),
                                                                    InkWell(
                                                                      onTap: () {

                                                                        showDialog(
                                                                          context: context,
                                                                          builder: (context) => const AddRestaurant(),
                                                                        );
                                                                      },
                                                                      child: SvgPicture.asset(
                                                                        "assets/icons/ic_edit.svg",
                                                                        color: themeChange.isDarkTheme()
                                                                            ? AppThemeData.lynch400
                                                                            : AppThemeData.lynch500,
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
                                                                          RestaurantController restaurantController = Get.put(RestaurantController());
                                                                          bool confirmDelete = await DialogBox.showConfirmationDeleteDialog(context);
                                                                          if (confirmDelete) {
                                                                            await restaurantController.removeRestaurant(restaurantModel);
                                                                            controller.getArgument();
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
                                                              )),
                                                            ],
                                                          );
                                                        }).toList(),
                                                      );
                                                    }
                                                  }),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ).expand(),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        )));
        });
  }

  Padding detailsWidget(String title, String data, themeChange) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TextCustom(
            title: title.tr,
            fontSize: 14,
            fontFamily: FontFamily.regular,
            color: themeChange.isDarkTheme() ? AppThemeData.lynch400 : AppThemeData.lynch500,
          ),
          TextCustom(
            title: data.tr,
            fontSize: 14,
            fontFamily: FontFamily.medium,
            color: themeChange.isDarkTheme() ? AppThemeData.lynch25 : AppThemeData.lynch950,
          ),
        ],
      ),
    );
  }
}

class TopUpDialog extends StatelessWidget {
  const TopUpDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetBuilder(
      init: OwnerDetailController(),
      builder: (controller) {
        return Dialog(
          backgroundColor: themeChange.isDarkTheme() ? AppThemeData.lynch950 : AppThemeData.lynch50,
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8.0))),
          alignment: Alignment.topCenter,
          child: SizedBox(
            width: 600,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.only(topLeft: Radius.circular(8.0), topRight: Radius.circular(8.0)),
                        color: themeChange.isDarkTheme() ? AppThemeData.lynch900 : AppThemeData.lynch100,
                      ),
                      child: const TextCustom(title: "Top Up", fontSize: 18),
                    ).expand(),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
                  child: Column(
                    children: [
                      CustomTextFormField(
                        hintText: 'Enter Top up Amount',
                        title: 'Top up Amount',
                        controller: controller.topUpAmountController.value,
                        textInputType: TextInputType.number,
                        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      ),
                      spaceH(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          CustomButtonWidget(
                            title: "Close".tr,
                            buttonColor: themeChange.isDarkTheme() ? AppThemeData.lynch700 : AppThemeData.lynch400,
                            onPress: () {
                              controller.topUpAmountController.value.clear();
                              Navigator.pop(context);
                            },
                          ),
                          spaceW(),
                          CustomButtonWidget(
                            title: "Top Up".tr,
                            onPress: () {
                              if (Constant.isDemo) {
                                DialogBox.demoDialogBox();
                              } else {
                                controller.completeTopUp(DateTime.now().millisecondsSinceEpoch.toString());
                              }
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
