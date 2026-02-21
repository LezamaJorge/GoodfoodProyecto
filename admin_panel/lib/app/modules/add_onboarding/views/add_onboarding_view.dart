// ignore_for_file: deprecated_member_use

import 'dart:io';
import 'package:admin_panel/app/components/custom_button.dart';
import 'package:admin_panel/app/components/custom_text_form_field.dart';
import 'package:admin_panel/app/components/dialog_box.dart';
import 'package:admin_panel/app/components/menu_widget.dart';
import 'package:admin_panel/app/components/network_image_widget.dart';
import 'package:admin_panel/app/constant/constants.dart';
import 'package:admin_panel/app/constant/show_toast.dart';
import 'package:admin_panel/app/models/onboarding_model.dart';
import 'package:admin_panel/app/modules/add_onboarding/controllers/add_onboarding_controller.dart';
import 'package:admin_panel/app/utils/app_colors.dart';
import 'package:admin_panel/app/utils/app_them_data.dart';
import 'package:admin_panel/app/utils/dark_theme_provider.dart';
import 'package:admin_panel/app/utils/fire_store_utils.dart';
import 'package:admin_panel/app/utils/responsive.dart';
import 'package:admin_panel/widget/common_ui.dart';
import 'package:admin_panel/widget/container_custom.dart';
import 'package:admin_panel/widget/global_widgets.dart';
import 'package:admin_panel/widget/text_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../../../routes/app_pages.dart';

class AddOnboardingView extends GetView<AddOnboardingController> {
  const AddOnboardingView({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetX<AddOnboardingController>(
        init: AddOnboardingController(),
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
                                  TextCustom(
                                    title: '${Constant.appName}',
                                    color: AppThemeData.primary500,
                                    fontSize: 25,
                                    fontFamily: FontFamily.titleBold,
                                    fontWeight: FontWeight.w600,
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
                  child: themeChange.isDarkTheme()
                      ? SvgPicture.asset(
                          "assets/icons/ic_sun.svg",
                          color: AppThemeData.lynch100,
                          height: 20,
                          width: 20,
                        )
                      : SvgPicture.asset(
                          "assets/icons/ic_moon.svg",
                          color: AppThemeData.lynch900,
                          height: 20,
                          width: 20,
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
                    child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: paddingEdgeInsets(),
                        child: ContainerCustom(
                          child: Column(
                            children: [
                              Row(
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
                                  CustomButtonWidget(
                                    padding: const EdgeInsets.symmetric(horizontal: 22),
                                    title: "+ Add".tr,
                                    onPress: () {
                                      controller.setDefaultData();
                                      showDialog(context: context, builder: (context) => const AddOnboardingScreen());
                                    },
                                  ),
                                ],
                              ),
                              spaceH(height: 20),
                              controller.isLoading.value
                                  ? Padding(
                                      padding: paddingEdgeInsets(),
                                      child: Constant.loader(),
                                    )
                                  : SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(12),
                                        child: controller.onboardingScreenList.isEmpty
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
                                                      columnTitle: "Image".tr, width: ResponsiveWidget.isMobile(context) ? 120 : MediaQuery.of(context).size.width * 0.10),
                                                  CommonUI.dataColumnWidget(context,
                                                      columnTitle: "Title".tr, width: ResponsiveWidget.isMobile(context) ? 150 : MediaQuery.of(context).size.width * 0.14),
                                                  CommonUI.dataColumnWidget(context,
                                                      columnTitle: "Description".tr, width: ResponsiveWidget.isMobile(context) ? 150 : MediaQuery.of(context).size.width * 0.20),
                                                  CommonUI.dataColumnWidget(context, columnTitle: "Type".tr, width: ResponsiveWidget.isMobile(context) ? 150 : MediaQuery.of(context).size.width * 0.1),
                                                  CommonUI.dataColumnWidget(context,
                                                      columnTitle: "Status".tr, width: ResponsiveWidget.isMobile(context) ? 100 : MediaQuery.of(context).size.width * 0.05),
                                                  CommonUI.dataColumnWidget(context,
                                                      columnTitle: "Actions".tr, width: ResponsiveWidget.isMobile(context) ? 70 : MediaQuery.of(context).size.width * 0.08),
                                                ],
                                                rows: controller.onboardingScreenList
                                                    .map((onboarding) => DataRow(cells: [
                                                          DataCell(
                                                            Container(
                                                              alignment: Alignment.center,
                                                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                                                              child: NetworkImageWidget(
                                                                fit: BoxFit.fill,
                                                                imageUrl: '${onboarding.lightModeImage}',
                                                                borderRadius: 10,
                                                                height: 40,
                                                                width: 80,
                                                              ),
                                                            ),
                                                          ),
                                                          DataCell(TextCustom(title: onboarding.title ?? "N/A".tr)),
                                                          DataCell(TextCustom(
                                                            title: onboarding.description ?? "N/A".tr,
                                                            maxLine: 2,
                                                          )),
                                                          DataCell(TextCustom(
                                                            title: onboarding.type == "customer"
                                                                ? "Customer".tr
                                                                : onboarding.type == "driver"
                                                                    ? "Driver".tr
                                                                    : "Vendor".tr,
                                                          )),
                                                          DataCell(
                                                            Transform.scale(
                                                              scale: 0.8,
                                                              child: CupertinoSwitch(
                                                                activeTrackColor: AppThemeData.primary500,
                                                                value: onboarding.status!,
                                                                onChanged: (value) async {
                                                                  if (Constant.isDemo) {
                                                                    DialogBox.demoDialogBox();
                                                                  } else {
                                                                    onboarding.status = value;
                                                                    await FireStoreUtils.updateOnboardingScreen(onboarding);
                                                                    controller.getData();
                                                                  }
                                                                },
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
                                                                      showDialog(
                                                                          context: context,
                                                                          builder: (context) => AddOnboardingScreen(
                                                                                onboardingModel: onboarding,
                                                                                isEditing: true,
                                                                              ));
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
                                                                          await controller.removeOnboarding(onboarding);
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
                                                            ),
                                                          ),
                                                        ]))
                                                    .toList()),
                                      ),
                                    )
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ))
              ],
            ),
          );
        });
  }
}

