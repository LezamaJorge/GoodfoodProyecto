
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';
import 'package:restaurant/app/models/owner_model.dart';
import 'package:restaurant/app/modules/account_disabled_screen.dart';
import 'package:restaurant/app/modules/login_screen/controllers/login_screen_controller.dart';
import 'package:restaurant/app/modules/signup_screen/views/signup_screen_view.dart';
import 'package:restaurant/app/routes/app_pages.dart';
import 'package:restaurant/app/widget/global_widgets.dart';
import 'package:restaurant/constant/constant.dart';
import 'package:restaurant/constant/show_toast_dialogue.dart';
import 'package:restaurant/constant_widgets/round_shape_button.dart';
import 'package:restaurant/themes/app_fonts.dart';
import 'package:restaurant/themes/app_theme_data.dart';
import 'package:restaurant/utils/dark_theme_provider.dart';
import 'package:restaurant/utils/fire_store_utils.dart';
import 'package:restaurant/utils/notification_service.dart';

import '../../../../themes/screen_size.dart';

class VerifyOtpView extends GetView<LoginScreenController> {
  VerifyOtpView({super.key});

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return Scaffold(
        appBar: AppBar(backgroundColor: Colors.transparent,
          systemOverlayStyle: const SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: Brightness.dark, // Android → black
            statusBarBrightness: Brightness.light,    // iOS → black
          ),
          leading: GestureDetector(
            onTap: () {
              Get.back();
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: themeChange.isDarkTheme() ? AppThemeData.grey900 : AppThemeData.grey100,
                ),
                child: Icon(
                  Icons.arrow_back_ios_sharp,
                  size: 20,
                  color: themeChange.isDarkTheme() ? AppThemeData.grey100 : AppThemeData.grey900,
                ),
              ),
            ),
          ),
        ),
      backgroundColor: themeChange.isDarkTheme() ? AppThemeData.grey1000 : AppThemeData.grey50,
      body: Form(
        key: formKey,
        child: SingleChildScrollView(
          child: Padding(
            padding: paddingEdgeInsets(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                buildTopWidget(context),
                buildEmailPasswordWidget(context),
                34.height,
                Obx(
                  () => controller.enableResend.value
                      ? Center(
                          child: GestureDetector(
                            onTap: () {
                              controller.sendCode();
                            },
                            child: Text(
                              "Resend OTP".tr,
                              style: const TextStyle(
                                  fontSize: 16,
                                  color: AppThemeData.accent300,
                                  fontFamily: FontFamily.regular,
                                  decoration: TextDecoration.underline,
                                  decorationColor: AppThemeData.accent300),
                            ),
                          ),
                        )
                      : RichText(
                          text: TextSpan(
                            text: "Didn’t received it? Retry in ".tr,
                            style: TextStyle(
                              fontFamily: FontFamily.regular,
                              color: themeChange.isDarkTheme() ? AppThemeData.grey200 : AppThemeData.grey800,
                              fontSize: 16,
                            ),
                            children: [
                              TextSpan(
                                text: "00:${controller.secondsRemaining.value.toString().padLeft(2, '0')} sec".tr,
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: AppThemeData.accent300,
                                  fontFamily: FontFamily.regular,
                                ),
                              ),
                            ],
                          ),
                        ).center(),
                ),
                spaceH(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: Obx(
                        () => RoundShapeButton(
                          title: "Verify OTP".tr,
                          buttonColor: controller.isVerifyButtonEnabled.value
                              ? AppThemeData.primary300
                              : themeChange.isDarkTheme()
                                  ? AppThemeData.grey800
                                  : AppThemeData.grey200,
                          buttonTextColor: controller.isVerifyButtonEnabled.value
                              ? themeChange.isDarkTheme()
                                  ? AppThemeData.grey1000
                                  : AppThemeData.grey50
                              : AppThemeData.grey500,
                          onTap: () async {
                            if (controller.otpCode.value.length == 6) {
                              ShowToastDialog.showLoader("Verify OTP".tr);
                              PhoneAuthCredential credential = PhoneAuthProvider.credential(verificationId: controller.verificationId.value, smsCode: controller.otpCode.value);
                              String fcmToken = await NotificationService.getToken();
                              await FirebaseAuth.instance.signInWithCredential(credential).then((value) async {
                                if (value.additionalUserInfo!.isNewUser) {
                                  OwnerModel ownerModel = OwnerModel();
                                  ownerModel.id = value.user!.uid;
                                  ownerModel.countryCode = controller.countryCode.value;
                                  ownerModel.phoneNumber = controller.mobileNumberController.value.text;
                                  ownerModel.loginType = Constant.phoneLoginType;
                                  ownerModel.fcmToken = fcmToken;

                                  ShowToastDialog.closeLoader();
                                  Get.off(SignupScreenView(), arguments: {
                                    "ownerModel": ownerModel,
                                  });
                                } else {
                                  await FireStoreUtils.userExistOrNot(value.user!.uid).then((userExit) async {
                                    ShowToastDialog.closeLoader();
                                    if (userExit == true) {
                                      OwnerModel? ownerModel = await FireStoreUtils.getOwnerProfile(value.user!.uid);
                                      if (ownerModel != null) {
                                        if (ownerModel.active == true) {
                                          if (ownerModel.vendorId != null && ownerModel.vendorId!.isNotEmpty) {
                                            Constant.vendorModel = await FireStoreUtils.getRestaurant(Constant.ownerModel!.vendorId!);

                                            if (Constant.vendorModel != null && Constant.vendorModel!.active == true) {
                                              ShowToastDialog.toast("Login successful!".tr);
                                              Constant.isLogin = await FireStoreUtils.isLogin();
                                              ShowToastDialog.closeLoader();
                                              Get.offAllNamed(Routes.DASHBOARD_SCREEN);
                                            } else {
                                              ShowToastDialog.closeLoader();
                                              Get.offAll(() => AccountDisabledScreen());
                                            }
                                          }
                                          else {
                                            ShowToastDialog.toast("Login successful! Please complete your restaurant setup.".tr);
                                            Constant.isLogin = await FireStoreUtils.isLogin();
                                            ShowToastDialog.closeLoader();
                                            Get.offAllNamed(Routes.DASHBOARD_SCREEN);
                                          }
                                        } else {
                                          Get.offAll(AccountDisabledScreen());
                                        }
                                      }
                                    } else {
                                      OwnerModel ownerModel = OwnerModel();
                                      ownerModel.id = value.user!.uid;
                                      ownerModel.countryCode = controller.countryCode.value;
                                      ownerModel.phoneNumber = controller.mobileNumberController.value.text;
                                      ownerModel.loginType = Constant.phoneLoginType;
                                      ownerModel.fcmToken = fcmToken;

                                      Get.off(SignupScreenView(), arguments: {
                                        "ownerModel": ownerModel,
                                      });
                                    }
                                  });
                                }
                              }).catchError((error) {
                                ShowToastDialog.closeLoader();
                                ShowToastDialog.toast("Invalid code. Please try again.".tr);
                              });
                            } else {
                              ShowToastDialog.toast("Enter a valid OTP.".tr);
                            }
                          },
                          size: Size(358.w, ScreenSize.height(6, context)),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  SizedBox buildTopWidget(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return SizedBox(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Verify Your Mobile Number".tr,
              style: TextStyle(
                fontFamily: FontFamily.bold,
                fontSize: 24,
                color: themeChange.isDarkTheme() ? AppThemeData.grey50 : AppThemeData.grey1000,
              )),
          RichText(
            text: TextSpan(
              text:
                  "${"Please enter the Verification code, we sent to".tr} \n${Constant.maskMobileNumber(countryCode: controller.countryCode.value, mobileNumber: controller.mobileNumberController.value.text)} ",
              style: TextStyle(
                fontFamily: FontFamily.regular,
                color: themeChange.isDarkTheme() ? AppThemeData.grey400 : AppThemeData.grey600,
                fontSize: 16,
              ),
              children: [
                TextSpan(
                  text: "Change Number".tr,
                  style: TextStyle(fontSize: 16, color: AppThemeData.primary300, fontFamily: FontFamily.regular, decoration: TextDecoration.underline),
                  recognizer: TapGestureRecognizer()..onTap = () => Get.back(),
                ),
              ],
            ),
          ),
          24.height
        ],
      ),
    );
  }

  OtpTextField buildEmailPasswordWidget(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);

    return OtpTextField(
      numberOfFields: 6,
      filled: true,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      cursorColor: AppThemeData.primary300,
      borderRadius: BorderRadius.circular(10),
      borderColor: themeChange.isDarkTheme() ? AppThemeData.grey600 : AppThemeData.grey400,
      enabledBorderColor: themeChange.isDarkTheme() ? AppThemeData.grey600 : AppThemeData.grey400,
      disabledBorderColor: themeChange.isDarkTheme() ? AppThemeData.grey600 : AppThemeData.grey400,
      fillColor: themeChange.isDarkTheme() ? AppThemeData.grey900 : AppThemeData.grey50,
      focusedBorderColor: AppThemeData.primary300,
      showFieldAsBox: true,
      onSubmit: (value) {
        controller.otpCode.value = value;
        controller.isVerifyButtonEnabled.value = true;
      },
      contentPadding: const EdgeInsets.symmetric(vertical: 5),
    );
  }
}
