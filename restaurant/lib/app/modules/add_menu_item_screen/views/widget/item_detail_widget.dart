// ignore_for_file: must_be_immutable, deprecated_member_use, depend_on_referenced_packages

import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';
import 'package:restaurant/app/models/category_model.dart';
import 'package:restaurant/app/models/sub_category_model.dart';
import 'package:restaurant/app/modules/add_menu_item_screen/controllers/add_menu_item_screen_controller.dart';
import 'package:restaurant/app/widget/global_widgets.dart';
import 'package:restaurant/app/widget/text_field_widget.dart';
import 'package:restaurant/app/widget/text_widget.dart';
import 'package:restaurant/constant/constant.dart';
import 'package:restaurant/constant/show_toast_dialogue.dart';
import 'package:restaurant/constant_widgets/round_shape_button.dart';
import 'package:restaurant/themes/app_fonts.dart';
import 'package:restaurant/themes/app_theme_data.dart';
import 'package:restaurant/utils/dark_theme_provider.dart';

import '../../../../../themes/screen_size.dart';

class ItemDetailWidget extends GetView<AddMenuItemsScreenController> {
  ItemDetailWidget({super.key});

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetX<AddMenuItemsScreenController>(
      init: AddMenuItemsScreenController(),
      builder: (controller) {
        bool areImagesUploaded = controller.areAllDetailsFilledOfAddMenuItem();
        return Scaffold(
          backgroundColor: Colors.transparent,
          body: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Padding(
                padding: paddingEdgeInsets(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextCustom(
                      title: "Add Menu Item".tr,
                      fontSize: 28,
                      maxLine: 2,
                      color: themeChange.isDarkTheme() ? AppThemeData.grey100 : AppThemeData.grey1000,
                      fontFamily: FontFamily.bold,
                      textAlign: TextAlign.start,
                    ),
                    2.height,
                    TextCustom(
                      title: "Provide the details of the new menu item you want to add.".tr,
                      fontSize: 16,
                      maxLine: 2,
                      color: themeChange.isDarkTheme() ? AppThemeData.grey400 : AppThemeData.grey600,
                      fontFamily: FontFamily.regular,
                      textAlign: TextAlign.start,
                    ),
                    spaceH(height: 8),
                    Constant.vendorModel!.vendorType == "Both"
                        ? const SizedBox()
                        : Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.all(Radius.circular(12)),
                        color: themeChange.isDarkTheme() ? AppThemeData.pending600 : AppThemeData.pending50,
                      ),
                      child: Center(
                        child: TextCustom(
                          title: Constant.vendorModel!.vendorType == "Veg"
                              ? "Your Restaurant is Veg, so only Veg items can be added."
                              : "Your Restaurant is Non-Veg, so only Non-Veg items can be added.",
                          fontSize: 16,
                          maxLine: 2,
                          color: AppThemeData.pending300,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    spaceH(height: 8),
                    TextCustom(
                      title: "Item Image".tr,
                      color: themeChange.isDarkTheme() ? AppThemeData.grey100 : AppThemeData.grey900,
                      fontFamily: FontFamily.medium,
                    ),
                    spaceH(height: 8),
                    Row(
                      children: [
                        DottedBorder(
                          options: RectDottedBorderOptions(
                            dashPattern: const [6, 6, 6, 6],
                            strokeWidth: 2,
                            padding: EdgeInsets.all(16),
                            color: themeChange.isDarkTheme() ? AppThemeData.grey600 : AppThemeData.grey400,
                          ),
                          child: controller.itemImage.value.isEmpty
                              ? Container(
                            height: 120.h,
                            width: 120.w,
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.all(Radius.circular(12)),
                              color: themeChange.isDarkTheme() ? AppThemeData.surface1000 : AppThemeData.surface50,
                            ),
                            child: Padding(
                              padding: paddingEdgeInsets(),
                              child: Center(
                                child: SizedBox(
                                  height: 18,
                                  width: 18,
                                  child: SvgPicture.asset(
                                    "assets/icons/ic_gallary.svg",
                                    color: AppThemeData.primary300,
                                  ),
                                ),
                              ),
                            ),
                          )
                              : ClipRRect(
                            borderRadius: BorderRadius.circular(5),
                            child: Constant.hasValidUrl(controller.itemImage.value.toString())
                                ? Image.network(
                              controller.itemImage.value.toString(),
                              height: 120.h,
                              width: 120.w,
                              fit: BoxFit.cover,
                            )
                                : Image.file(
                              File(controller.itemImage.value.toString()),
                              height: 120.h,
                              width: 120.w,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        const Spacer(),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TextCustom(
                              title: "Upload the item images".tr,
                              maxLine: 2,
                              color: themeChange.isDarkTheme() ? AppThemeData.grey100 : AppThemeData.grey900,
                              fontFamily: FontFamily.regular,
                            ),
                            TextCustom(
                              title: "image must be a .jpg, .jpeg".tr,
                              maxLine: 1,
                              fontSize: 12,
                              color: AppThemeData.secondary300,
                              fontFamily: FontFamily.light,
                            ),
                            TextCustom(
                              title: "Image size will be 120*120px".tr,
                              maxLine: 1,
                              fontSize: 12,
                              color: themeChange.isDarkTheme() ? AppThemeData.grey400 : AppThemeData.grey600,
                              fontFamily: FontFamily.light,
                            ),
                            spaceH(),
                            RoundShapeButton(
                              titleWidget: TextCustom(
                                title: "Browse Image".tr,
                                fontSize: 14,
                                color: themeChange.isDarkTheme() ? AppThemeData.grey1000 : AppThemeData.grey50,
                              ),
                              title: "",
                              buttonColor: AppThemeData.primary300,
                              buttonTextColor: themeChange.isDarkTheme() ? AppThemeData.grey1000 : AppThemeData.grey50,
                              onTap: () {
                                controller.pickFile().then((value) {
                                  if (value != null) {
                                    controller.itemImage.value = value;
                                  }
                                });
                              },
                              size: Size(140.w, 42.h),
                            ),
                          ],
                        ),
                        const Spacer(),
                      ],
                    ),
                    spaceH(height: 20),
                    Constant.vendorModel!.vendorType == "Both"
                        ? Row(
                      children: [
                        Row(
                          children: [
                            Radio(
                              value: FoodType.veg.obs,
                              groupValue: controller.foodType.value,
                              onChanged: (value) {
                                controller.foodType.value = FoodType.veg;
                              },
                              activeColor: AppThemeData.primary300,
                            ),
                            TextCustom(
                              title: "Veg".tr,
                              fontSize: 16,
                              color: themeChange.isDarkTheme() ? AppThemeData.grey400 : AppThemeData.grey600,
                            )
                          ],
                        ),
                        Row(
                          children: [
                            Radio(
                              value: FoodType.nonVeg.obs,
                              groupValue: controller.foodType.value,
                              onChanged: (value) {
                                controller.foodType.value = FoodType.nonVeg;
                              },
                              activeColor: AppThemeData.primary300,
                            ),
                            TextCustom(
                              title: "Non Veg".tr,
                              fontSize: 16,
                              color: themeChange.isDarkTheme() ? AppThemeData.grey400 : AppThemeData.grey600,
                            )
                          ],
                        ),
                      ],
                    )
                        : SizedBox(),
                    spaceH(height: 12),
                    TextCustom(
                      title: "Item Details".tr,
                      color: themeChange.isDarkTheme() ? AppThemeData.grey100 : AppThemeData.grey900,
                      fontFamily: FontFamily.medium,
                    ),
                    spaceH(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextCustom(
                          title: "In Stock".tr,
                          color: themeChange.isDarkTheme() ? AppThemeData.grey300 : AppThemeData.grey700,
                          fontSize: 16,
                        ),
                        Obx(
                              () =>
                              SizedBox(
                                height: 26.h,
                                child: FittedBox(
                                  child: CupertinoSwitch(
                                    activeTrackColor: AppThemeData.primary300,
                                    value: controller.itemInStock.value,
                                    onChanged: (value) {
                                      controller.itemInStock.value = value;
                                    },
                                  ),
                                ),
                              ),
                        ),
                      ],
                    ),
                    TextFieldWidget(
                      color: themeChange.isDarkTheme() ? AppThemeData.grey900 : AppThemeData.grey100,
                      title: "Item Name".tr,
                      hintText: "Enter Item Name".tr,
                      controller: controller.itemNameController.value,
                      onPress: () {},
                    ),
                    TextFieldWidget(
                      color: themeChange.isDarkTheme() ? AppThemeData.grey900 : AppThemeData.grey100,
                      title: "Description".tr,
                      hintText: "Enter Description".tr,
                      controller: controller.itemDescriptionController.value,
                      onPress: () {},
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: DropdownButtonFormField<CategoryModel>(
                        isExpanded: true,
                        onChanged: (value) {
                          controller.selectedCategory.value = value!;
                          controller.getSubCategory(controller.selectedCategory.value.id.toString());
                        },
                        value: controller.selectedCategory.value.id == null ? null : controller.selectedCategory.value,
                        items: controller.categoryList.map((item) {
                          return DropdownMenuItem<CategoryModel>(
                            value: item,
                            child: Text(item.categoryName.toString()),
                          );
                        }).toList(),
                        validator: (value) => value != null ? null : 'This field required'.tr,
                        icon: Icon(Icons.keyboard_arrow_down_outlined, color: themeChange.isDarkTheme() ? AppThemeData.grey600 : AppThemeData.grey400),
                        borderRadius: BorderRadius.circular(6),
                        dropdownColor: themeChange.isDarkTheme() ? AppThemeData.grey800 : AppThemeData.grey200,
                        focusColor: Colors.transparent,
                        elevation: 0,
                        hint: TextCustom(
                            title: "Select Category".tr,
                            fontSize: 14,
                            color: themeChange.isDarkTheme() ? AppThemeData.grey400 : AppThemeData.grey600,
                            fontFamily: FontFamily.regular),
                        style: TextStyle(color: themeChange.isDarkTheme() ? AppThemeData.grey200 : AppThemeData.grey800, fontFamily: FontFamily.regular, fontSize: 14),
                        decoration: InputDecoration(
                          errorStyle: const TextStyle(fontFamily: FontFamily.regular),
                          isDense: true,
                          filled: true,
                          fillColor: themeChange.isDarkTheme() ? AppThemeData.grey900 : AppThemeData.grey50,
                          contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: themeChange.isDarkTheme() ? AppThemeData.grey600 : AppThemeData.grey400, width: 1),
                          ),
                          disabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: themeChange.isDarkTheme() ? AppThemeData.grey600 : AppThemeData.grey400, width: 1),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: themeChange.isDarkTheme() ? AppThemeData.grey600 : AppThemeData.grey400, width: 1),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(color: AppThemeData.danger300, width: 1),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: themeChange.isDarkTheme() ? AppThemeData.grey600 : AppThemeData.grey400, width: 1),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: AppThemeData.primary300, width: 1),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: DropdownButtonFormField<SubCategoryModel>(
                        isExpanded: true,
                        onChanged: (value) {
                          controller.selectedSubCategory.value = value!;
                        },
                        value: controller.selectedSubCategory.value.id == null ? null : controller.selectedSubCategory.value,
                        items: controller.subCategoryList.map((item) {
                          return DropdownMenuItem<SubCategoryModel>(
                            value: item,
                            child: Text(item.subCategoryName.toString()),
                          );
                        }).toList(),
                        validator: (value) => value != null ? null : 'This field required'.tr,
                        icon: Icon(Icons.keyboard_arrow_down_outlined, color: themeChange.isDarkTheme() ? AppThemeData.grey600 : AppThemeData.grey400),
                        borderRadius: BorderRadius.circular(6),
                        dropdownColor: themeChange.isDarkTheme() ? AppThemeData.grey800 : AppThemeData.grey200,
                        focusColor: Colors.transparent,
                        elevation: 0,
                        hint: TextCustom(
                            title: "Select Sub Category".tr,
                            fontSize: 14,
                            color: themeChange.isDarkTheme() ? AppThemeData.grey400 : AppThemeData.grey600,
                            fontFamily: FontFamily.regular),
                        style: TextStyle(color: themeChange.isDarkTheme() ? AppThemeData.grey200 : AppThemeData.grey800, fontFamily: FontFamily.regular, fontSize: 14),
                        decoration: InputDecoration(
                          errorStyle: const TextStyle(fontFamily: FontFamily.regular),
                          isDense: true,
                          filled: true,
                          fillColor: themeChange.isDarkTheme() ? AppThemeData.grey900 : AppThemeData.grey50,
                          contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: themeChange.isDarkTheme() ? AppThemeData.grey600 : AppThemeData.grey400, width: 1),
                          ),
                          disabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: themeChange.isDarkTheme() ? AppThemeData.grey600 : AppThemeData.grey400, width: 1),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: themeChange.isDarkTheme() ? AppThemeData.grey600 : AppThemeData.grey400, width: 1),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(color: AppThemeData.danger300, width: 1),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: themeChange.isDarkTheme() ? AppThemeData.grey600 : AppThemeData.grey400, width: 1),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: AppThemeData.primary300, width: 1),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          bottomNavigationBar: Padding(
            padding: paddingEdgeInsets(vertical: 8),
            child: RoundShapeButton(
              title: "Next".tr,
              buttonColor: areImagesUploaded
                  ? AppThemeData.primary300
                  : themeChange.isDarkTheme()
                  ? AppThemeData.grey800
                  : AppThemeData.grey200,
              buttonTextColor: areImagesUploaded ? AppThemeData.grey50 : AppThemeData.grey500,
              onTap: () {
                if (formKey.currentState!.validate()) {
                  areImagesUploaded ? controller.nextStep() : ShowToastDialog.toast("Please upload item images.".tr);
                }
              },
              size: Size(358.w, ScreenSize.height(6, context)),
            ),
          ),
        );
      },
    );
  }
}
