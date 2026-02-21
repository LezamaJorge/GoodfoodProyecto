// ignore_for_file: depend_on_referenced_packages, must_be_immutable

import 'package:admin_panel/app/components/custom_button.dart';
import 'package:admin_panel/app/components/custom_text_form_field.dart';
import 'package:admin_panel/app/components/dialog_box.dart';
import 'package:admin_panel/app/components/network_image_widget.dart';
import 'package:admin_panel/app/constant/constants.dart';
import 'package:admin_panel/app/modules/admin_profile/controllers/admin_profile_controller.dart';
import 'package:admin_panel/app/utils/app_colors.dart';
import 'package:admin_panel/app/utils/app_them_data.dart';
import 'package:admin_panel/app/utils/dark_theme_provider.dart';
import 'package:admin_panel/widget/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class ProfileWidget extends StatelessWidget {
  AdminProfileController adminProfileController;

  ProfileWidget({super.key, required this.adminProfileController});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return Container(
      padding: const EdgeInsets.all(30),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: themeChange.isDarkTheme() ? AppThemeData.primaryBlack : AppThemeData.primaryWhite,
      ),
      child: Form(
        key: adminProfileController.profileFromKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                TextCustom(title: adminProfileController.profileTitle.value, fontSize: 20, fontFamily: FontFamily.bold),
              ],
            ),
            Obx(
              () => Row(
                children: [
                  adminProfileController.imagePickedFileBytes.value.isEmpty
                      ? SizedBox(
                          height: 100,
                          width: 100,
                          child: Stack(
                            children: [
                              NetworkImageWidget(
                                borderRadius: 60,
                                imageUrl: adminProfileController.imageController.value.text.toString(),
                                height: 100,
                                width: 100,
                              ),
                              Align(
                                alignment: AlignmentDirectional.bottomEnd,
                                child: InkWell(
                                  onTap: () {
                                    adminProfileController.pickPhoto();
                                  },
                                  child: Container(
                                    height: 30,
                                    width: 30,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: themeChange.isDarkTheme() ? AppThemeData.lynch900 : AppThemeData.lynch200,
                                    ),
                                    child: const Icon(
                                      Icons.edit,
                                      size: 20,
                                      color: AppThemeData.lynch500,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      : adminProfileController.uploading.value
                          ? Center(child: Constant.loader())
                          : SizedBox(
                              height: 100,
                              width: 100,
                              child: Stack(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(60),
                                    child: Image.memory(
                                      adminProfileController.imagePickedFileBytes.value,
                                      height: 100,
                                      width: 100,
                                    ),
                                  ),
                                  Align(
                                    alignment: AlignmentDirectional.bottomEnd,
                                    child: InkWell(
                                      onTap: () {
                                        adminProfileController.pickPhoto();
                                      },
                                      child: Container(
                                          height: 30,
                                          width: 30,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: themeChange.isDarkTheme() ? AppThemeData.lynch900 : AppThemeData.lynch200,
                                          ),
                                          child: const Icon(
                                            Icons.edit,
                                            size: 20,
                                          )),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                  const SizedBox(width: 20),
                  TextCustom(
                    title: "${Constant.adminModel!.name}",
                    // style: const TextStyle(fontSize: 16, color: AppColors.darkGrey10, fontFamily: AppThemeData.medium),
                  )
                ],
              ),
            ),
            const SizedBox(height: 40),
            Row(
              children: [
                Expanded(
                  child: CustomTextFormField(
                    title: "Name *".tr,
                    hintText: "Enter admin name".tr,
                    validator: (value) => value != null && value.isNotEmpty ? null : 'admin name required'.tr,
                    controller: adminProfileController.nameController.value,
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: CustomTextFormField(
                    title: "Contact Number *".tr,
                    hintText: "Enter admin number".tr,
                    validator: (value) => value != null && value.isNotEmpty ? null : 'contact number required'.tr,
                    controller: adminProfileController.contactNumberController.value,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: CustomTextFormField(
                    title: "Email *".tr,
                    hintText: "Enter admin email".tr,
                    validator: (value) => Constant.validateEmail(value),
                    controller: adminProfileController.emailController.value,
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Obx(
                    () => CustomTextFormField(
                      // width: ScreenSize.width(30, context),
                      title: "Current Password *".tr,
                      hintText: "Enter Current password".tr,
                      validator: (value) {
                        RegExp regex = RegExp(r'^.{6,}$');
                        if (value!.isEmpty) {
                          return ("Please enter your current password".tr);
                        }
                        if (!regex.hasMatch(value)) {
                          return ("Enter valid password(Min. 6 Character)".tr);
                        }
                        return null;
                      },
                      controller: adminProfileController.currentPasswordController.value,
                      suffix: InkWell(
                          onTap: () {
                            adminProfileController.isPasswordVisible.value = !adminProfileController.isPasswordVisible.value;
                          },
                          child: Icon(
                            adminProfileController.isPasswordVisible.value ? Icons.visibility_off : Icons.visibility,
                            color: AppThemeData.gallery500,
                          )),
                      obscureText: adminProfileController.isPasswordVisible.value,
                    ),
                  ),
                )
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                CustomButtonWidget(
                  title: "Update".tr,
                  onPress: () async {
                    if (Constant.isDemo) {
                      DialogBox.demoDialogBox();
                    } else {
                      if (adminProfileController.profileFromKey.currentState!.validate()) {
                        await adminProfileController.setAdminData();
                      }
                    }
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
