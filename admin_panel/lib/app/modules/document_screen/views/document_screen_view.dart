// ignore_for_file: deprecated_member_use

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
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import '../../../components/menu_widget.dart';
import '../../../routes/app_pages.dart';
import '../../../utils/fire_store_utils.dart';
import '../controllers/document_screen_controller.dart';

class DocumentScreenView extends GetView<DocumentScreenController> {
  const DocumentScreenView({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetBuilder<DocumentScreenController>(
      init: DocumentScreenController(),
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
                  child: Obx(
                    () => SingleChildScrollView(
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
                                      CustomButtonWidget(
                                        padding: const EdgeInsets.symmetric(horizontal: 22),
                                        onPress: () {
                                          controller.setDefaultData();
                                          showDialog(context: context, builder: (context) => const DocumentDialog());
                                        },
                                        title: '+ Add Document'.tr,
                                      ),
                                    ],
                                  )
                                : Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
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
                                      CustomButtonWidget(
                                        width: MediaQuery.sizeOf(context).width * 0.7,
                                        padding: const EdgeInsets.symmetric(horizontal: 22),
                                        title: "+ Add Document".tr,
                                        onPress: () {
                                          controller.setDefaultData();
                                          showDialog(context: context, builder: (context) => const DocumentDialog());
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
                                    : controller.documentsList.isEmpty
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
                                            headingRowColor: MaterialStateColor.resolveWith((states) => themeChange.isDarkTheme() ? AppThemeData.lynch900 : AppThemeData.lynch100),
                                            columns: [
                                              CommonUI.dataColumnWidget(context,
                                                  columnTitle: "Title".tr, width: ResponsiveWidget.isMobile(context) ? 150 : MediaQuery.of(context).size.width * 0.20),
                                              CommonUI.dataColumnWidget(context,
                                                  columnTitle: "Side".tr, width: ResponsiveWidget.isMobile(context) ? 150 : MediaQuery.of(context).size.width * 0.10),
                                              CommonUI.dataColumnWidget(context,
                                                  columnTitle: "Type".tr, width: ResponsiveWidget.isMobile(context) ? 150 : MediaQuery.of(context).size.width * 0.10),
                                              CommonUI.dataColumnWidget(context,
                                                  columnTitle: "Status".tr, width: ResponsiveWidget.isMobile(context) ? 100 : MediaQuery.of(context).size.width * 0.10),
                                              CommonUI.dataColumnWidget(context,
                                                  columnTitle: "Actions".tr, width: ResponsiveWidget.isMobile(context) ? 80 : MediaQuery.of(context).size.width * 0.10),
                                            ],
                                            rows: controller.documentsList
                                                .map((documentsModel) => DataRow(cells: [
                                                      DataCell(TextCustom(title: documentsModel.title)),
                                                      DataCell(TextCustom(title: documentsModel.isTwoSide == true ? "Two Side" : "One Side")),
                                                      DataCell(
                                                        TextCustom(
                                                          title: documentsModel.type.toString(),
                                                          fontSize: 14,
                                                          fontFamily: FontFamily.medium,
                                                        ),
                                                      ),
                                                      DataCell(
                                                        Transform.scale(
                                                          scale: 0.8,
                                                          child: CupertinoSwitch(
                                                            activeColor: AppThemeData.primary500,
                                                            value: documentsModel.active!,
                                                            onChanged: (value) async {
                                                              if (Constant.isDemo) {
                                                                DialogBox.demoDialogBox();
                                                              } else {
                                                                documentsModel.active = value;
                                                                await FireStoreUtils.updateDocument(documentsModel);
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
                                                                  controller.isEditing.value = true;
                                                                  controller.editingId.value = documentsModel.id;
                                                                  controller.isActive.value = documentsModel.active!;
                                                                  controller.documentSide.value = documentsModel.isTwoSide == true ? SideAt.isTwoSide : SideAt.isOneSide;
                                                                  controller.documentNameController.value.text = documentsModel.title;
                                                                  controller.selectedDocumentType.value=documentsModel.type.toString();
                                                                  showDialog(context: context, builder: (context) => const DocumentDialog());
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
                                                                    // controller.removeDocument(documentsModel);
                                                                    bool confirmDelete = await DialogBox.showConfirmationDeleteDialog(context);
                                                                    if (confirmDelete) {
                                                                      controller.removeDocument(documentsModel);
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
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

enum SideAt { isOneSide, isTwoSide }

class DocumentDialog extends StatelessWidget {
  const DocumentDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetX<DocumentScreenController>(
      init: DocumentScreenController(),
      builder: (controller) {
        return CustomDialog(
          title: controller.title.value.tr,
          widgetList: [
            Row(
              children: [
                Expanded(child: CustomTextFormField(hintText: 'Enter Document'.tr, controller: controller.documentNameController.value, title: 'Title *'.tr)),
                spaceW(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextCustom(
                        title: 'User Type *'.tr,
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
                              title: 'Select Document Type'.tr,
                              fontSize: 14,
                              fontFamily: FontFamily.regular,
                              color: themeChange.isDarkTheme() ? AppThemeData.lynch300 : AppThemeData.lynch400),
                          onChanged: (String? taxType) {
                            controller.selectedDocumentType.value = taxType ?? "Driver";
                          },
                          value: controller.selectedDocumentType.value,
                          icon: const Icon(Icons.keyboard_arrow_down_outlined),
                          items: controller.documentType.map<DropdownMenuItem<String>>((String value) {
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
                  ),
                ),
              ],
            ),
            spaceH(),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextCustom(
                        title: 'Status'.tr,
                        fontSize: 12,
                      ),
                      spaceH(),
                      Transform.scale(
                        scale: 0.8,
                        child: CupertinoSwitch(
                          activeColor: AppThemeData.primary500,
                          value: controller.isActive.value,
                          onChanged: (value) {
                            controller.isActive.value = value;
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextCustom(
                            title: 'Document Side'.tr,
                            fontSize: 12,
                          ),
                          spaceH(),
                          FittedBox(
                            child: Row(
                              children: [
                                Row(
                                  children: [
                                    Radio(
                                      value: SideAt.isTwoSide.obs,
                                      groupValue: controller.documentSide.value,
                                      onChanged: (value) {
                                        controller.documentSide.value = SideAt.isTwoSide;
                                      },
                                      activeColor: AppThemeData.primary500,
                                    ),
                                    Text("Two Side".tr,
                                        style: const TextStyle(
                                          fontFamily: FontFamily.regular,
                                          fontSize: 14,
                                          color: AppThemeData.textGrey,
                                        ))
                                  ],
                                ),
                                spaceW(width: 10),
                                Row(
                                  children: [
                                    Radio(
                                      value: SideAt.isOneSide.obs,
                                      groupValue: controller.documentSide.value,
                                      onChanged: (value) {
                                        controller.documentSide.value = SideAt.isOneSide;
                                      },
                                      activeColor: AppThemeData.primary500,
                                    ),
                                    Text("One Side".tr,
                                        style: const TextStyle(
                                          fontFamily: FontFamily.regular,
                                          fontSize: 14,
                                          color: AppThemeData.textGrey,
                                        ))
                                  ],
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
          bottomWidgetList: [
            CustomButtonWidget(
              title: "Close".tr,
              buttonColor: themeChange.isDarkTheme() ? AppThemeData.lynch900 : AppThemeData.lynch500,
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
                  if (controller.documentNameController.value.text.isNotEmpty && controller.selectedDocumentType.value.isNotEmpty) {
                    controller.isEditing.value ? controller.updateDocument() : controller.addDocument();
                    controller.setDefaultData();
                    Navigator.pop(context);
                  } else {
                    ShowToastDialog.errorToast("All fields are required.".tr);
                  }
                }
              },
            ),
          ],
          controller: controller,
        );
      },
    );
  }
}
