// ignore_for_file: deprecated_member_use, void_checks

import 'package:admin_panel/app/components/custom_button.dart';
import 'package:admin_panel/app/components/custom_text_form_field.dart';
import 'package:admin_panel/app/components/dialog_box.dart';
import 'package:admin_panel/app/components/menu_widget.dart';
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
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import '../../../routes/app_pages.dart';
import '../controllers/sub_categories_controller.dart';

class SubCategoryView extends GetView<SubCategoryController> {
  const SubCategoryView({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetX<SubCategoryController>(
      init: SubCategoryController(),
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
                child: Padding(
                    padding: paddingEdgeInsets(),
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      child: Column(mainAxisSize: MainAxisSize.min, mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.start, children: [
                        ContainerCustom(
                          child: Column( children: [
                            ResponsiveWidget.isDesktop(context)
                                ? Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                        TextCustom(title: controller.title.value, fontSize: 20, fontFamily: FontFamily.bold),
                                        spaceH(height: 2),
                                        Row(children: [
                                          InkWell(onTap: () => Get.offAllNamed(Routes.DASHBOARD_SCREEN), child: TextCustom(title: 'Dashboard'.tr, fontSize: 14, fontFamily: FontFamily.medium, color: AppThemeData.lynch500)),
                                          const TextCustom(title: ' / ', fontSize: 14, fontFamily: FontFamily.medium, color: AppThemeData.lynch500),
                                          TextCustom(title: ' ${controller.title.value} ', fontSize: 14, fontFamily: FontFamily.medium, color: AppThemeData.primary500)
                                        ])
                                      ]),
                                      CustomButtonWidget(
                                          title: "+ Add Sub Categories".tr,
                                          onPress: () {
                                            controller.setDefaultData();
                                            showDialog(context: context, builder: (context) => const AddSubCategoryDialog());
                                          })
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
                                          InkWell(onTap: () => Get.offAllNamed(Routes.DASHBOARD_SCREEN), child: TextCustom(title: 'Dashboard'.tr, fontSize: 14, fontFamily: FontFamily.medium, color: AppThemeData.lynch500)),
                                          const TextCustom(title: ' / ', fontSize: 14, fontFamily: FontFamily.medium, color: AppThemeData.lynch500),
                                          TextCustom(title: ' ${controller.title.value} ', fontSize: 14, fontFamily: FontFamily.medium, color: AppThemeData.primary500)
                                        ]),
                                        spaceH(height: 20),
                                        CustomButtonWidget(
                                          title: "Add Sub Categories".tr,
                                          onPress: () {
                                            controller.setDefaultData();
                                            showDialog(context: context, builder: (context) => const AddSubCategoryDialog());
                                          },
                                          width: 200,
                                        )
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
                                    : controller.subCategoryList.isEmpty
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
                                              CommonUI.dataColumnWidget(context, columnTitle: "Sub Category".tr, width: ResponsiveWidget.isMobile(context) ? 150 : MediaQuery.of(context).size.width * 0.24),
                                              CommonUI.dataColumnWidget(context, columnTitle: "Category".tr, width: ResponsiveWidget.isMobile(context) ? 150 : MediaQuery.of(context).size.width * 0.24),
                                              CommonUI.dataColumnWidget(context, columnTitle: "Action".tr, width: ResponsiveWidget.isMobile(context) ? 100 : MediaQuery.of(context).size.width * 0.20)
                                            ],
                                            rows: controller.subCategoryList
                                                .map((categoryModel) => DataRow(cells: [
                                                      DataCell(TextCustom(title: categoryModel.subCategoryName.toString())),
                                                      // DataCell(TextCustom(title: categoryModel.subCategoryName.toString())),
                                                      DataCell(
                                                        FutureBuilder<CategoryModel?>(
                                                            future: FireStoreUtils.getCategoryByCategoryID(categoryModel.categoryId.toString()),
                                                            builder: (BuildContext context, AsyncSnapshot<CategoryModel?> snapshot) {
                                                              switch (snapshot.connectionState) {
                                                                case ConnectionState.waiting:
                                                                  return  const TextShimmer();
                                                                default:
                                                                  if (snapshot.hasError) {
                                                                    return Text('Error: ${snapshot.error}');
                                                                  } else {
                                                                    CategoryModel constantModel = snapshot.data!;
                                                                    return TextCustom(title: constantModel.categoryName.toString());
                                                                  }
                                                              }
                                                            }),
                                                      ),
                                                      DataCell(Container(
                                                        alignment: Alignment.center,
                                                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                                                        child: Row(
                                                          mainAxisAlignment: MainAxisAlignment.start,
                                                          children: [
                                                            // InkWell(
                                                            //   onTap: () async {
                                                            //     // Get.toNamed(Routes.USER_DETAIL_SCREEN, arguments: {'userModel': categoryModel});
                                                            //   },
                                                            //   child: SvgPicture.asset(
                                                            //     "assets/icons/ic_eye.svg",
                                                            //     color: AppThemeData.lynch400,
                                                            //     height: 16,
                                                            //     width: 16,
                                                            //   ),
                                                            // ),
                                                            spaceW(width: 20),
                                                            InkWell(
                                                              onTap: () async {
                                                                controller.getArguments(categoryModel);
                                                                controller.isEditing.value = true;
                                                                showDialog(context: context, builder: (context) => const AddSubCategoryDialog());
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
                                                               // color: AppThemeData.lynch400,
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

class AddSubCategoryDialog extends StatelessWidget {
  const AddSubCategoryDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetX<SubCategoryController>(
      init: SubCategoryController(),
      builder: (controller) {
        return CustomDialog(
          title: controller.isEditing.value ? "Edit Sub Category".tr : "Add SubCategory".tr,
          controller: controller,
          widgetList: [
            // Visibility(
            //   visible: controller.isEditing.value,
            //   child: Column(
            //     mainAxisAlignment: MainAxisAlignment.start,
            //     crossAxisAlignment: CrossAxisAlignment.start,
            //     children: [
            //       Text(
            //         "✍ Edit your Item here".tr,
            //         style: TextStyle(
            //           fontFamily: FontFamily.bold,
            //           fontWeight: FontWeight.w800,
            //           fontSize: 16,
            //           color: AppThemeData.primaryBlack,
            //         ),
            //       ),
            //       const SizedBox(
            //         height: 20,
            //       ),
            //     ],
            //   ),
            // ),
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
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
                    spaceH(height: 16),
                    CustomTextFormField(hintText: "Enter Category Name".tr, title: "Category Name".tr, controller: controller.categoryNameController.value),
                    spaceH(height: 16),
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
                      if (controller.selectedCategory.value.categoryName == null || controller.selectedCategory.value.categoryName!.isEmpty) {
                        return ShowToastDialog.errorToast('Please select a category.'.tr);
                      } else if (controller.categoryNameController.value.text.isEmpty) {
                        return ShowToastDialog.errorToast('Enter a subcategory name.'.tr);
                      } else {
                        Navigator.pop(context);
                        controller.saveSubCategory();
                      }
                    }
                  },
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
