// ignore_for_file: deprecated_member_use, depend_on_referenced_packages

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:restaurant/app/models/coupon_model.dart';
import 'package:restaurant/app/modules/add_restaurant_screen/views/add_restaurant_screen_view.dart';
import 'package:restaurant/app/modules/restaurant_screen/views/widget/restaurant_offer_widget.dart';
import 'package:restaurant/app/widget/global_widgets.dart';
import 'package:restaurant/app/widget/network_image_widget.dart';
import 'package:restaurant/app/widget/text_widget.dart';
import 'package:restaurant/constant/constant.dart';
import 'package:restaurant/constant_widgets/container_custom.dart';
import 'package:restaurant/constant_widgets/custom_dialog_box.dart';
import 'package:restaurant/constant_widgets/no_document_view.dart';
import 'package:restaurant/constant_widgets/no_restaurant_view.dart';
import 'package:restaurant/themes/app_fonts.dart';
import 'package:restaurant/themes/app_theme_data.dart';
import 'package:restaurant/themes/screen_size.dart';
import 'package:restaurant/utils/dark_theme_provider.dart';
import 'package:restaurant/themes/responsive.dart' as responsive_ui;
import '../controllers/restaurant_screen_controller.dart';

class RestaurantScreenView extends GetView<RestaurantScreenController> {
  const RestaurantScreenView({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetBuilder(
      init: RestaurantScreenController(),
      builder: (controller) {
        return Obx(
          () => controller.isLoading.value
              ? Constant.loader()
              : Constant.isDocumentVerificationEnable == true && controller.ownerModel.value.isVerified == false
                  ? NoDocumentView(
                      themeChange: themeChange,
                      controller: controller,
                    )
                  : controller.ownerModel.value.vendorId == null || controller.ownerModel.value.vendorId!.isEmpty
                      ? NoRestaurantView(
                          themeChange: themeChange,
                          controller: controller,
                        )
                      : Container(
                          width: responsive_ui.Responsive.width(100, context),
                          height: responsive_ui.Responsive.height(100, context),
                          decoration: BoxDecoration(
                              gradient: LinearGradient(
                                  stops: const [0.1, 0.3],
                                  colors: themeChange.isDarkTheme() ? [const Color(0xff1C1C22), const Color(0xff1C1C22)] : [const Color(0xffFDE7E7), const Color(0xffFFFFFF)],
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter)),
                          child: Scaffold(
                            backgroundColor: themeChange.isDarkTheme() ? const Color(0xff1C1C22) : const Color(0xffFFFFFF),
                            body: CustomScrollView(physics: const AlwaysScrollableScrollPhysics(), slivers: [
                              SliverPersistentHeader(
                                pinned: true,
                                delegate: ExampleAppBar(),
                              ),
                              SliverToBoxAdapter(
                                child: Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 16),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      if (Constant.ownerModel!.isVerified != true)
                                        Container(
                                          height: 68,
                                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(8),
                                            color: AppThemeData.secondary50,
                                          ),
                                          child: TextCustom(
                                            title: 'Your restaurant account is not verified. Please contact the admin for approval.'.tr,
                                            maxLine: 3,
                                            fontFamily: FontFamily.mediumItalic,
                                            textAlign: TextAlign.left,
                                            color: AppThemeData.secondary300,
                                          ),
                                        ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            crossAxisAlignment: CrossAxisAlignment.end,
                                            children: [
                                              TextCustom(
                                                title: "${controller.restaurantModel.value.vendorName.toString()} ",
                                                fontSize: 20,
                                                fontFamily: FontFamily.bold,
                                                color: themeChange.isDarkTheme() ? AppThemeData.grey50 : AppThemeData.grey1000,
                                              ),
                                              Container(
                                                margin: const EdgeInsets.only(bottom: 6, right: 3),
                                                alignment: Alignment.bottomCenter,
                                                height: 6.h,
                                                width: 6.w,
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: themeChange.isDarkTheme() ? AppThemeData.grey50 : AppThemeData.grey1000,
                                                ),
                                              ),
                                              spaceW(width: 4),
                                              TextCustom(
                                                title: controller.restaurantModel.value.cuisineName.toString(),
                                                fontSize: 16,
                                                color: themeChange.isDarkTheme() ? AppThemeData.grey50 : AppThemeData.grey1000,
                                              ),
                                            ],
                                          ),
                                          Constant.showFoodType(name: controller.restaurantModel.value.vendorType.toString())
                                        ],
                                      ),
                                      TextCustom(
                                        textAlign: TextAlign.left,
                                        title: controller.restaurantModel.value.address!.address.toString(),
                                        color: AppThemeData.grey500,
                                        textOverflow: TextOverflow.ellipsis,
                                        maxLine: 3,
                                      ),
                                      spaceH(height: 20.h),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          TextCustom(
                                            title: "Opening Hours".tr,
                                            fontSize: 16,
                                            fontFamily: FontFamily.regular,
                                            color: themeChange.isDarkTheme() ? AppThemeData.grey100 : AppThemeData.grey900,
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              Get.to((() => AddRestaurantScreenView()),
                                                  arguments: {"restaurantModel": controller.restaurantModel.value, "editPage": "Select Opening Hours"});
                                            },
                                            child: Wrap(children: [
                                              SvgPicture.asset(
                                                "assets/icons/ic_edit_2.svg",
                                                color: AppThemeData.info300,
                                                height: 16,
                                                width: 16,
                                              ),
                                              spaceW(width: 4),
                                              TextCustom(
                                                title: "Edit".tr,
                                                fontSize: 14,
                                                fontFamily: FontFamily.medium,
                                                isUnderLine: true,
                                                color: AppThemeData.info300,
                                              ),
                                            ]),
                                          ),
                                        ],
                                      ),
                                      ContainerCustom(
                                        padding: paddingEdgeInsets(horizontal: 16, vertical: 8),
                                        child: Theme(
                                          data: ThemeData().copyWith(dividerColor: Colors.transparent),
                                          child: ExpansionTile(
                                            tilePadding: paddingEdgeInsets(horizontal: 0, vertical: 0),
                                            minTileHeight: 8,
                                            initiallyExpanded: false,
                                            title: Align(
                                              alignment: Alignment.centerLeft,
                                              child: TextCustom(
                                                title: "Sun - Sat".tr,
                                                fontSize: 16,
                                                fontFamily: FontFamily.medium,
                                              ),
                                            ),
                                            children: [
                                              ListView.builder(
                                                padding: EdgeInsets.zero,
                                                physics: const NeverScrollableScrollPhysics(),
                                                shrinkWrap: true,
                                                itemCount: controller.restaurantModel.value.openingHoursList!.length,
                                                itemBuilder: (context, index) {
                                                  return rowTextWidget(
                                                      name: controller.restaurantModel.value.openingHoursList![index].day.toString(),
                                                      value: controller.restaurantModel.value.openingHoursList![index].isOpen!
                                                          ? "${controller.restaurantModel.value.openingHoursList![index].openingHours.toString()} to ${controller.restaurantModel.value.openingHoursList![index].closingHours.toString()}"
                                                          : "Closed");
                                                },
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                      spaceH(),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          TextCustom(
                                            title: "Restaurant Offer".tr,
                                            fontSize: 16,
                                            fontFamily: FontFamily.regular,
                                            color: themeChange.isDarkTheme() ? AppThemeData.grey100 : AppThemeData.grey900,
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              controller.setDefaultData();
                                              Get.to(() => RestaurantOfferWidget());
                                            },
                                            child: Wrap(children: [
                                              SvgPicture.asset(
                                                "assets/icons/ic_edit_2.svg",
                                                color: AppThemeData.info300,
                                                height: 16,
                                                width: 16,
                                              ),
                                              spaceW(width: 4),
                                              TextCustom(
                                                title: "Add Offer".tr,
                                                fontSize: 14,
                                                fontFamily: FontFamily.medium,
                                                isUnderLine: true,
                                                color: AppThemeData.info300,
                                              ),
                                            ]),
                                          ),
                                        ],
                                      ),
                                      ContainerCustom(
                                        padding: paddingEdgeInsets(horizontal: 16, vertical: 8),
                                        child: Theme(
                                          data: ThemeData().copyWith(dividerColor: Colors.transparent),
                                          child: ExpansionTile(
                                            tilePadding: paddingEdgeInsets(horizontal: 0, vertical: 0),
                                            minTileHeight: 8,
                                            initiallyExpanded: false,
                                            title: Align(
                                              alignment: Alignment.centerLeft,
                                              child: TextCustom(
                                                title: "All Offers".tr,
                                                fontSize: 16,
                                                fontFamily: FontFamily.medium,
                                              ),
                                            ),
                                            children: [
                                              ListView.builder(
                                                padding: EdgeInsets.zero,
                                                physics: const NeverScrollableScrollPhysics(),
                                                shrinkWrap: true,
                                                itemCount: controller.restaurantOfferList.length,
                                                itemBuilder: (context, index) {
                                                  CouponModel couponModel = controller.restaurantOfferList[index];
                                                  return controller.restaurantOfferList.isEmpty
                                                      ? TextCustom(title: 'No Available Offer'.tr)
                                                      : Container(
                                                          margin: EdgeInsets.only(bottom: 10),
                                                          width: ScreenSize.width(100, context),
                                                          decoration: BoxDecoration(
                                                            borderRadius: BorderRadius.all(Radius.circular(10)),
                                                            color: themeChange.isDarkTheme() ? AppThemeData.grey800 : AppThemeData.primaryWhite,
                                                          ),
                                                          padding: EdgeInsets.all(10),
                                                          child: Row(
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                            children: [
                                                              Column(
                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                children: [
                                                                  TextCustom(
                                                                    title: couponModel.title.toString(),
                                                                    maxLine: 3,
                                                                  ),
                                                                  SizedBox(height: 8),
                                                                  Row(
                                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                                    children: [
                                                                      Column(
                                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                                        children: [
                                                                          TextCustom(
                                                                            title: 'Amount : ${Constant.amountShow(amount: couponModel.amount.toString())}',
                                                                          ),
                                                                          TextCustom(
                                                                            title: 'Code : ${couponModel.code}',
                                                                          ),
                                                                          Transform.scale(
                                                                            scale: 0.8,
                                                                            child: CupertinoSwitch(
                                                                              activeTrackColor: AppThemeData.primary300,
                                                                              value: couponModel.active!,
                                                                              onChanged: (value) {
                                                                                couponModel.active = value;
                                                                                controller.isActive.value = value;
                                                                                controller.update();
                                                                                controller.updateOfferCoupon(couponModel);
                                                                              },
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ],
                                                              ),
                                                              Spacer(),
                                                              GestureDetector(
                                                                onTap: () {
                                                                  controller.isEditing.value = true;
                                                                  controller.couponTitleController.value.text = couponModel.title!;
                                                                  controller.couponCodeController.value.text = couponModel.code!;
                                                                  controller.couponMinAmountController.value.text = couponModel.minAmount!;
                                                                  controller.couponDiscountAmountController.value.text = couponModel.amount!;
                                                                  controller.expireDateController.value.text = Constant.timestampToDate(couponModel.expireAt!);
                                                                  controller.isActive.value = couponModel.active!;
                                                                  controller.editingId.value = couponModel.id!;
                                                                  controller.selectedAdminCommissionType.value = couponModel.isFix == true ? 'Fix' : 'Percentage';
                                                                  controller.couponPrivateType.value = couponModel.isPrivate == true ? 'Private' : 'Public';
                                                                  Get.to(() => RestaurantOfferWidget());
                                                                },
                                                                child: SvgPicture.asset(
                                                                  "assets/icons/ic_edit_2.svg",
                                                                  color: AppThemeData.secondary300,
                                                                ),
                                                              ),
                                                              spaceW(),
                                                              GestureDetector(
                                                                onTap: () {
                                                                  showDialog(
                                                                      context: context,
                                                                      builder: (BuildContext context) {
                                                                        return CustomDialogBox(
                                                                          img: Image.asset(
                                                                            "assets/animation/am_delete.gif",
                                                                            height: 64.h,
                                                                            width: 64.w,
                                                                          ),
                                                                          themeChange: themeChange,
                                                                          title: "Delete Item".tr,
                                                                          descriptions: "Are you sure you want to delete this item from the menu?".tr,
                                                                          positiveString: "Yes".tr,
                                                                          negativeString: "No".tr,
                                                                          positiveClick: () async {
                                                                            controller.removeOffer(couponModel);
                                                                            controller.restaurantOfferList.removeAt(index);
                                                                            Navigator.pop(context);
                                                                          },
                                                                          negativeClick: () {
                                                                            Navigator.pop(context);
                                                                          },
                                                                          positiveButtonColor: AppThemeData.danger300,
                                                                          negativeButtonColor: themeChange.isDarkTheme() ? AppThemeData.grey1000 : AppThemeData.grey50,
                                                                          positiveButtonTextColor: themeChange.isDarkTheme() ? AppThemeData.grey1000 : AppThemeData.grey50,
                                                                          negativeButtonTextColor: themeChange.isDarkTheme() ? AppThemeData.grey100 : AppThemeData.grey900,
                                                                          negativeButtonBorderColor: themeChange.isDarkTheme() ? AppThemeData.grey600 : AppThemeData.grey400,
                                                                        );
                                                                      });
                                                                },
                                                                child: SvgPicture.asset(
                                                                  "assets/icons/ic_delete.svg",
                                                                  color: AppThemeData.danger300,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        );
                                                },
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                      spaceH(),
                                    ],
                                  ),
                                ),
                              )
                            ]),
                          ),
                        ),
        );
      },
    );
  }
}

class ExampleAppBar extends SliverPersistentHeaderDelegate {
  final bottomHeight = 65;
  final extraRadius = 4;

  @override
  Widget build(context, shrinkOffset, overlapsContent) {
    final themeChange = Provider.of<DarkThemeProvider>(Get.context!);

    final imageTop = -shrinkOffset.clamp(0.0, maxExtent - minExtent - bottomHeight);
    final double clowsingRate = (shrinkOffset == 0 ? 0.0 : (shrinkOffset / (maxExtent - minExtent - bottomHeight))).clamp(0, 1);

    final double opacity = (shrinkOffset == minExtent ? 0.0 : 1.0 - (shrinkOffset.clamp(minExtent, minExtent + 30.h) - minExtent) / 30.h).clamp(0.0, 1.0);

    return GetX<RestaurantScreenController>(
      init: RestaurantScreenController(),
      builder: (controller) {
        final double logoOpacity = (1.0 - clowsingRate * 1.2).clamp(0.0, 1.0);
        return Stack(
          clipBehavior: Clip.none,
          children: [
            Positioned(
              top: imageTop,
              left: 0,
              right: 0,
              child: SizedBox(
                height: maxExtent - bottomHeight,
                child: ColoredBox(
                  color: themeChange.isDarkTheme() ? AppThemeData.grey1000 : AppThemeData.grey50,
                  child: Opacity(
                    opacity: opacity,
                    child: NetworkImageWidget(
                      imageUrl: controller.restaurantModel.value.coverImage.toString(),
                      height: 255.h,
                      width: ScreenSize.width(100, context),
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              top: 255.h - (120.h / 2),
              left: 16.w,
              child: AnimatedOpacity(
                opacity: logoOpacity,
                duration: Duration(milliseconds: 150),
                child: Transform.scale(
                  scale: 1.0 - (clowsingRate * 0.3),
                  alignment: Alignment.center,
                  child: ClipOval(
                    child: Container(
                      width: 122.w,
                      height: 122.w,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: Image.network(
                        controller.restaurantModel.value.logoImage.toString(),
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Icon(Icons.error),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                automaticallyImplyLeading: false,
                surfaceTintColor: themeChange.isDarkTheme() ? AppThemeData.grey1000 : AppThemeData.grey50,
                actions: [
                  Padding(
                    padding: EdgeInsets.only(right: 16.w),
                    child: GestureDetector(
                      onTap: () {
                        Get.to(() => AddRestaurantScreenView(), arguments: {"restaurantModel": controller.restaurantModel.value, "editPage": "Upload Restaurant Cover and Logo"});
                      },
                      child: Container(
                        height: 36.h,
                        width: 36.w,
                        decoration: BoxDecoration(
                          color: themeChange.isDarkTheme() ? AppThemeData.grey900 : AppThemeData.grey100,
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: SvgPicture.asset(
                            "assets/icons/ic_edit.svg",
                            height: 20.h,
                            width: 20.w,
                            color: themeChange.isDarkTheme() ? AppThemeData.grey200 : AppThemeData.grey800,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  double get maxExtent => 315.h;

  @override
  double get minExtent => Get.statusBarHeight;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) => true;
}

class InvertedCircleClipper extends CustomClipper<Path> {
  const InvertedCircleClipper({
    required this.offset,
    required this.radius,
  });

  final Offset offset;
  final double radius;

  @override
  Path getClip(size) {
    return Path()
      ..addOval(Rect.fromCircle(
        center: offset,
        radius: radius,
      ))
      ..addRect(Rect.fromLTWH(0.0, 0.0, size.width, size.height))
      ..fillType = PathFillType.evenOdd;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}

Padding rowTextWidget({required String name, required String value}) {
  final themeChange = Provider.of<DarkThemeProvider>(Get.context!);
  return Padding(
    padding: const EdgeInsets.only(top: 10),
    child: Row(
      children: [
        TextCustom(
          title: name.tr,
          fontSize: 16,
          fontFamily: FontFamily.medium,
          color: themeChange.isDarkTheme() ? AppThemeData.grey50 : AppThemeData.grey1000,
        ),
        const Spacer(),
        TextCustom(
          title: value.tr,
          fontSize: 16,
          fontFamily: FontFamily.medium,
          color: themeChange.isDarkTheme() ? AppThemeData.grey50 : AppThemeData.grey1000,
        ),
      ],
    ),
  );
}
