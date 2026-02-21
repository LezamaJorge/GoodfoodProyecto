// ignore_for_file: deprecated_member_use

import 'dart:io';

import 'package:admin_panel/app/components/custom_button.dart';
import 'package:admin_panel/app/components/custom_text_form_field.dart';
import 'package:admin_panel/app/components/dialog_box.dart';
import 'package:admin_panel/app/constant/constants.dart';
import 'package:admin_panel/app/constant/show_toast.dart';
import 'package:admin_panel/app/utils/app_colors.dart';
import 'package:admin_panel/app/utils/app_them_data.dart';
import 'package:admin_panel/app/utils/dark_theme_provider.dart';
import 'package:admin_panel/app/utils/responsive.dart';
import 'package:admin_panel/widget/common_ui.dart';
import 'package:admin_panel/widget/container_custom.dart';
import 'package:admin_panel/widget/global_widgets.dart';
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
import '../../../utils/fire_store_utils.dart';
import '../controllers/language_controller.dart';

class LanguageView extends GetView<LanguageController> {
  const LanguageView({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetBuilder<LanguageController>(
      init: LanguageController(),
      builder: (controller) {
        return Obx(
          () => SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(mainAxisSize: MainAxisSize.min, mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.start, children: [
              ContainerCustom(
                child: Column(children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      ResponsiveWidget.isDesktop(context)
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                TextCustom(title: controller.title.value.tr, fontSize: 20, fontFamily: FontFamily.bold),
                                spaceH(height: 2),
                                Row(children: [
                                  InkWell(
                                      onTap: () => Get.offAllNamed(Routes.DASHBOARD_SCREEN),
                                      child: TextCustom(title: 'Dashboard'.tr, fontSize: 14, fontFamily: FontFamily.medium, color: AppThemeData.lynch500)),
                                  const TextCustom(title: ' / ', fontSize: 14, fontFamily: FontFamily.medium, color: AppThemeData.lynch500),
                                  TextCustom(title: 'Settings'.tr, fontSize: 14, fontFamily: FontFamily.medium, color: AppThemeData.lynch500),
                                  const TextCustom(title: ' / ', fontSize: 14, fontFamily: FontFamily.medium, color: AppThemeData.lynch500),
                                  TextCustom(title: ' ${controller.title.value.tr} ', fontSize: 14, fontFamily: FontFamily.medium, color: AppThemeData.primary500)
                                ])
                              ],
                            )
                          : TextCustom(title: ' ${controller.title.value.tr} ', fontSize: 14, fontFamily: FontFamily.medium, color: AppThemeData.primaryBlack),
                      CustomButtonWidget(
                        padding: const EdgeInsets.symmetric(horizontal: 22),
                        title: "+ Add Language".tr,
                        onPress: () {
                          controller.setDefaultData();
                          showDialog(context: context, builder: (context) => const CustomDialog());
                        },
                      ),
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
                          : controller.languageList.isEmpty
                          ? TextCustom(title: "No Data available".tr)
                          : DataTable(
                              horizontalMargin: 20,
                              columnSpacing: 30,
                              dataRowMaxHeight: 65,
                              headingRowHeight: 65,
                              border: TableBorder.all(
                                color: themeChange.isDarkTheme() ? AppThemeData.lynch900 : AppThemeData.lynch100,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              headingRowColor: WidgetStateColor.resolveWith((states) => themeChange.isDarkTheme() ? AppThemeData.lynch900 : AppThemeData.lynch100),
                              columns: [
                                CommonUI.dataColumnWidget(context,
                                    columnTitle: "Id".tr, width: ResponsiveWidget.isMobile(context) ? 50 : MediaQuery.of(context).size.width * 0.08),
                                CommonUI.dataColumnWidget(context,
                                    columnTitle: "Name".tr, width: ResponsiveWidget.isMobile(context) ? 120 : MediaQuery.of(context).size.width * 0.15),
                                CommonUI.dataColumnWidget(context,
                                    columnTitle: "Code".tr, width: ResponsiveWidget.isMobile(context) ? 100 : MediaQuery.of(context).size.width * 0.15),
                                CommonUI.dataColumnWidget(context,
                                    columnTitle: "Status".tr, width: ResponsiveWidget.isMobile(context) ? 90 : MediaQuery.of(context).size.width * 0.10),
                                CommonUI.dataColumnWidget(context,
                                    columnTitle: "Actions".tr, width: ResponsiveWidget.isMobile(context) ? 80 : MediaQuery.of(context).size.width * 0.10),
                              ],
                              rows: controller.languageList
                                  .map((languageModel) => DataRow(cells: [
                                        DataCell(TextCustom(title: "${controller.languageList.indexWhere((element) => element == languageModel) + 1}")),
                                        DataCell(TextCustom(title: "${languageModel.name}")),
                                        DataCell(TextCustom(title: "${languageModel.code}")),
                                        DataCell(
                                          SizedBox(
                                            height: 10,
                                            child: Transform.scale(
                                              scale: 0.8,
                                              child: CupertinoSwitch(
                                                activeTrackColor: AppThemeData.primary500,
                                                value: languageModel.active!,
                                                onChanged: (value) async {
                                                  if (Constant.isDemo) {
                                                    DialogBox.demoDialogBox();
                                                  } else {
                                                    languageModel.active = value;
                                                    await FireStoreUtils.updateLanguage(languageModel);
                                                    controller.getData();
                                                  }
                                                },
                                              ),
                                            ),
                                          ),
                                        ),
                                        DataCell(
                                          Container(
                                            alignment: Alignment.center,
                                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: [
                                                InkWell(
                                                  onTap: () {
                                                    controller.isEditing.value = true;
                                                    controller.languageModel.value.id = languageModel.id!;
                                                    controller.languageController.value.text = languageModel.name!;
                                                    controller.codeController.value.text = languageModel.code!;
                                                    controller.isActive.value = languageModel.active!;
                                                    controller.imageURL.value = languageModel.image!;

                                                    showDialog(context: context, builder: (context) => const CustomDialog());
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
                                                        await controller.removeLanguage(languageModel);
                                                        controller.getData();
                                                      }
                                                    }
                                                  },
                                                  child: SvgPicture.asset(
                                                    "assets/icons/ic_delete.svg",
                                                    //color: AppThemeData.lynch400,
                                                    height: 16,
                                                    width: 16,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ]))
                                  .toList()),
                    ),
                  ),
                  spaceH(),
                ]),
              )
            ]),
          ),
        );
      },
    );
  }
}

