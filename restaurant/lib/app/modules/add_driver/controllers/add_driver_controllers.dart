import 'dart:developer' as developer;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:restaurant/app/models/driver_user_model.dart';

import '../../../../constant/constant.dart';
import '../../../../constant/show_toast_dialogue.dart';
import '../../../../utils/fire_store_utils.dart';

class AddDriverController extends GetxController {
  RxBool isLoading = false.obs;
  Rx<TextEditingController> firstNameController = TextEditingController().obs;
  Rx<TextEditingController> lastNameController = TextEditingController().obs;
  Rx<TextEditingController> emailController = TextEditingController().obs;
  Rx<TextEditingController> passwordController = TextEditingController().obs;
  Rx<TextEditingController> confirmPasswordController = TextEditingController().obs;
  Rx<TextEditingController> mobileNumberController = TextEditingController().obs;
  Rx<TextEditingController> vehicleNameController = TextEditingController().obs;
  Rx<TextEditingController> vehicleNumberController = TextEditingController().obs;
  RxBool isEditing = false.obs;
  Rx<String?> countryCode = "+91".obs;
  RxBool isPasswordVisible = true.obs;
  Rx<VehicleType> vehicleType = VehicleType.bike.obs;
  RxBool isConfPasswordVisible = true.obs;
  Rx<DriverUserModel> driverModel = DriverUserModel().obs;

  @override
  void onInit() {
    getArgument();
    super.onInit();
  }

  void getArgument() {
    dynamic arguments = Get.arguments;
    if (arguments != null) {
      driverModel.value = arguments['driverModel'];
      isEditing.value = arguments['isEditing'];

      if (isEditing.value) {
        firstNameController.value.text = driverModel.value.firstName!;
        lastNameController.value.text = driverModel.value.lastName!;
        emailController.value.text = driverModel.value.email!;
        mobileNumberController.value.text = driverModel.value.phoneNumber!;
        countryCode.value = driverModel.value.countryCode ?? "+91";
        vehicleNameController.value.text = driverModel.value.driverVehicleDetails!.modelName!;
        vehicleNumberController.value.text = driverModel.value.driverVehicleDetails!.vehicleNumber!;
        if (driverModel.value.driverVehicleDetails?.vehicleTypeName?.toLowerCase() == "scooter") {
          vehicleType.value = VehicleType.scooter;
        } else {
          vehicleType.value = VehicleType.bike;
        }
      }
    }
  }

  void setDefaultData() {
    firstNameController.value.text = "";
    lastNameController.value.text = "";
    emailController.value.text = "";
    passwordController.value.text = "";
    confirmPasswordController.value.text = "";
    mobileNumberController.value.text = "";
    vehicleNameController.value.text = "";
    vehicleNumberController.value.text = "";
    vehicleType.value = VehicleType.bike;
    isPasswordVisible.value = true;
    isConfPasswordVisible.value = true;
  }

  bool checkIfFieldsAreFilled() {
    try {
      if (isEditing.value) {
        return firstNameController.value.text.isNotEmpty &&
            lastNameController.value.text.isNotEmpty &&
            mobileNumberController.value.text.isNotEmpty &&
            vehicleNameController.value.text.isNotEmpty &&
            vehicleNumberController.value.text.isNotEmpty;
      } else {
        return firstNameController.value.text.isNotEmpty &&
            lastNameController.value.text.isNotEmpty &&
            emailController.value.text.isNotEmpty &&
            mobileNumberController.value.text.isNotEmpty &&
            passwordController.value.text.isNotEmpty &&
            confirmPasswordController.value.text.isNotEmpty &&
            vehicleNameController.value.text.isNotEmpty &&
            vehicleNumberController.value.text.isNotEmpty;
      }
    } catch (e, stack) {
      developer.log("Error All Details Filled:", error: e, stackTrace: stack);
      return false;
    }
  }

  Future<void> saveData() async {
    try {
      ShowToastDialog.showLoader("Please Wait..".tr);

      if (!isEditing.value) {
        // 🔹 Add flow
        if (passwordController.value.text != confirmPasswordController.value.text) {
          ShowToastDialog.closeLoader();
          ShowToastDialog.toast("Password and Confirm Password do not match!");
          return;
        }

        FirebaseApp secondaryApp = await Firebase.initializeApp(
          name: "SecondaryApp",
          options: Firebase.app().options,
        );

        UserCredential? userCredential;
        try {
          userCredential = await FirebaseAuth.instanceFor(app: secondaryApp).createUserWithEmailAndPassword(
            email: emailController.value.text.trim(),
            password: passwordController.value.text.trim(),
          );
        } on FirebaseAuthException catch (e) {
          if (e.code == 'weak-password') {
            ShowToastDialog.toast('The password provided is too weak.');
          } else if (e.code == 'email-already-in-use') {
            ShowToastDialog.toast('Email already registered!');
          } else {
            ShowToastDialog.toast('Auth error: ${e.message}');
          }
          return;
        }
        if (userCredential.user == null) {
          ShowToastDialog.toast('Failed to create user.');
          return;
        }

        driverModel.value.driverId = userCredential.user!.uid;
        driverModel.value.createdAt = Timestamp.now();
        driverModel.value.active = true;
        driverModel.value.status = 'free';
        driverModel.value.orderId = '';
        driverModel.value.isOnline = false;
        driverModel.value.userType = Constant.driver;
        driverModel.value.loginType = "email";
        driverModel.value.walletAmount = "0.0";
        driverModel.value.isVerified = Constant.isDocumentVerificationEnable == false ? true : false;
      }

      // 🔹 Common fields (Add & Edit both)
      driverModel.value.vendorId = Constant.vendorModel?.id;
      driverModel.value.firstName = firstNameController.value.text;
      driverModel.value.lastName = lastNameController.value.text;
      driverModel.value.email = emailController.value.text.trim();
      driverModel.value.countryCode = countryCode.value;
      driverModel.value.phoneNumber = mobileNumberController.value.text;
      driverModel.value.slug = '${firstNameController.value.text} ${lastNameController.value.text}';
      driverModel.value.driverVehicleDetails = DriverVehicleDetails(
        isVerified: Constant.isDocumentVerificationEnable == false ? true : false,
        modelName: vehicleNameController.value.text,
        vehicleNumber: vehicleNumberController.value.text,
        vehicleTypeName: vehicleType.value.name,
      );
      final isDriverSaved = await FireStoreUtils.addDriver(driverModel.value);
      if (isDriverSaved) {
        ShowToastDialog.toast(isEditing.value ? "Driver updated successfully." : "Driver added successfully.");
        if (!isEditing.value) {
          setDefaultData();
        }
        Get.back();
      }
    } catch (e, stack) {
      developer.log("Error in saveData", error: e, stackTrace: stack);
      ShowToastDialog.toast("Something went wrong:\n$e");
    } finally {
      ShowToastDialog.closeLoader();
    }
  }
}

enum VehicleType { bike, scooter }
