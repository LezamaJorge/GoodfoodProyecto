// ignore_for_file: deprecated_member_use

import 'dart:io';

import 'package:admin_panel/app/components/custom_button.dart';
import 'package:admin_panel/app/components/custom_text_form_field.dart';
import 'package:admin_panel/app/components/dialog_box.dart';
import 'package:admin_panel/app/components/menu_widget.dart';
import 'package:admin_panel/app/components/network_image_widget.dart';
import 'package:admin_panel/app/constant/constants.dart';
import 'package:admin_panel/app/constant/show_toast.dart';
import 'package:admin_panel/app/models/category_model.dart';
import 'package:admin_panel/app/utils/app_colors.dart';
import 'package:admin_panel/app/utils/app_them_data.dart';
import 'package:admin_panel/app/utils/dark_theme_provider.dart';
import 'package:admin_panel/app/utils/fire_store_utils.dart';
import 'package:admin_panel/app/utils/responsive.dart';
import 'package:admin_panel/widget/common_ui.dart';
import 'package:admin_panel/widget/container_custom.dart';
import 'package:admin_panel/widget/global_widgets.dart';
import 'package:admin_panel/widget/gradient_text.dart';
import 'package:admin_panel/widget/text_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';
import '../../../routes/app_pages.dart';
import '../controllers/categories_controller.dart';

class CategoryView extends GetView<CategoryController> {
  const CategoryView({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetX<CategoryController>(
      init: CategoryController(),
      builder: (controller) {
        return Scaffold(
          backgroundColor: themeChange.isDarkTheme() ? AppThemeData.lynch950 : AppThemeData.lynch50,
          appBar: AppBar(
            elevation: 0.0,
            toolbarHeight: 70,
            automaticallyImplyLeading: false,
            backgroundColor: themeChange.isDarkTheme() ? AppThemeData.primaryBlack : AppThemeData.primaryWhite,
            leadingWidth: 200,
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
                child: Container(
                  padding: const EdgeInsets.all(8),
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
              ),
              spaceW(),
              const LanguagePopUp(),
              spaceW(),
              ProfilePopUp()
            ],
          ),
          drawer: Drawer(
            width: 270,
            backgroundColor: themeChange.isDarkTheme() ? AppThemeData.primaryBlack : AppThemeData.primaryWhite,
            child: const MenuWidget(),
          ),
          body: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (ResponsiveWidget.isDesktop(context)) ...{const MenuWidget()},
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
                                        TextCustom(title: controller.title.value.tr, fontSize: 20, fontFamily: FontFamily.bold),
                                        spaceH(height: 2),
                                        Row(children: [
                                          InkWell(
                                              onTap: () => Get.offAllNamed(Routes.DASHBOARD_SCREEN),
                                              child: TextCustom(title: 'Dashboard'.tr, fontSize: 14, fontFamily: FontFamily.medium, color: AppThemeData.lynch500)),
                                          const TextCustom(title: ' / ', fontSize: 14, fontFamily: FontFamily.medium, color: AppThemeData.lynch500),
                                          TextCustom(title: ' ${controller.title.value.tr} ', fontSize: 14, fontFamily: FontFamily.medium, color: AppThemeData.primary500)
                                        ])
                                      ]),
                                      const Spacer(),
                                      CustomButtonWidget(
                                          title: "+ Add Category".tr,
                                          onPress: () {
                                            controller.setDefaultData();
                                            showDialog(context: context, builder: (context) => const AddCategoryDialog());
                                          })
                                    ],
                                  )
                                : Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                        TextCustom(title: controller.title.value.tr, fontSize: 20, fontFamily: FontFamily.bold),
                                        spaceH(height: 2),
                                        Row(children: [
                                          InkWell(
                                              onTap: () => Get.offAllNamed(Routes.DASHBOARD_SCREEN),
                                              child: TextCustom(title: 'Dashboard'.tr, fontSize: 14, fontFamily: FontFamily.medium, color: AppThemeData.lynch500)),
                                          const TextCustom(title: ' / ', fontSize: 14, fontFamily: FontFamily.medium, color: AppThemeData.lynch500),
                                          TextCustom(title: ' ${controller.title.value.tr} ', fontSize: 14, fontFamily: FontFamily.medium, color: AppThemeData.primary500)
                                        ])
                                      ]),
                                      spaceH(),
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
                                    : Align(
                                        alignment: Alignment.topLeft,
                                        child: controller.categoryList.isEmpty
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
                                                  CommonUI.dataColumnWidget(context,
                                                      columnTitle: "Image".tr, width: ResponsiveWidget.isMobile(context) ? 150 : MediaQuery.of(context).size.width * 0.1),
                                                  CommonUI.dataColumnWidget(context, columnTitle: "Name".tr, width: ResponsiveWidget.isMobile(context) ? 150 : MediaQuery.of(context).size.width * 0.2),
                                                  CommonUI.dataColumnWidget(context,
                                                      columnTitle: "Status".tr, width: ResponsiveWidget.isMobile(context) ? 100 : MediaQuery.of(context).size.width * 0.1),
                                                  CommonUI.dataColumnWidget(context,
                                                      columnTitle: "Action".tr, width: ResponsiveWidget.isMobile(context) ? 100 : MediaQuery.of(context).size.width * 0.06)
                                                ],
                                                rows: controller.categoryList
                                                    .map((categoryModel) => DataRow(cells: [
                                                          DataCell(
                                                            Container(
                                                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                                                              child: NetworkImageWidget(
                                                                imageUrl: '${categoryModel.image}',
                                                                height: 37,
                                                                width: 37,
                                                              ),
                                                            ),
                                                          ),
                                                          DataCell(TextCustom(title: categoryModel.categoryName.toString())),
                                                          DataCell(
                                                            Transform.scale(
                                                              scale: 0.8,
                                                              child: CupertinoSwitch(
                                                                activeTrackColor: AppThemeData.primary500,
                                                                value: categoryModel.active ?? false,
                                                                onChanged: (value) async {
                                                                  if (Constant.isDemo) {
                                                                    DialogBox.demoDialogBox();
                                                                  } else {
                                                                    categoryModel.active = value;
                                                                    await FireStoreUtils.updateCategory(categoryModel);
                                                                    controller.getData();
                                                                  }
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
                                                                    controller.isEditing.value = true;
                                                                    controller.editingId.value = categoryModel.id!;
                                                                    controller.categoryNameController.value.text = categoryModel.categoryName!;
                                                                    controller.isActive.value = categoryModel.active ?? false;
                                                                    controller.categoryImageName.value.text = categoryModel.image!;
                                                                    controller.imageURL.value = categoryModel.image!;

                                                                    showDialog(context: context, builder: (context) => const AddCategoryDialog());
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
                                                                      bool confirmDelete = await DialogBox.showConfirmationDeleteDialog(context);
                                                                      if (confirmDelete) {
                                                                        await controller.removeCategory(categoryModel);
                                                                        controller.getData();
                                                                      }
                                                                    }
                                                                  },
                                                                  child: SvgPicture.asset(
                                                                    "assets/icons/ic_delete.svg",
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
                            ),
                          ]),
                        )
                      ]),
                    )),
              ),
            ],
          ),
        );
      },
    );
  }
}