class AddOnboardingScreen extends StatelessWidget {
  final OnboardingScreenModel? onboardingModel;
  final bool isEditing;

  const AddOnboardingScreen({super.key, this.onboardingModel, this.isEditing = false});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetX(
        init: AddOnboardingController(),
        builder: (controller) {
          if (isEditing == true && onboardingModel != null) {
            controller.getArgument(onboardingModel!);
          }
          return CustomDialog(
            controller: controller,
            title: controller.title.value,
            widgetList: [
              Visibility(
                visible: controller.isEditing.value,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "✍ Edit your OnBoarding here".tr,
                      style: TextStyle(
                        fontFamily: FontFamily.bold,
                        fontWeight: FontWeight.w800,
                        fontSize: 16,
                        color: themeChange.isDarkTheme() ? AppThemeData.lynch25 : AppThemeData.primaryBlack,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Center(
                child: Row(
                  children: [
                    // Light Mode Image
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const TextCustom(
                            title: "Light Mode Image",
                            fontSize: 14,
                          ),
                          spaceH(height: 8),
                          controller.isEditing.value == true
                              ? InkWell(
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
                                        controller.lightModeImageController.value.text = img.name;
                                        controller.lightModeImage.value = imageFile;
                                        controller.mimeType.value = "${img.mimeType}";
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
                                        height: 124.h,
                                        width: double.infinity,
                                        decoration: const BoxDecoration(
                                          borderRadius: BorderRadius.all(Radius.circular(12)),
                                        ),
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(12),
                                          child: NetworkImageWidget(
                                            imageUrl: controller.lightModeImage.value.path.isEmpty ? controller.lightModeImageURL.value : controller.lightModeImage.value.path,
                                            height: 124.h,
                                            fit: BoxFit.contain,
                                          ),
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
                                        final allowedExtensions = ['jpg', 'jpeg', 'png'];
                                        String fileExtension = img.name.split('.').last.toLowerCase();

                                        if (!allowedExtensions.contains(fileExtension)) {
                                          ShowToastDialog.errorToast("Invalid file type. Please select a .jpg, .jpeg, or .png image.".tr);
                                          return;
                                        }
                                        File imageFile = File(img.path);
                                        controller.lightModeImageController.value.text = img.name;
                                        controller.lightModeImage.value = imageFile;
                                        controller.mimeType.value = "${img.mimeType}";
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
                                        height: 124.h,
                                        width: double.infinity,
                                        decoration: const BoxDecoration(
                                          borderRadius: BorderRadius.all(Radius.circular(12)),
                                        ),
                                        child: controller.lightModeImage.value.path.isNotEmpty
                                            ? ClipRRect(
                                                borderRadius: BorderRadius.circular(12),
                                                child: CachedNetworkImage(
                                                  imageUrl: controller.lightModeImage.value.path,
                                                  height: 124.h,
                                                  fit: BoxFit.contain,
                                                ),
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
                                                        title: "Upload the Image".tr,
                                                        maxLine: 2,
                                                        color: themeChange.isDarkTheme() ? AppThemeData.primaryWhite : AppThemeData.primaryBlack,
                                                        fontFamily: FontFamily.regular,
                                                      ),
                                                      TextCustom(
                                                        title: "image must be a .jpg, .jpeg".tr,
                                                        maxLine: 1,
                                                        fontSize: 12,
                                                        color: AppThemeData.secondary300,
                                                        fontFamily: FontFamily.light,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              )),
                                  ),
                                ),
                        ],
                      ),
                    ),
                    spaceW(width: 20),
                    // Dark Mode Image
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const TextCustom(
                            title: "Dark Mode Image",
                            fontSize: 14,
                          ),
                          spaceH(height: 8),
                          controller.isEditing.value == true
                              ? InkWell(
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
                                        controller.darkModeImageController.value.text = img.name;
                                        controller.darkModeImage.value = imageFile;
                                        controller.mimeType.value = "${img.mimeType}";
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
                                        height: 124.h,
                                        width: double.infinity,
                                        decoration: const BoxDecoration(
                                          borderRadius: BorderRadius.all(Radius.circular(12)),
                                        ),
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(12),
                                          child: NetworkImageWidget(
                                            imageUrl: controller.darkModeImage.value.path.isEmpty ? controller.darkModeImageURL.value : controller.darkModeImage.value.path,
                                            height: 124.h,
                                            fit: BoxFit.contain,
                                          ),
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
                                        final allowedExtensions = ['jpg', 'jpeg', 'png'];
                                        String fileExtension = img.name.split('.').last.toLowerCase();

                                        if (!allowedExtensions.contains(fileExtension)) {
                                          ShowToastDialog.errorToast("Invalid file type. Please select a .jpg, .jpeg, or .png image.".tr);
                                          return;
                                        }
                                        File imageFile = File(img.path);
                                        controller.darkModeImageController.value.text = img.name;
                                        controller.darkModeImage.value = imageFile;
                                        controller.mimeType.value = "${img.mimeType}";
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
                                        height: 124.h,
                                        width: double.infinity,
                                        decoration: const BoxDecoration(
                                          borderRadius: BorderRadius.all(Radius.circular(12)),
                                        ),
                                        child: controller.darkModeImage.value.path.isNotEmpty
                                            ? ClipRRect(
                                                borderRadius: BorderRadius.circular(12),
                                                child: CachedNetworkImage(
                                                  imageUrl: controller.darkModeImage.value.path,
                                                  height: 124.h,
                                                  fit: BoxFit.contain,
                                                ),
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
                                                        title: "Upload the Image".tr,
                                                        maxLine: 2,
                                                        color: themeChange.isDarkTheme() ? AppThemeData.primaryWhite : AppThemeData.primaryBlack,
                                                        fontFamily: FontFamily.regular,
                                                      ),
                                                      TextCustom(
                                                        title: "image must be a .jpg, .jpeg".tr,
                                                        maxLine: 1,
                                                        fontSize: 12,
                                                        color: AppThemeData.secondary300,
                                                        fontFamily: FontFamily.light,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              )),
                                  ),
                                ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              spaceH(height: 20),
              CustomTextFormField(hintText: "Enter Title", title: "Title", controller: controller.titleController.value),
              spaceH(height: 20),
              CustomTextFormField(
                hintText: "Enter Description",
                title: "Description",
                controller: controller.descriptionController.value,
                maxLine: 2,
              ),
              spaceH(height: 20),
              Row(
                children: [
                  Expanded(
                      child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextCustom(
                        title: 'User Type'.tr,
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
                          hint:
                              TextCustom(title: 'Select User Type'.tr, fontSize: 14, fontFamily: FontFamily.regular, color: themeChange.isDarkTheme() ? AppThemeData.lynch300 : AppThemeData.lynch400),
                          onChanged: (String? userType) {
                            controller.selectedUserType.value = userType ?? "Customer";
                          },
                          value: controller.selectedUserType.value,
                          icon: const Icon(Icons.keyboard_arrow_down_outlined),
                          items: controller.userType.map<DropdownMenuItem<String>>((String value) {
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextCustom(
                          title: 'Status'.tr,
                          fontSize: 12,
                        ),
                        spaceH(),
                        Obx(
                          () => Transform.scale(
                            scale: 0.8,
                            child: CupertinoSwitch(
                              activeColor: AppThemeData.primary500,
                              value: controller.isActive.value,
                              onChanged: (value) {
                                controller.isActive.value = value;
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              )
            ],
            bottomWidgetList: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  CustomButtonWidget(
                    title: "Close".tr,
                    buttonColor: themeChange.isDarkTheme() ? AppThemeData.lynch500 : AppThemeData.lynch500,
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
                        if (controller.titleController.value.text.isNotEmpty &&
                            controller.lightModeImageController.value.text.isNotEmpty &&
                            controller.darkModeImageController.value.text.isNotEmpty &&
                            controller.descriptionController.value.text.isNotEmpty) {
                          controller.isEditing.value == true ? controller.updateOnboardingScreen() : controller.addOnboardingScreen();
                        } else {
                          ShowToastDialog.errorToast("All fields are required.".tr);
                        }
                      }
                    },
                  ),
                ],
              ),
            ],
          );
        });
  }
}
