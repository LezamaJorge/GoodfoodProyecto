import 'dart:async';
import 'dart:convert';
import 'dart:developer' as developer;
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:restaurant/app/models/owner_model.dart';
import 'package:restaurant/app/modules/account_disabled_screen.dart';
import 'package:restaurant/app/modules/login_screen/views/verify_otp_view.dart';
import 'package:restaurant/app/modules/signup_screen/views/signup_screen_view.dart';
import 'package:restaurant/app/routes/app_pages.dart';
import 'package:restaurant/constant/constant.dart';
import 'package:restaurant/constant/show_toast_dialogue.dart';
import 'package:restaurant/utils/fire_store_utils.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class LoginScreenController extends GetxController {
  Rx<TextEditingController> emailController = TextEditingController().obs;
  Rx<TextEditingController> passwordController = TextEditingController().obs;
  Rx<TextEditingController> mobileNumberController = TextEditingController().obs;
  Rx<TextEditingController> resetEmailController = TextEditingController().obs;

  Rx<String?> countryCode = "+91".obs;
  Rx<String> verificationId = "".obs;
  Rx<String> otpCode = "".obs;
  RxBool isPasswordVisible = true.obs;

  RxBool isLoginButtonEnabled = false.obs;
  RxBool isMobileNumberButtonEnabled = false.obs;
  RxBool isVerifyButtonEnabled = false.obs;

  RxInt secondsRemaining = 20.obs;
  RxBool enableResend = false.obs;
  Timer? timer;

  void checkFieldsFilled() {
    try {
      isLoginButtonEnabled.value = emailController.value.text.isNotEmpty && passwordController.value.text.isNotEmpty;

      isMobileNumberButtonEnabled.value = mobileNumberController.value.text.isNotEmpty;
    } catch (e, stack) {
      developer.log("Error checking fields:", error: e, stackTrace: stack);
    }
  }

  Future<void> resetPassword(String email) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      ShowToastDialog.toast("Password reset email sent.".tr);
    } on FirebaseAuthException catch (e, stack) {
      developer.log("Error resetting password:", error: e, stackTrace: stack);
      if (e.code == 'user-not-found') {
        ShowToastDialog.toast("No user found with this email.".tr);
      } else {
        ShowToastDialog.toast("Something went wrong: ${e.message}".tr);
      }
    } catch (e, stack) {
      developer.log("Error resetting password:", error: e, stackTrace: stack);
    }
  }

  void startTimer() {
    try {
      enableResend.value = false;
      secondsRemaining.value = 20;
      timer?.cancel();
      timer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
        if (secondsRemaining.value > 0) {
          secondsRemaining.value--;
        } else {
          enableResend.value = true;
          timer.cancel();
        }
      });
    } catch (e, stack) {
      developer.log("Error starting timer:", error: e, stackTrace: stack);
    }
  }

  Future<UserCredential> signInWithEmailAndPassword(String email, String password) async {
    return await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<void> emailSignIn() async {
    String email = emailController.value.text.trim();
    String password = passwordController.value.text;

    // Input validation
    if (email.isEmpty) {
      ShowToastDialog.toast("Please enter your email.".tr);
      return;
    }

    if (password.isEmpty) {
      ShowToastDialog.toast("Please enter your password.".tr);
      return;
    }

    ShowToastDialog.showLoader("Please Wait..".tr);

    try {
      UserCredential credential = await signInWithEmailAndPassword(email, password);

      final ownerProfile = await FireStoreUtils.getOwnerProfile(credential.user!.uid);
      if (ownerProfile == null) {
        ShowToastDialog.closeLoader();
        return;
      }

      Constant.ownerModel = ownerProfile;

      if (ownerProfile.active != true) {
        ShowToastDialog.closeLoader();
        Get.offAll(() => AccountDisabledScreen());
        return;
      }

      if (ownerProfile.vendorId != null && ownerProfile.vendorId!.isNotEmpty) {
        Constant.vendorModel = await FireStoreUtils.getRestaurant(ownerProfile.vendorId!);

        if (Constant.vendorModel != null && Constant.vendorModel!.active == true) {
          ShowToastDialog.toast("Login successful!".tr);
          Constant.isLogin = await FireStoreUtils.isLogin();
          ShowToastDialog.closeLoader();
          Get.offAllNamed(Routes.DASHBOARD_SCREEN);
        } else {
          ShowToastDialog.closeLoader();
          Get.offAll(() => AccountDisabledScreen());
        }
      } else {
        ShowToastDialog.toast("Login successful! Please complete your restaurant setup.".tr);
        Constant.isLogin = await FireStoreUtils.isLogin();
        ShowToastDialog.closeLoader();
        Get.offAllNamed(Routes.DASHBOARD_SCREEN);
      }
    } on FirebaseAuthException catch (e) {
      developer.log("Firebase code : ${e.code}");
      ShowToastDialog.closeLoader();
      switch (e.code) {
        case 'invalid-email':
          ShowToastDialog.toast("The email address is not valid.".tr);
          break;
        case 'invalid-credential':
          ShowToastDialog.toast("Invalid email or password. Please try again.".tr);
          break;
        case 'user-disabled':
          ShowToastDialog.toast("This user account has been disabled.".tr);
          break;
        case 'user-not-found':
          ShowToastDialog.toast("No user found with this email.".tr);
          break;
        case 'wrong-password':
          ShowToastDialog.toast("Incorrect password. Please try again.".tr);
          break;
        case 'too-many-requests':
          ShowToastDialog.toast("Too many attempts. Please try again later.".tr);
          break;
        case 'network-request-failed':
          ShowToastDialog.toast("Network error. Please check your connection.".tr);
          break;
        default:
          ShowToastDialog.toast("Login failed: ${e.message}".tr);
          break;
      }
    } catch (e) {
      developer.log("Login error", error: e);
      ShowToastDialog.closeLoader();
    }
  }

  Future<void> sendCode() async {
    try {
      ShowToastDialog.showLoader("Please Wait..".tr);

      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: countryCode.value! + mobileNumberController.value.text,
        verificationCompleted: (PhoneAuthCredential credential) {},
        verificationFailed: (FirebaseAuthException e) {
          ShowToastDialog.closeLoader();
          if (e.code == 'invalid-phone-number') {
            ShowToastDialog.toast("Invalid phone number. Please enter a valid number.".tr);
          } else if (e.code == 'too-many-requests') {
            ShowToastDialog.toast("Too many requests. Try again later.".tr);
          } else {
            ShowToastDialog.toast("Verification failed: ${e.message}".tr);
          }
        },
        codeSent: (String verificationId, int? resendToken) {
          ShowToastDialog.closeLoader();
          this.verificationId.value = verificationId;
          Get.to(() => VerifyOtpView());
          startTimer();
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          this.verificationId.value = verificationId;
        },
      );
    } catch (e, stack) {
      developer.log("Error sending verification code:", error: e, stackTrace: stack);
      ShowToastDialog.closeLoader();
    }
  }

  final GoogleSignIn googleSignIn = GoogleSignIn.instance;

  Future<void> initializeGoogleSignIn() async {
    await googleSignIn.initialize(
      serverClientId: '9816334922-lt529ejufea1ffg42gt1bugpc1fl23er.apps.googleusercontent.com',
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

      final OAuthCredential credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
      );

      return await FirebaseAuth.instance.signInWithCredential(credential);
    } catch (e, stack) {
      developer.log("Error signing in with Google:", error: e, stackTrace: stack);
      return null;
    }
  }

  Future<void> loginWithGoogle() async {
    try {
      ShowToastDialog.showLoader("Please Wait..".tr);

      final UserCredential? value = await signInWithGoogle();
      ShowToastDialog.closeLoader();

      if (value == null) {
        ShowToastDialog.toast("Google sign-in failed. Please try again.".tr);
        return;
      }

      final user = value.user;
      if (user == null) {
        ShowToastDialog.toast("User data not found.".tr);
        return;
      }

      if (value.additionalUserInfo?.isNewUser == true) {
        OwnerModel ownerModel = OwnerModel(
          id: user.uid,
          email: user.email,
          profileImage: user.photoURL,
          firstName: user.displayName,
          loginType: Constant.googleLoginType,
        );
        Get.to(() => SignupScreenView(), arguments: {"ownerModel": ownerModel});
      } else {
        bool userExists = await FireStoreUtils.userExistOrNot(user.uid);
        if (userExists) {
          OwnerModel? ownerModel = await FireStoreUtils.getOwnerProfile(user.uid);
          if (ownerModel != null) {
            if (ownerModel.active == true) {
              Constant.isLogin = await FireStoreUtils.isLogin();
              Get.offAllNamed(Routes.DASHBOARD_SCREEN);
            } else {
              ShowToastDialog.toast("Unable to Log In? Please Contact the Admin for Assistance".tr);
            }
          } else {
            ShowToastDialog.toast("This account is not linked with this app.".tr);
          }
        } else {
          OwnerModel ownerModel = OwnerModel(
            id: user.uid,
            email: user.email,
            profileImage: user.photoURL,
            loginType: Constant.googleLoginType,
            firstName: user.displayName,
          );
          Get.to(() => SignupScreenView(), arguments: {"ownerModel": ownerModel});
        }
      }
    } catch (e, stack) {
      developer.log("Error Login With Google:", error: e, stackTrace: stack);
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
      ).catchError((error) {
        ShowToastDialog.closeLoader();
        return error;
      });

      if (appleCredential.identityToken == null) {
        ShowToastDialog.toast("Apple sign-in was cancelled or failed.".tr);
        return null;
      }

      final oauthCredential = OAuthProvider("apple.com").credential(
        idToken: appleCredential.identityToken,
        rawNonce: rawNonce,
        accessToken: appleCredential.authorizationCode,
      );

      return await FirebaseAuth.instance.signInWithCredential(oauthCredential);
    } catch (e, stack) {
      developer.log("Error signing in with Apple:", error: e, stackTrace: stack);
      ShowToastDialog.closeLoader();
    }
    return null;
  }

  String generateNonce([int length = 32]) {
    try {
      const charset = '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
      final random = Random.secure();
      return List.generate(length, (_) => charset[random.nextInt(charset.length)]).join();
    } catch (e, stack) {
      developer.log("Error generating nonce:", error: e, stackTrace: stack);
      return '';
    }
  }

  String sha256ofString(String input) {
    try {
      final bytes = utf8.encode(input);
      final digest = sha256.convert(bytes);
      return digest.toString();
    } catch (e, stack) {
      developer.log("Error generating SHA256 hash:", error: e, stackTrace: stack);
      return '';
    }
  }

  Future<void> loginWithApple() async {
    try {
      ShowToastDialog.showLoader("Please Wait..".tr);

      final value = await signInWithApple();

      ShowToastDialog.closeLoader();

      if (value != null) {
        if (value.additionalUserInfo!.isNewUser) {
          OwnerModel ownerModel = OwnerModel();
          ownerModel.id = value.user!.uid;
          ownerModel.email = value.user!.email;
          ownerModel.loginType = Constant.appleLoginType;

          Get.to(() => SignupScreenView(), arguments: {"ownerModel": ownerModel});
        } else {
          FireStoreUtils.userExistOrNot(value.user!.uid).then((userExit) async {
            ShowToastDialog.closeLoader();

            if (userExit == true) {
              OwnerModel? ownerModel = await FireStoreUtils.getOwnerProfile(value.user!.uid);

              if (ownerModel != null) {
                if (ownerModel.active == true) {
                  Constant.isLogin = await FireStoreUtils.isLogin();
                  Get.offAllNamed(Routes.DASHBOARD_SCREEN);
                } else {
                  ShowToastDialog.toast("Unable to Log In? Please Contact the Admin for Assistance");
                }
              } else {
                ShowToastDialog.toast("This account is not linked with this app.");
              }
            } else {
              OwnerModel ownerModel = OwnerModel();
              ownerModel.id = value.user!.uid;
              ownerModel.email = value.user!.email;
              ownerModel.loginType = Constant.appleLoginType;

              Get.to(() => SignupScreenView(), arguments: {"ownerModel": ownerModel});
            }
          });
        }
      } else {
        ShowToastDialog.toast("Apple sign-in failed. Please try again.");
      }
    } catch (e, stack) {
      developer.log("Error Login With Apple:", error: e, stackTrace: stack);
      ShowToastDialog.closeLoader();
    }
  }
}
