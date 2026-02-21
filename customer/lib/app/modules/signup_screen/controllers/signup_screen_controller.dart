// ignore_for_file: invalid_return_type_for_catch_error, depend_on_referenced_packages

import 'dart:convert';
import 'dart:developer' as developer;
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';
import 'package:customer/app/models/add_address_model.dart';
import 'package:customer/app/models/user_model.dart';
import 'package:customer/app/modules/signup_screen/views/account_created_view.dart';
import 'package:customer/app/widget/permission_dialog.dart';
import 'package:customer/constant/constant.dart';
import 'package:customer/constant/show_toast_dialog.dart';
import 'package:customer/utils/fire_store_utils.dart';
import 'package:customer/utils/notification_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';

class SignupScreenController extends GetxController {
  Rx<UserModel> userModel = UserModel().obs;

  Rx<TextEditingController> firstNameController = TextEditingController().obs;
  Rx<TextEditingController> lastNameController = TextEditingController().obs;
  Rx<TextEditingController> emailController = TextEditingController().obs;
  Rx<TextEditingController> mobileNumberController = TextEditingController().obs;
  Rx<TextEditingController> passwordController = TextEditingController().obs;
  Rx<TextEditingController> confirmPasswordController = TextEditingController().obs;
  Rx<TextEditingController> addressController = TextEditingController().obs;
  Rx<String?> countryCode = "+504".obs;
  RxBool isPasswordVisible = true.obs;
  RxString loginType = "".obs;
  RxBool isFirstButtonEnabled = false.obs;

  Rx<AddAddressModel> addAddressModel = AddAddressModel().obs;

  @override
  void onInit() {
    getArgument();
    super.onInit();
  }

  void checkFieldsFilled() {
    try {
      isFirstButtonEnabled.value = loginType.value == Constant.emailLoginType
          ? firstNameController.value.text.isNotEmpty &&
              lastNameController.value.text.isNotEmpty &&
              mobileNumberController.value.text.isNotEmpty &&
              emailController.value.text.isNotEmpty &&
              passwordController.value.text.isNotEmpty &&
              confirmPasswordController.value.text.isNotEmpty
          : firstNameController.value.text.isNotEmpty &&
              lastNameController.value.text.isNotEmpty &&
              mobileNumberController.value.text.isNotEmpty &&
              emailController.value.text.isNotEmpty;
    } catch (e, stack) {
      developer.log("Error checking fields: $e", stackTrace: stack);
    }
  }

  Future<void> getArgument() async {
    try {
      dynamic argumentData = Get.arguments;
      if (argumentData != null) {
        if (argumentData['type'] != null) {
          loginType.value = argumentData['type'];
        } else if (argumentData['userModel'] != null) {
          userModel.value = await argumentData['userModel'];
          loginType.value = userModel.value.loginType!;
        }
        if (loginType.value == Constant.phoneLoginType) {
          mobileNumberController.value.text = userModel.value.phoneNumber.toString();
          countryCode.value = userModel.value.countryCode.toString();
        } else if (loginType.value == Constant.googleLoginType || loginType.value == Constant.appleLoginType) {
          emailController.value.text = userModel.value.email.toString();
        }
      }
      update();
    } catch (e, stack) {
      developer.log("Error getting arguments: $e", stackTrace: stack);
    }
  }

