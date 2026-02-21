// ignore_for_file: deprecated_member_use, depend_on_referenced_packages

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:restaurant/app/models/category_model.dart';
import 'package:restaurant/app/models/product_model.dart';
import 'package:restaurant/app/modules/add_menu_item_screen/views/add_menu_item_screen_view.dart';
import 'package:restaurant/app/modules/menu_screen/controllers/menu_screen_controller.dart';
import 'package:restaurant/app/modules/menu_screen/views/search_menu_items.dart';
import 'package:restaurant/app/modules/my_wallet/views/my_wallet_view.dart';
import 'package:restaurant/app/modules/notification_screen/views/notification_screen_view.dart';
import 'package:restaurant/app/widget/global_widgets.dart';
import 'package:restaurant/app/widget/network_image_widget.dart';
import 'package:restaurant/app/widget/search_field.dart';
import 'package:restaurant/app/widget/text_widget.dart';
import 'package:restaurant/constant/constant.dart';
import 'package:restaurant/constant/show_toast_dialogue.dart';
import 'package:restaurant/constant_widgets/custom_dialog_box.dart';
import 'package:restaurant/constant_widgets/no_menu_items_view.dart';
import 'package:restaurant/themes/app_fonts.dart';
import 'package:restaurant/themes/app_theme_data.dart';
import 'package:restaurant/themes/responsive.dart';
import 'package:restaurant/utils/dark_theme_provider.dart';

