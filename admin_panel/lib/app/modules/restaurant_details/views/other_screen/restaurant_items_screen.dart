// ignore_for_file: deprecated_member_use, void_checks

import 'dart:io';

import 'package:admin_panel/app/components/custom_button.dart';
import 'package:admin_panel/app/components/custom_text_form_field.dart';
import 'package:admin_panel/app/components/dialog_box.dart';
import 'package:admin_panel/app/components/network_image_widget.dart';
import 'package:admin_panel/app/constant/constants.dart';
import 'package:admin_panel/app/constant/show_toast.dart';
import 'package:admin_panel/app/models/addons_model.dart';
import 'package:admin_panel/app/models/category_model.dart';
import 'package:admin_panel/app/models/vendor_model.dart';
import 'package:admin_panel/app/models/sub_category_model.dart';
import 'package:admin_panel/app/models/variation_model.dart';
import 'package:admin_panel/app/modules/restaurant_details/controllers/restaurant_items_controller.dart';
import 'package:admin_panel/app/routes/app_pages.dart';
import 'package:admin_panel/app/utils/app_colors.dart';
import 'package:admin_panel/app/utils/app_them_data.dart';
import 'package:admin_panel/app/utils/dark_theme_provider.dart';
import 'package:admin_panel/app/utils/fire_store_utils.dart';
import 'package:admin_panel/app/utils/responsive.dart';
import 'package:admin_panel/widget/common_ui.dart';
import 'package:admin_panel/widget/container_custom.dart';
import 'package:admin_panel/widget/global_widgets.dart';
import 'package:admin_panel/widget/text_widget.dart';
import 'package:admin_panel/widget/web_pagination.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';

