import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:restaurant/app/models/onboarding_model.dart';
import 'package:restaurant/utils/fire_store_utils.dart';

class IntroScreenController extends GetxController {
  PageController pageController = PageController();
  RxInt currentPage = 0.obs;

  RxList<OnboardingScreenModel> onboardingList = <OnboardingScreenModel>[].obs;

  @override
  void onInit() {
    getOnboarding();
    super.onInit();
  }

  Future<void> getOnboarding() async {
    try {
      await FireStoreUtils.getOnboardingDataList().then((value) {
        onboardingList.value = value;
      });
    } catch (error) {
      debugPrint("Error fetching onboarding data: $error");
    }
  }
}
