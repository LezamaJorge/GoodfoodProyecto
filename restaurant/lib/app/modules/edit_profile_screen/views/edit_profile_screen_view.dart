// ignore_for_file: prefer_const_constructors_in_immutables, prefer_const_constructors, deprecated_member_use, depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:restaurant/app/modules/edit_profile_screen/controllers/edit_profile_screen_controller.dart';
import 'package:restaurant/app/widget/global_widgets.dart';
import 'package:restaurant/app/widget/network_image_widget.dart';
import 'package:restaurant/app/widget/text_field_widget.dart';
import 'package:restaurant/app/widget/text_widget.dart';
import 'package:restaurant/constant/constant.dart';
import 'package:restaurant/constant_widgets/round_shape_button.dart';
import 'package:restaurant/themes/app_fonts.dart';
import 'package:restaurant/themes/app_theme_data.dart';
import 'package:restaurant/themes/common_ui.dart';
import 'package:restaurant/themes/screen_size.dart';
import 'package:restaurant/utils/dark_theme_provider.dart';
import 'package:restaurant/themes/responsive.dart' as responsive_ui;


class EditProfileScreenView extends StatelessWidget {
  const EditProfileScreenView({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetX<EditProfileScreenController>(
        init: EditProfileScreenController(),
        builder: (controller) {
          return Container(
            width: responsive_ui.Responsive.width(100, context),
            height: responsive_ui.Responsive.height(100, context),
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    stops: const [0.1, 0.3],
                    colors: themeChange.isDarkTheme() ? [const Color(0xff1C1C22), const Color(0xff1C1C22)] : [const Color(0xffFDE7E7), const Color(0xffFFFFFF)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter)),
            child: Scaffold(
              backgroundColor: Colors.transparent,
              appBar: UiInterface.customAppBar(context, themeChange, "",backgroundColor: Colors.transparent),
              body: SingleChildScrollView(
                child: Form(
                  key: controller.formKey,
                  child: Padding(
                    padding: paddingEdgeInsets(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextCustom(
                          title: "Edit Profile".tr,
                          fontSize: 28,
                          maxLine: 2,
                          color: themeChange.isDarkTheme() ? AppThemeData.grey100 : AppThemeData.grey1000,
                          fontFamily: FontFamily.bold,
                          textAlign: TextAlign.start,
                        ),
                        spaceH(height: 2),
                        TextCustom(
                          title: "Update your personal details and preferences here.".tr,
                          fontSize: 16,
                          maxLine: 2,
                          color: themeChange.isDarkTheme() ? AppThemeData.grey400 : AppThemeData.grey600,
                          fontFamily: FontFamily.regular,
                          textAlign: TextAlign.start,
                        ),
                        spaceH(height: 32),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Stack(
                              alignment: Alignment.bottomRight,
                              children: [
                                Container(
                                  height: 116.w,
                                  width: 116.w,
                                  decoration: BoxDecoration(shape: BoxShape.circle),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(200),
                                    child: controller.isLoading.value
                                        ? Constant.loader()
                                        : controller.profileImage.value.isNotEmpty
                                            ? (Constant.hasValidUrl(controller.profileImage.value))
                                                ? NetworkImageWidget(
                                                    imageUrl: controller.profileImage.value,
                                                    height: 56.h,
                                                    width: 56.h,
                                                    borderRadius: 0,
                                                    fit: BoxFit.cover,
                                                    isProfile: true,
                                                  )
                                                : Image.asset(
                                                    controller.profileImage.value,
                                                    height: 56.h,
                                                    width: 56.h,
                                                    fit: BoxFit.cover,
                                                  )
                                            : Image.asset(
                                                Constant.userPlaceHolder,
                                                height: 56.h,
                                                width: 56.h,
                                                fit: BoxFit.cover,
                                              ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    buildBottomSheet(context, controller, themeChange);
                                  },
                                  child: Container(
                                    margin: EdgeInsets.only(right: 4, bottom: 4),
                                    height: 32.h,
                                    width: 32.w,
                                    decoration: BoxDecoration(shape: BoxShape.circle, color: AppThemeData.primary300),
                                    child: Padding(
                                      padding: const EdgeInsets.all(7),
                                      child: SvgPicture.asset(
                                        "assets/icons/ic_edit_3.svg",
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                        TextFieldWidget(
                          title: "First Name".tr,
                          hintText: "Enter First Name".tr,
                          validator: (value) => value != null && value.isNotEmpty ? null : 'This field required'.tr,
                          controller: controller.firstNameController.value,
                          onPress: () {},
                        ),
                        TextFieldWidget(
                          title: "Last Name".tr,
                          hintText: "Enter Last Name".tr,
                          validator: (value) => value != null && value.isNotEmpty ? null : 'This field required'.tr,
                          controller: controller.lastNameController.value,
                          onPress: () {},
                        ),
                        TextFieldWidget(
                          title: "Email".tr,
                          hintText: "Enter Email".tr,
                          validator: (value) => Constant.validateEmail(value),
                          controller: controller.emailController.value,
                          onPress: () {},
                          readOnly: Constant.ownerModel!.loginType == Constant.emailLoginType ||
                                  Constant.ownerModel!.loginType == Constant.googleLoginType ||
                                  Constant.ownerModel!.loginType == Constant.appleLoginType
                              ? true
                              : false,
                        ),
                        MobileNumberTextField(
                          controller: controller.mobileNumberController.value,
                          countryCode: "+91",
                          onPress: () {},
                          title: "Mobile Number".tr,
                          readOnly: Constant.ownerModel!.loginType == Constant.phoneLoginType ? true : false,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              bottomNavigationBar: Padding(
                padding: paddingEdgeInsets(vertical: 8),
                child: RoundShapeButton(
                  title: "Save Details".tr,
                   buttonColor: AppThemeData.primary300,
                  buttonTextColor: AppThemeData.grey100,
                  onTap: () {
                    if (controller.formKey.currentState!.validate()) {
                      controller.updateProfile();
                    }
                  },
                  size: Size(358.w, ScreenSize.height(6, context)),
                ),
              ),
            ),
          );
        });
  }
}

Future buildBottomSheet(BuildContext context, EditProfileScreenController controller, DarkThemeProvider themeChange) {
  return showModalBottomSheet(
    context: context,
    backgroundColor: themeChange.isDarkTheme() ? AppThemeData.primaryBlack : AppThemeData.primaryWhite,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return SizedBox(
            height: ScreenSize.height(22, context),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: paddingEdgeInsets(),
                  child: TextCustom(
                    title: "Please Select".tr,
                    fontSize: 18,
                    fontFamily: FontFamily.bold,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: paddingEdgeInsets(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          IconButton(
                              onPressed: () => controller.pickFile(source: ImageSource.camera),
                              icon: Icon(
                                Icons.camera_alt,
                                size: 32,
                                color: AppThemeData.primary300,
                              )),
                          Padding(
                            padding: const EdgeInsets.only(top: 3),
                            child: TextCustom(
                              title: "Camera".tr,
                            ),
                          ),
                        ],
                      ),
                    ),
                    spaceW(width: 36),
                    Padding(
                      padding: paddingEdgeInsets(),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          IconButton(
                              onPressed: () => controller.pickFile(source: ImageSource.gallery),
                              icon: Icon(
                                Icons.photo,
                                size: 32,
                                color: AppThemeData.primary300,
                              )),
                          Padding(
                            padding: const EdgeInsets.only(top: 3),
                            child: TextCustom(
                              title: "Gallery".tr,
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ],
            ),
          );
        },
      );
    },
  );
}
