// ignore_for_file: deprecated_member_use

import 'package:admin_panel/app/components/menu_widget.dart';
import 'package:admin_panel/app/constant/constants.dart';
import 'package:admin_panel/app/models/addons_model.dart';
import 'package:admin_panel/app/models/vendor_model.dart';
import 'package:admin_panel/app/models/variation_model.dart';
import 'package:admin_panel/app/modules/food_detail/controllers/food_detail_controller.dart';
import 'package:admin_panel/app/routes/app_pages.dart';
import 'package:admin_panel/app/utils/app_colors.dart';
import 'package:admin_panel/app/utils/app_them_data.dart';
import 'package:admin_panel/app/utils/dark_theme_provider.dart';
import 'package:admin_panel/app/utils/fire_store_utils.dart';
import 'package:admin_panel/app/utils/responsive.dart';
import 'package:admin_panel/app/utils/screen_size.dart';
import 'package:admin_panel/widget/common_ui.dart';
import 'package:admin_panel/widget/container_custom.dart';
import 'package:admin_panel/widget/global_widgets.dart';
import 'package:admin_panel/widget/gradient_text.dart';
import 'package:admin_panel/widget/text_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class FoodDetailView extends GetView<FoodDetailController> {
  const FoodDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetX<FoodDetailController>(
        init: FoodDetailController(),
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
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ContainerCustom(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        ResponsiveWidget.isDesktop(context)
                                            ? Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                mainAxisSize: MainAxisSize.max,
                                                children: [
                                                  Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                                    TextCustom(title: controller.title.value.tr, fontSize: 20, fontFamily: FontFamily.bold),
                                                    spaceH(height: 2),
                                                    Row(children: [
                                                      InkWell(
                                                          onTap: () => Get.offAllNamed(Routes.DASHBOARD_SCREEN),
                                                          child: TextCustom(title: 'Dashboard'.tr, fontSize: 14, fontFamily: FontFamily.medium, color: AppThemeData.lynch500)),
                                                      const TextCustom(title: ' / ', fontSize: 14, fontFamily: FontFamily.medium, color: AppThemeData.lynch500),
                                                      InkWell(
                                                          onTap: () => Get.offAllNamed(Routes.FOODS),
                                                          child: TextCustom(title: 'Foods'.tr, fontSize: 14, fontFamily: FontFamily.medium, color: AppThemeData.lynch500)),
                                                      const TextCustom(title: ' / ', fontSize: 14, fontFamily: FontFamily.medium, color: AppThemeData.lynch500),
                                                      TextCustom(title: ' ${controller.title.value.tr} ', fontSize: 14, fontFamily: FontFamily.medium, color: AppThemeData.primary500)
                                                    ])
                                                  ]),
                                                ],
                                              )
                                            : Column(mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.start, children: [
                                                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                                  TextCustom(title: controller.title.value.tr, fontSize: 20, fontFamily: FontFamily.bold),
                                                  spaceH(height: 2),
                                                  Row(children: [
                                                    InkWell(
                                                        onTap: () => Get.offAllNamed(Routes.DASHBOARD_SCREEN),
                                                        child: TextCustom(title: 'Dashboard'.tr, fontSize: 14, fontFamily: FontFamily.medium, color: AppThemeData.lynch500)),
                                                    const TextCustom(title: ' / ', fontSize: 14, fontFamily: FontFamily.medium, color: AppThemeData.lynch500),
                                                    InkWell(
                                                        onTap: () => Get.offAllNamed(Routes.FOODS),
                                                        child: TextCustom(title: 'Foods'.tr, fontSize: 14, fontFamily: FontFamily.medium, color: AppThemeData.lynch500)),
                                                    const TextCustom(title: ' / ', fontSize: 14, fontFamily: FontFamily.medium, color: AppThemeData.lynch500),
                                                    TextCustom(title: ' ${controller.title.value.tr} ', fontSize: 14, fontFamily: FontFamily.medium, color: AppThemeData.primary500)
                                                  ])
                                                ]),
                                              ]),
                                        spaceH(height: 20),
                                        ResponsiveWidget(
                                            mobile: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                ClipRRect(
                                                  borderRadius: const BorderRadius.only(
                                                    topLeft: Radius.circular(8),
                                                    topRight: Radius.circular(8),
                                                    bottomLeft: Radius.circular(8),
                                                    bottomRight: Radius.circular(8),
                                                  ),
                                                  child: CachedNetworkImage(
                                                    fit: BoxFit.fill,
                                                    height: ScreenSize.height(34, context),
                                                    width: MediaQuery.of(context).size.width,
                                                    imageUrl: controller.productModel.value.productImage.toString(),
                                                    progressIndicatorBuilder: (context, url, downloadProgress) => const Center(
                                                      child: CircularProgressIndicator(color: Colors.black),
                                                    ),
                                                    errorWidget: (context, url, error) => Image.asset(
                                                      Constant.userPlaceHolder,
                                                      height: ScreenSize.height(10, context),
                                                      width: MediaQuery.of(context).size.width,
                                                    ),
                                                  ),
                                                ),
                                                spaceH(height: 24),
                                                Padding(
                                                  padding: const EdgeInsets.symmetric(horizontal: 16),
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
                                                                title: controller.productModel.value.productName.toString(),
                                                                fontSize: 18,
                                                                fontFamily: FontFamily.bold,
                                                              ),
                                                              FutureBuilder(
                                                                  future: FireStoreUtils.getRestaurantByRestaurantId(controller.productModel.value.vendorId.toString()),
                                                                  builder: (context, snapshot) {
                                                                    if (!snapshot.hasData) {
                                                                      return Container();
                                                                    }
                                                                    VendorModel restaurant = snapshot.data ?? VendorModel();
                                                                    return TextCustom(
                                                                      title: "by ${restaurant.vendorName}",
                                                                      fontFamily: FontFamily.regular,
                                                                      fontSize: 14,
                                                                    );
                                                                  }),
                                                            ],
                                                          ),
                                                          TextCustom(
                                                            title: Constant.amountShow(amount: controller.productModel.value.price.toString()),
                                                            fontSize: 18,
                                                            fontFamily: FontFamily.bold,
                                                          ),
                                                        ],
                                                      ),
                                                      spaceH(),
                                                      Row(
                                                        children: [
                                                          RatingBar.builder(
                                                            glow: false,
                                                            initialRating: double.parse(
                                                              controller
                                                                  .calculateReview(
                                                                    double.parse(controller.productModel.value.reviewSum.toString()),
                                                                    double.parse(controller.productModel.value.reviewCount.toString()),
                                                                  )
                                                                  .toStringAsFixed(1),
                                                            ),
                                                            minRating: 0,
                                                            direction: Axis.horizontal,
                                                            allowHalfRating: false,
                                                            itemCount: 5,
                                                            tapOnlyMode: false,
                                                            itemSize: 18,
                                                            ignoreGestures: true,
                                                            itemPadding: const EdgeInsets.symmetric(horizontal: 2.0),
                                                            unratedColor: themeChange.isDarkTheme() ? AppThemeData.lynch900 : AppThemeData.lynch100,
                                                            itemBuilder: (context, _) => const Icon(Icons.star, color: AppThemeData.warning200),
                                                            // itemBuilder: (context, _) =>
                                                            //     Icon(Icons.star, color: themeChange.isDarkTheme() ? AppThemeData.primaryWhite : AppThemeData.primary500),
                                                            onRatingUpdate: (rating) {
                                                              // controller.rating(rating);
                                                            },
                                                          ),
                                                          spaceW(),
                                                          TextCustom(
                                                              title: controller
                                                                  .calculateReview(
                                                                    double.parse(controller.productModel.value.reviewSum.toString()),
                                                                    double.parse(controller.productModel.value.reviewCount.toString()),
                                                                  )
                                                                  .toStringAsFixed(1)),
                                                        ],
                                                      ),
                                                      spaceH(height: 10),
                                                      TextCustom(
                                                        title: controller.productModel.value.description.toString(),
                                                        fontSize: 14,
                                                        fontFamily: FontFamily.regular,
                                                        color: themeChange.isDarkTheme() ? AppThemeData.lynch400 : AppThemeData.lynch500,
                                                        maxLine: 10,
                                                      ),
                                                      spaceH(height: 24),
                                                      TextCustom(
                                                        title: "Item Type".tr,
                                                        fontSize: 14,
                                                        fontFamily: FontFamily.regular,
                                                      ),
                                                      Row(
                                                        children: [
                                                          controller.productModel.value.foodType == "Veg"
                                                              ? SvgPicture.asset("assets/icons/ic_food_type.svg")
                                                              : controller.productModel.value.foodType == "Non veg"
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
                                                            title: controller.productModel.value.foodType.toString(),
                                                            fontSize: 14,
                                                            fontFamily: FontFamily.medium,
                                                          ),
                                                        ],
                                                      ),
                                                      spaceH(height: 16),
                                                      TextCustom(
                                                        title: "Category".tr,
                                                        fontSize: 14,
                                                        fontFamily: FontFamily.regular,
                                                      ),
                                                      TextCustom(
                                                        title: controller.productModel.value.categoryModel!.categoryName.toString(),
                                                        fontSize: 14,
                                                        fontFamily: FontFamily.medium,
                                                      ),
                                                      if (controller.productModel.value.addonsList!.isNotEmpty)
                                                        Column(
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          children: [
                                                            spaceH(height: 16),
                                                            TextCustom(
                                                              title: "Add Ons".tr,
                                                              fontSize: 14,
                                                              fontFamily: FontFamily.regular,
                                                            ),
                                                            SizedBox(
                                                              // width: 500,
                                                              child: ListView.builder(
                                                                  shrinkWrap: true,
                                                                  itemCount: controller.productModel.value.addonsList!.length,
                                                                  itemBuilder: (context, index) {
                                                                    AddonsModel addonsModel = controller.productModel.value.addonsList![index];
                                                                    return Row(
                                                                      children: [
                                                                        SizedBox(
                                                                          width: ScreenSize.width(20, context),
                                                                          child: TextCustom(
                                                                            title: addonsModel.name.toString(),
                                                                            fontSize: 14,
                                                                            fontFamily: FontFamily.medium,
                                                                          ),
                                                                        ),
                                                                        spaceW(width: 20),
                                                                        TextCustom(
                                                                          title: Constant.amountToShow(amount: addonsModel.price.toString()),
                                                                          fontSize: 14,
                                                                          fontFamily: FontFamily.medium,
                                                                        ),
                                                                      ],
                                                                    );
                                                                  }),
                                                            ),
                                                          ],
                                                        ),
                                                      if (controller.productModel.value.variationList!.isNotEmpty)
                                                        Column(
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          children: [
                                                            spaceH(height: 16),
                                                            TextCustom(
                                                              title: "Variation".tr,
                                                              fontSize: 14,
                                                              fontFamily: FontFamily.regular,
                                                            ),
                                                            ListView.builder(
                                                                shrinkWrap: true,
                                                                itemCount: controller.productModel.value.variationList!.length,
                                                                itemBuilder: (context, index) {
                                                                  VariationModel variationModel = controller.productModel.value.variationList![index];
                                                                  return Column(
                                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                                    children: [
                                                                      TextCustom(
                                                                        title: variationModel.name.toString(),
                                                                        fontSize: 14,
                                                                        fontFamily: FontFamily.medium,
                                                                      ),
                                                                      ListView.builder(
                                                                          shrinkWrap: true,
                                                                          itemCount: variationModel.optionList!.length,
                                                                          itemBuilder: (context, index) {
                                                                            OptionModel optionModel = variationModel.optionList![index];
                                                                            return Row(
                                                                              children: [
                                                                                spaceW(),
                                                                                SizedBox(
                                                                                  width: ScreenSize.width(20, context),
                                                                                  child: TextCustom(
                                                                                    title: optionModel.name.toString(),
                                                                                    fontSize: 14,
                                                                                    fontFamily: FontFamily.medium,
                                                                                  ),
                                                                                ),
                                                                                spaceW(),
                                                                                TextCustom(
                                                                                  title: Constant.amountToShow(amount: optionModel.price.toString()),
                                                                                  fontSize: 14,
                                                                                  fontFamily: FontFamily.medium,
                                                                                ),
                                                                              ],
                                                                            );
                                                                          }),
                                                                    ],
                                                                  );
                                                                }),
                                                          ],
                                                        ),
                                                      spaceH(height: 16),
                                                      // Column(
                                                      //   crossAxisAlignment: CrossAxisAlignment.start,
                                                      //   children: [
                                                      //     TextCustom(
                                                      //       title: "Add Ons".tr,
                                                      //       fontSize: 16,
                                                      //       fontWeight: FontWeight.w600,
                                                      //       fontFamily: FontFamily.regular,
                                                      //     ),
                                                      //     ListView.builder(
                                                      //         shrinkWrap: true,
                                                      //         scrollDirection: Axis.vertical,
                                                      //         itemCount: controller.productModel.value.addonsList!.length,
                                                      //         itemBuilder: (context ,index){
                                                      //           AddonsModel addonsModel = controller.productModel.value.addonsList![index];
                                                      //           return Row(children: [
                                                      //             TextCustom(
                                                      //               title: addonsModel.name.toString(),
                                                      //               fontSize: 14,
                                                      //               fontFamily: FontFamily.regular,
                                                      //             ),
                                                      //             spaceW(width: 20),
                                                      //             TextCustom(
                                                      //               title: addonsModel.price.toString(),
                                                      //               fontSize: 14,
                                                      //               fontFamily: FontFamily.regular,
                                                      //             ),
                                                      //           ],);
                                                      //
                                                      //
                                                      //         })
                                                      //   ],
                                                      // ),
                                                      // spaceH(height: 20),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                            tablet: Row(
                                              children: [
                                                ClipRRect(
                                                  borderRadius: const BorderRadius.only(
                                                    topLeft: Radius.circular(8),
                                                    bottomLeft: Radius.circular(8),
                                                    bottomRight: Radius.circular(8),
                                                    topRight: Radius.circular(8),
                                                  ),
                                                  child: CachedNetworkImage(
                                                    fit: BoxFit.fill,
                                                    height: ScreenSize.height(30, context),
                                                    width: ScreenSize.width(20, context),
                                                    imageUrl: controller.productModel.value.productImage.toString(),
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
                                                Expanded(
                                                  child: Padding(
                                                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
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
                                                                  title: controller.productModel.value.productName.toString(),
                                                                  fontSize: 18,
                                                                  fontFamily: FontFamily.bold,
                                                                ),
                                                                FutureBuilder(
                                                                    future: FireStoreUtils.getRestaurantByRestaurantId(controller.productModel.value.vendorId.toString()),
                                                                    builder: (context, snapshot) {
                                                                      if (!snapshot.hasData) {
                                                                        return Container();
                                                                      }
                                                                      VendorModel restaurant = snapshot.data ?? VendorModel();
                                                                      return TextCustom(
                                                                        title: "by ${restaurant.vendorName}",
                                                                        fontFamily: FontFamily.regular,
                                                                        fontSize: 14,
                                                                      );
                                                                    }),
                                                              ],
                                                            ),
                                                            // spaceW(width: 30),
                                                            TextCustom(
                                                              title: Constant.amountShow(amount: controller.productModel.value.price.toString()),
                                                              fontSize: 18,
                                                              fontFamily: FontFamily.bold,
                                                            ),
                                                          ],
                                                        ),
                                                        spaceH(),
                                                        Row(
                                                          children: [
                                                            RatingBar.builder(
                                                              glow: false,
                                                              initialRating: double.parse(
                                                                controller
                                                                    .calculateReview(
                                                                      double.parse(controller.productModel.value.reviewSum.toString()),
                                                                      double.parse(controller.productModel.value.reviewCount.toString()),
                                                                    )
                                                                    .toStringAsFixed(1),
                                                              ),
                                                              minRating: 0,
                                                              direction: Axis.horizontal,
                                                              allowHalfRating: false,
                                                              itemCount: 5,
                                                              tapOnlyMode: false,
                                                              itemSize: 18,
                                                              ignoreGestures: true,
                                                              itemPadding: const EdgeInsets.symmetric(horizontal: 2.0),
                                                              unratedColor: themeChange.isDarkTheme() ? AppThemeData.lynch900 : AppThemeData.lynch100,
                                                              itemBuilder: (context, _) => const Icon(Icons.star, color: AppThemeData.warning200),
                                                              // itemBuilder: (context, _) =>
                                                              //     Icon(Icons.star, color: themeChange.isDarkTheme() ? AppThemeData.primaryWhite : AppThemeData.primary500),
                                                              onRatingUpdate: (rating) {
                                                                // controller.rating(rating);
                                                              },
                                                            ),
                                                            spaceW(),
                                                            TextCustom(
                                                                title: controller
                                                                    .calculateReview(
                                                                      double.parse(controller.productModel.value.reviewSum.toString()),
                                                                      double.parse(controller.productModel.value.reviewCount.toString()),
                                                                    )
                                                                    .toStringAsFixed(1)),
                                                          ],
                                                        ),
                                                        spaceH(height: 10),
                                                        TextCustom(
                                                          title: controller.productModel.value.description.toString(),
                                                          fontSize: 14,
                                                          fontFamily: FontFamily.regular,
                                                          color: themeChange.isDarkTheme() ? AppThemeData.lynch400 : AppThemeData.lynch500,
                                                          maxLine: 10,
                                                        ),
                                                        spaceH(height: 24),
                                                        Row(
                                                          children: [
                                                            SizedBox(
                                                              width: ScreenSize.width(20, context),
                                                              child: Column(
                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                children: [
                                                                  TextCustom(
                                                                    title: "Item Type".tr,
                                                                    fontSize: 14,
                                                                    fontFamily: FontFamily.regular,
                                                                  ),
                                                                  Row(
                                                                    children: [
                                                                      controller.productModel.value.foodType == "Veg"
                                                                          ? SvgPicture.asset("assets/icons/ic_food_type.svg")
                                                                          : controller.productModel.value.foodType == "Non veg"
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
                                                                        title: controller.productModel.value.foodType.toString(),
                                                                        fontSize: 14,
                                                                        fontFamily: FontFamily.medium,
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                            Column(
                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                              children: [
                                                                TextCustom(
                                                                  title: "Category".tr,
                                                                  fontSize: 14,
                                                                  fontFamily: FontFamily.regular,
                                                                ),
                                                                TextCustom(
                                                                  title: controller.productModel.value.categoryModel!.categoryName.toString(),
                                                                  fontSize: 14,
                                                                  fontFamily: FontFamily.medium,
                                                                ),
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                        spaceH(height: 24),
                                                        Row(
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          children: [
                                                            if (controller.productModel.value.addonsList!.isNotEmpty)
                                                              SizedBox(
                                                                width: ScreenSize.width(20, context),
                                                                child: Column(
                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                  children: [
                                                                    TextCustom(
                                                                      title: "Add Ons".tr,
                                                                      fontSize: 14,
                                                                      fontFamily: FontFamily.regular,
                                                                    ),
                                                                    SizedBox(
                                                                      // width: 500,
                                                                      child: ListView.builder(
                                                                          shrinkWrap: true,
                                                                          itemCount: controller.productModel.value.addonsList!.length,
                                                                          itemBuilder: (context, index) {
                                                                            AddonsModel addonsModel = controller.productModel.value.addonsList![index];
                                                                            return Row(
                                                                              children: [
                                                                                SizedBox(
                                                                                  width: ScreenSize.width(10, context),
                                                                                  child: TextCustom(
                                                                                    title: addonsModel.name.toString(),
                                                                                    fontSize: 14,
                                                                                    fontFamily: FontFamily.medium,
                                                                                  ),
                                                                                ),
                                                                                TextCustom(
                                                                                  title: Constant.amountToShow(amount: addonsModel.price.toString()),
                                                                                  fontSize: 14,
                                                                                  fontFamily: FontFamily.medium,
                                                                                ),
                                                                              ],
                                                                            );
                                                                          }),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            if (controller.productModel.value.variationList!.isNotEmpty)
                                                              Column(
                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                children: [
                                                                  TextCustom(
                                                                    title: "Variation".tr,
                                                                    fontSize: 14,
                                                                    fontFamily: FontFamily.regular,
                                                                  ),
                                                                  SizedBox(
                                                                    width: 300,
                                                                    child: ListView.builder(
                                                                        shrinkWrap: true,
                                                                        itemCount: controller.productModel.value.variationList!.length,
                                                                        itemBuilder: (context, index) {
                                                                          VariationModel variationModel = controller.productModel.value.variationList![index];
                                                                          return Column(
                                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                                            children: [
                                                                              TextCustom(
                                                                                title: variationModel.name.toString(),
                                                                                fontSize: 14,
                                                                                fontFamily: FontFamily.medium,
                                                                              ),
                                                                              ListView.builder(
                                                                                  shrinkWrap: true,
                                                                                  itemCount: variationModel.optionList!.length,
                                                                                  itemBuilder: (context, index) {
                                                                                    OptionModel optionModel = variationModel.optionList![index];
                                                                                    return Row(
                                                                                      children: [
                                                                                        spaceW(),
                                                                                        SizedBox(
                                                                                          width: ScreenSize.width(10, context),
                                                                                          child: TextCustom(
                                                                                            title: optionModel.name.toString(),
                                                                                            fontSize: 14,
                                                                                            fontFamily: FontFamily.medium,
                                                                                          ),
                                                                                        ),
                                                                                        spaceW(),
                                                                                        TextCustom(
                                                                                          title: Constant.amountToShow(amount: optionModel.price.toString()),
                                                                                          fontSize: 14,
                                                                                          fontFamily: FontFamily.medium,
                                                                                        ),
                                                                                      ],
                                                                                    );
                                                                                  }),
                                                                            ],
                                                                          );
                                                                        }),
                                                                  ),
                                                                ],
                                                              ),
                                                          ],
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                            desktop: Container(
                                              decoration: BoxDecoration(
                                                  // color: themeChange.isDarkTheme() ? AppThemeData.lynch950 : AppThemeData.lynch50,
                                                  borderRadius: BorderRadius.circular(8)),
                                              child: Row(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  ClipRRect(
                                                    borderRadius: BorderRadius.circular(8),
                                                    child: CachedNetworkImage(
                                                      fit: BoxFit.fill,
                                                      height: ScreenSize.height(30, context),
                                                      width: ScreenSize.width(20, context),
                                                      imageUrl: controller.productModel.value.productImage.toString(),
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
                                                  Expanded(
                                                    child: Padding(
                                                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 0),
                                                      child: Column(
                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          Row(
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                            children: [
                                                              Column(
                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                children: [
                                                                  TextCustom(
                                                                    title: controller.productModel.value.productName.toString(),
                                                                    fontSize: 18,
                                                                    fontFamily: FontFamily.bold,
                                                                  ),
                                                                  FutureBuilder(
                                                                      future: FireStoreUtils.getRestaurantByRestaurantId(controller.productModel.value.vendorId.toString()),
                                                                      builder: (context, snapshot) {
                                                                        if (!snapshot.hasData) {
                                                                          return Container();
                                                                        }
                                                                        VendorModel restaurant = snapshot.data ?? VendorModel();
                                                                        return TextCustom(
                                                                          title: "by ${restaurant.vendorName}",
                                                                          fontFamily: FontFamily.regular,
                                                                          fontSize: 14,
                                                                        );
                                                                      }),
                                                                ],
                                                              ),
                                                              spaceW(width: 20),
                                                              TextCustom(
                                                                title: Constant.amountShow(amount: controller.productModel.value.price.toString()),
                                                                fontSize: 18,
                                                                fontFamily: FontFamily.bold,
                                                              ),
                                                            ],
                                                          ),
                                                          spaceH(),
                                                          Row(
                                                            children: [
                                                              RatingBar.builder(
                                                                glow: false,
                                                                initialRating: double.parse(
                                                                  controller
                                                                      .calculateReview(
                                                                        double.parse(controller.productModel.value.reviewSum.toString()),
                                                                        double.parse(controller.productModel.value.reviewCount.toString()),
                                                                      )
                                                                      .toStringAsFixed(1),
                                                                ),
                                                                minRating: 0,
                                                                direction: Axis.horizontal,
                                                                allowHalfRating: false,
                                                                itemCount: 5,
                                                                tapOnlyMode: false,
                                                                itemSize: 18,
                                                                ignoreGestures: true,
                                                                itemPadding: const EdgeInsets.symmetric(horizontal: 2.0),
                                                                unratedColor: themeChange.isDarkTheme() ? AppThemeData.lynch900 : AppThemeData.lynch100,
                                                                itemBuilder: (context, _) => const Icon(Icons.star, color: AppThemeData.warning200),
                                                                // itemBuilder: (context, _) =>
                                                                //     Icon(Icons.star, color: themeChange.isDarkTheme() ? AppThemeData.primaryWhite : AppThemeData.primary500),
                                                                onRatingUpdate: (rating) {
                                                                  // controller.rating(rating);
                                                                },
                                                              ),
                                                              spaceW(),
                                                              TextCustom(
                                                                  title: controller
                                                                      .calculateReview(
                                                                        double.parse(controller.productModel.value.reviewSum.toString()),
                                                                        double.parse(controller.productModel.value.reviewCount.toString()),
                                                                      )
                                                                      .toStringAsFixed(1)),
                                                            ],
                                                          ),
                                                          spaceH(height: 10),
                                                          TextCustom(
                                                            title: controller.productModel.value.description.toString(),
                                                            fontSize: 14,
                                                            fontFamily: FontFamily.regular,
                                                            color: themeChange.isDarkTheme() ? AppThemeData.lynch400 : AppThemeData.lynch500,
                                                            maxLine: 8,
                                                          ),
                                                          spaceH(height: 24),
                                                          Row(
                                                            children: [
                                                              SizedBox(
                                                                width: ScreenSize.width(17, context),
                                                                child: Column(
                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                  children: [
                                                                    TextCustom(
                                                                      title: "Item Type".tr,
                                                                      fontSize: 14,
                                                                      fontFamily: FontFamily.regular,
                                                                    ),
                                                                    Row(
                                                                      children: [
                                                                        controller.productModel.value.foodType == "Veg"
                                                                            ? SvgPicture.asset("assets/icons/ic_food_type.svg")
                                                                            : controller.productModel.value.foodType == "Non veg"
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
                                                                          title: controller.productModel.value.foodType.toString(),
                                                                          fontSize: 14,
                                                                          fontFamily: FontFamily.medium,
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                              Column(
                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                children: [
                                                                  TextCustom(
                                                                    title: "Category".tr,
                                                                    fontSize: 14,
                                                                    fontFamily: FontFamily.regular,
                                                                  ),
                                                                  TextCustom(
                                                                    title: controller.productModel.value.categoryModel!.categoryName.toString(),
                                                                    fontSize: 14,
                                                                    fontFamily: FontFamily.medium,
                                                                  ),
                                                                ],
                                                              ),
                                                            ],
                                                          ),
                                                          spaceH(height: 24),
                                                          Row(
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            children: [
                                                              if (controller.productModel.value.addonsList!.isNotEmpty)
                                                                SizedBox(
                                                                  width: ScreenSize.width(17, context),
                                                                  child: Column(
                                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                                    children: [
                                                                      TextCustom(
                                                                        title: "Add Ons".tr,
                                                                        fontSize: 14,
                                                                        fontFamily: FontFamily.regular,
                                                                      ),
                                                                      SizedBox(
                                                                        // width: 500,
                                                                        child: ListView.builder(
                                                                            shrinkWrap: true,
                                                                            itemCount: controller.productModel.value.addonsList!.length,
                                                                            itemBuilder: (context, index) {
                                                                              AddonsModel addonsModel = controller.productModel.value.addonsList![index];
                                                                              return Row(
                                                                                children: [
                                                                                  SizedBox(
                                                                                    width: ScreenSize.width(5, context),
                                                                                    child: TextCustom(
                                                                                      title: addonsModel.name.toString(),
                                                                                      fontSize: 14,
                                                                                      fontFamily: FontFamily.medium,
                                                                                    ),
                                                                                  ),
                                                                                  TextCustom(
                                                                                    title: Constant.amountToShow(amount: addonsModel.price.toString()),
                                                                                    fontSize: 14,
                                                                                    fontFamily: FontFamily.medium,
                                                                                  ),
                                                                                ],
                                                                              );
                                                                            }),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              if (controller.productModel.value.variationList!.isNotEmpty)
                                                                Column(
                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                  children: [
                                                                    TextCustom(
                                                                      title: "Variation".tr,
                                                                      fontSize: 14,
                                                                      fontFamily: FontFamily.regular,
                                                                    ),
                                                                    SizedBox(
                                                                      width: 500,
                                                                      child: ListView.builder(
                                                                          shrinkWrap: true,
                                                                          itemCount: controller.productModel.value.variationList!.length,
                                                                          itemBuilder: (context, index) {
                                                                            VariationModel variationModel = controller.productModel.value.variationList![index];
                                                                            return Column(
                                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                                              children: [
                                                                                TextCustom(
                                                                                  title: variationModel.name.toString(),
                                                                                  fontSize: 14,
                                                                                  fontFamily: FontFamily.medium,
                                                                                ),
                                                                                ListView.builder(
                                                                                    shrinkWrap: true,
                                                                                    itemCount: variationModel.optionList!.length,
                                                                                    itemBuilder: (context, index) {
                                                                                      OptionModel optionModel = variationModel.optionList![index];
                                                                                      return Row(
                                                                                        children: [
                                                                                          spaceW(),
                                                                                          SizedBox(
                                                                                            width: ScreenSize.width(5, context),
                                                                                            child: TextCustom(
                                                                                              title: optionModel.name.toString(),
                                                                                              fontSize: 14,
                                                                                              fontFamily: FontFamily.medium,
                                                                                            ),
                                                                                          ),
                                                                                          spaceW(),
                                                                                          TextCustom(
                                                                                            title: Constant.amountToShow(amount: optionModel.price.toString()),
                                                                                            fontSize: 14,
                                                                                            fontFamily: FontFamily.medium,
                                                                                          ),
                                                                                        ],
                                                                                      );
                                                                                    }),
                                                                              ],
                                                                            );
                                                                          }),
                                                                    ),
                                                                  ],
                                                                ),
                                                            ],
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ))
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ))
              ],
            ),
          );
        });
  }
}