class RestaurantItemsScreen extends GetView {
  const RestaurantItemsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<RestaurantItemsController>(
        init: RestaurantItemsController(),
        builder: (controller) {
          final themeChange = Provider.of<DarkThemeProvider>(context);
          return Scaffold(
            backgroundColor: themeChange.isDarkTheme() ? AppThemeData.primaryBlack : AppThemeData.primaryWhite,
            body: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Padding(
                      padding: paddingEdgeInsets(),
                      child: SingleChildScrollView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        child: Column(mainAxisSize: MainAxisSize.min, mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.start, children: [
                          ContainerCustom(
                            child: Column(children: [
                              ResponsiveWidget.isDesktop(context)
                                  ? Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                          TextCustom(title: controller.title.value, fontSize: 20, fontFamily: FontFamily.bold),
                                          spaceH(height: 2),
                                          Row(children: [
                                            InkWell(
                                                onTap: () => Get.offAllNamed(Routes.DASHBOARD_SCREEN),
                                                child: TextCustom(title: 'Dashboard'.tr, fontSize: 14, fontFamily: FontFamily.medium, color: AppThemeData.lynch500)),
                                            const TextCustom(title: ' / ', fontSize: 14, fontFamily: FontFamily.medium, color: AppThemeData.lynch500),
                                            TextCustom(title: ' ${controller.title.value} ', fontSize: 14, fontFamily: FontFamily.medium, color: AppThemeData.primary500)
                                          ])
                                        ]),
                                        spaceH(),
                                        Row(
                                          children: [
                                            SizedBox(
                                              width: ResponsiveWidget.isDesktop(context) ? MediaQuery.of(context).size.width * 0.15 : 200,
                                              child: CustomTextFormField(
                                                hintText: "Search here".tr,
                                                controller: controller.searchController.value,
                                                onFieldSubmitted: (value) async {
                                                  if (controller.isSearchEnable.value) {
                                                    await FireStoreUtils.countSearchProduct(controller.searchController.value.text);
                                                    controller.setPagination(controller.totalItemPerPage.value);
                                                    controller.isSearchEnable.value = false;
                                                  } else {
                                                    controller.searchController.value.text = "";
                                                    controller.getUser();
                                                    controller.isSearchEnable.value = true;
                                                  }
                                                },
                                                suffix: IconButton(
                                                  onPressed: () async {
                                                    if (controller.isSearchEnable.value) {
                                                      await FireStoreUtils.countSearchProduct(controller.searchController.value.text);
                                                      controller.setPagination(controller.totalItemPerPage.value);
                                                      controller.isSearchEnable.value = false;
                                                    } else {
                                                      controller.searchController.value.text = "";
                                                      controller.getUser();
                                                      controller.isSearchEnable.value = true;
                                                    }
                                                  },
                                                  icon: Icon(
                                                    controller.isSearchEnable.value ? Icons.search : Icons.clear,
                                                  ),
                                                ),
                                                title: '',
                                              ),
                                            ),
                                            spaceW(),
                                            NumberOfRowsDropDown(
                                              controller: controller,
                                            ),
                                            spaceW(),
                                            CustomButtonWidget(
                                                title: "+ Add Item".tr,
                                                onPress: () {
                                                  controller.setDefaultData();
                                                  showDialog(context: context, builder: (context) => const AddItemDialog());
                                                })
                                          ],
                                        )
                                      ],
                                    )
                                  : Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                          TextCustom(title: controller.title.value, fontSize: 20, fontFamily: FontFamily.bold),
                                          spaceH(height: 2),
                                          Row(children: [
                                            InkWell(
                                                onTap: () => Get.offAllNamed(Routes.DASHBOARD_SCREEN),
                                                child: TextCustom(title: 'Dashboard'.tr, fontSize: 14, fontFamily: FontFamily.medium, color: AppThemeData.lynch500)),
                                            const TextCustom(title: ' / ', fontSize: 14, fontFamily: FontFamily.medium, color: AppThemeData.lynch500),
                                            TextCustom(title: ' ${controller.title.value} ', fontSize: 14, fontFamily: FontFamily.medium, color: AppThemeData.primary500)
                                          ])
                                        ]),
                                        spaceH(),
                                        SizedBox(
                                          height: 50,
                                          width: MediaQuery.sizeOf(context).width * 0.8,
                                          child: CustomTextFormField(
                                            hintText: "Search here".tr,
                                            controller: controller.searchController.value,
                                            onFieldSubmitted: (value) async {
                                              if (controller.isSearchEnable.value) {
                                                await FireStoreUtils.countSearchProduct(controller.searchController.value.text);
                                                controller.setPagination(controller.totalItemPerPage.value);
                                                controller.isSearchEnable.value = false;
                                              } else {
                                                controller.searchController.value.text = "";
                                                controller.getUser();
                                                controller.isSearchEnable.value = true;
                                              }
                                            },
                                            suffix: IconButton(
                                              onPressed: () async {
                                                if (controller.isSearchEnable.value) {
                                                  await FireStoreUtils.countSearchProduct(controller.searchController.value.text);
                                                  controller.setPagination(controller.totalItemPerPage.value);
                                                  controller.isSearchEnable.value = false;
                                                } else {
                                                  controller.searchController.value.text = "";
                                                  controller.getUser();
                                                  controller.isSearchEnable.value = true;
                                                }
                                              },
                                              icon: Icon(
                                                controller.isSearchEnable.value ? Icons.search : Icons.clear,
                                              ),
                                            ),
                                            title: '',
                                          ),
                                        ),
                                        spaceH(),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            NumberOfRowsDropDown(
                                              controller: controller,
                                            ),
                                            CustomButtonWidget(
                                                title: "+ Add Item".tr,
                                                onPress: () {
                                                  controller.setDefaultData();
                                                  showDialog(context: context, builder: (context) => const AddItemDialog());
                                                })
                                          ],
                                        )
                                      ],
                                    ),
                              spaceH(height: 20),
                              SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: controller.isLoading.value
                                      ? Padding(
                                          padding: paddingEdgeInsets(),
                                          child: Constant.loader(),
                                        )
                                      : controller.currentPageUser.isEmpty
                                          ? TextCustom(title: "No Data available".tr)
                                          : DataTable(
                                              horizontalMargin: 20,
                                              columnSpacing: 30,
                                              dataRowMaxHeight: 65,
                                              headingRowHeight: 65,
                                              border: TableBorder.all(
                                                color: themeChange.isDarkTheme() ? AppThemeData.lynch800 : AppThemeData.lynch100,
                                                borderRadius: BorderRadius.circular(12),
                                              ),
                                              headingRowColor: WidgetStateColor.resolveWith((states) => themeChange.isDarkTheme() ? AppThemeData.lynch800 : AppThemeData.lynch100),
                                              columns: [
                                                CommonUI.dataColumnWidget(context, columnTitle: "Image".tr, width: 150),
                                                CommonUI.dataColumnWidget(context, columnTitle: "Name".tr, width: ResponsiveWidget.isMobile(context) ? 150 : MediaQuery.of(context).size.width * 0.12),
                                                CommonUI.dataColumnWidget(context,
                                                    columnTitle: "Category".tr, width: ResponsiveWidget.isMobile(context) ? 150 : MediaQuery.of(context).size.width * 0.12),
                                                CommonUI.dataColumnWidget(context,
                                                    columnTitle: "Restaurant Name".tr, width: ResponsiveWidget.isMobile(context) ? 150 : MediaQuery.of(context).size.width * 0.12),
                                                CommonUI.dataColumnWidget(context, columnTitle: "Created At".tr, width: 220),
                                                CommonUI.dataColumnWidget(context, columnTitle: "Price".tr, width: 100),
                                                CommonUI.dataColumnWidget(context,
                                                    columnTitle: "Status".tr, width: ResponsiveWidget.isMobile(context) ? 100 : MediaQuery.of(context).size.width * 0.05),
                                                CommonUI.dataColumnWidget(context, columnTitle: "Action".tr, width: ResponsiveWidget.isMobile(context) ? 100 : MediaQuery.of(context).size.width * 0.08)
                                              ],
                                              rows: controller.currentPageUser
                                                  .map((productModel) => DataRow(cells: [
                                                        DataCell(
                                                          Container(
                                                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                                                            child: NetworkImageWidget(
                                                              imageUrl: '${productModel.productImage}',
                                                              height: 37,
                                                              width: 37,
                                                            ),
                                                          ),
                                                        ),
                                                        DataCell(TextCustom(title: productModel.productName.toString())),
                                                        DataCell(TextCustom(title: productModel.categoryModel!.categoryName.toString())),
                                                        DataCell(FutureBuilder(
                                                          future: FireStoreUtils.getRestaurantByRestaurantId(productModel.vendorId.toString()),
                                                          builder: (context, snapshot) {
                                                            if (!snapshot.hasData) {
                                                              return Container();
                                                            }
                                                            VendorModel restaurant = snapshot.data ?? VendorModel();
                                                            return TextCustom(
                                                              title: restaurant.vendorName.toString(),
                                                              fontSize: 14,
                                                              fontFamily: FontFamily.regular,
                                                            );
                                                          },
                                                        )),
                                                        DataCell(TextCustom(title: productModel.createAt == null ? '' : Constant.timestampToDateTime(productModel.createAt!))),
                                                        DataCell(TextCustom(title: Constant.amountShow(amount: productModel.price.toString()), fontSize: 14, fontFamily: FontFamily.regular)),
                                                        DataCell(
                                                          Transform.scale(
                                                            scale: 0.8,
                                                            child: CupertinoSwitch(
                                                              activeTrackColor: AppThemeData.primary500,
                                                              value: productModel.status ?? false,
                                                              onChanged: (value) async {
                                                                productModel.status = value;
                                                                await FireStoreUtils.updateItems(productModel);
                                                                controller.getUser();
                                                              },
                                                            ),
                                                          ),
                                                        ),
                                                        DataCell(Container(
                                                          alignment: Alignment.center,
                                                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                                                          child: Row(
                                                            mainAxisAlignment: MainAxisAlignment.start,
                                                            children: [
                                                              InkWell(
                                                                onTap: () async {
                                                                  Get.toNamed("${Routes.FOOD_DETAIL}/${productModel.id}");
                                                                },
                                                                child: SvgPicture.asset(
                                                                  "assets/icons/ic_eye.svg",
                                                                  color: AppThemeData.lynch400,
                                                                  height: 16,
                                                                  width: 16,
                                                                ),
                                                              ),
                                                              spaceW(width: 20),
                                                              InkWell(
                                                                onTap: () async {
                                                                  controller.isEditing.value = true;
                                                                  controller.getArguments(productModel);
                                                                  showDialog(context: context, builder: (context) => const AddItemDialog());
                                                                },
                                                                child: SvgPicture.asset(
                                                                  "assets/icons/ic_edit.svg",
                                                                  color: AppThemeData.lynch400,
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
                                                                    // await controller.removePassengers(userModel);
                                                                    // controller.getUser();
                                                                    bool confirmDelete = await DialogBox.showConfirmationDeleteDialog(context);
                                                                    if (confirmDelete) {
                                                                      await controller.removeProduct(productModel);
                                                                      controller.getUser();
                                                                    }
                                                                  }
                                                                },
                                                                child: SvgPicture.asset(
                                                                  "assets/icons/ic_delete.svg",
                                                                  color: AppThemeData.lynch400,
                                                                  height: 16,
                                                                  width: 16,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        )),
                                                      ]))
                                                  .toList()),
                                ),
                              ),
                              spaceH(),
                              ResponsiveWidget.isMobile(context)
                                  ? Visibility(
                                      visible: controller.totalPage.value > 1,
                                      child: SingleChildScrollView(
                                        // Wrap the Row with SingleChildScrollView
                                        scrollDirection: Axis.horizontal, // Enable horizontal scrolling
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.end,
                                          children: [
                                            WebPagination(
                                              currentPage: controller.currentPage.value,
                                              totalPage: controller.totalPage.value,
                                              displayItemCount: controller.pageValue("5"),
                                              onPageChanged: (page) {
                                                controller.currentPage.value = page;
                                                controller.setPagination(controller.totalItemPerPage.value);
                                              },
                                            ),
                                          ],
                                        ),
                                      ),
                                    )
                                  : Visibility(
                                      visible: controller.totalPage.value > 1,
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: [
                                          Align(
                                            alignment: Alignment.centerRight,
                                            child: WebPagination(
                                                currentPage: controller.currentPage.value,
                                                totalPage: controller.totalPage.value,
                                                displayItemCount: controller.pageValue("5"),
                                                onPageChanged: (page) {
                                                  controller.currentPage.value = page;
                                                  controller.setPagination(controller.totalItemPerPage.value);
                                                }),
                                          )
                                        ],
                                      ),
                                    ),
                            ]),
                          )
                        ]),
                      )),
                ),
              ],
            ),
          );
        });
  }
}

