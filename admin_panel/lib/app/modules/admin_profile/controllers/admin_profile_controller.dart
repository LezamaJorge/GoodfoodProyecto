// ignore_for_file: invalid_return_type_for_catch_error, depend_on_referenced_packages

import 'dart:developer';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:admin_panel/app/constant/constants.dart';
import 'package:admin_panel/app/constant/show_toast.dart';
import 'package:admin_panel/app/modules/home/controllers/home_controller.dart';
import 'package:admin_panel/app/utils/fire_store_utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class AdminProfileController extends GetxController {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  final GlobalKey<FormState> profileFromKey = GlobalKey<FormState>();
  final GlobalKey<FormState> changePasswordFromKey = GlobalKey<FormState>();

  Rx<TextEditingController> nameController = TextEditingController().obs;
  Rx<TextEditingController> contactNumberController = TextEditingController().obs;
  Rx<TextEditingController> emailController = TextEditingController().obs;
  Rx<TextEditingController> imageController = TextEditingController().obs;
  Rx<TextEditingController> passwordResetController = TextEditingController().obs;
  Rx<TextEditingController> currentPasswordController = TextEditingController().obs;
  Rx<TextEditingController> newPasswordController = TextEditingController().obs;
  Rx<TextEditingController> confirmPasswordController = TextEditingController().obs;
  RxInt selectedTabIndex = 0.obs;

  HomeController homeController = Get.put(HomeController());
  RxString selectedTab = "profile".tr.obs;

  Rx<File> imagePath = File('').obs;

  RxString mimeType = 'image/png'.obs;
  Rx<Uint8List> imagePickedFileBytes = Uint8List(0).obs;

  RxBool uploading = false.obs;
  RxString title = "Change Password".tr.obs;
  RxString profileTitle = "Profile".tr.obs;

  RxBool isPasswordVisible = true.obs;

  @override
  void onInit() {
    getData();
    super.onInit();
  }

  void getData() {
    FireStoreUtils.getAdmin().then((value) async {
      if (value != null) {
        nameController.value.text = value.name!;
        contactNumberController.value.text = value.contactNumber!;
        emailController.value.text = value.email!;
        imageController.value.text = value.image!;
        if (value.image != null && value.image!.isNotEmpty) {
          try {
            final response = await http.get(Uri.parse(value.image!));
            if (response.statusCode == 200) {
              imagePickedFileBytes.value = response.bodyBytes;
              // Reset imagePath since it's a network image
              imagePath.value = File('');
            }
          } catch (e) {
            ShowToastDialog.errorToast("Failed to load profile image: $e");
          }
      }
    }});
  }

  Future<void> pickPhoto() async {
    uploading.value = true;
    ImagePicker picker = ImagePicker();
    final img = await picker.pickImage(source: ImageSource.gallery, imageQuality: 80);

    if (img == null) {
      uploading.value = false;
      return;
    }

    final allowedExtensions = ['jpg', 'jpeg', 'png'];
    String fileExtension = img.name.split('.').last.toLowerCase();

    if (!allowedExtensions.contains(fileExtension)) {
      ShowToastDialog.errorToast("Invalid file type. Please select a JPG, JPEG, or PNG image.");
      uploading.value = false;
      return;
    }
    File imageFile = File(img.path);

    imageController.value.text = img.name;
    imagePath.value = imageFile;
    imagePickedFileBytes.value = await img.readAsBytes();
    mimeType.value = "${img.mimeType}";
    uploading.value = false;
  }

  Future<void> setAdminData() async {
    try {
      Constant.waitingLoader();
      User? currentUser = FirebaseAuth.instance.currentUser;

      if (currentUser != null && currentUser.email != emailController.value.text) {
        if (currentPasswordController.value.text.isEmpty) {
          ShowToastDialog.closeLoader();
          ShowToastDialog.errorToast("Please enter your current password to update the email.".tr);
          return;
        }

        try {
          AuthCredential authCredential = EmailAuthProvider.credential(
            email: currentUser.email!,
            password: currentPasswordController.value.text,
          );

          await currentUser.reauthenticateWithCredential(authCredential);
          await currentUser.verifyBeforeUpdateEmail(emailController.value.text);

          ShowToastDialog.closeLoader();
          ShowToastDialog.successToast("Verification email sent to ${emailController.value.text}. Please verify to complete the update.".tr);
          currentPasswordController.value.clear();
        } on FirebaseAuthException catch (e) {
          ShowToastDialog.closeLoader();
          if (e.code == 'wrong-password') {
            ShowToastDialog.closeLoader();
            ShowToastDialog.errorToast("Current password is incorrect.".tr);
          } else if (e.code == 'user-mismatch') {
            ShowToastDialog.closeLoader();
            ShowToastDialog.errorToast("User mismatch during reauthentication.".tr);
          } else if (e.code == 'invalid-credential') {
            ShowToastDialog.closeLoader();
            ShowToastDialog.errorToast("Password does not match with current password.".tr);
          } else if (e.code == 'user-not-found') {
            ShowToastDialog.closeLoader();
            ShowToastDialog.errorToast("User not found.".tr);
          } else if (e.code == 'requires-recent-login') {
            ShowToastDialog.closeLoader();
            ShowToastDialog.errorToast("Please login again to update your email.".tr);
          } else {
            ShowToastDialog.closeLoader();
            ShowToastDialog.errorToast("Reauthentication failed: ${e.message}".tr);
          }

          return;
        } catch (e) {
          ShowToastDialog.closeLoader();
          ShowToastDialog.errorToast("Unexpected error during reauthentication: $e".tr);
          return;
        }
      }

      // Update image if any
      if (imagePath.value.path.isNotEmpty) {
        String? downloadUrl = await FireStoreUtils.uploadPic(
          PickedFile(imagePath.value.path),
          "admin",
          "admin",
          mimeType.value,
        );
        Constant.adminModel!.image = downloadUrl;
      }

      Constant.adminModel!
        ..email = emailController.value.text
        ..name = nameController.value.text.trim()
        ..contactNumber = contactNumberController.value.text.trim();

      await FireStoreUtils.setAdmin(Constant.adminModel!);
      await FireStoreUtils.getAdmin();

      Get.back();
      ShowToastDialog.successToast("Profile updated successfully.".tr);
    } catch (e) {
      log("Error updating profile: $e");
      ShowToastDialog.closeLoader();
      ShowToastDialog.errorToast("Failed to update profile.".tr);
    }
  }

  Future<void> setAdminPasswordLink() async {
    String email = passwordResetController.value.text.trim();
    try {
      Constant.waitingLoader();
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);

      Get.back();
      ShowToastDialog.successToast("Password reset link has been sent to $email.");
    } on FirebaseAuthException catch (e) {
      ShowToastDialog.closeLoader();
      String errorMessage = '';
      switch (e.code) {
        case 'invalid-email':
          errorMessage = 'The email address is invalid.';
          break;
        case 'user-not-found':
          errorMessage = 'No user found with this email.';
          break;
        default:
          errorMessage = 'Failed to send password reset email.';
      }
      ShowToastDialog.errorToast(errorMessage);
    } catch (e) {
      ShowToastDialog.closeLoader();
      log("Error in setAdminPasswordLink: $e");
      ShowToastDialog.errorToast("Failed to send password reset link".tr);
    }
  }
}