class MenuScreenView extends StatelessWidget {
  const MenuScreenView({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetBuilder<MenuScreenController>(
        init: MenuScreenController(),
        builder: (controller) {
          return Obx(
            () => Container(
              width: Responsive.width(100, context),
              height: Responsive.height(100, context),
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      stops: const [0.1, 0.3],
                      colors: themeChange.isDarkTheme() ? [Color(0xff180202), Color(0xff1C1C22)] : [Color(0xffFDE7E7), Color(0xffFAFAFA)],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter)),
              child: Scaffold(
                backgroundColor: Colors.transparent,
                appBar: AppBar(
                  backgroundColor: Colors.transparent,
                  systemOverlayStyle: const SystemUiOverlayStyle(
                    statusBarColor: Colors.transparent,
                    statusBarIconBrightness: Brightness.dark, // Android → black
                    statusBarBrightness: Brightness.light, // iOS → black
                  ),
                  title: Row(
                    children: [
                      SizedBox(
                        height: 28,
                        width: 28,
                        child: SvgPicture.asset(
                          "assets/images/logo.svg",
                          color: AppThemeData.primary300,
                        ),
                      ),
                      spaceW(),
                      TextCustom(
                        title: Constant.appName.value,
                        fontSize: 20,
                        color: AppThemeData.primary300,
                        fontFamily: FontFamily.bold,
                      ),
                    ],
                  ),
                  actions: [
                    GestureDetector(
                      onTap: () {
                        Get.to(() => MyWalletView());
                      },
                      child: Container(
                        height: 36.h,
                        width: 36.w,
                        decoration: BoxDecoration(color: themeChange.isDarkTheme() ? AppThemeData.grey900 : AppThemeData.grey100, shape: BoxShape.circle),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SvgPicture.asset(
                            "assets/icons/ic_wallet.svg",
                            color: themeChange.isDarkTheme() ? AppThemeData.grey200 : AppThemeData.grey800,
                          ),
                        ),
                      ),
                    ),
                    spaceW(),
                    GestureDetector(
                      onTap: () {
                        Get.to(() => NotificationScreenView());
                      },
                      child: Container(
                        height: 36.h,
                        width: 36.w,
                        decoration: BoxDecoration(color: themeChange.isDarkTheme() ? AppThemeData.grey900 : AppThemeData.grey100, shape: BoxShape.circle),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SvgPicture.asset(
                            "assets/icons/ic_bell.svg",
                            color: themeChange.isDarkTheme() ? AppThemeData.grey200 : AppThemeData.grey800,
                          ),
                        ),
                      ),
                    ),
                    spaceW()
                  ],
                ),
                body: controller.isLoading.value
                    ? Constant.loader()
                    : controller.productList.isEmpty
                        ? NoMenuItemsView(
                            themeChange: themeChange,
                          )
                        : Obx(
                            () => SingleChildScrollView(
                              child: Padding(
                                padding: paddingEdgeInsets(),
                                child: Column(
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        Get.to(() => const SearchMenuItems());
                                      },
                                      child: IgnorePointer(
                                        ignoring: true,
                                        child: SearchField(
                                          controller: controller.notUseController.value,
                                          onChanged: () {},
                                          readOnly: true,
                                        ),
                                      ),
                                    ),
                                    spaceH(height: 16),
                                    SizedBox(
                                      height: 38.h,
                                      child: ListView.builder(
                                        scrollDirection: Axis.horizontal,
                                        physics: AlwaysScrollableScrollPhysics(),
                                        itemCount: controller.categoryList.length,
                                        itemBuilder: (context, index) {
                                          CategoryModel categoryModel = controller.categoryList[index];

                                          int productCount = categoryModel.id == 'all' ? controller.allProductList.length : controller.categoryProductCount[categoryModel.id] ?? 0;
                                          return GestureDetector(
                                            onTap: () {
                                              controller.selectedCategory.value = categoryModel;
                                              controller.isSubCategoryLoading.value = true;

                                              if (categoryModel.id == 'all') {
                                                controller.productList.value = controller.allProductList;
                                                controller.isSubCategoryLoading.value = false;
                                              } else {
                                                controller.getSubCategory(categoryModel.id.toString());
                                              }
                                            },
                                            child: Obx(
                                              () => Container(
                                                margin: EdgeInsets.only(right: 8),
                                                decoration: BoxDecoration(
                                                    color: controller.selectedCategory.value == controller.categoryList[index]
                                                        ? AppThemeData.secondary300
                                                        : themeChange.isDarkTheme()
                                                            ? AppThemeData.grey800
                                                            : AppThemeData.grey200,
                                                    borderRadius: BorderRadius.circular(30)),
                                                padding: paddingEdgeInsets(horizontal: 16, vertical: 8),
                                                child: Center(
                                                  child: TextCustom(
                                                    title: "${controller.categoryList[index].categoryName.toString()} ($productCount)",
                                                    color: controller.selectedCategory.value == controller.categoryList[index]
                                                        ? AppThemeData.grey50
                                                        : themeChange.isDarkTheme()
                                                            ? AppThemeData.grey400
                                                            : AppThemeData.grey600,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                    spaceH(height: 16),
                                    Obx(() {
                                      if (controller.selectedCategory.value.id == 'all') {
                                        return controller.productList.isEmpty
                                            ? Center(child: TextCustom(title: 'No Available Products'))
                                            : ListView.builder(
                                                shrinkWrap: true,
                                                itemCount: controller.productList.length,
                                                physics: NeverScrollableScrollPhysics(),
                                                itemBuilder: (context, index) {
                                                  ProductModel product = controller.productList[index];
                                                  return Padding(
                                                    padding: paddingEdgeInsets(horizontal: 0, vertical: 8),
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
                                                                    color:
                                                                        themeChange.isDarkTheme() ? AppThemeData.grey900.withOpacity(0.8) : AppThemeData.grey100.withOpacity(0.8),
                                                                    borderRadius: BorderRadius.circular(5)),
                                                                child: TextCustom(
                                                                  title: product.itemTag.toString(),
                                                                  color: AppThemeData.getRandomColor(),
                                                                  fontSize: 12,
                                                                  fontFamily: FontFamily.bold,
                                                                ),
                                                              )
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
                                                                        Get.to(() => AddMenuItemsScreenView(), arguments: {'productModelId': product.id});
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
                                                                            });
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
                                                                              controller.productList[index].inStock = value;
                                                                              controller.update();
                                                                              controller.updateProduct(product);
                                                                            },
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              )
                                                            ],
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  );
                                                },
                                              );
                                      } else {
                                        return controller.isSubCategoryLoading.value
                                            ? Constant.loader()
                                            : controller.subCategoryList.isEmpty
                                                ? Center(child: Container(margin: EdgeInsets.only(top: 50), child: TextCustom(title: 'No Available Menu Items')))
                                                : ListView.builder(
                                                    shrinkWrap: true,
                                                    itemCount: controller.subCategoryList.length,
                                                    scrollDirection: Axis.vertical,
                                                    physics: NeverScrollableScrollPhysics(),
                                                    itemBuilder: (context, index) {
                                                      final subCategory = controller.subCategoryList[index];
                                                      final products = controller.allProductList.where((product) => product.subCategoryId == subCategory.id).toList();
                                                      return ListTileTheme(
                                                        minLeadingWidth: 20,
                                                        child: Theme(
                                                          data: ThemeData().copyWith(dividerColor: Colors.transparent),
                                                          child: ExpansionTile(
                                                            initiallyExpanded: controller.isOpen.length > index && controller.isOpen[index],
                                                            onExpansionChanged: (value) {
                                                              if (index < controller.isOpen.length) {
                                                                controller.isOpen[index] = value;
                                                              } else {
                                                                controller.selectedSubCategory.value = controller.subCategoryList[index];
                                                                controller.filterProductList();
                                                              }
                                                            },
                                                            tilePadding: paddingEdgeInsets(horizontal: 0, vertical: 0),
                                                            minTileHeight: 8,
                                                            title: Align(
                                                              alignment: Alignment.centerLeft,
                                                              child: TextCustom(
                                                                title: subCategory.subCategoryName!.capitalizeFirst ?? '',
                                                                fontSize: 16,
                                                                fontFamily: FontFamily.medium,
                                                              ),
                                                            ),
                                                            children: [
                                                              ListView.builder(
                                                                itemCount: products.length,
                                                                shrinkWrap: true,
                                                                physics: NeverScrollableScrollPhysics(),
                                                                scrollDirection: Axis.vertical,
                                                                itemBuilder: (context, productIndex) {
                                                                  ProductModel product = products[productIndex];
                                                                  if (product.subCategoryId == controller.subCategoryList[index].id) {
                                                                    return Padding(
                                                                      padding: paddingEdgeInsets(horizontal: 0, vertical: 8),
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
                                                                                      color: themeChange.isDarkTheme()
                                                                                          ? AppThemeData.grey900.withOpacity(0.8)
                                                                                          : AppThemeData.grey100.withOpacity(0.8),
                                                                                      borderRadius: BorderRadius.circular(5)),
                                                                                  child: TextCustom(
                                                                                    title: product.itemTag.toString(),
                                                                                    color: AppThemeData.getRandomColor(),
                                                                                    fontSize: 12,
                                                                                    fontFamily: FontFamily.bold,
                                                                                  ),
                                                                                )
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
                                                                                          Get.to(() => AddMenuItemsScreenView(), arguments: {'productModelId': product.id});
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
                                                                                                  negativeButtonColor:
                                                                                                      themeChange.isDarkTheme() ? AppThemeData.grey1000 : AppThemeData.grey50,
                                                                                                  positiveButtonTextColor:
                                                                                                      themeChange.isDarkTheme() ? AppThemeData.grey1000 : AppThemeData.grey50,
                                                                                                  negativeButtonTextColor:
                                                                                                      themeChange.isDarkTheme() ? AppThemeData.grey100 : AppThemeData.grey900,
                                                                                                  negativeButtonBorderColor:
                                                                                                      themeChange.isDarkTheme() ? AppThemeData.grey600 : AppThemeData.grey400,
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
                                                                                                controller.filteredProductList[productIndex].inStock = value;
                                                                                                controller.update();
                                                                                                controller.updateProduct(product);
                                                                                              },
                                                                                            ),
                                                                                          ),
                                                                                        ),
                                                                                      ),
                                                                                    ],
                                                                                  ),
                                                                                )
                                                                              ],
                                                                            )
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    );
                                                                  }
                                                                  return Container();
                                                                },
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                  );
                                      }
                                    })
                                  ],
                                ),
                              ),
                            ),
                          ),
                floatingActionButton: FloatingActionButton(
                  onPressed: () {
                    if (Constant.ownerModel!.vendorId != null && Constant.ownerModel!.vendorId!.isNotEmpty) {
                      Get.to(() => AddMenuItemsScreenView());
                    } else {
                      ShowToastDialog.toast('First Add your restaurant to change Option.'.tr);
                    }
                  },
                  child: Icon(Icons.add),
                ),
              ),
            ),
          );
        });
  }
}
