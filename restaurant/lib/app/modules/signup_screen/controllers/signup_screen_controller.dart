// ignore_for_file: depend_on_referenced_packages

import 'dart:convert';
import 'dart:developer' as developer;
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:restaurant/app/models/owner_model.dart';
import 'package:restaurant/app/modules/account_disabled_screen.dart';
import 'package:restaurant/app/modules/signup_screen/views/account_created_view.dart';
import 'package:restaurant/app/modules/signup_screen/views/signup_screen_view.dart';
import 'package:restaurant/app/routes/app_pages.dart';
import 'package:restaurant/constant/constant.dart';
import 'package:restaurant/constant/show_toast_dialogue.dart';
import 'package:restaurant/utils/fire_store_utils.dart';
import 'package:restaurant/utils/notification_service.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class SignupScreenController extends GetxController {
  Rx<TextEditingController> firstNameController = TextEditingController().obs;
  Rx<TextEditingController> lastNameController = TextEditingController().obs;
  Rx<TextEditingController> emailController = TextEditingController().obs;
  Rx<TextEditingController> mobileNumberController = TextEditingController().obs;
  Rx<TextEditingController> passwordController = TextEditingController().obs;
  Rx<TextEditingController> confirmPasswordController = TextEditingController().obs;
  Rx<String?> countryCode = "+504".obs;
  RxBool isPasswordVisible = true.obs;
  RxBool isConfPasswordVisible = true.obs;
  RxString loginType = "".obs;
  Rx<OwnerModel> ownerModel = OwnerModel().obs;
  RxBool isFirstButtonEnabled = false.obs;

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
      developer.log(
        'Error in checkFieldsFilled: $e',
        error: e,
        stackTrace: stack,
      );
      isFirstButtonEnabled.value = false;
    }
  }

  Future<void> getArgument() async {
    try {
      dynamic argumentData = Get.arguments;
      if (argumentData != null) {
        if (argumentData['type'] != null) {
          loginType.value = argumentData['type'];
        } else if (argumentData['ownerModel'] != null) {
          ownerModel.value = await argumentData['ownerModel'];
          loginType.value = ownerModel.value.loginType!;
        }
        if (loginType.value == Constant.phoneLoginType) {
          mobileNumberController.value.text = ownerModel.value.phoneNumber.toString();
          countryCode.value = ownerModel.value.countryCode.toString();
        } else if (loginType.value == Constant.googleLoginType || loginType.value == Constant.appleLoginType) {
          emailController.value.text = ownerModel.value.email.toString();
        }
      }
      update();
    } catch (e, stack) {
      developer.log(
        'Error in getArgument: $e',
        error: e,
        stackTrace: stack,
      );
    }
  }

  Future<UserCredential> signUpEmailWithPass(String email, String password) async {
    return await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<void> signUp() async {
    String email = emailController.value.text;
    String password = passwordController.value.text;

    ShowToastDialog.showLoader("Please Wait..".tr);
    try {
      UserCredential value = await signUpEmailWithPass(email, password);

      String fcmToken = await NotificationService.getToken();

      ownerModel.value.id = value.user!.uid;
      ownerModel.value.firstName = firstNameController.value.text;
      ownerModel.value.lastName = lastNameController.value.text;
      ownerModel.value.slug = Constant.fullNameString(firstNameController.value.text, lastNameController.value.text).toSlug(delimiter: "-");
      ownerModel.value.loginType = Constant.emailLoginType;
      ownerModel.value.email = email;
      ownerModel.value.password = password;
      ownerModel.value.countryCode = countryCode.value;
      ownerModel.value.phoneNumber = mobileNumberController.value.text;
      ownerModel.value.profileImage = '';
      ownerModel.value.isOpen = false;
      ownerModel.value.fcmToken = fcmToken;
      ownerModel.value.createdAt = Timestamp.now();
      ownerModel.value.active = true;
      ownerModel.value.walletAmount = "0.0";
      ownerModel.value.userType = Constant.owner;
      ownerModel.value.vendorId = "";
      ownerModel.value.isVerified = Constant.isDocumentVerificationEnable == true ? false : true;

      bool? updateResult = await FireStoreUtils.updateOwner(ownerModel.value);
      ShowToastDialog.closeLoader();

      if (updateResult == true) {
        Constant.isLogin = await FireStoreUtils.isLogin();
        Constant.ownerModel = await FireStoreUtils.getOwnerProfile(FireStoreUtils.getCurrentUid()!);
        Get.offAll(const AccountCreatedView());
      } else {
        ShowToastDialog.toast("Failed to update user data.".tr);
      }
    } on FirebaseAuthException catch (e) {
      ShowToastDialog.closeLoader();

      // 🔍 Firebase-specific errors
      switch (e.code) {
        case 'email-already-in-use':
          ShowToastDialog.toast("This email is already in use.".tr);
          break;
        case 'invalid-email':
          ShowToastDialog.toast("The email address is invalid.".tr);
          break;
        case 'operation-not-allowed':
          ShowToastDialog.toast("Email/password accounts are not enabled.".tr);
          break;
        case 'weak-password':
          ShowToastDialog.toast("The password is too weak.".tr);
          break;
        default:
          ShowToastDialog.toast("Signup failed: ${e.message}");
      }
    } catch (e, stack) {
      developer.log(
        'Error in signUp: $e',
        error: e,
        stackTrace: stack,
      );
      ShowToastDialog.closeLoader();
    }
  }

  final GoogleSignIn googleSignIn = GoogleSignIn.instance;

  Future<void> initializeGoogleSignIn() async {
    await googleSignIn.initialize(
      serverClientId: '339012005849-mt8hkep8nt1s0l9djgfp4lbqgol4mrei.apps.googleusercontent.com',
    );
  }

  Future<UserCredential?> signInWithGoogle() async {
    try {
      initializeGoogleSignIn();
      if (!googleSignIn.supportsAuthenticate()) {
        if (kDebugMode) {
          print('This platform does not support authenticate().');
        }
        return null;
      }

      // Obtain the auth details from the request
      GoogleSignInAccount? googleSignInAccount = await googleSignIn.authenticate();
      final GoogleSignInAuthentication googleAuth = googleSignInAccount.authentication;

      final credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
      );

      return await FirebaseAuth.instance.signInWithCredential(credential);
    } catch (e, stack) {
      developer.log(
        'Error in signInWithGoogle: $e',
        error: e,
        stackTrace: stack,
      );
      return null;
    }
  }

  Future<void> loginWithGoogle() async {
    ShowToastDialog.showLoader("Please Wait..".tr);
    try {
      final value = await signInWithGoogle();
      ShowToastDialog.closeLoader();

      if (value != null) {
        if (value.additionalUserInfo!.isNewUser) {
          OwnerModel ownerModel = OwnerModel();
          ownerModel.id = value.user!.uid;
          ownerModel.email = value.user!.email;
          ownerModel.profileImage = value.user!.photoURL;
          ownerModel.loginType = Constant.googleLoginType;
          loginType.value = Constant.googleLoginType;

          Get.to(() => SignupScreenView(), arguments: {"ownerModel": ownerModel});
        } else {
          bool userExist = await FireStoreUtils.userExistOrNot(value.user!.uid);

          if (userExist) {
            OwnerModel? ownerModel = await FireStoreUtils.getOwnerProfile(value.user!.uid);

            if (ownerModel != null) {
              if (ownerModel.active == true) {
                if (ownerModel.vendorId != null && ownerModel.vendorId!.isNotEmpty) {
                  Constant.vendorModel = await FireStoreUtils.getRestaurant(ownerModel.vendorId!);

                  if (Constant.vendorModel != null && Constant.vendorModel!.active == true) {
                    ShowToastDialog.toast("Login successful!");
                    Constant.isLogin = await FireStoreUtils.isLogin();
                    Get.offAllNamed(Routes.DASHBOARD_SCREEN);
                  } else {
                    Get.offAll(() => AccountDisabledScreen());
                  }
                } else {
                  ShowToastDialog.toast("Login successful! Please complete your restaurant setup.".tr);
                  Constant.isLogin = await FireStoreUtils.isLogin();
                  Get.offAllNamed(Routes.DASHBOARD_SCREEN);
                }
              } else {
                ShowToastDialog.toast("Unable to Log In? Please Contact the Admin for Assistance".tr);
              }
            } else {
              ShowToastDialog.toast("This account is not linked with this app.".tr);
            }
          } else {
            OwnerModel ownerModel = OwnerModel();
            ownerModel.id = value.user!.uid;
            ownerModel.email = value.user!.email;
            ownerModel.profileImage = value.user!.photoURL;
            ownerModel.loginType = Constant.googleLoginType;
            emailController.value.text = value.user!.email!;
            loginType.value = Constant.googleLoginType;

            Get.to(() => SignupScreenView(), arguments: {"ownerModel": ownerModel});
          }
        }
      }
    } catch (e, stack) {
      developer.log(
        'Error in loginWithGoogle: $e',
        error: e,
        stackTrace: stack,
      );
      ShowToastDialog.closeLoader();
    }
  }

  Future<UserCredential?> signInWithApple() async {
    try {
      final rawNonce = generateNonce();
      final nonce = sha256ofString(rawNonce);

      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
        nonce: nonce,
      );

      final oauthCredential = OAuthProvider("apple.com").credential(
        idToken: appleCredential.identityToken,
        rawNonce: rawNonce,
      );

      return await FirebaseAuth.instance.signInWithCredential(oauthCredential);
    } catch (e, stack) {
      developer.log(
        'Error in signInWithApple: $e',
        error: e,
        stackTrace: stack,
      );
      ShowToastDialog.closeLoader();
      return null;
    }
  }

  String generateNonce([int length = 32]) {
    try {
      const charset = '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
      final random = Random.secure();
      return List.generate(length, (_) => charset[random.nextInt(charset.length)]).join();
    } catch (e, stack) {
      developer.log(
        'Error in generateNonce: $e',
        error: e,
        stackTrace: stack,
      );
      return '';
    }
  }

  String sha256ofString(String input) {
    try {
      final bytes = utf8.encode(input);
      final digest = sha256.convert(bytes);
      return digest.toString();
    } catch (e, stack) {
      developer.log(
        'Error in sha256ofString: $e',
        error: e,
        stackTrace: stack,
      );
      return '';
    }
  }

  Future<void> loginWithApple() async {
    ShowToastDialog.showLoader("Please Wait..".tr);
    try {
      final value = await signInWithApple();
      ShowToastDialog.closeLoader();
      if (value != null) {
        if (value.additionalUserInfo!.isNewUser) {
          OwnerModel ownerModel = OwnerModel();
          ownerModel.id = value.user!.uid;
          ownerModel.email = value.user!.email;
          ownerModel.loginType = Constant.appleLoginType;

          emailController.value.text = value.user!.email!;
          loginType.value = Constant.appleLoginType;

          Get.to(() => SignupScreenView(), arguments: {"ownerModel": ownerModel});
        } else {
          bool userExit = await FireStoreUtils.userExistOrNot(value.user!.uid);
          ShowToastDialog.closeLoader();

          if (userExit) {
            OwnerModel? ownerModel = await FireStoreUtils.getOwnerProfile(value.user!.uid);
            if (ownerModel != null) {
              if (ownerModel.active == true) {
                if (ownerModel.vendorId != null && ownerModel.vendorId!.isNotEmpty) {
                  Constant.vendorModel = await FireStoreUtils.getRestaurant(Constant.ownerModel!.vendorId!);

                  if (Constant.vendorModel != null && Constant.vendorModel!.active == true) {
                    ShowToastDialog.toast("Login successful!");
                    Constant.isLogin = await FireStoreUtils.isLogin();
                    ShowToastDialog.closeLoader();
                    Get.offAllNamed(Routes.DASHBOARD_SCREEN);
                  } else {
                    ShowToastDialog.closeLoader();
                    Get.offAll(() => AccountDisabledScreen());
                  }
                } else {
                  ShowToastDialog.toast("Login successful! Please complete your restaurant setup.");
                  Constant.isLogin = await FireStoreUtils.isLogin();
                  ShowToastDialog.closeLoader();
                  Get.offAllNamed(Routes.DASHBOARD_SCREEN);
                }
              } else {
                ShowToastDialog.toast("Unable to Log In?  Please Contact the Admin for Assistance");
              }
            } else {
              ShowToastDialog.closeLoader();
              ShowToastDialog.toast("This account is not linked with this app.");
            }
          } else {
            OwnerModel ownerModel = OwnerModel();
            ownerModel.id = value.user!.uid;
            ownerModel.email = value.user!.email;
            ownerModel.loginType = Constant.appleLoginType;

            emailController.value.text = value.user!.email!;
            loginType.value = Constant.appleLoginType;
            Get.to(() => SignupScreenView(), arguments: {"ownerModel": ownerModel});
          }
        }
      }
    } catch (e, stack) {
      developer.log(
        'Error in loginWithApple: $e',
        error: e,
        stackTrace: stack,
      );
      ShowToastDialog.closeLoader();
    }
  }

  Future<void> saveData() async {
    ShowToastDialog.showLoader("Please Wait..".tr);
    try {
      ownerModel.value.firstName = firstNameController.value.text;
      ownerModel.value.lastName = lastNameController.value.text;
      ownerModel.value.slug = Constant.fullNameString(firstNameController.value.text, lastNameController.value.text).toSlug(delimiter: "-");
      ownerModel.value.email = emailController.value.text;
      ownerModel.value.password = passwordController.value.text;
      ownerModel.value.countryCode = countryCode.value;
      ownerModel.value.phoneNumber = mobileNumberController.value.text;
      ownerModel.value.profileImage = '';
      ownerModel.value.createdAt = Timestamp.now();
      ownerModel.value.active = true;
      ownerModel.value.walletAmount = "0.0";
      ownerModel.value.userType = Constant.user;

      bool value = await FireStoreUtils.addOwner(ownerModel.value);
      if (value) {
        Constant.isLogin = await FireStoreUtils.isLogin();
        Constant.ownerModel = await FireStoreUtils.getOwnerProfile(FireStoreUtils.getCurrentUid()!);
        Get.offAll(const AccountCreatedView());
      }
    } catch (e, stack) {
      developer.log(
        'Error in saveData: $e',
        error: e,
        stackTrace: stack,
      );
    } finally {
      ShowToastDialog.closeLoader();
    }
  }
}
