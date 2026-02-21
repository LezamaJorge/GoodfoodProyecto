// ignore_for_file: deprecated_member_use

import 'package:admin_panel/app/components/custom_button.dart';
import 'package:admin_panel/app/components/custom_text_form_field.dart';
import 'package:admin_panel/app/components/menu_widget.dart';
import 'package:admin_panel/app/components/network_image_widget.dart';
import 'package:admin_panel/app/constant/constants.dart';
import 'package:admin_panel/app/constant/show_toast.dart';
import 'package:admin_panel/app/models/documents_model.dart';
import 'package:admin_panel/app/modules/new_join_restaurant_screen/controllers/new_restaurant_join_request_controller.dart';
import 'package:admin_panel/app/utils/app_colors.dart';
import 'package:admin_panel/app/utils/app_them_data.dart';
import 'package:admin_panel/app/utils/dark_theme_provider.dart';
import 'package:admin_panel/app/utils/fire_store_utils.dart';
import 'package:admin_panel/app/utils/responsive.dart';
import 'package:admin_panel/app/utils/screen_size.dart';
import 'package:admin_panel/widget/common_ui.dart';
import 'package:admin_panel/widget/container_custom.dart';
import 'package:admin_panel/widget/global_widgets.dart';
import 'package:admin_panel/widget/gradient_text.dart';
import 'package:admin_panel/widget/text_widget.dart';
import 'package:admin_panel/widget/web_pagination.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import '../../../routes/app_pages.dart';

class NewRestaurantJoinRequestScreenView extends GetView<NewRestaurantJoinRequestController> {
  const NewRestaurantJoinRequestScreenView({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetX<NewRestaurantJoinRequestController>(
      init: NewRestaurantJoinRequestController(),
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
                                      NumberOfRowsDropDown(
                                        controller: controller,
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
                                      NumberOfRowsDropDown(
                                        controller: controller,
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
                                    : controller.currentPageVerifyOwner.isEmpty
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
                                                  columnTitle: "Owner  Name".tr, width: ResponsiveWidget.isMobile(context) ? 200 : MediaQuery.of(context).size.width * 0.20),
                                              CommonUI.dataColumnWidget(context,
                                                  columnTitle: "Owner Email".tr, width: ResponsiveWidget.isMobile(context) ? 250 : MediaQuery.of(context).size.width * 0.25),
                                              CommonUI.dataColumnWidget(context,
                                                  columnTitle: "Document Verify".tr, width: ResponsiveWidget.isMobile(context) ? 140 : MediaQuery.of(context).size.width * 0.1),
                                            ],
                                            rows: controller.currentPageVerifyOwner
                                                .map((user) => DataRow(cells: [
                                                      DataCell(TextCustom(title: user.fullNameString().isEmpty ? "N/A" : user.fullNameString())),
                                                      DataCell(TextCustom(title: user.email == null || user.email!.isEmpty ? "N/A" : Constant.maskEmail(email: user.email.toString()))),
                                                      DataCell(CustomButtonWidget(
                                                        title: "Unverified",
                                                        buttonColor: AppThemeData.danger300,
                                                        height: 42,
                                                        width: 130,
                                                        radius: 50,
                                                        onPress: () {
                                                          controller.getArgument(user);
                                                          if (user.verifyDocument != null && user.verifyDocument!.isNotEmpty) {
                                                            showDialog(context: context, builder: (context) => const VerifyDriverDialog());
                                                          } else {
                                                            ShowToastDialog.errorToast("Owner Not Uploaded Document");
                                                          }
                                                        },
                                                      )),
                                                    ]))
                                                .toList()),
                              ),
                            ),
                            spaceH(),
                            ResponsiveWidget.isMobile(context)
                                ? SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Visibility(
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
                                                  // if (controller.currentPage.value < 1 || controller.currentPage.value > controller.totalPage.value) {
                                                  //   controller.currentPage.value = 1; // Reset to the first page if out of bounds
                                                  // }
                                                  controller.currentPage.value = page;
                                                  controller.setPagination(controller.totalItemPerPage.value);
                                                }),
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
                                        ),
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
      },
    );
  }
}

