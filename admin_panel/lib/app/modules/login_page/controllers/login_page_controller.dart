// ignore_for_file: depend_on_referenced_packages

import 'package:admin_panel/app/constant/collection_name.dart';
import 'package:admin_panel/app/constant/constants.dart';
import 'package:admin_panel/app/constant/show_toast.dart';
import 'package:admin_panel/app/models/admin_model.dart';
import 'package:admin_panel/app/routes/app_pages.dart';
import 'package:admin_panel/app/utils/fire_store_utils.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginPageController extends GetxController {
  var isPasswordVisible = true.obs;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  final GlobalKey<FormState> loginFormKey = GlobalKey<FormState>();

  RxString email = "".obs;
  RxString password = "".obs;

  @override
  void onInit() {
    getData();
    super.onInit();
  }

  Future<void> checkAndLoginOrCreateAdmin() async {
    ShowToastDialog.showLoader("Please wait...".tr);

    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    var adminSnapshot = await FirebaseFirestore.instance.collection(CollectionName.admin).get();

    if (adminSnapshot.docs.isEmpty) {
      try {
        UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);

        AdminModel adminModel = AdminModel(
          id: userCredential.user!.uid,
          email: email,
          name: "",
          image: "",
          contactNumber: "",
          isDemo: false,
        );
        Constant.isDemoSet(adminModel);
        await FirebaseFirestore.instance.collection(CollectionName.admin).doc(userCredential.user!.uid).set(adminModel.toJson());

        ShowToastDialog.successToast("Logged in successfully!".tr);
        ShowToastDialog.closeLoader();
        Get.offAllNamed(Routes.DASHBOARD_SCREEN);
      } catch (e) {
        ShowToastDialog.closeLoader();
        ShowToastDialog.errorToast("Login Failed!".tr);
      }
    } else {
      try {
        await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password).then(
          (value) async {
            AdminModel? adminData = await FireStoreUtils.getAdminProfile(value.user!.uid);
            if (adminData != null) {
              ShowToastDialog.successToast("Logged in successfully!".tr);
              Constant.isLogin = await FireStoreUtils.isLogin();
              ShowToastDialog.closeLoader();
              Constant.isDemoSet(adminData);
              Get.offAllNamed(Routes.DASHBOARD_SCREEN);
            } else {
              ShowToastDialog.closeLoader();
              await FirebaseAuth.instance.signOut();
              ShowToastDialog.errorToast("Admin not active or unauthorized.".tr);
            }
          },
        );
      } on FirebaseAuthException catch (e) {
        String errorMessage;

        switch (e.code) {
          case 'invalid-email':
            errorMessage = 'The email address is invalid.';
            break;
          case 'user-disabled':
            errorMessage = 'This user account has been disabled.';
            break;
          case 'user-not-found':
            errorMessage = 'No user found with this email.';
            break;
          case 'wrong-password':
            errorMessage = 'Incorrect password.';
            break;
          case 'invalid-credential':
            errorMessage = 'Email or password is invalid.';
            break;
          default:
            errorMessage = 'Login failed. Please try again.';
        }
        ShowToastDialog.closeLoader();
        ShowToastDialog.errorToast(errorMessage.tr);
        return;
      } catch (e) {
        ShowToastDialog.errorToast("An unexpected error occurred. Please try again.".tr);
        return;
      }
    }
  }

  Future<void> getData() async {
    await Constant.getCurrencyData();
    await Constant.getLanguageData();
  }
}
