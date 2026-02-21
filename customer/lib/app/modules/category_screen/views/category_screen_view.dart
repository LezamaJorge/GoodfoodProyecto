// ignore_for_file: deprecated_member_use, depend_on_referenced_packages

import 'package:customer/app/models/category_model.dart';
import 'package:customer/app/modules/category_restaurant_screen/views/category_restaurant_screen_view.dart';
import 'package:customer/app/modules/category_screen/controllers/category_screen_controller.dart';
import 'package:customer/app/modules/my_cart/views/my_cart_view.dart';
import 'package:customer/app/widget/global_widgets.dart';
import 'package:customer/app/widget/network_image_widget.dart';
import 'package:customer/app/widget/text_widget.dart';
import 'package:customer/constant_widgets/top_widget.dart';
import 'package:customer/themes/app_fonts.dart';
import 'package:customer/themes/app_theme_data.dart';
import 'package:customer/themes/common_ui.dart';
import 'package:customer/themes/responsive.dart';
import 'package:customer/utils/dark_theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class CategoryScreenView extends GetView<CategoryScreenController> {
  const CategoryScreenView({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);return GetX<CategoryScreenController>(
        init: CategoryScreenController(),
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
                      child: (controller.getCartItemCount() > 0)
                          ? Badge(
                              offset: const Offset(6, -8),
                              largeSize: 18,
                              padding: const EdgeInsets.fromLTRB(6, 0, 6, 0),
                              backgroundColor: AppThemeData.orange300,
                              label: TextCustom(
                                title: controller.getCartItemCount().toString(),
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
              body: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Column(
                    children: [
                      buildTopWidget(context, "Find Your Favorite Food", "Find your favorite dishes from our extensive category list."),
                      spaceH(height: 32),
                      GridView.builder(
                          shrinkWrap: true,
                          primary: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: controller.categoryList.length,
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, mainAxisSpacing: 16, crossAxisSpacing: 16, mainAxisExtent: 58),
                          itemBuilder: (context, index) {
                            CategoryModel category = controller.categoryList[index];
                            return Column(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    //Get.toNamed(Routes.CATEGORY_RESTAURANT, arguments: {"categoryModel": category});
                                    Get.to(const CategoryRestaurantScreenView(),arguments: {"categoryModel": category});
                                  },
                                  child: Container(
                                    height: 54.h,
                                    margin: const EdgeInsets.only(right: 0),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(100),
                                      border: Border.all(
                                        color: themeChange.isDarkTheme() ? AppThemeData.grey700 : AppThemeData.grey300,
                                      ),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8),
                                      child: Row(
                                        children: [
                                          NetworkImageWidget(
                                            imageUrl: category.image.toString(),
                                            height: 42.h,
                                            width: 42.h,
                                            borderRadius: 200,
                                            fit: BoxFit.cover,
                                          ),
                                          spaceW(width: 8),
                                          Expanded(
                                            child: TextCustom(
                                              title: category.categoryName.toString(),
                                              textOverflow: TextOverflow.ellipsis,
                                              fontFamily: FontFamily.light,
                                              textAlign: TextAlign.start,
                                              color: themeChange.isDarkTheme() ? AppThemeData.grey50 : AppThemeData.grey1000,
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            );
                          })
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }
}
