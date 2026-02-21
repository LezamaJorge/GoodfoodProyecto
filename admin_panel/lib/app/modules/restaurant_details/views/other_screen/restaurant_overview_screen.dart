// ignore_for_file: deprecated_member_use

import 'package:admin_panel/app/components/dialog_box.dart';
import 'package:admin_panel/app/constant/constants.dart';
import 'package:admin_panel/app/models/owner_model.dart';
import 'package:admin_panel/app/modules/restaurant_details/controllers/restaurant_details_controller.dart';
import 'package:admin_panel/app/utils/app_colors.dart';
import 'package:admin_panel/app/utils/app_them_data.dart';
import 'package:admin_panel/app/utils/dark_theme_provider.dart';
import 'package:admin_panel/app/utils/fire_store_utils.dart';
import 'package:admin_panel/app/utils/responsive.dart';
import 'package:admin_panel/app/utils/screen_size.dart';
import 'package:admin_panel/widget/container_custom.dart';
import 'package:admin_panel/widget/global_widgets.dart';
import 'package:admin_panel/widget/text_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';

import '../../../../components/custom_button.dart';
import '../../../../components/custom_text_form_field.dart';

class RestaurantOverviewScreen extends GetView {
  const RestaurantOverviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetX<RestaurantDetailsController>(
        init: RestaurantDetailsController(),
        builder: (controller) {
          return ResponsiveWidget(
              mobile: controller.isLoading.value
                  ? Constant.loader()
                  : SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            children: [
                              Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 0),
                                    child: Wrap(
                                      children: [
                                        commonView(
                                          context: context,
                                          title: "Total Earnings".tr,
                                          value: controller.totalRestaurantEarnings.value.toStringAsFixed(2),
                                          imageAssets: "assets/icons/ic_doller.svg",
                                          bgColor: const Color(0xffE7FCFD),
                                          textColor: const Color(0xff0CB9C1),
                                        ),
                                        commonView(
                                            context: context,
                                            title: "Total Orders".tr,
                                            value: Constant.restaurantOrderLength.toString(),
                                            imageAssets: "assets/icons/ic_totla.svg",
                                            bgColor: const Color(0xffF2ECF9),
                                            textColor: const Color(0xff7338B3)),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 0),
                                    child: Wrap(
                                      children: [
                                        commonView(
                                          context: context,
                                          title: "Total Items".tr,
                                          value: Constant.restaurantProductLength.toString(),
                                          imageAssets: "assets/icons/ic_total.svg",
                                          bgColor: const Color(0xffFEF4E6),
                                          textColor: const Color(0xffF99007),
                                        ),
                                        commonView(
                                          context: context,
                                          title: "Total Reviews".tr,
                                          value: Constant.restaurantReviewLength.toString(),
                                          imageAssets: "assets/icons/ic_star.svg",
                                          bgColor: const Color(0xffFEEAE6),
                                          textColor: const Color(0xffF85A40),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              spaceH(height: 24),
                              Container(
                                decoration: BoxDecoration(color: themeChange.isDarkTheme() ? AppThemeData.primaryBlack : AppThemeData.primaryWhite, borderRadius: BorderRadius.circular(8)),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    spaceH(height: 20),
                                    // Padding(
                                    //   padding: const EdgeInsets.only(right: 16),
                                    //   child: Row(
                                    //     mainAxisAlignment: MainAxisAlignment.end,
                                    //     children: [
                                    //       Column(
                                    //         crossAxisAlignment: CrossAxisAlignment.start,
                                    //         children: [
                                    //           TextCustom(
                                    //             title: 'Wallet Amount : '.tr,
                                    //             fontSize: 16,
                                    //             fontFamily: FontFamily.regular,
                                    //             color: themeChange.isDarkTheme() ? AppThemeData.lynch25 : AppThemeData.lynch950,
                                    //           ),
                                    //           spaceH(height: 2),
                                    //           Obx(
                                    //             () {
                                    //               return TextCustom(
                                    //                 title: Constant.amountShow(amount: controller.ownerModel.value.walletAmount ?? "0.0"),
                                    //                 fontSize: 18,
                                    //                 color: themeChange.isDarkTheme() ? AppThemeData.lynch25 : AppThemeData.lynch950,
                                    //                 fontFamily: FontFamily.bold,
                                    //               );
                                    //             },
                                    //           ),
                                    //         ],
                                    //       ),
                                    //       spaceW(width: 16),
                                    //       CustomButtonWidget(
                                    //         title: 'Top Up'.tr,
                                    //         buttonColor: AppThemeData.primary500,
                                    //         onPress: () {
                                    //           showDialog(context: context, builder: (context) => const TopUpDialog());
                                    //         },
                                    //       ),
                                    //     ],
                                    //   ),
                                    // ),
                                    spaceH(height: 16),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 16, left: 16, right: 16),
                                      child: ClipRRect(
                                        borderRadius: const BorderRadius.all(Radius.circular(8)),
                                        child: CachedNetworkImage(
                                          fit: BoxFit.fill,
                                          height: ScreenSize.height(34, context),
                                          width: double.infinity,
                                          imageUrl: controller.restaurantModel.value.coverImage.toString(),
                                          progressIndicatorBuilder: (context, url, downloadProgress) => const Center(
                                            child: CircularProgressIndicator(color: Colors.black),
                                          ),
                                          errorWidget: (context, url, error) => Image.asset(
                                            Constant.userPlaceHolder,
                                            height: ScreenSize.height(10, context),
                                            width: ScreenSize.width(80, context),
                                          ),
                                        ),
                                      ),
                                    ),
                                    spaceW(width: 24),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Column(
                                                mainAxisSize: MainAxisSize.min,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  TextCustom(title: controller.restaurantModel.value.vendorName.toString(), fontSize: 18, fontFamily: FontFamily.bold),
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      SvgPicture.asset(
                                                        "assets/icons/ic_location.svg",
                                                        height: 16,
                                                        width: 16,
                                                        color: themeChange.isDarkTheme() ? AppThemeData.lynch400 : AppThemeData.lynch500,
                                                      ),
                                                      spaceW(),
                                                      SizedBox(
                                                        width: MediaQuery.sizeOf(context).width * 0.7,
                                                        child: TextCustom(
                                                          title: controller.restaurantModel.value.address!.address.toString(),
                                                          fontSize: 14,
                                                          fontFamily: FontFamily.regular,
                                                          maxLine: 3,
                                                          color: themeChange.isDarkTheme() ? AppThemeData.lynch400 : AppThemeData.lynch500,
                                                        ),
                                                      ),
                                                    ],
                                                  )
                                                ],
                                              )
                                            ],
                                          ),
                                          spaceH(height: 24),
                                          Row(
                                            children: [
                                              Column(
                                                mainAxisSize: MainAxisSize.min,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  TextCustom(
                                                    title: "Restaurant Type".tr,
                                                    fontSize: 14,
                                                    fontFamily: FontFamily.regular,
                                                    color: themeChange.isDarkTheme() ? AppThemeData.lynch25 : AppThemeData.lynch950,
                                                  ),
                                                  Row(
                                                    children: [
                                                      controller.restaurantModel.value.vendorType == "Veg"
                                                          ? SvgPicture.asset("assets/icons/ic_food_type.svg")
                                                          : controller.restaurantModel.value.vendorType == "Non veg"
                                                              ? SvgPicture.asset(
                                                                  "assets/icons/ic_food_type.svg",
                                                                  color: AppThemeData.red500,
                                                                )
                                                              : Row(
                                                                  mainAxisSize: MainAxisSize.min,
                                                                  children: [
                                                                    SvgPicture.asset(
                                                                      "assets/icons/ic_food_type.svg",
                                                                      color: AppThemeData.red500,
                                                                    ),
                                                                    spaceW(width: 4),
                                                                    SvgPicture.asset("assets/icons/ic_food_type.svg")
                                                                  ],
                                                                ),
                                                      spaceW(),
                                                      TextCustom(
                                                        title: controller.restaurantModel.value.vendorType.toString(),
                                                        fontSize: 14,
                                                        fontFamily: FontFamily.medium,
                                                        color: themeChange.isDarkTheme() ? AppThemeData.lynch25 : AppThemeData.lynch950,
                                                      )
                                                    ],
                                                  )
                                                ],
                                              ),
                                              spaceW(width: 30),
                                              Column(
                                                mainAxisSize: MainAxisSize.min,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  TextCustom(
                                                    title: "Cuisine".tr,
                                                    fontSize: 14,
                                                    fontFamily: FontFamily.regular,
                                                    color: themeChange.isDarkTheme() ? AppThemeData.lynch25 : AppThemeData.lynch950,
                                                  ),
                                                  TextCustom(
                                                    title: controller.restaurantModel.value.cuisineName.toString(),
                                                    fontSize: 14,
                                                    fontFamily: FontFamily.medium,
                                                    color: themeChange.isDarkTheme() ? AppThemeData.lynch25 : AppThemeData.lynch950,
                                                  )
                                                ],
                                              )
                                            ],
                                          ),
                                          spaceH(height: 24),
                                          Column(
                                            mainAxisSize: MainAxisSize.min,
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
                                                children: [
                                                  SvgPicture.asset(
                                                    "assets/icons/ic_user.svg",
                                                    color: themeChange.isDarkTheme() ? AppThemeData.lynch25 : AppThemeData.lynch950,
                                                  ),
                                                  spaceW(width: 8),
                                                  TextCustom(
                                                    title: controller.restaurantModel.value.ownerFullName.toString(),
                                                    fontSize: 14,
                                                    fontFamily: FontFamily.regular,
                                                    color: themeChange.isDarkTheme() ? AppThemeData.lynch25 : AppThemeData.lynch950,
                                                  )
                                                ],
                                              ),
                                              spaceH(height: 8),
                                              Row(
                                                children: [
                                                  SvgPicture.asset(
                                                    "assets/icons/ic_call.svg",
                                                    color: themeChange.isDarkTheme() ? AppThemeData.lynch25 : AppThemeData.lynch950,
                                                  ),
                                                  spaceW(width: 8),
                                                  FutureBuilder(
                                                      future: FireStoreUtils.getOwnerByOwnerId(controller.restaurantModel.value.ownerId.toString()),
                                                      builder: (context, snapshot) {
                                                        if (!snapshot.hasData) {
                                                          return Container();
                                                        }
                                                        OwnerModel owner = snapshot.data ?? OwnerModel();
                                                        return TextCustom(
                                                          title: Constant.maskMobileNumber(countryCode: owner.countryCode.toString(), mobileNumber: owner.phoneNumber.toString()),
                                                          fontSize: 14,
                                                          fontFamily: FontFamily.regular,
                                                          color: themeChange.isDarkTheme() ? AppThemeData.lynch25 : AppThemeData.lynch950,
                                                        );
                                                      }),
                                                ],
                                              )
                                            ],
                                          ),
                                          spaceH(height: 24),
                                          TextCustom(
                                            title: "Opening Hours".tr,
                                            fontSize: 16,
                                            fontFamily: FontFamily.medium,
                                            color: themeChange.isDarkTheme() ? AppThemeData.lynch25 : AppThemeData.lynch950,
                                          ),
                                          spaceH(height: 4),
                                          SizedBox(
                                            width: 300,
                                            child: ListView.builder(
                                              padding: EdgeInsets.zero,
                                              physics: const NeverScrollableScrollPhysics(),
                                              shrinkWrap: true,
                                              itemCount: controller.restaurantModel.value.openingHoursList!.length,
                                              itemBuilder: (context, index) {
                                                return rowTextWidget(
                                                  name: controller.restaurantModel.value.openingHoursList![index].day.toString(),
                                                  value: controller.restaurantModel.value.openingHoursList![index].isOpen!
                                                      ? "${controller.restaurantModel.value.openingHoursList![index].openingHours.toString()} to ${controller.restaurantModel.value.openingHoursList![index].closingHours.toString()}"
                                                      : "Closed".tr,
                                                );
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
              tablet: controller.isLoading.value
                  ? Constant.loader()
                  : SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 0),
                                child: Wrap(
                                  children: [
                                    commonView(
                                      context: context,
                                      title: "Total Earnings".tr,
                                      value: controller.totalRestaurantEarnings.value.toStringAsFixed(2),
                                      imageAssets: "assets/icons/ic_doller.svg",
                                      bgColor: const Color(0xffE7FCFD),
                                      textColor: const Color(0xff0CB9C1),
                                    ),
                                    commonView(
                                        context: context,
                                        title: "Total Orders".tr,
                                        value: Constant.restaurantOrderLength.toString(),
                                        imageAssets: "assets/icons/ic_totla.svg",
                                        bgColor: const Color(0xffF2ECF9),
                                        textColor: const Color(0xff7338B3)),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 0),
                                child: Wrap(
                                  children: [
                                    commonView(
                                      context: context,
                                      title: "Total Items".tr,
                                      value: Constant.restaurantProductLength.toString(),
                                      imageAssets: "assets/icons/ic_total.svg",
                                      bgColor: const Color(0xffFEF4E6),
                                      textColor: const Color(0xffF99007),
                                    ),
                                    commonView(
                                      context: context,
                                      title: "Total Reviews".tr,
                                      value: Constant.restaurantReviewLength.toString(),
                                      imageAssets: "assets/icons/ic_star.svg",
                                      bgColor: const Color(0xffFEEAE6),
                                      textColor: const Color(0xffF85A40),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          spaceH(height: 24),
                          Container(
                            decoration: BoxDecoration(color: themeChange.isDarkTheme() ? AppThemeData.primaryBlack : AppThemeData.primaryWhite, borderRadius: BorderRadius.circular(8)),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                spaceH(height: 20),
                                // Padding(
                                //   padding: const EdgeInsets.only(right: 16),
                                //   child: Row(
                                //     mainAxisAlignment: MainAxisAlignment.end,
                                //     children: [
                                //       Column(
                                //         crossAxisAlignment: CrossAxisAlignment.start,
                                //         children: [
                                //           TextCustom(
                                //             title: 'Wallet Amount : ',
                                //             fontSize: 16,
                                //             fontFamily: FontFamily.regular,
                                //             color: themeChange.isDarkTheme() ? AppThemeData.lynch25 : AppThemeData.lynch950,
                                //           ),
                                //           spaceH(height: 2),
                                //           Obx(
                                //             () {
                                //               return TextCustom(
                                //                 title: Constant.amountShow(amount: controller.ownerModel.value.walletAmount ?? "0.0"),
                                //                 fontSize: 18,
                                //                 color: themeChange.isDarkTheme() ? AppThemeData.lynch25 : AppThemeData.lynch950,
                                //                 fontFamily: FontFamily.bold,
                                //               );
                                //             },
                                //           ),
                                //         ],
                                //       ),
                                //       spaceW(width: 16),
                                //       CustomButtonWidget(
                                //         title: 'Top Up'.tr,
                                //         buttonColor: AppThemeData.primary500,
                                //         onPress: () {
                                //           showDialog(context: context, builder: (context) => const TopUpDialog());
                                //         },
                                //       ),
                                //     ],
                                //   ),
                                // ),
                                spaceH(height: 16),
                                Padding(
                                  padding: const EdgeInsets.only(left: 16, right: 16, top: 16),
                                  child: ClipRRect(
                                    borderRadius: const BorderRadius.all(Radius.circular(8)),
                                    child: CachedNetworkImage(
                                      fit: BoxFit.fill,
                                      height: ScreenSize.height(34, context),
                                      width: double.infinity,
                                      imageUrl: controller.restaurantModel.value.coverImage.toString(),
                                      progressIndicatorBuilder: (context, url, downloadProgress) => const Center(
                                        child: CircularProgressIndicator(color: Colors.black),
                                      ),
                                      errorWidget: (context, url, error) => Image.asset(
                                        Constant.userPlaceHolder,
                                        height: ScreenSize.height(10, context),
                                        width: ScreenSize.width(18, context),
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                TextCustom(title: controller.restaurantModel.value.vendorName.toString(), fontSize: 18, fontFamily: FontFamily.bold),
                                                Row(
                                                  children: [
                                                    SvgPicture.asset(
                                                      "assets/icons/ic_location.svg",
                                                      height: 16,
                                                      width: 16,
                                                      color: themeChange.isDarkTheme() ? AppThemeData.lynch400 : AppThemeData.lynch500,
                                                    ),
                                                    spaceW(),
                                                    TextCustom(
                                                      title: controller.restaurantModel.value.address!.address.toString(),
                                                      fontSize: 14,
                                                      fontFamily: FontFamily.regular,
                                                      maxLine: 2,
                                                      color: themeChange.isDarkTheme() ? AppThemeData.lynch400 : AppThemeData.lynch500,
                                                    ),
                                                  ],
                                                )
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                      spaceH(height: 24),
                                      Row(
                                        children: [
                                          SizedBox(
                                            width: ScreenSize.width(15, context),
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                TextCustom(
                                                  title: "Restaurant Type".tr,
                                                  fontSize: 14,
                                                  fontFamily: FontFamily.regular,
                                                  color: themeChange.isDarkTheme() ? AppThemeData.lynch25 : AppThemeData.lynch950,
                                                ),
                                                Row(
                                                  children: [
                                                    controller.restaurantModel.value.vendorType == "Veg"
                                                        ? SvgPicture.asset("assets/icons/ic_food_type.svg")
                                                        : controller.restaurantModel.value.vendorType == "Non veg"
                                                            ? SvgPicture.asset(
                                                                "assets/icons/ic_food_type.svg",
                                                                color: AppThemeData.red500,
                                                              )
                                                            : Row(
                                                                mainAxisSize: MainAxisSize.min,
                                                                children: [
                                                                  SvgPicture.asset(
                                                                    "assets/icons/ic_food_type.svg",
                                                                    color: AppThemeData.red500,
                                                                  ),
                                                                  spaceW(width: 4),
                                                                  SvgPicture.asset("assets/icons/ic_food_type.svg")
                                                                ],
                                                              ),
                                                    spaceW(width: 4),
                                                    TextCustom(
                                                      title: controller.restaurantModel.value.vendorType.toString(),
                                                      fontSize: 14,
                                                      fontFamily: FontFamily.medium,
                                                      color: themeChange.isDarkTheme() ? AppThemeData.lynch25 : AppThemeData.lynch950,
                                                    )
                                                  ],
                                                )
                                              ],
                                            ),
                                          ),
                                          Column(
                                            mainAxisSize: MainAxisSize.min,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              TextCustom(
                                                title: "Cuisine".tr,
                                                fontSize: 14,
                                                fontFamily: FontFamily.regular,
                                                color: themeChange.isDarkTheme() ? AppThemeData.lynch25 : AppThemeData.lynch950,
                                              ),
                                              TextCustom(
                                                title: controller.restaurantModel.value.cuisineName.toString(),
                                                fontSize: 14,
                                                fontFamily: FontFamily.medium,
                                                color: themeChange.isDarkTheme() ? AppThemeData.lynch25 : AppThemeData.lynch950,
                                              )
                                            ],
                                          )
                                        ],
                                      ),
                                      spaceH(height: 24),
                                      Column(
                                        mainAxisSize: MainAxisSize.min,
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
                                            children: [
                                              SvgPicture.asset(
                                                "assets/icons/ic_user.svg",
                                                color: themeChange.isDarkTheme() ? AppThemeData.lynch25 : AppThemeData.lynch950,
                                              ),
                                              spaceW(width: 8),
                                              TextCustom(
                                                title: controller.restaurantModel.value.ownerFullName.toString(),
                                                fontSize: 14,
                                                fontFamily: FontFamily.regular,
                                                color: themeChange.isDarkTheme() ? AppThemeData.lynch25 : AppThemeData.lynch950,
                                              )
                                            ],
                                          ),
                                          spaceH(height: 8),
                                          Row(
                                            children: [
                                              SvgPicture.asset(
                                                "assets/icons/ic_call.svg",
                                                color: themeChange.isDarkTheme() ? AppThemeData.lynch25 : AppThemeData.lynch950,
                                              ),
                                              spaceW(width: 8),
                                              FutureBuilder(
                                                  future: FireStoreUtils.getOwnerByOwnerId(controller.restaurantModel.value.ownerId.toString()),
                                                  builder: (context, snapshot) {
                                                    if (!snapshot.hasData) {
                                                      return Container();
                                                    }
                                                    OwnerModel owner = snapshot.data ?? OwnerModel();
                                                    return TextCustom(
                                                      title: Constant.maskMobileNumber(countryCode: owner.countryCode.toString(), mobileNumber: owner.phoneNumber.toString()),
                                                      fontSize: 14,
                                                      fontFamily: FontFamily.regular,
                                                      color: themeChange.isDarkTheme() ? AppThemeData.lynch25 : AppThemeData.lynch950,
                                                    );
                                                  }),
                                            ],
                                          )
                                        ],
                                      ),
                                      spaceH(height: 24),
                                      TextCustom(
                                        title: "Opening Hours".tr,
                                        fontSize: 16,
                                        fontFamily: FontFamily.medium,
                                        color: themeChange.isDarkTheme() ? AppThemeData.lynch25 : AppThemeData.lynch950,
                                      ),
                                      spaceH(height: 4),
                                      SizedBox(
                                        width: 300,
                                        child: ListView.builder(
                                          padding: EdgeInsets.zero,
                                          physics: const NeverScrollableScrollPhysics(),
                                          shrinkWrap: true,
                                          itemCount: controller.restaurantModel.value.openingHoursList!.length,
                                          itemBuilder: (context, index) {
                                            return rowTextWidget(
                                              name: controller.restaurantModel.value.openingHoursList![index].day.toString(),
                                              value: controller.restaurantModel.value.openingHoursList![index].isOpen!
                                                  ? "${controller.restaurantModel.value.openingHoursList![index].openingHours.toString()} to ${controller.restaurantModel.value.openingHoursList![index].closingHours.toString()}"
                                                  : "Closed",
                                            );
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
              desktop: controller.isLoading.value
                  ? Constant.loader()
                  : SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 0),
                                child: Wrap(
                                  children: [
                                    commonView(
                                      context: context,
                                      title: "Total Earnings".tr,
                                      value: controller.totalRestaurantEarnings.value.toStringAsFixed(2),
                                      imageAssets: "assets/icons/ic_doller.svg",
                                      bgColor: const Color(0xffE7FCFD),
                                      textColor: const Color(0xff0CB9C1),
                                    ),
                                    commonView(
                                        context: context,
                                        title: "Total Orders".tr,
                                        value: Constant.restaurantOrderLength.toString(),
                                        imageAssets: "assets/icons/ic_totla.svg",
                                        bgColor: const Color(0xffF2ECF9),
                                        textColor: const Color(0xff7338B3)),
                                    commonView(
                                      context: context,
                                      title: "Total Items".tr,
                                      value: Constant.restaurantProductLength.toString(),
                                      imageAssets: "assets/icons/ic_total.svg",
                                      bgColor: const Color(0xffFEF4E6),
                                      textColor: const Color(0xffF99007),
                                    ),
                                    commonView(
                                      context: context,
                                      title: "Total Reviews".tr,
                                      value: Constant.restaurantReviewLength.toString(),
                                      imageAssets: "assets/icons/ic_star.svg",
                                      bgColor: const Color(0xffFEEAE6),
                                      textColor: const Color(0xffF85A40),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          spaceH(height: 24),
                          ContainerCustom(
                            color: themeChange.isDarkTheme() ? AppThemeData.primaryBlack : AppThemeData.primaryWhite,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                spaceH(height: 20),
                                Padding(
                                  padding: const EdgeInsets.only(top: 18, left: 18),
                                  child: ClipRRect(
                                    borderRadius: const BorderRadius.all(Radius.circular(8)),
                                    child: CachedNetworkImage(
                                      fit: BoxFit.fill,
                                      height: ScreenSize.height(30, context),
                                      width: ScreenSize.width(20, context),
                                      imageUrl: controller.restaurantModel.value.coverImage.toString(),
                                      progressIndicatorBuilder: (context, url, downloadProgress) => const Center(
                                        child: CircularProgressIndicator(color: Colors.black),
                                      ),
                                      errorWidget: (context, url, error) => Image.asset(
                                        Constant.userPlaceHolder,
                                        height: ScreenSize.height(10, context),
                                        width: ScreenSize.width(18, context),
                                      ),
                                    ),
                                  ),
                                ),
                                spaceW(width: 24),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 24),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween, // Align children to space between
                                          children: [
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  TextCustom(
                                                    title: controller.restaurantModel.value.vendorName.toString(),
                                                    fontSize: 18,
                                                    fontFamily: FontFamily.bold,
                                                  ),
                                                  Row(
                                                    children: [
                                                      SvgPicture.asset(
                                                        "assets/icons/ic_location.svg",
                                                        height: 16,
                                                        width: 16,
                                                        color: themeChange.isDarkTheme() ? AppThemeData.lynch400 : AppThemeData.lynch500,
                                                      ),
                                                      spaceW(),
                                                      Expanded(
                                                        child: TextCustom(
                                                          title: controller.restaurantModel.value.address!.address.toString(),
                                                          fontSize: 14,
                                                          fontFamily: FontFamily.regular,
                                                          maxLine: 2,
                                                          color: themeChange.isDarkTheme() ? AppThemeData.lynch400 : AppThemeData.lynch500,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  spaceH(height: 24),
                                                  Row(
                                                    children: [
                                                      SizedBox(
                                                        width: ScreenSize.width(15, context),
                                                        child: Column(
                                                          mainAxisSize: MainAxisSize.min,
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          children: [
                                                            TextCustom(
                                                              title: "Restaurant Type".tr,
                                                              fontSize: 14,
                                                              fontFamily: FontFamily.regular,
                                                              color: themeChange.isDarkTheme() ? AppThemeData.lynch25 : AppThemeData.lynch950,
                                                            ),
                                                            Row(
                                                              children: [
                                                                controller.restaurantModel.value.vendorType == "Veg"
                                                                    ? SvgPicture.asset("assets/icons/ic_food_type.svg")
                                                                    : controller.restaurantModel.value.vendorType == "Non veg"
                                                                        ? SvgPicture.asset(
                                                                            "assets/icons/ic_food_type.svg",
                                                                            color: AppThemeData.red500,
                                                                          )
                                                                        : Row(
                                                                            mainAxisSize: MainAxisSize.min,
                                                                            children: [
                                                                              SvgPicture.asset(
                                                                                "assets/icons/ic_food_type.svg",
                                                                                color: AppThemeData.red500,
                                                                              ),
                                                                              spaceW(width: 6),
                                                                              SvgPicture.asset("assets/icons/ic_food_type.svg")
                                                                            ],
                                                                          ),
                                                                spaceW(width: 4),
                                                                TextCustom(
                                                                  title: controller.restaurantModel.value.vendorType.toString(),
                                                                  fontSize: 14,
                                                                  fontFamily: FontFamily.medium,
                                                                  color: themeChange.isDarkTheme() ? AppThemeData.lynch25 : AppThemeData.lynch950,
                                                                )
                                                              ],
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                      Column(
                                                        mainAxisSize: MainAxisSize.min,
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          TextCustom(
                                                            title: "Cuisine".tr,
                                                            fontSize: 14,
                                                            fontFamily: FontFamily.regular,
                                                            color: themeChange.isDarkTheme() ? AppThemeData.lynch25 : AppThemeData.lynch950,
                                                          ),
                                                          TextCustom(
                                                            title: controller.restaurantModel.value.cuisineName.toString(),
                                                            fontSize: 14,
                                                            fontFamily: FontFamily.medium,
                                                            color: themeChange.isDarkTheme() ? AppThemeData.lynch25 : AppThemeData.lynch950,
                                                          )
                                                        ],
                                                      )
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                            spaceW(width: 24),
                                            // Column(
                                            //   crossAxisAlignment: CrossAxisAlignment.end,
                                            //   children: [
                                            //     TextCustom(
                                            //       title: 'Wallet Amount : ',
                                            //       fontSize: 16,
                                            //       fontFamily: FontFamily.regular,
                                            //       color: themeChange.isDarkTheme() ? AppThemeData.lynch25 : AppThemeData.lynch950,
                                            //     ),
                                            //     spaceH(height: 2),
                                            //     Obx(
                                            //       () {
                                            //         return TextCustom(
                                            //           title: Constant.amountShow(amount: controller.ownerModel.value.walletAmount ?? "0.0"),
                                            //           fontSize: 18,
                                            //           color: themeChange.isDarkTheme() ? AppThemeData.lynch25 : AppThemeData.lynch950,
                                            //           fontFamily: FontFamily.bold,
                                            //         );
                                            //       },
                                            //     ),
                                            //     spaceH(height: 10),
                                            //     CustomButtonWidget(
                                            //       title: 'Top Up'.tr,
                                            //       buttonColor: AppThemeData.primary500,
                                            //       onPress: () {
                                            //         showDialog(context: context, builder: (context) => const TopUpDialog());
                                            //       },
                                            //     ),
                                            //   ],
                                            // ),
                                          ],
                                        ),
                                        spaceH(height: 24),
                                        Column(
                                          mainAxisSize: MainAxisSize.min,
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
                                              children: [
                                                SvgPicture.asset(
                                                  "assets/icons/ic_user.svg",
                                                  color: themeChange.isDarkTheme() ? AppThemeData.lynch25 : AppThemeData.lynch950,
                                                ),
                                                spaceW(width: 8),
                                                TextCustom(
                                                  title: controller.restaurantModel.value.ownerFullName.toString(),
                                                  fontSize: 14,
                                                  fontFamily: FontFamily.regular,
                                                  color: themeChange.isDarkTheme() ? AppThemeData.lynch25 : AppThemeData.lynch950,
                                                )
                                              ],
                                            ),
                                            spaceH(height: 8),
                                            Row(
                                              children: [
                                                SvgPicture.asset(
                                                  "assets/icons/ic_call.svg",
                                                  color: themeChange.isDarkTheme() ? AppThemeData.lynch25 : AppThemeData.lynch950,
                                                ),
                                                spaceW(width: 8),
                                                FutureBuilder(
                                                    future: FireStoreUtils.getOwnerByOwnerId(controller.restaurantModel.value.ownerId.toString()),
                                                    builder: (context, snapshot) {
                                                      if (!snapshot.hasData) {
                                                        return Container();
                                                      }
                                                      OwnerModel owner = snapshot.data ?? OwnerModel();
                                                      return TextCustom(
                                                        title: Constant.maskMobileNumber(countryCode: owner.countryCode.toString(), mobileNumber: owner.phoneNumber.toString()),
                                                        fontSize: 14,
                                                        fontFamily: FontFamily.regular,
                                                        color: themeChange.isDarkTheme() ? AppThemeData.lynch25 : AppThemeData.lynch950,
                                                      );
                                                    }),
                                              ],
                                            )
                                          ],
                                        ),
                                        spaceH(height: 24),
                                        TextCustom(
                                          title: "Opening Hours".tr,
                                          fontSize: 16,
                                          fontFamily: FontFamily.medium,
                                          color: themeChange.isDarkTheme() ? AppThemeData.lynch25 : AppThemeData.lynch950,
                                        ),
                                        spaceH(height: 4),
                                        SizedBox(
                                          width: 300,
                                          child: ListView.builder(
                                            padding: EdgeInsets.zero,
                                            physics: const NeverScrollableScrollPhysics(),
                                            shrinkWrap: true,
                                            itemCount: controller.restaurantModel.value.openingHoursList!.length,
                                            itemBuilder: (context, index) {
                                              return rowTextWidget(
                                                name: controller.restaurantModel.value.openingHoursList![index].day.toString(),
                                                value: controller.restaurantModel.value.openingHoursList![index].isOpen!
                                                    ? "${controller.restaurantModel.value.openingHoursList![index].openingHours.toString()} to ${controller.restaurantModel.value.openingHoursList![index].closingHours.toString()}"
                                                    : "Closed",
                                              );
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ),
                            // child: Row(
                            //   mainAxisAlignment: MainAxisAlignment.start,
                            //   crossAxisAlignment: CrossAxisAlignment.start,
                            //   children: [
                            //     spaceH(height: 20),
                            //     Padding(
                            //       padding: const EdgeInsets.only(top: 18, left: 18),
                            //       child: ClipRRect(
                            //         borderRadius: const BorderRadius.all(Radius.circular(8)),
                            //         child: CachedNetworkImage(
                            //           fit: BoxFit.fill,
                            //           height: ScreenSize.height(30, context),
                            //           width: ScreenSize.width(20, context),
                            //           imageUrl: controller.restaurantModel.value.coverImage.toString(),
                            //           progressIndicatorBuilder: (context, url, downloadProgress) => const Center(
                            //             child: CircularProgressIndicator(color: Colors.black),
                            //           ),
                            //           errorWidget: (context, url, error) => Image.asset(
                            //             Constant.userPlaceHolder,
                            //             height: ScreenSize.height(10, context),
                            //             width: ScreenSize.width(18, context),
                            //           ),
                            //         ),
                            //       ),
                            //     ),
                            //     spaceW(width: 24),
                            //     Padding(
                            //       padding: const EdgeInsets.symmetric(vertical: 24),
                            //       child: Column(
                            //         mainAxisSize: MainAxisSize.min,
                            //         crossAxisAlignment: CrossAxisAlignment.start,
                            //         mainAxisAlignment: MainAxisAlignment.start,
                            //         children: [
                            //           Row(
                            //             crossAxisAlignment: CrossAxisAlignment.start,
                            //             children: [
                            //               Column(
                            //                 crossAxisAlignment: CrossAxisAlignment.start,
                            //                 children: [
                            //                   TextCustom(title: controller.restaurantModel.value.vendorName.toString(), fontSize: 18, fontFamily: FontFamily.bold),
                            //                   Row(
                            //                     children: [
                            //                       SvgPicture.asset(
                            //                         "assets/icons/ic_location.svg",
                            //                         height: 16,
                            //                         width: 16,
                            //                         color: themeChange.isDarkTheme() ? AppThemeData.lynch400 : AppThemeData.lynch500,
                            //                       ),
                            //                       spaceW(),
                            //                       TextCustom(
                            //                         title: controller.restaurantModel.value.address!.address.toString(),
                            //                         fontSize: 14,
                            //                         fontFamily: FontFamily.regular,
                            //                         maxLine: 2,
                            //                         color: themeChange.isDarkTheme() ? AppThemeData.lynch400 : AppThemeData.lynch500,
                            //                       ),
                            //                     ],
                            //                   ),
                            //                   spaceH(height: 24),
                            //                   Row(
                            //                     children: [
                            //                       SizedBox(
                            //                         width: ScreenSize.width(15, context),
                            //                         child: Column(
                            //                           mainAxisSize: MainAxisSize.min,
                            //                           crossAxisAlignment: CrossAxisAlignment.start,
                            //                           children: [
                            //                             TextCustom(
                            //                               title: "Restaurant Type".tr,
                            //                               fontSize: 14,
                            //                               fontFamily: FontFamily.regular,
                            //                               color: themeChange.isDarkTheme() ? AppThemeData.lynch25 : AppThemeData.lynch950,
                            //                             ),
                            //                             Row(
                            //                               children: [
                            //                                 controller.restaurantModel.value.vendorType == "Veg"
                            //                                     ? SvgPicture.asset("assets/icons/ic_food_type.svg")
                            //                                     : controller.restaurantModel.value.vendorType == "Non veg"
                            //                                         ? SvgPicture.asset(
                            //                                             "assets/icons/ic_food_type.svg",
                            //                                             color: AppThemeData.red500,
                            //                                           )
                            //                                         : Row(
                            //                                             mainAxisSize: MainAxisSize.min,
                            //                                             children: [
                            //                                               SvgPicture.asset(
                            //                                                 "assets/icons/ic_food_type.svg",
                            //                                                 color: AppThemeData.red500,
                            //                                               ),
                            //                                               spaceW(width: 6),
                            //                                               SvgPicture.asset("assets/icons/ic_food_type.svg")
                            //                                             ],
                            //                                           ),
                            //                                 spaceW(width: 4),
                            //                                 TextCustom(
                            //                                   title: controller.restaurantModel.value.vendorType.toString(),
                            //                                   fontSize: 14,
                            //                                   fontFamily: FontFamily.medium,
                            //                                   color: themeChange.isDarkTheme() ? AppThemeData.lynch25 : AppThemeData.lynch950,
                            //                                 )
                            //                               ],
                            //                             )
                            //                           ],
                            //                         ),
                            //                       ),
                            //                       Column(
                            //                         mainAxisSize: MainAxisSize.min,
                            //                         crossAxisAlignment: CrossAxisAlignment.start,
                            //                         children: [
                            //                           TextCustom(
                            //                             title: "Cuisine".tr,
                            //                             fontSize: 14,
                            //                             fontFamily: FontFamily.regular,
                            //                             color: themeChange.isDarkTheme() ? AppThemeData.lynch25 : AppThemeData.lynch950,
                            //                           ),
                            //                           TextCustom(
                            //                             title: controller.restaurantModel.value.cuisineName.toString(),
                            //                             fontSize: 14,
                            //                             fontFamily: FontFamily.medium,
                            //                             color: themeChange.isDarkTheme() ? AppThemeData.lynch25 : AppThemeData.lynch950,
                            //                           )
                            //                         ],
                            //                       )
                            //                     ],
                            //                   ),
                            //                 ],
                            //               ),
                            //               spaceW(width: 24),
                            //               Column(
                            //                 crossAxisAlignment: CrossAxisAlignment.end,
                            //                 children: [
                            //                   TextCustom(
                            //                     title: 'Wallet Amount',
                            //                     fontSize: 16,
                            //                     color: themeChange.isDarkTheme() ? AppThemeData.lynch400 : AppThemeData.lynch500,
                            //
                            //                     //fontFamily: AppThemeData.medium,
                            //                   ),
                            //                   spaceH(height: 8),
                            //                   Obx(() => TextCustom(
                            //                         title: Constant.amountShow(amount: controller.ownerModel.value.walletAmount!),
                            //                         fontSize: 18,
                            //                         color: themeChange.isDarkTheme() ? AppThemeData.lynch400 : AppThemeData.lynch500,
                            //                         fontFamily: FontFamily.medium,
                            //                       )),
                            //                   spaceH(height: 10),
                            //                   CustomButtonWidget(
                            //                     title: 'Top Up'.tr,
                            //                     buttonColor: AppThemeData.primary500,
                            //                     onPress: () {
                            //                       showDialog(context: context, builder: (context) => const TopUpDialog());
                            //                     },
                            //                   ),
                            //                 ],
                            //               ),
                            //             ],
                            //           ),
                            //           spaceH(height: 24),
                            //           Column(
                            //             mainAxisSize: MainAxisSize.min,
                            //             crossAxisAlignment: CrossAxisAlignment.start,
                            //             children: [
                            //               TextCustom(
                            //                 title: "Owner Details".tr,
                            //                 fontSize: 16,
                            //                 fontFamily: FontFamily.medium,
                            //                 color: themeChange.isDarkTheme() ? AppThemeData.lynch25 : AppThemeData.lynch950,
                            //               ),
                            //               spaceH(height: 12),
                            //               Row(
                            //                 children: [
                            //                   SvgPicture.asset(
                            //                     "assets/icons/ic_user.svg",
                            //                     color: themeChange.isDarkTheme() ? AppThemeData.lynch25 : AppThemeData.lynch950,
                            //                   ),
                            //                   spaceW(width: 8),
                            //                   TextCustom(
                            //                     title: controller.restaurantModel.value.ownerFullName.toString(),
                            //                     fontSize: 14,
                            //                     fontFamily: FontFamily.regular,
                            //                     color: themeChange.isDarkTheme() ? AppThemeData.lynch25 : AppThemeData.lynch950,
                            //                   )
                            //                 ],
                            //               ),
                            //               spaceH(height: 8),
                            //               Row(
                            //                 children: [
                            //                   SvgPicture.asset(
                            //                     "assets/icons/ic_call.svg",
                            //                     color: themeChange.isDarkTheme() ? AppThemeData.lynch25 : AppThemeData.lynch950,
                            //                   ),
                            //                   spaceW(width: 8),
                            //                   FutureBuilder(
                            //                       future: FireStoreUtils.getOwnerByOwnerId(controller.restaurantModel.value.ownerId.toString()),
                            //                       builder: (context, snapshot) {
                            //                         if (!snapshot.hasData) {
                            //                           return Container();
                            //                         }
                            //                         OwnerModel owner = snapshot.data ?? OwnerModel();
                            //                         return TextCustom(
                            //                           title: Constant.maskMobileNumber(countryCode: owner.countryCode.toString(), mobileNumber: owner.phoneNumber.toString()),
                            //                           fontSize: 14,
                            //                           fontFamily: FontFamily.regular,
                            //                           color: themeChange.isDarkTheme() ? AppThemeData.lynch25 : AppThemeData.lynch950,
                            //                         );
                            //                      }),
                            //                 ],
                            //               )
                            //             ],
                            //           ),
                            //           spaceH(height: 24),
                            //           TextCustom(
                            //             title: "Opening Hours".tr,
                            //             fontSize: 16,
                            //             fontFamily: FontFamily.medium,
                            //             color: themeChange.isDarkTheme() ? AppThemeData.lynch25 : AppThemeData.lynch950,
                            //           ),
                            //           spaceH(height: 4),
                            //           SizedBox(
                            //             width: 300,
                            //             // height: ScreenSize.height(50, context), // Adjust height as needed
                            //             child: ListView.builder(
                            //               padding: EdgeInsets.zero,
                            //               physics: const NeverScrollableScrollPhysics(),
                            //               shrinkWrap: true,
                            //               itemCount: controller.restaurantModel.value.openingHoursList!.length,
                            //               itemBuilder: (context, index) {
                            //                 return rowTextWidget(
                            //                   name: controller.restaurantModel.value.openingHoursList![index].day.toString(),
                            //                   value: controller.restaurantModel.value.openingHoursList![index].isOpen!
                            //                       ? "${controller.restaurantModel.value.openingHoursList![index].openingHours.toString()} to ${controller.restaurantModel.value.openingHoursList![index].closingHours.toString()}"
                            //                       : "Closed",
                            //                 );
                            //               },
                            //             ),
                            //           ),
                            //         ],
                            //       ),
                            //     )
                            //   ],
                            // ),
                          )
                        ],
                      ),
                    ));
        });
  }

  Padding rowTextWidget({required String name, required String value}) {
    final themeChange = Provider.of<DarkThemeProvider>(Get.context!);
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          TextCustom(
            title: name.tr,
            fontSize: 14,
            fontFamily: FontFamily.regular,
            color: themeChange.isDarkTheme() ? AppThemeData.lynch25 : AppThemeData.lynch900,
          ),
          const Spacer(),
          TextCustom(
            title: value.tr,
            fontSize: 14,
            fontFamily: FontFamily.regular,
            color: themeChange.isDarkTheme() ? AppThemeData.lynch25 : AppThemeData.lynch900,
          ),
        ],
      ),
    );
  }

  Container commonView({required BuildContext context, required String title, required String value, required String imageAssets, required Color bgColor, required Color textColor}) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return Container(
      margin: const EdgeInsets.only(right: 24, top: 24),
      padding: const EdgeInsets.all(12),
      height: 120,
      width: ResponsiveWidget.isDesktop(context) ? (ScreenSize.width(100, context) - 445) / 4 : (ScreenSize.width(100, context) - 80) / 2,
      decoration: BoxDecoration(
        // image: const DecorationImage(image: AssetImage("assets/images/Card1.png"), fit: BoxFit.fill),
        color: themeChange.isDarkTheme() ? AppThemeData.primaryBlack : AppThemeData.primaryWhite,
        // border: Border.all(color: themeChange.getTheme() ? AppColors.greyShade900 : AppColors.greyShade100.withOpacity(.5)),
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
            color: AppThemeData.lynch500,
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
}

class TopUpDialog extends StatelessWidget {
  const TopUpDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetBuilder(
      init: RestaurantDetailsController(),
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