class VerifyDriverDialog extends StatelessWidget {
  const VerifyDriverDialog({super.key, data});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetBuilder(
      init: NewRestaurantJoinRequestController(),
      builder: (controller) {
        return SingleChildScrollView(
          child: CustomDialog(
            title: controller.title.value,
            width: ScreenSize.width(50, context),
            widgetList: [
              SizedBox(
                height: ScreenSize.height(70, context),
                child: ListView(
                  children: [
                    ContainerCustom(
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                TextCustom(title: controller.ownerModel.value.fullNameString(), fontSize: 14, fontFamily: FontFamily.bold),
                                // TextCustom(title: Constant.maskEmail(email: controller.verifyDriverModel.value.driverEmail.toString()), fontSize: 14, fontFamily: FontFamily.bold),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    spaceH(),
                    if (controller.verifyDocumentList.isNotEmpty) ...{
                      ContainerCustom(
                        // borderColor: Colors.pink,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Obx(
                              () => DataTable(
                                  horizontalMargin: 20,
                                  columnSpacing: 30,
                                  dataRowMaxHeight: 65,
                                  headingRowHeight: 65,
                                  border: TableBorder.all(
                                    color: themeChange.isDarkTheme() ? AppThemeData.lynch950 : AppThemeData.lynch25,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  headingRowColor: WidgetStateColor.resolveWith((states) => themeChange.isDarkTheme() ? AppThemeData.lynch950 : AppThemeData.lynch25),
                                  columns: [
                                    CommonUI.dataColumnWidget(context, columnTitle: "Name".tr, width: 150),
                                    CommonUI.dataColumnWidget(context, columnTitle: "Document".tr, width: 150),
                                    CommonUI.dataColumnWidget(context, columnTitle: "status".tr, width: 100),
                                    CommonUI.dataColumnWidget(context, columnTitle: "Verify".tr, width: 100),
                                  ],
                                  rows: controller.verifyDocumentList
                                      .map((verifyDocumentModel) => DataRow(cells: [
                                            DataCell(
                                              FutureBuilder<DocumentsModel?>(
                                                  future: FireStoreUtils.getDocumentByDocumentId(verifyDocumentModel.documentId.toString()),
                                                  // async work
                                                  builder: (BuildContext context, AsyncSnapshot<DocumentsModel?> snapshot) {
                                                    switch (snapshot.connectionState) {
                                                      case ConnectionState.waiting:
                                                        // return Center(child: Constant.loader());
                                                        return const SizedBox();
                                                      default:
                                                        if (snapshot.hasError) {
                                                          return TextCustom(
                                                            title: 'Error: ${snapshot.error}',
                                                          );
                                                        } else {
                                                          if (snapshot.data == null) {
                                                            return const TextCustom(title: 'Document is Deleted');
                                                          }

                                                          DocumentsModel documentModel = snapshot.data!;
                                                          return Container(
                                                            alignment: Alignment.centerLeft,
                                                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                                                            child: TextButton(
                                                              onPressed: () {},
                                                              child: TextCustom(
                                                                title: documentModel.title.isEmpty || documentModel.title == '' ? "N/A".tr : documentModel.title.toString(),
                                                              ),
                                                            ),
                                                          );
                                                        }
                                                    }
                                                  }),
                                            ),
                                            DataCell(
                                              InkWell(
                                                onTap: () {
                                                  viewURLImage(verifyDocumentModel.documentImage!.toString());
                                                },
                                                child: Container(
                                                  alignment: Alignment.centerLeft,
                                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                                                  child: NetworkImageWidget(
                                                    imageUrl: verifyDocumentModel.documentImage!,
                                                    borderRadius: 10,
                                                    height: 40,
                                                    width: 100,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            DataCell(TextCustom(
                                              title: verifyDocumentModel.status == 'approved'
                                                  ? "Approved"
                                                  : verifyDocumentModel.status == "rejected"
                                                      ? "Rejected"
                                                      : "Uploaded",
                                              fontSize: 16,
                                              fontFamily: FontFamily.semiBold,
                                              color: verifyDocumentModel.status == 'approved'
                                                  ? AppThemeData.success300
                                                  : verifyDocumentModel.status == "rejected"
                                                      ? AppThemeData.danger300
                                                      : AppThemeData.tertiary500,
                                            )),
                                            DataCell(Row(
                                              children: [
                                                CustomButtonWidget(
                                                  title: "Approved",
                                                  buttonColor: AppThemeData.success300,
                                                  onPress: () async {
                                                    if (verifyDocumentModel.status == "approved") {
                                                      ShowToastDialog.errorToast("Document Already Approved.");
                                                    } else {
                                                      verifyDocumentModel.status = "approved";
                                                      verifyDocumentModel.rejectedReason = "";
                                                      await FireStoreUtils.updateOwner(controller.ownerModel.value);
                                                      controller.verifyDocumentList.refresh();
                                                      ShowToastDialog.successToast("Document Approved.");
                                                    }
                                                  },
                                                  height: 40,
                                                ),
                                                spaceW(),
                                                CustomButtonWidget(
                                                  title: "Rejected",
                                                  buttonColor: AppThemeData.danger300,
                                                  height: 40,
                                                  onPress: () async {
                                                    showDialog(
                                                        context: context,
                                                        builder: (context) {
                                                          return CustomDialog(
                                                            controller: controller,
                                                            title: 'Add Rejected Reason',
                                                            widgetList: [
                                                              CustomTextFormField(
                                                                  hintText: "Enter Reason For Reject the Document", title: 'Rejected Reason', controller: controller.rejectedReasonController.value)
                                                            ],
                                                            bottomWidgetList: [
                                                              CustomButtonWidget(
                                                                title: "Save",
                                                                onPress: () async {
                                                                  if (verifyDocumentModel.status == "rejected") {
                                                                    ShowToastDialog.errorToast("Document Already Rejected.");
                                                                  } else {
                                                                    if (controller.rejectedReasonController.value.text.isEmpty) {
                                                                      ShowToastDialog.errorToast("Please Add Rejected Reason.");
                                                                    } else {
                                                                      verifyDocumentModel.status = "rejected";
                                                                      verifyDocumentModel.rejectedReason = controller.rejectedReasonController.value.text;
                                                                      await FireStoreUtils.updateOwner(controller.ownerModel.value);
                                                                      controller.verifyDocumentList.refresh();
                                                                      ShowToastDialog.successToast("Document Rejected.");
                                                                      Get.back();
                                                                    }
                                                                  }
                                                                },
                                                              )
                                                            ],
                                                          );
                                                        });
                                                  },
                                                ),
                                              ],
                                            )),
                                          ]))
                                      .toList()),
                            ),
                          ),
                        ),
                      )
                    } else ...{
                      // Data is not available
                      ContainerCustom(
                          child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Text(
                            'Restaurant has not upload document',
                            style: TextStyle(
                              color: themeChange.isDarkTheme() ? AppThemeData.primaryWhite : AppThemeData.primaryBlack,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ))
                    },
                    spaceH(),
                    ContainerCustom(
                      padding: const EdgeInsets.all(0),
                      borderColor: themeChange.isDarkTheme() ? AppThemeData.lynch950 : AppThemeData.lynch25,
                      child: Obx(
                        () {
                          if (controller.isLoadingVehicleDetails.value) {
                            // Show loader while loading
                            return Padding(
                              padding: paddingEdgeInsets(),
                              child: Constant.loader(),
                            );
                          } else {
                            // Loading is complete
                            if (controller.ownerModel.value.vendorId == null) {
                              // Data is not available
                              return Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Text(
                                    'Restaurant has not add other data '.tr,
                                    style: TextStyle(
                                      color: themeChange.isDarkTheme() ? AppThemeData.primaryWhite : AppThemeData.primaryBlack,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              );
                            } else {
                              // Data is available, show details
                              return Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        TextCustom(
                                          title: 'Verify'.tr,
                                        ),
                                        SizedBox(
                                          height: 10,
                                          child: Transform.scale(
                                            scale: 0.8,
                                            child: CupertinoSwitch(
                                              activeTrackColor: AppThemeData.primary500,
                                              value: controller.ownerModel.value.isVerified ?? false,
                                              onChanged: (value) async {
                                                if (controller.verifyDocumentList.every((doc) => doc.status == "approved")) {
                                                  controller.ownerModel.value.isVerified = value;
                                                  controller.ownerModel.refresh();
                                                } else {
                                                  ShowToastDialog.errorToast("Please First Approve All Document.");
                                                }

                                                // Save this change to Firestore or your backend.
                                              },
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 1,
                                    child: ContainerCustom(
                                      padding: const EdgeInsets.all(0),
                                      color: themeChange.isDarkTheme() ? AppThemeData.lynch950 : AppThemeData.lynch25,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        TextCustom(
                                          title: 'Restaurant OwnerName'.tr,
                                        ),
                                        TextCustom(
                                          title: controller.ownerModel.value.fullNameString(),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 1,
                                    child: ContainerCustom(
                                      padding: const EdgeInsets.all(0),
                                      color: themeChange.isDarkTheme() ? AppThemeData.lynch950 : AppThemeData.lynch25,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        TextCustom(
                                          title: 'Restaurant Owner Email'.tr,
                                        ),
                                        TextCustom(
                                          title: controller.ownerModel.value.email.toString(),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 1,
                                    child: ContainerCustom(
                                      padding: const EdgeInsets.all(0),
                                      color: themeChange.isDarkTheme() ? AppThemeData.lynch950 : AppThemeData.lynch25,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        TextCustom(
                                          title: 'Restaurant Owner Number'.tr,
                                        ),
                                        TextCustom(
                                          title: controller.ownerModel.value.phoneNumber.toString(),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 1,
                                    child: ContainerCustom(
                                      padding: const EdgeInsets.all(0),
                                      color: themeChange.isDarkTheme() ? AppThemeData.lynch950 : AppThemeData.lynch25,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 1,
                                    child: ContainerCustom(
                                      padding: const EdgeInsets.all(0),
                                      color: themeChange.isDarkTheme() ? AppThemeData.lynch950 : AppThemeData.lynch25,
                                    ),
                                  ),
                                ],
                              );
                            }
                          }
                        },
                      ),
                    ),
                  ],
                ),
              )
            ],
            bottomWidgetList: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  CustomButtonWidget(
                    // buttonTitle: "Close".tr,
                    buttonColor: themeChange.isDarkTheme() ? AppThemeData.lynch900 : AppThemeData.lynch500,
                    onPress: () {
                      Navigator.pop(context);
                    },
                    title: "Close".tr,
                  ),
                  spaceW(),
                  CustomButtonWidget(
                    buttonColor: AppThemeData.primary500,
                    onPress: () {
                      // editingVerifyDocumentId
                      // controller.updateVerifyStatus();
                      controller.saveData();
                      Navigator.pop(context);
                    },
                    title: "Save".tr,
                  ),
                ],
              ),
            ],
            controller: controller,
          ),
        );
      },
    );
  }
}

Row rowDataWidget({required String name, required String value, required themeChange}) {
  return Row(
    children: [
      TextCustom(
        title: "${name.tr}  : ",
        fontSize: 14,
        fontFamily: FontFamily.bold,
      ),
      TextCustom(
        title: value,
        fontSize: 14,
        fontFamily: FontFamily.bold,
      ),
    ],
  );
}

void viewURLImage(String image) {
  showDialog(
    context: Get.context!,
    builder: (BuildContext context) {
      return Dialog(
        backgroundColor: Colors.transparent,
        child: SizedBox(
          height: 300,
          width: 400,
          child: Stack(
            alignment: Alignment.center,
            children: [
              NetworkImageWidget(
                borderRadius: 12,
                height: 300,
                width: 400,
                imageUrl: image,
                fit: BoxFit.fill,
              ),
              Align(
                alignment: Alignment.topRight,
                child: InkWell(
                  onTap: () {
                    Get.back();
                  },
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    margin: const EdgeInsets.all(10),
                    decoration: const BoxDecoration(shape: BoxShape.circle, color: AppThemeData.lynch500),
                    child: const Icon(Icons.close),
                  ),
                ),
              )
            ],
          ),
        ),
      );
    },
  );
}
