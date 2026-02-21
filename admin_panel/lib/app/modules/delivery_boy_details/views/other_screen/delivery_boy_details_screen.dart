// ignore_for_file: deprecated_member_use

import 'package:admin_panel/app/components/custom_text_form_field.dart';
import 'package:admin_panel/app/components/network_image_widget.dart';
import 'package:admin_panel/app/modules/delivery_boy_details/controllers/delivery_boy_details_controller.dart';
import 'package:admin_panel/app/utils/app_them_data.dart';
import 'package:admin_panel/app/utils/dark_theme_provider.dart';
import 'package:admin_panel/app/utils/responsive.dart';
import 'package:admin_panel/app/utils/screen_size.dart';
import 'package:admin_panel/widget/global_widgets.dart';
import 'package:admin_panel/widget/text_widget.dart';
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
import '../../../../utils/app_colors.dart';

class DeliveryBoyDetailsScreen extends StatelessWidget {
  const DeliveryBoyDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetX(
        init: DeliveryBoyDetailsController(),
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
                                            imageUrl: controller.driverModel.value.profileImage.toString(),
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
                                                    title: controller.driverModel.value.fullNameString(),
                                                    fontSize: 14,
                                                    fontFamily: FontFamily.regular,
                                                    color: themeChange.isDarkTheme() ? AppThemeData.lynch25 : AppThemeData.lynch950,
                                                  ),
                                                ],
                                              ),
                                              spaceH(height: 4),
                                              if (controller.driverModel.value.email != null && controller.driverModel.value.email!.isNotEmpty)
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  children: [
                                                    SvgPicture.asset(
                                                      "assets/icons/ic_mail.svg",
                                                      color: themeChange.isDarkTheme() ? AppThemeData.lynch25 : AppThemeData.lynch950,
                                                    ),
                                                    spaceW(width: 8),
                                                    TextCustom(
                                                      title: controller.driverModel.value.email.toString(),
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
                                                    title: "${controller.driverModel.value.countryCode} ${controller.driverModel.value.phoneNumber}",
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
                                                            title: Constant.amountShow(amount: controller.driverModel.value.walletAmount!),
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
                                      TextCustom(
                                        title: "Vehicle Details".tr,
                                        fontSize: 16,
                                        fontFamily: FontFamily.medium,
                                        color: themeChange.isDarkTheme() ? AppThemeData.lynch25 : AppThemeData.lynch950,
                                      ),
                                      spaceH(height: 12),
                                      Container(
                                        decoration:
                                            BoxDecoration(border: Border.all(color: themeChange.isDarkTheme() ? AppThemeData.lynch800 : AppThemeData.lynch100), borderRadius: BorderRadius.circular(8)),
                                        child: Column(
                                          children: [
                                            spaceH(height: 4),
                                            detailsWidget("Type".tr, "${controller.driverModel.value.driverVehicleDetails!.vehicleTypeName}", themeChange),
                                            Divider(
                                              color: themeChange.isDarkTheme() ? AppThemeData.lynch800 : AppThemeData.lynch100,
                                            ),
                                            detailsWidget("Model".tr, controller.driverModel.value.driverVehicleDetails!.modelName.toString(), themeChange),
                                            Divider(
                                              color: themeChange.isDarkTheme() ? AppThemeData.lynch800 : AppThemeData.lynch100,
                                            ),
                                            detailsWidget("Number".tr, controller.driverModel.value.driverVehicleDetails!.vehicleNumber.toString(), themeChange),
                                            spaceH(height: 4),
                                          ],
                                        ),
                                      ),
                                      spaceH(height: 24),
                                      controller.bankDetailsList.isEmpty
                                          ? const SizedBox()
                                          : Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          TextCustom(
                                            title: "Bank Details".tr,
                                            fontSize: 16,
                                            fontFamily: FontFamily.medium,
                                            color: themeChange.isDarkTheme() ? AppThemeData.lynch25 : AppThemeData.lynch950,
                                          ),
                                          spaceH(height: 12),
                                          Obx(
                                                () => SingleChildScrollView(
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
                                                      CommonUI.dataColumnWidget(context, columnTitle: "Id".tr, width: MediaQuery.of(context).size.width * 0.05),
                                                      CommonUI.dataColumnWidget(context, columnTitle: "holderName".tr, width: MediaQuery.of(context).size.width * 0.10),
                                                      CommonUI.dataColumnWidget(context, columnTitle: "bankName".tr, width: MediaQuery.of(context).size.width * 0.14),
                                                      CommonUI.dataColumnWidget(context, columnTitle: "accountNumber".tr, width: MediaQuery.of(context).size.width * 0.10),
                                                      CommonUI.dataColumnWidget(context, columnTitle: "ifscCode".tr, width: MediaQuery.of(context).size.width * 0.10),
                                                      CommonUI.dataColumnWidget(context, columnTitle: "swiftCode".tr, width: MediaQuery.of(context).size.width * 0.05),
                                                      CommonUI.dataColumnWidget(context, columnTitle: "branchCity".tr, width: MediaQuery.of(context).size.width * 0.08),
                                                      CommonUI.dataColumnWidget(context, columnTitle: "branchCountry".tr, width: MediaQuery.of(context).size.width * 0.08),
                                                    ],
                                                    rows: controller.bankDetailsList
                                                        .map(
                                                          (transaction) => DataRow(
                                                        cells: [
                                                          DataCell(TextCustom(title: "${controller.bankDetailsList.indexWhere((element) => element == transaction) + 1}")),
                                                          DataCell(TextCustom(
                                                            title: transaction.holderName.toString(),
                                                          )),
                                                          DataCell(TextCustom(
                                                            title: transaction.bankName.toString(),
                                                          )),
                                                          DataCell(TextCustom(
                                                            title: transaction.accountNumber.toString(),
                                                          )),
                                                          DataCell(TextCustom(
                                                            title: transaction.ifscCode.toString(),
                                                          )),
                                                          DataCell(TextCustom(
                                                            title: transaction.swiftCode.toString(),
                                                          )),
                                                          DataCell(TextCustom(
                                                            title: transaction.branchCity.toString(),
                                                          )),
                                                          DataCell(TextCustom(
                                                            title: transaction.branchCountry.toString(),
                                                          )),
                                                        ],
                                                      ),
                                                    )
                                                        .toList(),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      )
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
                                      imageUrl: controller.driverModel.value.profileImage.toString(),
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
                                                          title: controller.driverModel.value.fullNameString(),
                                                          fontSize: 14,
                                                          fontFamily: FontFamily.regular,
                                                          color: themeChange.isDarkTheme() ? AppThemeData.lynch25 : AppThemeData.lynch950,
                                                        ),
                                                      ],
                                                    ),
                                                    spaceH(height: 4),
                                                    if (controller.driverModel.value.email != null && controller.driverModel.value.email!.isNotEmpty)
                                                      Row(
                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                        children: [
                                                          SvgPicture.asset(
                                                            "assets/icons/ic_mail.svg",
                                                            color: themeChange.isDarkTheme() ? AppThemeData.lynch25 : AppThemeData.lynch950,
                                                          ),
                                                          spaceW(width: 8),
                                                          TextCustom(
                                                            title: controller.driverModel.value.email.toString(),
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
                                                          title: "${controller.driverModel.value.countryCode} ${controller.driverModel.value.phoneNumber}",
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
                                                          title: Constant.amountShow(amount: controller.driverModel.value.walletAmount!),
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
                                            TextCustom(
                                              title: "Vehicle Details".tr,
                                              fontSize: 16,
                                              fontFamily: FontFamily.medium,
                                              color: themeChange.isDarkTheme() ? AppThemeData.lynch25 : AppThemeData.lynch950,
                                            ),
                                            spaceH(height: 12),
                                            Container(
                                              decoration: BoxDecoration(
                                                  border: Border.all(color: themeChange.isDarkTheme() ? AppThemeData.lynch800 : AppThemeData.lynch100), borderRadius: BorderRadius.circular(8)),
                                              child: Column(
                                                children: [
                                                  detailsWidget("Type".tr, controller.driverModel.value.driverVehicleDetails!.vehicleTypeName.toString(), themeChange),
                                                  Divider(
                                                    color: themeChange.isDarkTheme() ? AppThemeData.lynch800 : AppThemeData.lynch100,
                                                  ),
                                                  detailsWidget("Model".tr, controller.driverModel.value.driverVehicleDetails!.modelName.toString(), themeChange),
                                                  Divider(
                                                    color: themeChange.isDarkTheme() ? AppThemeData.lynch800 : AppThemeData.lynch100,
                                                  ),
                                                  detailsWidget("Number".tr, controller.driverModel.value.driverVehicleDetails!.vehicleNumber.toString(), themeChange)
                                                ],
                                              ),
                                            ),
                                            spaceH(height: 24),
                                            controller.bankDetailsList.isEmpty
                                                ? const SizedBox()
                                                : Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                TextCustom(
                                                  title: "Bank Details".tr,
                                                  fontSize: 16,
                                                  fontFamily: FontFamily.medium,
                                                  color: themeChange.isDarkTheme() ? AppThemeData.lynch25 : AppThemeData.lynch950,
                                                ),
                                                spaceH(height: 12),
                                                Obx(
                                                      () => SingleChildScrollView(
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
                                                            CommonUI.dataColumnWidget(context, columnTitle: "Id".tr, width: MediaQuery.of(context).size.width * 0.05),
                                                            CommonUI.dataColumnWidget(context, columnTitle: "holderName".tr, width: MediaQuery.of(context).size.width * 0.10),
                                                            CommonUI.dataColumnWidget(context, columnTitle: "bankName".tr, width: MediaQuery.of(context).size.width * 0.14),
                                                            CommonUI.dataColumnWidget(context, columnTitle: "accountNumber".tr, width: MediaQuery.of(context).size.width * 0.10),
                                                            CommonUI.dataColumnWidget(context, columnTitle: "ifscCode".tr, width: MediaQuery.of(context).size.width * 0.10),
                                                            CommonUI.dataColumnWidget(context, columnTitle: "swiftCode".tr, width: MediaQuery.of(context).size.width * 0.05),
                                                            CommonUI.dataColumnWidget(context, columnTitle: "branchCity".tr, width: MediaQuery.of(context).size.width * 0.08),
                                                            CommonUI.dataColumnWidget(context, columnTitle: "branchCountry".tr, width: MediaQuery.of(context).size.width * 0.08),
                                                          ],
                                                          rows: controller.bankDetailsList
                                                              .map(
                                                                (transaction) => DataRow(
                                                              cells: [
                                                                DataCell(TextCustom(title: "${controller.bankDetailsList.indexWhere((element) => element == transaction) + 1}")),
                                                                DataCell(TextCustom(
                                                                  title: transaction.holderName.toString(),
                                                                )),
                                                                DataCell(TextCustom(
                                                                  title: transaction.bankName.toString(),
                                                                )),
                                                                DataCell(TextCustom(
                                                                  title: transaction.accountNumber.toString(),
                                                                )),
                                                                DataCell(TextCustom(
                                                                  title: transaction.ifscCode.toString(),
                                                                )),
                                                                DataCell(TextCustom(
                                                                  title: transaction.swiftCode.toString(),
                                                                )),
                                                                DataCell(TextCustom(
                                                                  title: transaction.branchCity.toString(),
                                                                )),
                                                                DataCell(TextCustom(
                                                                  title: transaction.branchCountry.toString(),
                                                                )),
                                                              ],
                                                            ),
                                                          )
                                                              .toList(),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            )
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
                                          imageUrl: controller.driverModel.value.profileImage.toString(),
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
                                                        title: "Driver Details".tr,
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
                                                            title: controller.driverModel.value.fullNameString(),
                                                            fontSize: 14,
                                                            fontFamily: FontFamily.regular,
                                                            color: themeChange.isDarkTheme() ? AppThemeData.lynch25 : AppThemeData.lynch950,
                                                          ),
                                                        ],
                                                      ),
                                                      spaceH(height: 4),
                                                      if (controller.driverModel.value.email != null && controller.driverModel.value.email!.isNotEmpty)
                                                        Row(
                                                          mainAxisAlignment: MainAxisAlignment.start,
                                                          children: [
                                                            SvgPicture.asset(
                                                              "assets/icons/ic_mail.svg",
                                                              color: themeChange.isDarkTheme() ? AppThemeData.lynch25 : AppThemeData.lynch950,
                                                            ),
                                                            spaceW(width: 8),
                                                            TextCustom(
                                                              title: controller.driverModel.value.email.toString(),
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
                                                            title: "${controller.driverModel.value.countryCode} ${controller.driverModel.value.phoneNumber}",
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
                                                                title: Constant.amountShow(amount: controller.driverModel.value.walletAmount!),
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
                                              TextCustom(
                                                title: "Vehicle Details".tr,
                                                fontSize: 16,
                                                fontFamily: FontFamily.medium,
                                                color: themeChange.isDarkTheme() ? AppThemeData.lynch25 : AppThemeData.lynch950,
                                              ),
                                              spaceH(height: 12),
                                              Container(
                                                decoration: BoxDecoration(
                                                    border: Border.all(color: themeChange.isDarkTheme() ? AppThemeData.lynch800 : AppThemeData.lynch100), borderRadius: BorderRadius.circular(8)),
                                                child: Column(
                                                  children: [
                                                    detailsWidget("Type".tr, controller.driverModel.value.driverVehicleDetails!.vehicleTypeName.toString(), themeChange),
                                                    Divider(
                                                      color: themeChange.isDarkTheme() ? AppThemeData.lynch800 : AppThemeData.lynch100,
                                                    ),
                                                    detailsWidget("Model".tr, controller.driverModel.value.driverVehicleDetails!.modelName.toString(), themeChange),
                                                    Divider(
                                                      color: themeChange.isDarkTheme() ? AppThemeData.lynch800 : AppThemeData.lynch100,
                                                    ),
                                                    detailsWidget("Number".tr, controller.driverModel.value.driverVehicleDetails!.vehicleNumber.toString(), themeChange)
                                                  ],
                                                ),
                                              ),
                                              spaceH(height: 24),
                                              controller.bankDetailsList.isEmpty
                                                  ? const SizedBox()
                                                  : Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        TextCustom(
                                                          title: "Bank Details".tr,
                                                          fontSize: 16,
                                                          fontFamily: FontFamily.medium,
                                                          color: themeChange.isDarkTheme() ? AppThemeData.lynch25 : AppThemeData.lynch950,
                                                        ),
                                                        spaceH(height: 12),
                                                        Obx(
                                                          () => SingleChildScrollView(
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
                                                                    CommonUI.dataColumnWidget(context, columnTitle: "Id".tr, width: MediaQuery.of(context).size.width * 0.05),
                                                                    CommonUI.dataColumnWidget(context, columnTitle: "holderName".tr, width: MediaQuery.of(context).size.width * 0.10),
                                                                    CommonUI.dataColumnWidget(context, columnTitle: "bankName".tr, width: MediaQuery.of(context).size.width * 0.14),
                                                                    CommonUI.dataColumnWidget(context, columnTitle: "accountNumber".tr, width: MediaQuery.of(context).size.width * 0.10),
                                                                    CommonUI.dataColumnWidget(context, columnTitle: "ifscCode".tr, width: MediaQuery.of(context).size.width * 0.10),
                                                                    CommonUI.dataColumnWidget(context, columnTitle: "swiftCode".tr, width: MediaQuery.of(context).size.width * 0.05),
                                                                    CommonUI.dataColumnWidget(context, columnTitle: "branchCity".tr, width: MediaQuery.of(context).size.width * 0.08),
                                                                    CommonUI.dataColumnWidget(context, columnTitle: "branchCountry".tr, width: MediaQuery.of(context).size.width * 0.08),
                                                                  ],
                                                                  rows: controller.bankDetailsList
                                                                      .map(
                                                                        (transaction) => DataRow(
                                                                          cells: [
                                                                            DataCell(TextCustom(title: "${controller.bankDetailsList.indexWhere((element) => element == transaction) + 1}")),
                                                                            DataCell(TextCustom(
                                                                              title: transaction.holderName.toString(),
                                                                            )),
                                                                            DataCell(TextCustom(
                                                                              title: transaction.bankName.toString(),
                                                                            )),
                                                                            DataCell(TextCustom(
                                                                              title: transaction.accountNumber.toString(),
                                                                            )),
                                                                            DataCell(TextCustom(
                                                                              title: transaction.ifscCode.toString(),
                                                                            )),
                                                                            DataCell(TextCustom(
                                                                              title: transaction.swiftCode.toString(),
                                                                            )),
                                                                            DataCell(TextCustom(
                                                                              title: transaction.branchCity.toString(),
                                                                            )),
                                                                            DataCell(TextCustom(
                                                                              title: transaction.branchCountry.toString(),
                                                                            )),
                                                                          ],
                                                                        ),
                                                                      )
                                                                      .toList(),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    )
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
                        )
                  // desktop: ContainerCustom(
                  //   color: themeChange.isDarkTheme() ? AppThemeData.primaryBlack : AppThemeData.primaryWhite,
                  //   child: Row(
                  //     mainAxisAlignment: MainAxisAlignment.start,
                  //     crossAxisAlignment: CrossAxisAlignment.start,
                  //     children: [
                  //       NetworkImageWidget(
                  //         imageUrl: controller.driverModel.value.profileImage.toString(),
                  //         height: ScreenSize.height(30, context),
                  //         width: ScreenSize.width(20, context),
                  //         borderRadius: 0,
                  //         fit: BoxFit.cover,
                  //       ),
                  //       spaceW(width: 24),
                  //       Column(
                  //         mainAxisSize: MainAxisSize.min,
                  //         crossAxisAlignment: CrossAxisAlignment.start,
                  //         mainAxisAlignment: MainAxisAlignment.start,
                  //         children: [
                  //           TextCustom(
                  //             title: "Driver Details".tr,
                  //             fontSize: 16,
                  //             fontFamily: FontFamily.medium,
                  //             color: themeChange.isDarkTheme() ? AppThemeData.lynch25 : AppThemeData.lynch950,
                  //           ),
                  //           spaceH(height: 12),
                  //           Row(
                  //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //             children: [
                  //               Column(
                  //                 mainAxisSize: MainAxisSize.min,
                  //                 crossAxisAlignment: CrossAxisAlignment.start,
                  //                 children: [
                  //                   Row(
                  //                     mainAxisAlignment: MainAxisAlignment.start,
                  //                     children: [
                  //                       SvgPicture.asset(
                  //                         "assets/icons/ic_user.svg",
                  //                         color: themeChange.isDarkTheme() ? AppThemeData.lynch25 : AppThemeData.lynch950,
                  //                       ),
                  //                       spaceW(width: 8),
                  //                       TextCustom(
                  //                         title: controller.driverModel.value.fullNameString(),
                  //                         fontSize: 14,
                  //                         fontFamily: FontFamily.regular,
                  //                         color: themeChange.isDarkTheme() ? AppThemeData.lynch25 : AppThemeData.lynch950,
                  //                       ),
                  //                     ],
                  //                   ),
                  //                   spaceH(height: 4),
                  //                   if (controller.driverModel.value.email != null && controller.driverModel.value.email!.isNotEmpty)
                  //                     Row(
                  //                       mainAxisAlignment: MainAxisAlignment.start,
                  //                       children: [
                  //                         SvgPicture.asset(
                  //                           "assets/icons/ic_mail.svg",
                  //                           color: themeChange.isDarkTheme() ? AppThemeData.lynch25 : AppThemeData.lynch950,
                  //                         ),
                  //                         spaceW(width: 8),
                  //                         TextCustom(
                  //                           title: controller.driverModel.value.email.toString(),
                  //                           fontSize: 14,
                  //                           fontFamily: FontFamily.regular,
                  //                           color: themeChange.isDarkTheme() ? AppThemeData.lynch25 : AppThemeData.lynch950,
                  //                         ),
                  //                       ],
                  //                     ),
                  //                   spaceH(height: 4),
                  //                   Row(
                  //                     mainAxisAlignment: MainAxisAlignment.start,
                  //                     children: [
                  //                       SvgPicture.asset(
                  //                         "assets/icons/ic_call.svg",
                  //                         color: themeChange.isDarkTheme() ? AppThemeData.lynch25 : AppThemeData.lynch950,
                  //                       ),
                  //                       spaceW(width: 8),
                  //                       TextCustom(
                  //                         title: "${controller.driverModel.value.countryCode} ${controller.driverModel.value.phoneNumber}",
                  //                         fontSize: 14,
                  //                         fontFamily: FontFamily.regular,
                  //                         color: themeChange.isDarkTheme() ? AppThemeData.lynch25 : AppThemeData.lynch950,
                  //                       ),
                  //                     ],
                  //                   ),
                  //                 ],
                  //               ),
                  //             ],
                  //           ),
                  //           spaceH(height: 24),
                  //           TextCustom(
                  //             title: "Vehicle Details".tr,
                  //             fontSize: 16,
                  //             fontFamily: FontFamily.medium,
                  //             color: themeChange.isDarkTheme() ? AppThemeData.lynch25 : AppThemeData.lynch950,
                  //           ),
                  //           spaceH(height: 12),
                  //           Container(
                  //             decoration: BoxDecoration(
                  //                 border: Border.all(color: themeChange.isDarkTheme() ? AppThemeData.lynch800 : AppThemeData.lynch100), borderRadius: BorderRadius.circular(8)),
                  //             child: Column(
                  //               children: [
                  //                 detailsWidget("Type".tr, controller.driverModel.value.driverVehicleDetails!.vehicleTypeName.toString(), themeChange),
                  //                 Divider(
                  //                   color: themeChange.isDarkTheme() ? AppThemeData.lynch800 : AppThemeData.lynch100,
                  //                 ),
                  //                 detailsWidget("Model".tr, controller.driverModel.value.driverVehicleDetails!.modelName.toString(), themeChange),
                  //                 Divider(
                  //                   color: themeChange.isDarkTheme() ? AppThemeData.lynch800 : AppThemeData.lynch100,
                  //                 ),
                  //                 detailsWidget("Number".tr, controller.driverModel.value.driverVehicleDetails!.vehicleNumber.toString(), themeChange)
                  //               ],
                  //             ),
                  //           ),
                  //           spaceH(height: 24),
                  //           // TextCustom(
                  //           //   title: "Bank Details".tr,
                  //           //   fontSize: 16,
                  //           //   fontFamily: FontFamily.medium,
                  //           //   color: themeChange.isDarkTheme() ? AppThemeData.lynch25 : AppThemeData.lynch950,
                  //           // ),
                  //           // spaceH(height: 12),
                  //         ],
                  //       ),
                  //     ],
                  //   ),
                  // ),
                  ));
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
      init: DeliveryBoyDetailsController(),
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
