// ignore_for_file: deprecated_member_use, must_be_immutable, depend_on_referenced_packages, use_build_context_synchronously, use_super_parameters

import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';
import 'package:restaurant/app/modules/add_restaurant_screen/controllers/document_verify_controller.dart';
import 'package:restaurant/app/widget/global_widgets.dart';
import 'package:restaurant/app/widget/text_widget.dart';
import 'package:restaurant/constant/constant.dart';
import 'package:restaurant/constant/show_toast_dialogue.dart';
import 'package:restaurant/themes/app_fonts.dart';
import 'package:restaurant/themes/app_theme_data.dart';
import 'package:restaurant/themes/common_ui.dart';
import 'package:restaurant/utils/dark_theme_provider.dart';

import '../../../../../constant_widgets/round_shape_button.dart';
import '../../../../../themes/screen_size.dart';

class UploadDocumentView extends GetView<DocumentVerifyController> {
  const UploadDocumentView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetX(
      init: DocumentVerifyController(),
      builder: (controller) {
        return Scaffold(
          appBar: UiInterface.customAppBar(context, themeChange, ""),
          body: SingleChildScrollView(
            child: Padding(
              padding: paddingEdgeInsets(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextCustom(
                    title: "Upload Documents".tr,
                    fontSize: 28,
                    maxLine: 2,
                    color: themeChange.isDarkTheme() ? AppThemeData.grey100 : AppThemeData.grey1000,
                    fontFamily: FontFamily.bold,
                    textAlign: TextAlign.start,
                  ),
                  2.height,
                  TextCustom(
                    title: "Upload legal documents required for operating your restaurant.".tr,
                    fontSize: 16,
                    maxLine: 2,
                    color: themeChange.isDarkTheme() ? AppThemeData.grey400 : AppThemeData.grey600,
                    fontFamily: FontFamily.regular,
                    textAlign: TextAlign.start,
                  ),
                  controller.isLoading.value
                      ? Constant.loader()
                      : ListView.builder(
                          itemCount: controller.documentsList.length,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),

                          itemBuilder: (context, index) {
                            // VerifyDocumentModel documentModel = controller.verifyDocumentList[index];
                            return Obx(
                              () => Padding(
                                padding: const EdgeInsets.only(top: 20),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    spaceH(height: 6),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        TextCustom(
                                          title: "${controller.documentsList[index].name}".tr,
                                          color: themeChange.isDarkTheme() ? AppThemeData.grey100 : AppThemeData.grey900,
                                          fontFamily: FontFamily.medium,
                                        ),
                                        spaceW(width: 12),
                                        TextCustom(
                                          title: controller.verifyDocumentList[index].status == "pending"
                                              ? ""
                                              : controller.verifyDocumentList[index].status == "uploaded"
                                                  ? "Uploaded"
                                                  : controller.verifyDocumentList[index].status == "approved"
                                                      ? "Approved"
                                                      : "Rejected",
                                          color: controller.verifyDocumentList[index].status == "pending"
                                              ? AppThemeData.info300
                                              : controller.verifyDocumentList[index].status == "uploaded"
                                                  ? AppThemeData.pending300
                                                  : controller.verifyDocumentList[index].status == "approved"
                                                      ? AppThemeData.success300
                                                      : AppThemeData.danger300,
                                          fontSize: 16,
                                          fontFamily: FontFamily.medium,
                                        ),
                                      ],
                                    ),
                                    spaceH(height: 8),
                                    InkWell(
                                      onTap: () {
                                        if (controller.verifyDocumentList[index].status == "pending" || controller.verifyDocumentList[index].status == "rejected") {
                                          controller.documentPickFile(source: ImageSource.gallery, verifyDocumentModel: controller.verifyDocumentList[index], index: index);
                                        }
                                      },
                                      child: DottedBorder(
                                        options: RectDottedBorderOptions(
                                          dashPattern: const [6, 6, 6, 6],
                                          strokeWidth: 2,
                                          padding: EdgeInsets.all(16),
                                          color: themeChange.isDarkTheme() ? AppThemeData.grey600 : AppThemeData.grey400,
                                        ),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            controller.verifyDocumentList[index].status == "rejected"
                                                ? Row(
                                                    children: [
                                                      TextCustom(
                                                        title: "Reason : ",
                                                        fontSize: 16,
                                                        fontFamily: FontFamily.regular,
                                                        color: themeChange.isDarkTheme() ? AppThemeData.primaryWhite : AppThemeData.primaryBlack,
                                                      ),
                                                      TextCustom(
                                                        title: controller.verifyDocumentList[index].rejectedReason.toString(),
                                                        fontSize: 16,
                                                        fontFamily: FontFamily.medium,
                                                        color: AppThemeData.danger300,
                                                      ),
                                                    ],
                                                  ).paddingOnly(bottom: 6)
                                                : SizedBox(),
                                            controller.verifyDocumentList[index].documentImage!.isEmpty
                                                ? Container(
                                                    height: 174.h,
                                                    width: 358.w,
                                                    decoration: BoxDecoration(
                                                      borderRadius: const BorderRadius.all(Radius.circular(12)),
                                                      color: themeChange.isDarkTheme() ? AppThemeData.surface1000 : AppThemeData.surface50,
                                                    ),
                                                    child: Padding(
                                                      padding: paddingEdgeInsets(),
                                                      child: Center(
                                                        child: SingleChildScrollView(
                                                          child: Column(
                                                            crossAxisAlignment: CrossAxisAlignment.center,
                                                            mainAxisAlignment: MainAxisAlignment.center,
                                                            children: [
                                                              SizedBox(
                                                                height: 18,
                                                                width: 18,
                                                                child: SvgPicture.asset(
                                                                  "assets/icons/ic_upload.svg",
                                                                  color: AppThemeData.primary300,
                                                                ),
                                                              ),
                                                              spaceH(height: 16),
                                                              TextCustom(
                                                                title: "Upload".tr + " ${controller.documentsList[index].name}".tr,
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
                                                                  if (controller.verifyDocumentList[index].documentImage!.isEmpty) {
                                                                    controller.documentPickFile(
                                                                      source: ImageSource.gallery,
                                                                      verifyDocumentModel: controller.verifyDocumentList[index],
                                                                      index: index,
                                                                    );
                                                                  }
                                                                },
                                                                size: Size(140.w, 42.h),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  )
                                                : ClipRRect(
                                                    borderRadius: BorderRadius.circular(5),
                                                    child: Constant.hasValidUrl(controller.verifyDocumentList[index].documentImage.toString())
                                                        ? Image.network(
                                                            controller.verifyDocumentList[index].documentImage.toString(),
                                                            height: 174.h,
                                                            width: 358.w,
                                                            fit: BoxFit.fill,
                                                          )
                                                        : Image.file(
                                                            File(controller.verifyDocumentList[index].documentImage.toString()),
                                                            height: 174.h,
                                                            width: 358.w,
                                                            fit: BoxFit.fill,
                                                          ),
                                                  ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                ],
              ),
            ),
          ),
          bottomNavigationBar: Padding(
              padding: paddingEdgeInsets(vertical: 8),
              child: Row(
                children: [
                  controller.verifyDocumentList.any((doc) => doc.status == "pending" || doc.status == "rejected")
                      ? Expanded(
                          child: RoundShapeButton(
                            title: "Save".tr,
                            buttonColor: AppThemeData.primary300,
                            buttonTextColor: AppThemeData.grey50,
                            onTap: () {
                              if (controller.verifyDocumentList.every((doc) => doc.documentImage!.isEmpty)) {
                                ShowToastDialog.toast("Please upload the required legal document images.".tr);
                              } else {
                                controller.uploadDocument();
                              }
                            },
                            size: Size(0, ScreenSize.height(6, context)),
                          ),
                        )
                      : SizedBox(),
                  controller.verifyDocumentList.every((doc) => doc.status == "approved")
                      ? Expanded(
                          child: RoundShapeButton(
                            title: "Your Document is Approved".tr,
                            buttonColor: AppThemeData.success300,
                            buttonTextColor: AppThemeData.grey50,
                            onTap: () async {},
                            size: Size(0, ScreenSize.height(6, context)),
                          ),
                        )
                      : SizedBox(),
                  controller.verifyDocumentList.any((doc) => doc.status == "uploaded")
                      ? Expanded(
                          child: RoundShapeButton(
                              size: Size(0, ScreenSize.height(6, context)),
                              title: "Check Status".tr,
                              buttonColor: AppThemeData.primary300,
                              buttonTextColor: AppThemeData.primaryWhite,
                              onTap: () async {
                                ShowToastDialog.showLoader("Please wait");
                                await controller.getData();
                                bool isUserVerified = controller.ownerModel.value.isVerified ?? false;
                                bool allDocsApproved = controller.ownerModel.value.verifyDocument!.every((doc) => doc.status == "approved");

                                if (allDocsApproved && isUserVerified) {
                                  Get.back(result: true);
                                  controller.getData();
                                  ShowToastDialog.toast("Verified Successfully".tr);
                                } else {
                                  ShowToastDialog.toast(
                                    "Your documents have been sent to admin. Please contact administrator".tr,
                                  );
                                }

                                ShowToastDialog.closeLoader();
                              }).paddingOnly(left: 12),
                        )
                      : SizedBox(),
                ],
              )),
        );
      },
    );
  }
}
