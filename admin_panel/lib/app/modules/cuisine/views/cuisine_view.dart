// ignore_for_file: deprecated_member_use

import 'package:admin_panel/app/components/custom_button.dart';
import 'package:admin_panel/app/components/custom_text_form_field.dart';
import 'package:admin_panel/app/components/dialog_box.dart';
import 'package:admin_panel/app/components/menu_widget.dart';
import 'package:admin_panel/app/constant/constants.dart';
import 'package:admin_panel/app/constant/show_toast.dart';
import 'package:admin_panel/app/routes/app_pages.dart';
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
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';
import '../controllers/cuisine_controller.dart';

class CuisineView extends GetView<CuisineController> {
  const CuisineView({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetX<CuisineController>(
      init: CuisineController(),
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
                                        TextCustom(title: controller.title.value, fontSize: 20, fontFamily: FontFamily.bold),
                                        spaceH(height: 2),
                                        Row(children: [
                                          InkWell(
                                              onTap: () => Get.offAllNamed(Routes.DASHBOARD_SCREEN),
                                              child: TextCustom(title: 'Dashboard'.tr, fontSize: 14, fontFamily: FontFamily.medium, color: AppThemeData.lynch500)),
                                          const TextCustom(title: ' / ', fontSize: 14, fontFamily: FontFamily.medium, color: AppThemeData.lynch500),
                                          TextCustom(title: ' ${controller.title.value} ', fontSize: 14, fontFamily: FontFamily.medium, color: AppThemeData.primary500),
                                        ]),
                                      ]),
                                      const Spacer(),
                                      CustomButtonWidget(
                                          title: "+ Add Cuisine".tr,
                                          onPress: () {
                                            controller.setDefaultData();
                                            showDialog(context: context, builder: (context) => const AddCuisineDialog());
                                          }),
                                    ],
                                  )
                                : Column(mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.start, children: [
                                    Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                      TextCustom(title: controller.title.value, fontSize: 20, fontFamily: FontFamily.bold),
                                      spaceH(height: 2),
                                      Row(children: [
                                        InkWell(
                                            onTap: () => Get.offAllNamed(Routes.DASHBOARD_SCREEN),
                                            child: TextCustom(title: 'Dashboard'.tr, fontSize: 14, fontFamily: FontFamily.medium, color: AppThemeData.lynch500)),
                                        const TextCustom(title: ' / ', fontSize: 14, fontFamily: FontFamily.medium, color: AppThemeData.lynch500),
                                        TextCustom(title: ' ${controller.title.value} ', fontSize: 14, fontFamily: FontFamily.medium, color: AppThemeData.primary500)
                                      ]),
                                    ]),
                                    spaceH(),
                                    CustomButtonWidget(title: "+ Add Cuisine".tr, onPress: () {}),
                                  ]),
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
                                      : controller.cuisineList.isEmpty
                                          ? TextCustom(title: "No Data Available".tr)
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
                                                CommonUI.dataColumnWidget(context, columnTitle: "id".tr, width: ResponsiveWidget.isMobile(context) ? 100 : MediaQuery.of(context).size.width * 0.10),
                                                CommonUI.dataColumnWidget(context,
                                                    columnTitle: "Cuisine Name".tr, width: ResponsiveWidget.isMobile(context) ? 150 : MediaQuery.of(context).size.width * 0.22),
                                                CommonUI.dataColumnWidget(context,
                                                    columnTitle: "Status".tr, width: ResponsiveWidget.isMobile(context) ? 100 : MediaQuery.of(context).size.width * 0.16),
                                                CommonUI.dataColumnWidget(context, columnTitle: "Action".tr, width: ResponsiveWidget.isMobile(context) ? 100 : MediaQuery.of(context).size.width * 0.13)
                                              ],
                                              rows: controller.cuisineList
                                                  .map((cuisineModel) => DataRow(cells: [
                                                        DataCell(TextCustom(
                                                          title: "# ${cuisineModel.id!.substring(0, 7)}",
                                                        )),
                                                        DataCell(TextCustom(title: cuisineModel.cuisineName.toString())),
                                                        DataCell(
                                                          Transform.scale(
                                                            scale: 0.8,
                                                            child: CupertinoSwitch(
                                                              activeTrackColor: AppThemeData.primary500,
                                                              value: cuisineModel.active ?? false,
                                                              onChanged: (value) async {
                                                                if (Constant.isDemo) {
                                                                  DialogBox.demoDialogBox();
                                                                } else {
                                                                  cuisineModel.active = value;
                                                                  await FireStoreUtils.updateCuisine(cuisineModel);
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
                                                              spaceW(width: 20),
                                                              InkWell(
                                                                onTap: () async {
                                                                  controller.isEditing.value = true;
                                                                  controller.cuisineModel.value.id = cuisineModel.id;
                                                                  controller.cuisineNameController.value.text = cuisineModel.cuisineName!;
                                                                  controller.isActive.value = cuisineModel.active!;

                                                                  showDialog(context: context, builder: (context) => const AddCuisineDialog());
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
                                                                      await controller.removeCuisine(cuisineModel);
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
                                                        ))
                                                      ]))
                                                  .toList())),
                            )
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

class AddCuisineDialog extends StatelessWidget {
  const AddCuisineDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetX<CuisineController>(
      init: CuisineController(),
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
                            child: TextCustom(title: controller.isEditing.value ? "Edit Cuisine".tr : "Add Cuisine".tr, fontSize: 18))
                        .expand(),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 20, 24, 20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // controller.isEditing.value == true
                      //     ? Padding(
                      //   padding: const EdgeInsets.all(20),
                      //   child: Container(
                      //     height: 0.18.sh,
                      //     width: 0.30.sw,
                      //     decoration: BoxDecoration(
                      //       color: themeChange.isDarkTheme() ? AppThemeData.lynch800 : AppThemeData.lynch100,
                      //       borderRadius: BorderRadius.circular(12),
                      //     ),
                      //     child: Stack(
                      //       children: [
                      //         ClipRRect(
                      //           borderRadius: BorderRadius.circular(12),
                      //           child: CachedNetworkImage(
                      //             fit: BoxFit.contain,
                      //             height: 0.18.sh,
                      //             width: 0.30.sw,
                      //             imageUrl: controller.imageFile.value.path.isEmpty
                      //                 ? controller.imageURL.value
                      //                 : controller.imageFile.value.path,
                      //           ),
                      //         ),
                      //         Center(
                      //           child: InkWell(
                      //             onTap: () async {
                      //               if (Constant.isDemo) {
                      //                 DialogBox.demoDialogBox();
                      //               } else {
                      //                 ImagePicker picker = ImagePicker();
                      //                 final img = await picker.pickImage(source: ImageSource.gallery, imageQuality: 80);
                      //                 if (img != null) {
                      //                   File imageFile = File(img.path);
                      //                   // controller.bannerImageName.value.text = img.name;
                      //                   controller.imageFile.value = imageFile;
                      //                   controller.mimeType.value = "${img.mimeType}";
                      //                   // controller.isImageUpdated.value = true;
                      //                 }
                      //               }
                      //             },
                      //             child: controller.imageFile.value.path.isEmpty
                      //                 ? const Icon(
                      //               Icons.add,
                      //               color: AppThemeData.lynch500,
                      //             )
                      //                 : const SizedBox(),
                      //           ),
                      //         ),
                      //       ],
                      //     ),
                      //   ),
                      // )
                      //     : Padding(
                      //   padding: const EdgeInsets.all(20),
                      //   child: Container(
                      //     height: 0.18.sh,
                      //     width: 0.30.sw,
                      //     padding: const EdgeInsets.all(20),
                      //     decoration: BoxDecoration(
                      //       color: themeChange.isDarkTheme() ? AppThemeData.lynch800 : AppThemeData.lynch100,
                      //       borderRadius: BorderRadius.circular(12),
                      //     ),
                      //     child: Stack(
                      //       children: [
                      //         if (controller.imageFile.value.path.isNotEmpty)
                      //           ClipRRect(
                      //             borderRadius: BorderRadius.circular(12),
                      //             child: CachedNetworkImage(
                      //               fit: BoxFit.contain,
                      //               height: 0.18.sh,
                      //               width: 0.30.sw,
                      //               imageUrl: controller.imageFile.value.path,
                      //             ),
                      //           ),
                      //         Center(
                      //           child: InkWell(
                      //             onTap: () async {
                      //               if (Constant.isDemo) {
                      //                 DialogBox.demoDialogBox();
                      //               } else {
                      //                 ImagePicker picker = ImagePicker();
                      //                 final img = await picker.pickImage(source: ImageSource.gallery, imageQuality: 80);
                      //                 if (img != null) {
                      //                   File imageFile = File(img.path);
                      //                   // controller.bannerImageName.value.text = img.name;
                      //                   controller.imageFile.value = imageFile;
                      //                   controller.mimeType.value = "${img.mimeType}";
                      //                   // controller.isImageUpdated.value = true;
                      //                 }
                      //               }
                      //             },
                      //             child: controller.imageFile.value.path.isEmpty
                      //                 ? Row(
                      //               mainAxisAlignment: MainAxisAlignment.center,
                      //               children: [
                      //                 Text(
                      //                   'upload image'.tr,
                      //                   style: const TextStyle(
                      //                       fontSize: 16, color: AppThemeData.lynch500, fontFamily: FontFamily.medium),
                      //                 ),
                      //                 const SizedBox(
                      //                   width: 12,
                      //                 ),
                      //                 const Icon(
                      //                   Icons.file_upload_outlined,
                      //                   color: AppThemeData.lynch500,
                      //                 ),
                      //               ],
                      //             )
                      //                 : const SizedBox(),
                      //           ),
                      //         ),
                      //       ],
                      //     ),
                      //   ),
                      // ),
                      CustomTextFormField(hintText: "Enter Cuisine Name".tr, title: "Cuisine Name".tr, controller: controller.cuisineNameController.value),
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
                            onPress: () {
                              if (Constant.isDemo) {
                                DialogBox.demoDialogBox();
                              } else {
                                if (controller.cuisineNameController.value.text != "") {
                                  controller.isEditing.value ? controller.updateCuisine() : controller.addCuisine();
                                  controller.setDefaultData();
                                  Navigator.pop(context);
                                } else {
                                  ShowToastDialog.errorToast("All fields are required.".tr);
                                }
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