class AddItemDialog extends StatelessWidget {
  const AddItemDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetX<RestaurantItemsController>(
      init: RestaurantItemsController(),
      builder: (controller) {
        return CustomDialog(
          width: ResponsiveWidget.isDesktop(context) ? MediaQuery.of(context).size.width * .6 : MediaQuery.of(context).size.width * .8,
          title: controller.isEditing.value ? "Edit Item".tr : "Add Item".tr,
          controller: controller,
          widgetList: [
            Visibility(
              visible: controller.isEditing.value,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "✍ Edit your Item here".tr,
                    style: TextStyle(
                      fontFamily: FontFamily.bold,
                      fontWeight: FontWeight.w800,
                      fontSize: 16,
                      color: themeChange.isDarkTheme() ? AppThemeData.primaryWhite : AppThemeData.textBlack,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: controller.isEditing.value == true
                      ? InkWell(
                          onTap: () async {
                            if (Constant.isDemo) {
                              DialogBox.demoDialogBox();
                            } else {
                              ImagePicker picker = ImagePicker();
                              final img = await picker.pickImage(source: ImageSource.gallery, imageQuality: 80);
                              if (img != null) {
                                File imageFile = File(img.path);
                                controller.imageController.value.text = img.name;
                                controller.imageFile.value = imageFile;
                                controller.mimeType.value = "${img.mimeType}";
                                // controller.isImageUpdated.value = true;
                              }
                            }
                          },
                          child: DottedBorder(
                            options: RoundedRectDottedBorderOptions(
                              dashPattern: const [6, 6, 6, 6],
                              color: themeChange.isDarkTheme() ? AppThemeData.lynch700 : AppThemeData.lynch300,
                              radius: const Radius.circular(12),
                            ),
                            child: Container(
                                height: 150.h,
                                width: 250.h,
                                decoration: const BoxDecoration(
                                  borderRadius: BorderRadius.all(Radius.circular(12)),
                                ),
                                child: NetworkImageWidget(
                                  imageUrl: controller.imageFile.value.path.isEmpty ? controller.imageURL.value : controller.imageFile.value.path,
                                  height: 150.h,
                                  // width: 250.w,
                                  fit: BoxFit.contain,
                                )),
                          ),
                        )
                      : InkWell(
                          onTap: () async {
                            if (Constant.isDemo) {
                              DialogBox.demoDialogBox();
                            } else {
                              ImagePicker picker = ImagePicker();
                              final img = await picker.pickImage(source: ImageSource.gallery, imageQuality: 80);
                              if (img != null) {
                                File imageFile = File(img.path);
                                controller.imageController.value.text = img.name;
                                controller.imageFile.value = imageFile;
                                controller.mimeType.value = "${img.mimeType}";
                                // controller.isImageUpdated.value = true;
                              }
                            }
                          },
                          child: DottedBorder(
                            options: RoundedRectDottedBorderOptions(
                              dashPattern: const [6, 6, 6, 6],
                              color: themeChange.isDarkTheme() ? AppThemeData.lynch700 : AppThemeData.lynch300,
                              radius: const Radius.circular(12),
                            ),
                            child: Container(
                                height: 150.h,
                                width: 250.h,
                                decoration: const BoxDecoration(
                                  borderRadius: BorderRadius.all(Radius.circular(12)),
                                ),
                                child: controller.imageFile.value.path.isNotEmpty
                                    ? NetworkImageWidget(
                                        imageUrl: controller.imageFile.value.path,
                                        height: 150.h,
                                        //width: double.infinity,
                                        fit: BoxFit.contain,
                                      )
                                    : Padding(
                                        padding: paddingEdgeInsets(),
                                        child: Center(
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              SvgPicture.asset(
                                                "assets/icons/ic_upload.svg",
                                                color: AppThemeData.lynch500,
                                              ),
                                              spaceH(height: 16),
                                              TextCustom(
                                                title: "Upload Image".tr,
                                                maxLine: 2,
                                                color: themeChange.isDarkTheme() ? AppThemeData.primaryWhite : AppThemeData.primaryBlack,
                                                fontFamily: FontFamily.regular,
                                              ),
                                            ],
                                          ),
                                        ),
                                      )),
                          ),
                        ),
                ),
                spaceH(height: 24),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        SvgPicture.asset("assets/new_icon/ic_scroll.svg"),
                        spaceW(width: 8),
                        TextCustom(
                          title: "Item Details".tr,
                          fontSize: 16,
                          fontFamily: FontFamily.medium,
                        ),
                      ],
                    ),
                    spaceH(height: 16),
                    CustomTextFormField(hintText: "Enter Item Name".tr, title: "Item Name *".tr, controller: controller.itemNameController.value),
                    spaceH(height: 16),
                    CustomTextFormField(
                      hintText: "Enter Item Description".tr,
                      title: "Item Description *".tr,
                      controller: controller.itemDescriptionController.value,
                      maxLine: 2,
                    ),
                    spaceH(height: 16),
                    TextCustom(
                      title: "Restaurant Name *".tr,
                      fontSize: 14,
                    ),
                    spaceH(height: 10),
                    DropdownButtonFormField<VendorModel>(
                      isExpanded: true,
                      dropdownColor: themeChange.isDarkTheme() ? AppThemeData.lynch800 : AppThemeData.lynch100,
                      style: TextStyle(
                        fontFamily: FontFamily.medium,
                        color: themeChange.isDarkTheme() ? AppThemeData.primaryWhite : AppThemeData.textBlack,
                      ),
                      hint: TextCustom(
                          title: 'Select Restaurant Name'.tr, fontSize: 14, fontFamily: FontFamily.regular, color: themeChange.isDarkTheme() ? AppThemeData.lynch300 : AppThemeData.lynch400),
                      onChanged: (restaurant) {
                        controller.selectedRestaurantId.value = restaurant!;
                      },
                      validator: (value) => value != null ? null : 'This field required'.tr,
                      value: controller.selectedRestaurantId.value.id == null ? null : controller.selectedRestaurantId.value,
                      icon: const Icon(Icons.keyboard_arrow_down_outlined),
                      items: controller.restaurantList.map((value) {
                        return DropdownMenuItem<VendorModel>(
                          value: value,
                          child: Text(
                            value.vendorName.toString(),
                            style: TextStyle(
                              fontFamily: FontFamily.regular,
                              fontSize: 14,
                              color: themeChange.isDarkTheme() ? AppThemeData.lynch200 : AppThemeData.lynch800,
                            ),
                          ),
                        );
                      }).toList(),
                      decoration: Constant.DefaultInputDecoration(context),
                    ),
                    spaceH(height: 16),
                    Row(
                      children: [
                        Expanded(
                            child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextCustom(
                              title: 'Item Type *'.tr,
                              fontSize: 14,
                            ),
                            spaceH(height: 10),
                            Obx(
                              () => DropdownButtonFormField(
                                isExpanded: true,
                                dropdownColor: themeChange.isDarkTheme() ? AppThemeData.lynch800 : AppThemeData.lynch100,
                                style: TextStyle(
                                  fontFamily: FontFamily.medium,
                                  color: themeChange.isDarkTheme() ? AppThemeData.primaryWhite : AppThemeData.textBlack,
                                ),
                                hint: TextCustom(
                                    title: 'Select Item Type'.tr, fontSize: 14, fontFamily: FontFamily.regular, color: themeChange.isDarkTheme() ? AppThemeData.lynch300 : AppThemeData.lynch400),
                                onChanged: (String? taxType) {
                                  controller.selectedItemType.value = taxType ?? "Veg";
                                },
                                value: controller.selectedItemType.value,
                                icon: const Icon(Icons.keyboard_arrow_down_outlined),
                                items: controller.itemType.map<DropdownMenuItem<String>>((String value) {
                                  return DropdownMenuItem(
                                    value: value,
                                    child: Text(
                                      value,
                                      style: TextStyle(
                                        fontFamily: FontFamily.regular,
                                        fontSize: 14,
                                        color: themeChange.isDarkTheme() ? AppThemeData.lynch200 : AppThemeData.lynch800,
                                      ),
                                    ),
                                  );
                                }).toList(),
                                decoration: Constant.DefaultInputDecoration(context),
                              ),
                            ),
                          ],
                        )),
                        spaceW(width: 20),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              TextCustom(
                                title: "In Stock *".tr,
                                fontSize: 14,
                              ),
                              Transform.scale(
                                scale: 0.8,
                                child: CupertinoSwitch(
                                  activeTrackColor: AppThemeData.primary300,
                                  value: controller.itemInStock.value,
                                  onChanged: (value) {
                                    controller.itemInStock.value = value;
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                        spaceW(width: 20),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              TextCustom(
                                title: "Status *".tr,
                                fontSize: 14,
                              ),
                              Transform.scale(
                                scale: 0.8,
                                child: CupertinoSwitch(
                                  activeTrackColor: AppThemeData.primary300,
                                  value: controller.isActive.value,
                                  onChanged: (value) {
                                    controller.isActive.value = value;
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    spaceH(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TextCustom(
                                title: "Category *".tr,
                                fontSize: 14,
                              ),
                              spaceH(height: 10),
                              DropdownButtonFormField<CategoryModel>(
                                isExpanded: true,
                                dropdownColor: themeChange.isDarkTheme() ? AppThemeData.lynch800 : AppThemeData.lynch100,
                                onChanged: (value) {
                                  controller.selectedCategory.value = value!;
                                  controller.selectedSubCategory.value = SubCategoryModel(); // Clear the selected subcategory
                                  controller.getSubCategory(controller.selectedCategory.value.id.toString());
                                  // controller.selectedCategory.value = value!;
                                  // controller.getSubCategory(controller.selectedCategory.value.id.toString());
                                },
                                value: controller.selectedCategory.value.id == null ? null : controller.selectedCategory.value,
                                items: controller.categoryList.map((item) {
                                  return DropdownMenuItem<CategoryModel>(
                                    value: item,
                                    child: Text(
                                      item.categoryName.toString(),
                                      style: TextStyle(
                                        fontFamily: FontFamily.regular,
                                        fontSize: 14,
                                        color: themeChange.isDarkTheme() ? AppThemeData.lynch200 : AppThemeData.lynch800,
                                      ),
                                    ),
                                  );
                                }).toList(),
                                validator: (value) => value != null ? null : 'This field required'.tr,
                                icon: const Icon(
                                  Icons.keyboard_arrow_down_outlined,
                                ),
                                borderRadius: BorderRadius.circular(6),
                                // dropdownColor: themeChange.isDarkTheme() ? AppThemeData.grey800 : AppThemeData.grey200,
                                focusColor: Colors.transparent,
                                elevation: 0,
                                hint: TextCustom(
                                  title: "Select Category".tr,
                                  fontSize: 14,
                                  fontFamily: FontFamily.regular,
                                  color: themeChange.isDarkTheme() ? AppThemeData.lynch300 : AppThemeData.lynch400,
                                ),
                                style: TextStyle(fontFamily: FontFamily.medium, color: themeChange.isDarkTheme() ? AppThemeData.primaryWhite : AppThemeData.textBlack, fontSize: 14),
                                decoration: Constant.DefaultInputDecoration(context),
                              ),
                            ],
                          ),
                        ),
                        spaceW(width: 20),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TextCustom(
                                title: "Sub category *".tr,
                                fontSize: 14,
                              ),
                              spaceH(height: 10),
                              DropdownButtonFormField<SubCategoryModel>(
                                isExpanded: true,
                                onChanged: (value) {
                                  controller.selectedSubCategory.value = value!;
                                },
                                value: controller.selectedSubCategory.value.id == null ? null : controller.selectedSubCategory.value,
                                items: controller.subCategoryList.map((item) {
                                  return DropdownMenuItem<SubCategoryModel>(
                                    value: item,
                                    child: Text(
                                      item.subCategoryName.toString(),
                                      style: TextStyle(
                                        fontFamily: FontFamily.regular,
                                        fontSize: 14,
                                        color: themeChange.isDarkTheme() ? AppThemeData.lynch200 : AppThemeData.lynch800,
                                      ),
                                    ),
                                  );
                                }).toList(),
                                validator: (value) => value != null ? null : 'This field required'.tr,
                                icon: const Icon(
                                  Icons.keyboard_arrow_down_outlined,
                                ),
                                borderRadius: BorderRadius.circular(6),
                                dropdownColor: themeChange.isDarkTheme() ? AppThemeData.lynch800 : AppThemeData.lynch100,
                                focusColor: Colors.transparent,
                                elevation: 0,
                                hint: TextCustom(
                                  title: "Select Sub Category".tr,
                                  fontSize: 14,
                                  fontFamily: FontFamily.regular,
                                  color: themeChange.isDarkTheme() ? AppThemeData.lynch300 : AppThemeData.lynch400,
                                ),
                                style: TextStyle(color: themeChange.isDarkTheme() ? AppThemeData.primaryWhite : AppThemeData.textBlack, fontFamily: FontFamily.medium, fontSize: 14),
                                decoration: Constant.DefaultInputDecoration(context),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                    spaceH(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: CustomTextFormField(
                              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                              textInputType: TextInputType.number,
                              hintText: "Enter Item Price".tr,
                              title: "Price *".tr,
                              controller: controller.itemPriceController.value),
                        ),
                        spaceW(width: 20),
                        Expanded(
                          child: CustomTextFormField(
                              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                              textInputType: TextInputType.number,
                              hintText: "Enter Max Purchase Quantity".tr,
                              title: "Max Purchase Quantity *".tr,
                              controller: controller.maxQtyController.value),
                        )
                      ],
                    ),
                    spaceH(height: 16),
                    Row(
                      children: [
                        Expanded(
                            child: CustomTextFormField(
                                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                textInputType: TextInputType.number,
                                hintText: "Enter Discount".tr,
                                title: "Discount *".tr,
                                controller: controller.discountController.value)),
                        spaceW(width: 20),
                        Padding(
                          padding: const EdgeInsets.only(top: 20),
                          child: DropdownButtonFormField(
                            isExpanded: true,
                            onChanged: (value) {
                              controller.selectedDiscountType.value = value!;
                            },
                            value: controller.selectedDiscountType.value.isEmpty ? null : controller.selectedDiscountType.value,
                            items: controller.discountType.map((item) {
                              return DropdownMenuItem<String>(value: item, child: Text(item));
                            }).toList(),
                            validator: (value) => value != null ? null : 'This field required'.tr,
                            icon: const Icon(
                              Icons.keyboard_arrow_down_outlined,
                            ),
                            borderRadius: BorderRadius.circular(6),
                            dropdownColor: themeChange.isDarkTheme() ? AppThemeData.lynch800 : AppThemeData.lynch100,
                            focusColor: Colors.transparent,
                            elevation: 0,
                            hint: TextCustom(
                              title: "Discount Type".tr,
                              fontSize: 14,
                              fontFamily: FontFamily.regular,
                              color: themeChange.isDarkTheme() ? AppThemeData.lynch300 : AppThemeData.lynch400,
                            ),
                            style: TextStyle(color: themeChange.isDarkTheme() ? AppThemeData.primaryWhite : AppThemeData.textBlack, fontFamily: FontFamily.medium, fontSize: 14),
                            decoration: Constant.DefaultInputDecoration(context),
                          ),
                        ).expand(),
                      ],
                    ),
                    spaceH(height: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextCustom(
                          title: "Item Tag *".tr,
                          fontSize: 14,
                        ),
                        spaceH(height: 10),
                        Wrap(
                          children: List.generate(
                            controller.tagsList.length,
                            (index) {
                              return InkWell(
                                onTap: () {
                                  controller.selectedTags.value = controller.tagsList[index];
                                },
                                child: Padding(
                                  padding: const EdgeInsets.only(bottom: 8, right: 8),
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: controller.selectedTags.value == controller.tagsList[index]
                                            ? AppThemeData.secondary300
                                            : themeChange.isDarkTheme()
                                                ? AppThemeData.lynch800
                                                : AppThemeData.lynch100,
                                        borderRadius: BorderRadius.circular(30)),
                                    padding: paddingEdgeInsets(horizontal: 24, vertical: 12),
                                    child: TextCustom(
                                      title: controller.tagsList[index],
                                      color: controller.selectedTags.value == controller.tagsList[index]
                                          ? AppThemeData.lynch50
                                          : themeChange.isDarkTheme()
                                              ? AppThemeData.lynch400
                                              : AppThemeData.lynch600,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        )
                      ],
                    ),
                    spaceH(height: 16),
                    TextCustom(
                      title: "Add ons *".tr,
                      fontSize: 16,
                      fontFamily: FontFamily.medium,
                    ),
                    spaceH(height: 10),
                    Container(
                      padding: paddingEdgeInsets(),
                      margin: const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: themeChange.isDarkTheme() ? AppThemeData.lynch900 : AppThemeData.lynch100,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: CustomTextFormField(hintText: "Enter Addons Name".tr, title: "Addons Name".tr, controller: controller.addonsNameController.value),
                              ),
                              spaceW(width: 20),
                              Expanded(
                                child: CustomTextFormField(
                                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                    textInputType: TextInputType.number,
                                    hintText: "Enter Addons Price".tr,
                                    title: "Addons Price".tr,
                                    controller: controller.addonsPriceController.value),
                              ),
                              spaceW(width: 20),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  TextCustom(
                                    title: "In Stock".tr,
                                    fontSize: 14,
                                  ),
                                  Transform.scale(
                                    scale: 0.8,
                                    child: FittedBox(
                                      child: CupertinoSwitch(
                                        activeTrackColor: AppThemeData.primary300,
                                        value: controller.addonsInStock.value,
                                        onChanged: (value) {
                                          controller.addonsInStock.value = value;
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          spaceH(height: 12),
                          Row(
                            children: [
                              const Spacer(),
                              CustomButtonWidget(
                                height: 40,
                                title: "Save Addons".tr,
                                onPress: () {
                                  if (controller.addonsPriceController.value.text.isEmpty) {
                                    return ShowToastDialog.errorToast(" Please Add Addons Price".tr);
                                  } else if (controller.addonsNameController.value.text.isEmpty) {
                                    return ShowToastDialog.errorToast(" Please Add Addons Name".tr);
                                  } else {
                                    controller.addonsList.add(
                                        AddonsModel(inStock: controller.addonsInStock.value, name: controller.addonsNameController.value.text, price: controller.addonsPriceController.value.text));
                                    controller.update();

                                    controller.addonsNameController.value.clear();
                                    controller.addonsPriceController.value.clear();
                                    controller.addonsInStock.value = true;
                                  }
                                },
                              ),
                            ],
                          ),
                          spaceH(height: 10),
                        ],
                      ),
                    ),
                    if (controller.addonsList.isNotEmpty) ...{
                      ListView.builder(
                        shrinkWrap: true,
                        itemCount: controller.addonsList.length,
                        itemBuilder: (context, index) {
                          return Container(
                            padding: const EdgeInsets.all(12),
                            margin: const EdgeInsets.only(bottom: 8),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: themeChange.isDarkTheme() ? AppThemeData.lynch700 : AppThemeData.lynch200),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      TextCustom(
                                        title: controller.addonsList[index].name.toString(),
                                        fontSize: 16,
                                        fontFamily: FontFamily.medium,
                                        color: themeChange.isDarkTheme() ? AppThemeData.lynch50 : AppThemeData.lynch900,
                                      ),
                                      TextCustom(
                                        title: Constant.amountShow(amount: controller.addonsList[index].price.toString()),
                                        fontSize: 16,
                                        color: themeChange.isDarkTheme() ? AppThemeData.lynch400 : AppThemeData.lynch600,
                                      ),
                                      Row(
                                        children: [
                                          TextCustom(
                                            title: "In Stock".tr,
                                            fontSize: 16,
                                          ),
                                          spaceW(),
                                          Obx(
                                            () => SizedBox(
                                              height: 26.h,
                                              child: FittedBox(
                                                child: CupertinoSwitch(
                                                  activeTrackColor: AppThemeData.primary300,
                                                  value: controller.addonsList[index].inStock!,
                                                  onChanged: (value) {},
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                                spaceW(),
                                InkWell(
                                  onTap: () {
                                    controller.addonsList.remove(controller.addonsList[index]);
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
                    },
                    spaceH(height: 16),
                    Container(
                      padding: paddingEdgeInsets(),
                      margin: const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: themeChange.isDarkTheme() ? AppThemeData.lynch900 : AppThemeData.lynch100,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextCustom(
                            title: "Add Variations *".tr,
                            fontSize: 16,
                            fontFamily: FontFamily.medium,
                          ),
                          spaceH(height: 10),
                          Row(
                            children: [
                              Expanded(
                                child: CustomTextFormField(
                                  hintText: "Enter Variations Name".tr,
                                  title: "Variations Name".tr,
                                  controller: controller.variationNameController.value,
                                ),
                              ),
                              spaceW(width: 20),
                              Obx(() {
                                // bool isLastInStock = controller.variationList.isNotEmpty ? controller.variationList.last.inStock ?? true : true;
                                //   CupertinoSwitch(
                                //   value: controller.variationInStockDemo.value,
                                //   activeColor: AppThemeData.primary300,
                                //   onChanged: (value) {
                                //     controller.variationInStockDemo.value = value;
                                //     // if (controller.variationList.isNotEmpty) {
                                //     //   controller.variationList.last.inStock = value;
                                //     //   controller.variationList.refresh();
                                //     // }
                                //   },
                                // );
                                return Transform.scale(
                                  scale: 0.8,
                                  child: CupertinoSwitch(
                                    activeTrackColor: AppThemeData.primary300,
                                    value: controller.variationInStock.value,
                                    onChanged: (value) {
                                      controller.variationInStock.value = value;
                                      // if (controller.variationList.isNotEmpty) {
                                      //   controller.variationList.last.inStock = value;
                                      //   controller.variationList.refresh();
                                      // }
                                    },
                                  ),
                                );
                              }),
                            ],
                          ),
                          spaceH(),
                          Row(
                            children: [
                              const Spacer(),
                              CustomButtonWidget(
                                height: 40,
                                title: "Save Variation".tr,
                                onPress: () {
                                  if (controller.variationNameController.value.text.isEmpty) {
                                    return ShowToastDialog.errorToast("Please Add Variations name".tr);
                                  }
                                  controller.addVariation(
                                    controller.variationNameController.value.text,
                                    true, // Default to in-stock
                                  );
                                },
                              ),
                            ],
                          ),
                          spaceH(),
                        ],
                      ),
                    ),
                    Obx(
                      () => ListView.builder(
                        shrinkWrap: true,
                        itemCount: controller.variationList.length,
                        itemBuilder: (context, variationIndex) {
                          VariationModel variation = controller.variationList[variationIndex];
                          return Container(
                            margin: const EdgeInsets.symmetric(vertical: 8),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: themeChange.isDarkTheme() ? AppThemeData.lynch700 : AppThemeData.lynch200),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      variation.name ?? "Unnamed Variation",
                                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                    ),
                                    Row(
                                      children: [
                                        SizedBox(
                                          height: 26.h,
                                          child: FittedBox(
                                            child: CupertinoSwitch(
                                              activeTrackColor: AppThemeData.primary300,
                                              value: variation.inStock ?? true,
                                              onChanged: (value) {
                                                variation.inStock = value;
                                                controller.variationList.refresh();
                                              },
                                            ),
                                          ),
                                        ),
                                        spaceW(),
                                        InkWell(
                                          onTap: () {
                                            controller.removeOptionToVariation(
                                              variationIndex,
                                            );
                                          },
                                          child: SvgPicture.asset(
                                            "assets/icons/ic_delete.svg",
                                            color: AppThemeData.danger300,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ).paddingOnly(bottom: 8),
                                if (variation.optionList != null)
                                  ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: variation.optionList!.length,
                                    itemBuilder: (context, optionIndex) {
                                      OptionModel option = variation.optionList![optionIndex];
                                      return Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 16),
                                        child: Column(
                                          children: [
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    TextCustom(title: option.name.toString()),
                                                    TextCustom(
                                                      // title: option.price.toString()
                                                      title: Constant.amountShow(amount: option.price.toString()), fontSize: 14, fontFamily: FontFamily.regular,
                                                    ),
                                                  ],
                                                ),
                                                InkWell(
                                                  onTap: () {
                                                    controller.removeOptionFromVariation(
                                                      variationIndex,
                                                      optionIndex,
                                                    );
                                                  },
                                                  child: SvgPicture.asset(
                                                    "assets/icons/ic_delete.svg",
                                                    color: AppThemeData.danger300,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            if (optionIndex != variation.optionList!.length - 1)
                                              Padding(
                                                padding: const EdgeInsets.symmetric(vertical: 10),
                                                child: Divider(
                                                  color: themeChange.isDarkTheme() ? AppThemeData.lynch600 : AppThemeData.lynch200,
                                                ),
                                              )
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                spaceH(height: 24),
                                Container(
                                  padding: paddingEdgeInsets(),
                                  decoration: BoxDecoration(
                                    color: themeChange.isDarkTheme() ? AppThemeData.lynch900 : AppThemeData.lynch100,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Expanded(
                                        child: CustomTextFormField(
                                          hintText: "Option Name",
                                          controller: controller.optionNameController.value,
                                          title: 'Option Name',
                                        ),
                                      ),
                                      spaceW(width: 10),
                                      Expanded(
                                        child: CustomTextFormField(
                                          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                          textInputType: TextInputType.number,
                                          hintText: "Option Price",
                                          controller: controller.optionPriceController.value,
                                          title: 'Option Price',
                                        ),
                                      ),
                                      spaceW(),
                                      CustomButtonWidget(
                                        height: 40,
                                        title: "Save",
                                        onPress: () {
                                          if (controller.optionNameController.value.text.isEmpty) {
                                            ShowToastDialog.errorToast('Please enter option name');
                                          } else if (controller.optionPriceController.value.text.isEmpty) {
                                            ShowToastDialog.errorToast('Please enter option price');
                                          } else {
                                            controller.addOptionToVariation(
                                              variationIndex,
                                              controller.optionNameController.value.text,
                                              controller.optionPriceController.value.text,
                                            );
                                          }
                                        },
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                )
              ],
            )
          ],
          bottomWidgetList: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                CustomButtonWidget(
                  title: "Close".tr,
                  buttonColor: themeChange.isDarkTheme() ? AppThemeData.lynch700 : AppThemeData.lynch400,
                  onPress: () {
                    Navigator.pop(context);
                  },
                ),
                spaceW(),
                CustomButtonWidget(
                  title: "Save".tr,
                  onPress: () {
                    if (Constant.isDemo) {
                      DialogBox.demoDialogBox();
                    } else {
                      if (controller.itemNameController.value.text.isNotEmpty &&
                          controller.itemDescriptionController.value.text.isNotEmpty &&
                          controller.itemPriceController.value.text.isNotEmpty &&
                          controller.selectedRestaurantId.value.id!.isNotEmpty &&
                          controller.selectedItemType.value.isNotEmpty &&
                          controller.selectedCategory.value.id!.isNotEmpty &&
                          controller.selectedSubCategory.value.id!.isNotEmpty &&
                          controller.maxQtyController.value.text.isNotEmpty &&
                          controller.selectedTags.isNotEmpty) {
                        controller.isEditing.value ? controller.updateProduct() : controller.saveItem();
                      } else {
                        ShowToastDialog.errorToast("Please Enter Valid Details..");
                      }
                    }
                  },
                ),
              ],
            ),
          ],
        );
        // return Dialog(
        //   backgroundColor: themeChange.isDarkTheme() ? AppThemeData.lynch950 : AppThemeData.lynch50,
        //   shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8.0))),
        //   alignment: Alignment.topCenter,
        //   child: SizedBox(
        //     width: 500,
        //     child: Column(
        //       mainAxisSize: MainAxisSize.min,
        //       crossAxisAlignment: CrossAxisAlignment.start,
        //       children: [
        //         Row(
        //           children: [
        //             Container(
        //                     padding: const EdgeInsets.all(24),
        //                     decoration: BoxDecoration(
        //                       borderRadius: const BorderRadius.only(topLeft: Radius.circular(8.0), topRight: Radius.circular(8.0)),
        //                       color: themeChange.isDarkTheme() ? AppThemeData.lynch900 : AppThemeData.lynch100,
        //                     ),
        //                     child: TextCustom(title: controller.isEditing.value ? "Edit Item".tr : "Add Item".tr, fontSize: 18))
        //                 .expand(),
        //           ],
        //         ),
        //         Padding(
        //           padding: const EdgeInsets.fromLTRB(24, 20, 24, 20),
        //           child: Column(
        //             mainAxisSize: MainAxisSize.min,
        //             crossAxisAlignment: CrossAxisAlignment.start,
        //             children: [
        //               DottedBorder(
        //                 borderType: BorderType.RRect,
        //                 radius: const Radius.circular(12),
        //                 dashPattern: const [6, 6, 6, 6],
        //                 color: themeChange.isDarkTheme() ? AppThemeData.lynch600 : AppThemeData.lynch400,
        //                 child: controller.itemImage.value.isEmpty
        //                     ? Padding(
        //                         padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 32),
        //                         child: Column(
        //                           crossAxisAlignment: CrossAxisAlignment.start,
        //                           mainAxisAlignment: MainAxisAlignment.center,
        //                           children: [
        //                             TextCustom(
        //                               title: "Upload the item images".tr,
        //                               maxLine: 2,
        //                               color: themeChange.isDarkTheme() ? AppThemeData.lynch100 : AppThemeData.lynch900,
        //                               fontFamily: FontFamily.regular,
        //                             ),
        //                             TextCustom(
        //                               title: "image must be a .jpg, .jpeg".tr,
        //                               maxLine: 1,
        //                               fontSize: 12,
        //                               color: AppThemeData.secondary300,
        //                               fontFamily: FontFamily.light,
        //                             ),
        //                             spaceH(),
        //                             InkWell(
        //                                 onTap: () {
        //                                   controller.pickFile().then((value) => controller.itemImage.value = value!);
        //                                 },
        //                                 child: TextCustom(
        //                                   title: "Browse Image",
        //                                   isUnderLine: true,
        //                                   fontSize: 14,
        //                                   fontFamily: FontFamily.regular,
        //                                   color: Color(0xff0479C7),
        //                                 )),
        //                             // CustomButtonWidget(
        //                             //     title: "Browse Image".tr,
        //                             //     width: ,
        //                             //     onPress: () {
        //                             //       controller.pickFile().then((value) => controller.itemImage.value = value!);
        //                             //     })
        //                           ],
        //                         ),
        //                       )
        //                     : ClipRRect(
        //                         borderRadius: BorderRadius.circular(5),
        //                         child: Constant.hasValidUrl(controller.itemImage.value.toString())
        //                             ? Image.network(
        //                                 controller.itemImage.value.toString(),
        //                                 height: 120.h,
        //                                 width: 120.w,
        //                                 fit: BoxFit.cover,
        //                               )
        //                             : Image.file(
        //                                 File(controller.itemImage.value.toString()),
        //                                 height: 120.h,
        //                                 width: 120.w,
        //                                 fit: BoxFit.cover,
        //                               ),
        //                       ),
        //               ),
        //               spaceH(height: 24),
        //               Column(
        //                 crossAxisAlignment: CrossAxisAlignment.start,
        //                 children: [
        //                   Row(
        //                     children: [
        //                       SvgPicture.asset("assets/new_icon/ic_scroll.svg"),
        //                       spaceW(width: 8),
        //                       TextCustom(
        //                         title: "Item Details".tr,
        //                         fontSize: 16,
        //                         fontFamily: FontFamily.medium,
        //                       ),
        //                     ],
        //                   ),
        //                   spaceH(height: 16),
        //                   CustomTextFormField(
        //                       hintText: "Enter Item Name".tr, title: "Item Name *".tr, controller: controller.itemNameController.value),
        //                   spaceH(),
        //                   CustomTextFormField(
        //                       hintText: "Enter Item Description".tr,
        //                       title: "Item Description *".tr,
        //                       controller: controller.itemDescriptionController.value,maxLine: 2,),
        //                   spaceH(),
        //                   TextCustom(
        //                     title: 'Item Type *'.tr,
        //                     fontSize: 14,
        //                   ),
        //                   spaceH(height: 10),
        //                   Obx(
        //                         () => DropdownButtonFormField(
        //                       isExpanded: true,
        //                       style: TextStyle(
        //                         fontFamily: FontFamily.medium,
        //                         color: themeChange.isDarkTheme() ? AppThemeData.primaryWhite : AppThemeData.textBlack,
        //                       ),
        //                       hint: TextCustom(title: 'Select Item Type'.tr, fontSize: 14, fontFamily: FontFamily.regular),
        //                       onChanged: (String? taxType) {
        //                         controller.selectedItemType.value = taxType ?? "Veg";
        //                       },
        //                       value: controller.selectedItemType.value,
        //                       icon: const Icon(Icons.keyboard_arrow_down_outlined),
        //                       foods: controller.itemType.map<DropdownMenuItem<String>>((String value) {
        //                         return DropdownMenuItem(
        //                           value: value,
        //                           child: Text(
        //                             value,
        //                             style: TextStyle(
        //                               fontFamily: FontFamily.regular,
        //                               fontSize: 14,
        //                               color: themeChange.isDarkTheme() ? AppThemeData.lynch200 : AppThemeData.lynch800,
        //                             ),
        //                           ),
        //                         );
        //                       }).toList(),
        //                       decoration: Constant.DefaultInputDecoration(context),
        //                     ),
        //                   ),
        //                 ],
        //               )
        //             ],
        //           ),
        //         )
        //       ],
        //     ),
        //   ),
        // );
      },
    );
  }
}
