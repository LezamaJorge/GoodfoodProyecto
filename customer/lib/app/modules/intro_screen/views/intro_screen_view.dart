import 'package:customer/app/models/onboarding_model.dart';
import 'package:customer/themes/app_theme_data.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/intro_screen_controller.dart';
import 'widgets/intro_page_view.dart';

class IntroScreenView extends StatelessWidget {
  const IntroScreenView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
        init: IntroScreenController(),
        builder: (controller) {
          return Obx(
            () => Scaffold(
                backgroundColor: controller.currentPage.value == 0
                    ? const Color(0xFFFFFFE7)
                    : controller.currentPage.value == 1
                        ? const Color(0xFFEDFAFF)
                        : const Color(0xFFFFF3F1),
                body: PageView.builder(
                    controller: controller.pageController,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: controller.onboardingList.length,
                    onPageChanged: (index) {
                      controller.currentPage.value = index;
                    },
                    itemBuilder: (context, index) {
                      OnboardingScreenModel item = controller.onboardingList[index];
                      return IntroScreenPage(
                        title: item.title!,
                        body: item.description!,
                        textColor: index == 0
                            ? AppThemeData.orange300
                            : index == 1
                                ? AppThemeData.success300
                                : AppThemeData.info300,
                        image: item.lightModeImage!,
                        imageDarkMode: item.darkModeImage!,
                      );
                    })

                // PageView(
                //   controller: controller.pageController,
                //   physics: const NeverScrollableScrollPhysics(),
                //   onPageChanged: (index) {
                //     controller.currentPage.value = index;
                //   },
                //   children: [
                //     IntroScreenPage(
                //       title: "Choose Your-Favorite Food".tr,
                //       body: "Browse through a variety of delicious cuisines, customize your order, and enjoy swift delivery".tr,
                //       textColor: AppThemeData.orange300,
                //       image: 'assets/images/intro_1.svg',
                //       imageDarkMode: 'assets/images/intro_1_dark.svg',
                //     ),
                //     IntroScreenPage(
                //       title: "Find-Restaurants".tr,
                //       body: "Explore diverse cuisines and find your perfect dining spot effortlessly".tr,
                //       textColor: AppThemeData.success300,
                //       image: 'assets/images/intro_2.svg',
                //       imageDarkMode: 'assets/images/intro_2_dark.svg',
                //     ),
                //     IntroScreenPage(
                //       title: "Get-Faster Delivery".tr,
                //       body: "Our express service ensures that your food arrives hot and fresh in no time. ".tr,
                //       textColor: AppThemeData.info300,
                //       image: 'assets/images/intro_3.svg',
                //       imageDarkMode: 'assets/images/intro_3_dark.svg',
                //     ),
                //   ],
                // ),
                ),
          );
        });
  }
}
