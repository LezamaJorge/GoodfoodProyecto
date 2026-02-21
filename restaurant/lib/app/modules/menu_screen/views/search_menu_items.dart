
// ignore_for_file: deprecated_member_use, depend_on_referenced_packages

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:restaurant/app/models/product_model.dart';
import 'package:restaurant/app/modules/add_menu_item_screen/views/add_menu_item_screen_view.dart';
import 'package:restaurant/app/modules/menu_screen/controllers/menu_screen_controller.dart';
import 'package:restaurant/app/widget/global_widgets.dart';
import 'package:restaurant/app/widget/network_image_widget.dart';
import 'package:restaurant/app/widget/search_field.dart';
import 'package:restaurant/app/widget/text_widget.dart';
import 'package:restaurant/constant/constant.dart';
import 'package:restaurant/constant_widgets/custom_dialog_box.dart';
import 'package:restaurant/constant_widgets/top_widget.dart';
import 'package:restaurant/themes/app_fonts.dart';
import 'package:restaurant/themes/app_theme_data.dart';
import 'package:restaurant/utils/dark_theme_provider.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SearchMenuItems extends StatefulWidget {
  const SearchMenuItems({super.key});

  @override
  SearchMenuItemsState createState() => SearchMenuItemsState();
}

class SearchMenuItemsState extends State<SearchMenuItems> {
  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);

    return GetBuilder<MenuScreenController>(
        init: MenuScreenController(),
        builder: (controller) {
          return Scaffold(
            appBar: AppBar(
              systemOverlayStyle: const SystemUiOverlayStyle(
                statusBarColor: Colors.transparent,
                statusBarIconBrightness: Brightness.dark, // Android → black
                statusBarBrightness: Brightness.light,    // iOS → black
              ),
              backgroundColor: Colors.transparent,
              surfaceTintColor: Colors.transparent,
              automaticallyImplyLeading: false,
              leading: GestureDetector(
                onTap: () {
                  Get.back();
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: themeChange.isDarkTheme() ? AppThemeData.grey900 : AppThemeData.grey100,
                    ),
                    child: Icon(
                      Icons.arrow_back_ios_sharp,
                      size: 20,
                      color: themeChange.isDarkTheme() ? AppThemeData.grey100 : AppThemeData.grey900,
                    ),
                  ),
                ),
              ),
            ),
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    buildTopWidget(context, "Search Your Menu Food", "Find your menu dishes from our extensive category list."),
                    spaceH(),
                    SearchField(
                      controller: controller.searchController.value,
                      onChanged: () {
                        controller.filterSearchResults();
                      },
                    ),
                    Obx(
                      () => controller.searchFoodList.isEmpty
                          ? Center(
                              child: Container(
                                margin: EdgeInsets.only(top: 50),
                                child: TextCustom(
                                  title: "No data available".tr,
                                  fontSize: 16,
                                  fontFamily: FontFamily.medium,
                                  color: themeChange.isDarkTheme() ? AppThemeData.grey400 : AppThemeData.grey600,
                                ),
                              ),
                            )
                          : ListView.builder(
                              itemCount: controller.searchFoodList.length,
                              shrinkWrap: true,
                              scrollDirection: Axis.vertical,
                              physics: AlwaysScrollableScrollPhysics(),
                              itemBuilder: (context, productIndex) {
                                ProductModel product = controller.searchFoodList[productIndex];
                                return Padding(
                                  padding: paddingEdgeInsets(horizontal: 0, vertical: 20),
                                  child: FittedBox(
                                    child: Row(
                                      children: [
                                        Stack(
                                          children: [
                                            NetworkImageWidget(
                                              imageUrl: product.productImage.toString(),
                                              width: 140.w,
                                              height: 162.h,
                                              borderRadius: 10,
                                              fit: BoxFit.cover,
                                            ),
                                            Container(
                                              margin: paddingEdgeInsets(horizontal: 8, vertical: 8),
                                              padding: paddingEdgeInsets(horizontal: 8, vertical: 4),
                                              decoration: BoxDecoration(
                                                color: themeChange.isDarkTheme() ? AppThemeData.grey900.withOpacity(0.8) : AppThemeData.grey100.withOpacity(0.8),
                                                borderRadius: BorderRadius.circular(5),
                                              ),
                                              child: TextCustom(
                                                title: product.itemTag.toString(),
                                                color: AppThemeData.getRandomColor(),
                                                fontSize: 12,
                                                fontFamily: FontFamily.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                        spaceW(width: 12),
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            SizedBox(
                                              width: 206.w,
                                              child: Row(
                                                children: [
                                                  Constant.showFoodType(name: product.foodType.toString()),
                                                  Spacer(),
                                                  GestureDetector(
                                                    onTap: () {
                                                      Get.to(()=>AddMenuItemsScreenView(), arguments: {'productModelId': product.id});
                                                    },
                                                    child: SvgPicture.asset(
                                                      "assets/icons/ic_edit_2.svg",
                                                      color: AppThemeData.secondary300,
                                                    ),
                                                  ),
                                                  spaceW(width: 12),
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
                                                              controller.removeItem(product.id.toString());
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
                                                        },
                                                      );
                                                    },
                                                    child: SvgPicture.asset(
                                                      "assets/icons/ic_delete.svg",
                                                      color: AppThemeData.danger300,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            TextCustom(
                                              title: product.productName.toString(),
                                              fontSize: 16,
                                              fontFamily: FontFamily.medium,
                                              color: themeChange.isDarkTheme() ? AppThemeData.grey50 : AppThemeData.grey1000,
                                            ),
                                            TextCustom(
                                              title: Constant.amountShow(amount: product.price.toString()),
                                              fontSize: 16,
                                              fontFamily: FontFamily.bold,
                                              color: themeChange.isDarkTheme() ? AppThemeData.grey50 : AppThemeData.grey1000,
                                            ),
                                            SizedBox(
                                              width: 206.w,
                                              child: TextCustom(
                                                title: product.description.toString(),
                                                maxLine: 1,
                                                textAlign: TextAlign.start,
                                                textOverflow: TextOverflow.ellipsis,
                                                color: themeChange.isDarkTheme() ? AppThemeData.grey400 : AppThemeData.grey600,
                                              ),
                                            ),
                                            spaceH(height: 8),
                                            SizedBox(
                                              height: 24.h,
                                              width: 150.w,
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Expanded(
                                                    child: TextCustom(
                                                      title: "In Stock".tr,
                                                      fontSize: 16,
                                                      color: themeChange.isDarkTheme() ? AppThemeData.grey300 : AppThemeData.grey700,
                                                    ),
                                                  ),
                                                  spaceW(width: 8),
                                                  Expanded(
                                                    child: SizedBox(
                                                      height: 26.h,
                                                      child: FittedBox(
                                                        child: CupertinoSwitch(
                                                          activeTrackColor: AppThemeData.primary300,
                                                          value: product.inStock!,
                                                          onChanged: (value) {
                                                            product.inStock = value;
                                                            controller.searchFoodList[productIndex].inStock = value;
                                                            controller.update();
                                                            controller.updateProduct(product);
                                                          },
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }
}
