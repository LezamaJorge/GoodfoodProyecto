// ignore_for_file: deprecated_member_use, depend_on_referenced_packages

import 'package:customer/app/models/product_model.dart';
import 'package:customer/app/models/vendor_model.dart';
import 'package:customer/app/modules/home/controllers/home_controller.dart';
import 'package:customer/app/modules/my_cart/views/my_cart_view.dart';
import 'package:customer/app/modules/restaurant_detail_screen/controllers/restaurant_detail_screen_controller.dart';
import 'package:customer/app/modules/restaurant_detail_screen/views/restaurant_detail_screen_view.dart';
import 'package:customer/app/modules/search_food_screen/controllers/search_food_controller.dart';
import 'package:customer/app/widget/global_widgets.dart';
import 'package:customer/app/widget/network_image_widget.dart';
import 'package:customer/app/widget/search_field.dart';
import 'package:customer/app/widget/text_widget.dart';
import 'package:customer/constant/constant.dart';
import 'package:customer/constant/item_tag.dart';
import 'package:customer/constant/show_toast_dialog.dart';
import 'package:customer/constant_widgets/top_widget.dart';
import 'package:customer/extension/string_extensions.dart';
import 'package:customer/themes/app_fonts.dart';
import 'package:customer/themes/app_theme_data.dart';
import 'package:customer/themes/common_ui.dart';
import 'package:customer/themes/responsive.dart';
import 'package:customer/utils/dark_theme_provider.dart';
import 'package:customer/utils/fire_store_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class SearchFoodScreenView extends GetView<SearchFoodScreenController> {
  const SearchFoodScreenView({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    final RestaurantDetailScreenController restaurantDetailController = Get.put(RestaurantDetailScreenController());
    return GetX<SearchFoodScreenController>(
        init: SearchFoodScreenController(),
        builder: (controller) {
          return Container(
            width: Responsive.width(100, context),
            height: Responsive.height(100, context),
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    stops: const [0.2, 0.4],
                    colors: themeChange.isDarkTheme() ? [const Color(0xff1A0B00), const Color(0xff1C1C22)] : [const Color(0xffFFF1E5), const Color(0xffFFFFFF)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter)),
            child: Scaffold(
              backgroundColor: Colors.transparent,
              resizeToAvoidBottomInset: true,
              appBar: UiInterface.customAppBar(context, themeChange, "", backgroundColor: Colors.transparent, actions: [
                GestureDetector(
                  onTap: () {
                    Get.to(const MyCartView());
                  },
                  child: Container(
                    height: 36.h,
                    width: 36.w,
                    decoration: BoxDecoration(color: themeChange.isDarkTheme() ? AppThemeData.grey900 : AppThemeData.grey100, shape: BoxShape.circle),
                    child: Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: (restaurantDetailController.getCartItemCount() > 0)
                          ? Badge(
                              offset: const Offset(6, -8),
                              largeSize: 18,
                              padding: const EdgeInsets.fromLTRB(6, 0, 6, 0),
                              backgroundColor: AppThemeData.orange300,
                              label: TextCustom(
                                title: restaurantDetailController.getCartItemCount().toString(),
                                fontSize: 12,
                                fontFamily: FontFamily.regular,
                                color: themeChange.isDarkTheme() ? AppThemeData.grey1000 : AppThemeData.grey50,
                              ),
                              child: SvgPicture.asset(
                                "assets/icons/ic_cart.svg",
                                color: themeChange.isDarkTheme() ? AppThemeData.grey200 : AppThemeData.grey800,
                              ),
                            )
                          : SvgPicture.asset(
                              "assets/icons/ic_cart.svg",
                              color: themeChange.isDarkTheme() ? AppThemeData.grey200 : AppThemeData.grey800,
                            ),
                    ),
                  ),
                ),
                spaceW(width: 16)
              ]),
              body: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Column(
                  children: [
                    Column(
                      children: [
                        buildTopWidget(context, "Search Your Favorite Food", "Find your favorite dishes from our extensive category list."),
                        spaceH(height: 20.h),
                        SearchField(
                          controller: controller.searchController.value,
                          onChanged: (value) {
                            HomeController homeController = Get.put(HomeController());

                            controller.searchFoodNearby(
                                latitude: homeController.selectedAddress.value.location!.latitude!.toDouble(),
                                longitude: homeController.selectedAddress.value.location!.longitude!.toDouble(),
                                radius: Constant.restaurantRadius.toDouble());
                          },
                          onPress: () {},
                        ),
                        spaceH(height: 20),
                      ],
                    ),
                    Expanded(
                      flex: 4,
                      child: Obx(() {
                        if (controller.isLoading.value) {
                          return Constant.loader(); // Loading indicator
                        } else if (controller.searchProductList.isEmpty && controller.searchController.value.text.isNotEmpty) {
                          return const Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "No results found",
                                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.grey),
                                ),
                                SizedBox(height: 10),
                                Icon(Icons.search_off, size: 40, color: Colors.grey),
                              ],
                            ),
                          );
                        } else {
                          return SizedBox(
                            height: MediaQuery.of(context).size.height - 200,
                            // margin: EdgeInsets.only(bottom: 20),
                            child: ListView.builder(
                              padding: EdgeInsets.zero,
                              shrinkWrap: true,
                              scrollDirection: Axis.vertical,
                              itemCount: controller.searchProductList.length,
                              itemBuilder: (context, index) {
                                ProductModel product = controller.searchProductList[index];
                                bool isLiked = product.likedUser?.contains(FireStoreUtils.getCurrentUid()) ?? false;
                                return GestureDetector(
                                  onTap: () async {
                                    ShowToastDialog.showLoader("Please Wait..".tr);
                                    VendorModel? restaurantModel = await FireStoreUtils.getRestaurant(product.vendorId.toString());
                                    if (restaurantModel == null) {
                                      ShowToastDialog.closeLoader();
                                      ShowToastDialog.showToast("Restaurant not found.");
                                      return;
                                    }
                                    Get.to(const RestaurantDetailScreenView(), arguments: {"restaurantModel": restaurantModel});
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 8, bottom: 10),
                                    child: FittedBox(
                                      child: Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Stack(
                                            children: [
                                              NetworkImageWidget(
                                                imageUrl: product.productImage.toString(),
                                                height: 150.h,
                                                width: 140.w,
                                                borderRadius: 8,
                                              ),
                                              Positioned(
                                                top: 8,
                                                left: 8,
                                                child: Container(
                                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                                  decoration: BoxDecoration(
                                                      color: ItemTag.getItemTagBackgroundColor(product.itemTag.toString(), context), borderRadius: BorderRadius.circular(4)),
                                                  child: TextCustom(
                                                    title: ItemTag.getItemTagTitle(product.itemTag.toString()),
                                                    fontSize: 12,
                                                    fontFamily: FontFamily.medium,
                                                    color: ItemTag.getItemTagTitleColor(product.itemTag.toString(), context),
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                          spaceW(width: 12),
                                          SizedBox(
                                            width: 202.w,
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  children: [
                                                    SvgPicture.asset(
                                                      "assets/icons/ic_star.svg",
                                                    ),
                                                    spaceW(width: 5),
                                                    TextCustom(
                                                      title: Constant.calculateReview(
                                                        Constant.safeParse(product.reviewSum),
                                                        Constant.safeParse(product.reviewCount),
                                                      ).toStringAsFixed(1),
                                                      fontSize: 14,
                                                      fontFamily: FontFamily.regular,
                                                      color: themeChange.isDarkTheme() ? AppThemeData.grey50 : AppThemeData.grey1000,
                                                    ),
                                                    const Spacer(),
                                                    GestureDetector(
                                                        onTap: () async {
                                                          if (isLiked) {
                                                            product.likedUser!.remove(FireStoreUtils.getCurrentUid());
                                                          } else {
                                                            product.likedUser!.add(FireStoreUtils.getCurrentUid());
                                                          }
                                                          await FireStoreUtils.updateProduct(product);
                                                          controller.searchProductList.refresh();
                                                        },
                                                        child: isLiked ? SvgPicture.asset("assets/icons/ic_fill_favourite.svg") : SvgPicture.asset("assets/icons/ic_favorite.svg")),
                                                  ],
                                                ),
                                                Row(
                                                  children: [
                                                    SvgPicture.asset(
                                                      "assets/icons/ic_food_type.svg",
                                                      color: product.foodType == "Veg"
                                                          ? themeChange.isDarkTheme()
                                                              ? AppThemeData.success200
                                                              : AppThemeData.success400
                                                          : themeChange.isDarkTheme()
                                                              ? AppThemeData.danger200
                                                              : AppThemeData.danger400,
                                                      height: 18.h,
                                                      width: 18.w,
                                                    ),
                                                    spaceW(width: 4),
                                                    Expanded(
                                                        child: TextCustom(
                                                      title: product.productName.toString(),
                                                      fontSize: 16,
                                                      fontFamily: FontFamily.medium,
                                                      textAlign: TextAlign.start,
                                                      color: themeChange.isDarkTheme() ? AppThemeData.grey50 : AppThemeData.grey1000,
                                                    ))
                                                  ],
                                                ),
                                                TextCustom(
                                                  title: Constant.amountShow(amount: product.price.toString()),
                                                  fontSize: 16,
                                                  fontFamily: FontFamily.bold,
                                                  color: themeChange.isDarkTheme() ? AppThemeData.grey50 : AppThemeData.grey1000,
                                                ),
                                                TextCustom(
                                                  title: product.description.toString(),
                                                  fontSize: 14,
                                                  fontFamily: FontFamily.regular,
                                                  color: themeChange.isDarkTheme() ? AppThemeData.grey400 : AppThemeData.grey600,
                                                ),
                                                spaceH(height: 10),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          );
                        }
                      }),
                    )
                  ],
                ),
              ),
            ),
          );
        });
  }
}