  Future<UserCredential?> signUpEmailWithPass(String email, String password) async {
    return await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<void> saveData() async {
    ShowToastDialog.showLoader("Please Wait..".tr);
    try {
      userModel.value.firstName = firstNameController.value.text;
      userModel.value.lastName = lastNameController.value.text;
      userModel.value.slug = Constant.fullNameString(firstNameController.value.text, lastNameController.value.text).toSlug(delimiter: "-");
      userModel.value.email = emailController.value.text;
      userModel.value.password = passwordController.value.text;
      userModel.value.countryCode = countryCode.value;
      userModel.value.phoneNumber = mobileNumberController.value.text;
      userModel.value.profilePic = '';
      userModel.value.createdAt = Timestamp.now();
      userModel.value.isActive = true;
      userModel.value.walletAmount = "0.0";
      userModel.value.userType = Constant.user;

      bool? success = await FireStoreUtils.addUser(userModel.value);
      if (success == true) {
        Constant.userModel = await FireStoreUtils.getUserProfile(FireStoreUtils.getCurrentUid()!);
        Get.offAll(const AccountCreatedView());
      } else {
        ShowToastDialog.showToast("Failed to save user data.".tr);
      }
    } catch (e, stack) {
      developer.log("Error saving data: $e", stackTrace: stack);
    } finally {
      ShowToastDialog.closeLoader();
    }
  }

  Future<void> signUp() async {
    String email = emailController.value.text;
    String password = passwordController.value.text;

    ShowToastDialog.showLoader("Please Wait..".tr);

    try {
      final value = await signUpEmailWithPass(email, password);

      if (value?.user?.uid == null) {
        throw Exception("User ID is null");
      }

      String fcmToken = await NotificationService.getToken();
      userModel.value.id = value!.user!.uid;
      userModel.value.firstName = firstNameController.value.text;
      userModel.value.lastName = lastNameController.value.text;
      userModel.value.slug = Constant.fullNameString(firstNameController.value.text, lastNameController.value.text).toSlug(delimiter: "-");
      userModel.value.loginType = Constant.emailLoginType;
      userModel.value.email = email;
      userModel.value.password = password;
      userModel.value.countryCode = countryCode.value;
      userModel.value.phoneNumber = mobileNumberController.value.text;
      userModel.value.profilePic = '';
      userModel.value.fcmToken = fcmToken;
      userModel.value.createdAt = Timestamp.now();
      userModel.value.isActive = true;
      userModel.value.walletAmount = "0.0";
      userModel.value.userType = Constant.user;

      bool? updated = await FireStoreUtils.updateUser(userModel.value);
      if (updated == true) {
        Constant.userModel = await FireStoreUtils.getUserProfile(FireStoreUtils.getCurrentUid()!);
        Get.offAll(const AccountCreatedView());
      } else {
        ShowToastDialog.showToast("Failed to update user data.".tr);
      }
    } on FirebaseAuthException catch (e) {

      String message;
      switch (e.code) {
        case 'email-already-in-use':
          message = "This email is already in use.";
          break;
        case 'invalid-email':
          message = "The email address is not valid.";
          break;
        case 'weak-password':
          message = "The password is too weak.";
          break;
        default:
          message = "Authentication error: ${e.message}";
      }
      ShowToastDialog.showToast(message);
    } finally {
      ShowToastDialog.closeLoader();
    }
  }

  Future<void> saveAddress() async {
    try {
      Constant.userModel!.addAddresses!.add(addAddressModel.value);
      bool? success = await FireStoreUtils.updateUser(Constant.userModel!);
      ShowToastDialog.closeLoader();

      if (success == true) {
        Constant.userModel = await FireStoreUtils.getUserProfile(FireStoreUtils.getCurrentUid()!);
      } else {
        ShowToastDialog.showToast("Failed to save address.".tr);
      }
    } catch (e, stack) {
      developer.log("Error saving address: $e", stackTrace: stack);
      ShowToastDialog.closeLoader();
    }
  }

  void checkPermission(Function() onTap) async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.denied) {
        ShowToastDialog.showToast("You have to allow location permission to use your location".tr);
      } else if (permission == LocationPermission.deniedForever) {
        showDialog(
          context: Get.context!,
          builder: (BuildContext context) {
            return const PermissionDialog();
          },
        );
      } else {
        onTap();
      }
    } catch (e, stack) {
      developer.log("Error checking location permission: $e", stackTrace: stack);
    }
  }

  String generateNonce([int length = 32]) {
    try {
      const charset = '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
      final random = Random.secure();
      return List.generate(length, (_) => charset[random.nextInt(charset.length)]).join();
    } catch (e, stack) {
      developer.log("Error generating nonce: $e", stackTrace: stack);
      return '';
    }
  }

  /// Returns the sha256 hash of [input] in hex notation.
  String sha256ofString(String input) {
    try {
      final bytes = utf8.encode(input);
      final digest = sha256.convert(bytes);
      return digest.toString();
    } catch (e, stack) {
      developer.log("Error generating SHA256 hash: $e", stackTrace: stack);
      return '';
    }
  }
}