class AddCategoryDialog extends StatelessWidget {
  const AddCategoryDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetX<CategoryController>(
      init: CategoryController(),
      builder: (controller) {
        return Dialog(
          backgroundColor: themeChange.isDarkTheme() ? AppThemeData.lynch950 : AppThemeData.lynch50,
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8.0))),
          alignment: Alignment.topCenter,
          child: SizedBox(
            width: 500,
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
                            child: TextCustom(title: controller.isEditing.value ? "Edit Category".tr : "Add Category".tr, fontSize: 18))
                        .expand(),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 20, 24, 20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      controller.isEditing.value == true
                          ? Padding(
                              padding: const EdgeInsets.all(20),
                              child: Container(
                                height: 0.18.sh,
                                width: 0.30.sw,
                                decoration: BoxDecoration(
                                  color: themeChange.isDarkTheme() ? AppThemeData.lynch800 : AppThemeData.lynch100,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Stack(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      child: CachedNetworkImage(
                                        fit: BoxFit.contain,
                                        height: 0.18.sh,
                                        width: 0.30.sw,
                                        imageUrl: controller.imageFile.value.path.isEmpty ? controller.imageURL.value : controller.imageFile.value.path,
                                      ),
                                    ),
                                    Center(
                                      child: InkWell(
                                        onTap: () async {
                                          if (Constant.isDemo) {
                                            DialogBox.demoDialogBox();
                                          } else {
                                            ImagePicker picker = ImagePicker();
                                            final img = await picker.pickImage(source: ImageSource.gallery, imageQuality: 80);
                                            if (img != null) {
                                              final allowedExtensions = ['jpg', 'jpeg', 'png'];
                                              String fileExtension = img.name.split('.').last.toLowerCase();

                                              if (!allowedExtensions.contains(fileExtension)) {
                                                ShowToastDialog.errorToast("Invalid file type. Please select a .jpg, .jpeg, or .png image.".tr);
                                                return;
                                              }
                                              File imageFile = File(img.path);
                                              controller.categoryImageName.value.text = img.name;
                                              controller.imageFile.value = imageFile;
                                              controller.mimeType.value = "${img.mimeType}";
                                              controller.isImageUpdated.value = true;
                                            }
                                          }
                                        },
                                        child: controller.imageFile.value.path.isEmpty
                                            ? const Icon(
                                                Icons.add,
                                                color: AppThemeData.lynch500,
                                              )
                                            : const SizedBox(),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          : Padding(
                              padding: const EdgeInsets.all(20),
                              child: Container(
                                height: 0.18.sh,
                                width: 0.30.sw,
                                padding: const EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  color: themeChange.isDarkTheme() ? AppThemeData.lynch800 : AppThemeData.lynch100,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Stack(
                                  children: [
                                    if (controller.imageFile.value.path.isNotEmpty)
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(12),
                                        child: CachedNetworkImage(
                                          fit: BoxFit.contain,
                                          height: 0.18.sh,
                                          width: 0.30.sw,
                                          imageUrl: controller.imageFile.value.path,
                                        ),
                                      ),
                                    Center(
                                      child: InkWell(
                                        onTap: () async {
                                          if (Constant.isDemo) {
                                            DialogBox.demoDialogBox();
                                          } else {
                                            ImagePicker picker = ImagePicker();
                                            final img = await picker.pickImage(source: ImageSource.gallery, imageQuality: 80);
                                            if (img != null) {
                                              final allowedExtensions = ['jpg', 'jpeg', 'png'];
                                              String fileExtension = img.name.split('.').last.toLowerCase();

                                              if (!allowedExtensions.contains(fileExtension)) {
                                                ShowToastDialog.errorToast("Invalid file type. Please select a .jpg, .jpeg, or .png image.".tr);
                                                return;
                                              }
                                              File imageFile = File(img.path);
                                              controller.categoryImageName.value.text = img.name;
                                              controller.imageFile.value = imageFile;
                                              controller.mimeType.value = "${img.mimeType}";
                                              controller.isImageUpdated.value = true;
                                            }
                                          }
                                        },
                                        child: controller.imageFile.value.path.isEmpty
                                            ? Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    'upload image'.tr,
                                                    style: const TextStyle(fontSize: 16, color: AppThemeData.lynch500, fontFamily: FontFamily.medium),
                                                  ),
                                                  const SizedBox(
                                                    width: 12,
                                                  ),
                                                  const Icon(
                                                    Icons.file_upload_outlined,
                                                    color: AppThemeData.lynch500,
                                                  ),
                                                ],
                                              )
                                            : const SizedBox(),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                      CustomTextFormField(hintText: "Enter Category Name".tr, title: "Category Name".tr, controller: controller.categoryNameController.value),
                      spaceH(height: 20),
                      TextCustom(
                        title: 'Status'.tr,
                        fontSize: 14,
                      ),
                      spaceH(height: 10),
                      Transform.scale(
                        scale: 0.8,
                        child: CupertinoSwitch(
                          activeTrackColor: AppThemeData.primary500,
                          value: controller.isActive.value,
                          onChanged: (value) {

                            controller.isActive.value = value;
                          },
                        ),
                      ),
                      spaceH(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          CustomButtonWidget(
                            title: "Close".tr,
                            buttonColor: themeChange.isDarkTheme() ? AppThemeData.lynch700 : AppThemeData.lynch400,
                            onPress: () {
                              controller.setDefaultData();

                              Navigator.pop(context);
                            },
                          ),
                          spaceW(),
                          CustomButtonWidget(
                            title: "Save".tr,
                            onPress: () async {
                              if (Constant.isDemo) {
                                DialogBox.demoDialogBox();
                              } else {
                                if (controller.categoryNameController.value.text.isNotEmpty && controller.categoryImageName.value.text.isNotEmpty) {
                                  controller.isLoading.value = true;
                                  if (controller.isEditing.value) {
                                    String url = controller.isImageUpdated.value
                                        ? await FireStoreUtils.uploadPic(PickedFile(controller.imageFile.value.path), "categoryImage", controller.editingId.toString(), controller.mimeType.value)
                                        : controller.imageURL.value;
                                    CategoryModel categoryModel = CategoryModel(
                                      id: controller.editingId.value,
                                      image: url,
                                      active: controller.isActive.value,
                                      categoryName: controller.categoryNameController.value.text,
                                    );
                                    bool isSaved = await FireStoreUtils.updateCategory(categoryModel);
                                    if (isSaved) {
                                      controller.setDefaultData();
                                      controller.getData();
                                    } else {
                                      ShowToastDialog.errorToast("An error occurred. Please try again.");
                                    }
                                    Get.back();
                                    return;
                                  }
                                  String docId = Constant.getRandomString(20);
                                  String url = await FireStoreUtils.uploadPic(PickedFile(controller.imageFile.value.path), "categoryImage", docId, controller.mimeType.value);
                                  CategoryModel categoryModel = CategoryModel(
                                    id: docId,
                                    image: url,
                                    categoryName: controller.categoryNameController.value.text,
                                  );
                                  bool isSaved = await FireStoreUtils.addCategory(categoryModel);
                                  if (isSaved) {
                                    controller.setDefaultData();
                                    controller.getData();
                                  } else {
                                    ShowToastDialog.errorToast("An error occurred. Please try again.");
                                  }
                                } else {
                                  ShowToastDialog.errorToast("Invalid details entered. Please review and correct them.");
                                }
                                Get.back();
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