class CustomDialog extends StatelessWidget {
  const CustomDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetX<LanguageController>(
        init: LanguageController(),
        builder: (controller) {
          return Dialog(
            backgroundColor: themeChange.isDarkTheme() ? AppThemeData.lynch950 : AppThemeData.lynch50,
            shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8.0))),
            alignment: Alignment.topCenter,
            // title: const TextCustom(title: 'Item Categories', fontSize: 18),
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
                              child: TextCustom(title: '${controller.title}', fontSize: 18))
                          .expand(),
                    ],
                  ),
                  spaceH(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: TextCustom(
                      title: 'Upload Language image'.tr,
                      fontSize: 14,
                    ),
                  ),
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
                                          File imageFile = File(img.path);
                                          // controller.bannerImageName.value.text = img.name;
                                          controller.imageFile.value = imageFile;
                                          controller.mimeType.value = "${img.mimeType}";
                                          // controller.isImageUpdated.value = true;
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
                                          File imageFile = File(img.path);
                                          // controller.bannerImageName.value.text = img.name;
                                          controller.imageFile.value = imageFile;
                                          controller.mimeType.value = "${img.mimeType}";
                                          // controller.isImageUpdated.value = true;
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
                  spaceH(height: 16),
                  Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          children: [
                            Expanded(child: CustomTextFormField(hintText: 'Enter Language Name'.tr, controller: controller.languageController.value, title: 'Name *'.tr)),
                            spaceW(width: 24),
                            Expanded(child: CustomTextFormField(hintText: 'Enter Language Code'.tr, controller: controller.codeController.value, title: 'Code *'.tr)),
                          ],
                        ),
                        spaceH(height: 16),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              children: [
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
                                spaceH(height: 16),
                              ],
                            ),
                          ],
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
                                  if (controller.languageController.value.text != "" && controller.codeController.value.text != "") {
                                    controller.isEditing.value ? controller.updateLanguage() : controller.addLanguage();
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
        });
  }
}
