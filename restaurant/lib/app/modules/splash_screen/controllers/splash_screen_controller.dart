import 'dart:async';
import 'dart:developer' as developer;

import 'package:get/get.dart';
import 'package:restaurant/app/models/owner_model.dart';
import 'package:restaurant/app/modules/account_disabled_screen.dart';
import 'package:restaurant/app/routes/app_pages.dart';
import 'package:restaurant/constant/constant.dart';
import 'package:restaurant/utils/fire_store_utils.dart';
import 'package:restaurant/utils/preferences.dart';

class SplashScreenController extends GetxController {
  @override
  Future<void> onInit() async {
    super.onInit();
    await FireStoreUtils().getSettings();
    Future.delayed(const Duration(seconds: 3), () => redirectScreen());
  }

  Future<void> redirectScreen() async {
    try {
      if (Preferences.getBoolean(Preferences.isFinishOnBoardingKey) == false) {
        Get.offAllNamed(Routes.INTRO_SCREEN);
      } else {
        bool isLogin = await FireStoreUtils.isLogin();
        if (isLogin == true) {
          OwnerModel? ownerModel = await FireStoreUtils.getOwnerProfile(FireStoreUtils.getCurrentUid()!);
          if (ownerModel != null && ownerModel.active == true) {
            if (ownerModel.vendorId != null && ownerModel.vendorId!.isNotEmpty) {
              await FireStoreUtils.getRestaurant(ownerModel.vendorId!).then((value) {
                Constant.vendorModel = value;
                if (value != null && value.active == true) {
                  Get.offAllNamed(Routes.DASHBOARD_SCREEN);
                } else {
                  Get.offAll(AccountDisabledScreen());
                }
              }).catchError((e, stack) {
                developer.log("Error fetching restaurant: $e", error: e, stackTrace: stack);
                Get.offAll(AccountDisabledScreen());
              });
            } else {
              Get.offAllNamed(Routes.DASHBOARD_SCREEN);
            }
          } else {
            Get.offAll(AccountDisabledScreen());
          }
        } else {
          Get.offAllNamed(Routes.LANDING_SCREEN);
        }
      }
    } catch (e, stack) {
      developer.log("Error in SplashScreenController: $e", error: e, stackTrace: stack);
      Get.offAllNamed(Routes.LANDING_SCREEN);
    }
  }
}
