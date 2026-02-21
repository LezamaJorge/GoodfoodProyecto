// ignore_for_file: deprecated_member_use, depend_on_referenced_packages, use_super_parameters

import 'dart:io';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';
import 'package:restaurant/app/modules/add_restaurant_screen/controllers/add_restaurant_screen_controller.dart';
import 'package:restaurant/app/widget/global_widgets.dart';
import 'package:restaurant/app/widget/text_widget.dart';
import 'package:restaurant/constant/constant.dart';
import 'package:restaurant/constant/show_toast_dialogue.dart';
import 'package:restaurant/constant_widgets/round_shape_button.dart';
import 'package:restaurant/themes/app_fonts.dart';
import 'package:restaurant/themes/app_theme_data.dart';
import 'package:restaurant/utils/dark_theme_provider.dart';

import '../../../../../themes/screen_size.dart';

class UploadRestaurantImage extends GetView<AddRestaurantScreenController> {
  const UploadRestaurantImage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);

    return GetX(
      init: AddRestaurantScreenController(),
      builder: (controller) {
        bool areImagesUploaded = controller.coverImage.value.isNotEmpty && controller.logoImage.value.isNotEmpty;
        return Scaffold(
          backgroundColor: Colors.transparent,
          body: SingleChildScrollView(
            child: Padding(
              padding: paddingEdgeInsets(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextCustom(
                    title: "Upload Restaurant Cover and Logo".tr,
                    fontSize: 28,
                    maxLine: 2,
                    color: themeChange.isDarkTheme() ? AppThemeData.grey100 : AppThemeData.grey1000,
                    fontFamily: FontFamily.bold,
                    textAlign: TextAlign.start,
                  ),
                  2.height,
                  TextCustom(
                    title: "Customize your restaurant's profile with a cover image and logo for better visibility.".tr,
                    fontSize: 16,
                    maxLine: 2,
                    color: themeChange.isDarkTheme() ? AppThemeData.grey400 : AppThemeData.grey600,
                    fontFamily: FontFamily.regular,
                    textAlign: TextAlign.start,
                  ),
                  spaceH(height: 32),
                  TextCustom(
                    title: "Cover Image".tr,
                    color: themeChange.isDarkTheme() ? AppThemeData.grey100 : AppThemeData.grey900,
                    fontFamily: FontFamily.medium,
                  ),
                  spaceH(height: 8),
                  InkWell(
                    onTap: () {
                      if (controller.coverImage.value.isNotEmpty) {
                        controller.pickFile().then((value) => controller.coverImage.value = value!);
                      }
                    },
                    child: DottedBorder(
                      options: RectDottedBorderOptions(
                        dashPattern: const [6, 6, 6, 6],
                        strokeWidth: 2,
                        padding: EdgeInsets.all(16),
                        color: themeChange.isDarkTheme() ? AppThemeData.grey600 : AppThemeData.grey400,
                      ),
                      child: controller.coverImage.value.isEmpty
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
                                    physics: NeverScrollableScrollPhysics(),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
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
                                          title: "Upload the restaurant cover image".tr,
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
                                            if (controller.coverImage.value.isEmpty) {
                                              controller.pickFile().then((value) => controller.coverImage.value = value!);
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
                              child: Constant.hasValidUrl(controller.coverImage.value.toString())
                                  ? Image.network(
                                      controller.coverImage.value.toString(),
                                      height: 174.h,
                                      width: 358.w,
                                      fit: BoxFit.fill,
                                    )
                                  : Image.file(
                                      File(controller.coverImage.value.toString()),
                                      height: 174.h,
                                      width: 358.w,
                                      fit: BoxFit.fill,
                                    ),
                            ),
                    ),
                  ),
                  spaceH(height: 16),
                  TextCustom(
                    title: "Restaurant Logo".tr,
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
                        child: controller.logoImage.value.isEmpty
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
                                child: Constant.hasValidUrl(controller.logoImage.value.toString())
                                    ? Image.network(
                                        controller.logoImage.value.toString(),
                                        height: 120.h,
                                        width: 120.w,
                                        fit: BoxFit.fill,
                                      )
                                    : Image.file(
                                        File(controller.logoImage.value.toString()),
                                        height: 120.h,
                                        width: 120.w,
                                        fit: BoxFit.fill,
                                      ),
                              ),
                      ),
                      const Spacer(),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextCustom(
                            title: "Upload the restaurant logo".tr,
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
                            title: "Logo size will be 120*120px".tr,
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
                                  controller.logoImage.value = value;
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
                ],
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
                areImagesUploaded ? controller.nextStep() : ShowToastDialog.toast("Please upload restaurant images.".tr);
              },
              size: Size(358.w, ScreenSize.height(6, context)),
            ),
          ),
        );
      },
    );
  }
}
